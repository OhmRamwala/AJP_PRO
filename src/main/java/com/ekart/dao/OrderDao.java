package com.ekart.dao;

import com.ekart.model.CartItem;
import com.ekart.model.Order;
import com.ekart.model.OrderItem;
import com.ekart.util.DbUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDao {
    public int placeOrder(int userId, Collection<CartItem> items) throws SQLException {
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty");
        }

        String stockSql = "SELECT stock FROM products WHERE id = ? FOR UPDATE";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";

        try (Connection connection = DbUtil.getConnection()) {
            connection.setAutoCommit(false);
            try {
                boolean hasStatusColumn = hasOrderStatusColumn(connection);
                String orderSql = hasStatusColumn
                        ? "INSERT INTO orders (user_id, total, status) VALUES (?, ?, 'PENDING')"
                        : "INSERT INTO orders (user_id, total) VALUES (?, ?)";
                BigDecimal total = BigDecimal.ZERO;
                for (CartItem item : items) {
                    try (PreparedStatement stockStatement = connection.prepareStatement(stockSql)) {
                        stockStatement.setInt(1, item.getProduct().getId());
                        try (ResultSet resultSet = stockStatement.executeQuery()) {
                            if (!resultSet.next()) {
                                throw new SQLException("Product not found for checkout");
                            }

                            int availableStock = resultSet.getInt("stock");
                            if (item.getQuantity() > availableStock) {
                                throw new SQLException(item.getProduct().getName() + " has only " + availableStock + " left");
                            }
                        }
                    }
                    total = total.add(item.getSubtotal());
                }

                int orderId;
                try (PreparedStatement orderStatement = connection.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    orderStatement.setInt(1, userId);
                    orderStatement.setBigDecimal(2, total);
                    orderStatement.executeUpdate();
                    try (ResultSet keys = orderStatement.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Failed to create order");
                        }
                        orderId = keys.getInt(1);
                    }
                }

                for (CartItem item : items) {
                    try (PreparedStatement itemStatement = connection.prepareStatement(itemSql)) {
                        itemStatement.setInt(1, orderId);
                        itemStatement.setInt(2, item.getProduct().getId());
                        itemStatement.setInt(3, item.getQuantity());
                        itemStatement.setBigDecimal(4, item.getProduct().getPrice());
                        itemStatement.executeUpdate();
                    }

                    try (PreparedStatement updateStockStatement = connection.prepareStatement(updateStockSql)) {
                        updateStockStatement.setInt(1, item.getQuantity());
                        updateStockStatement.setInt(2, item.getProduct().getId());
                        updateStockStatement.executeUpdate();
                    }
                }

                connection.commit();
                return orderId;
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public List<Order> findAllOrders() throws SQLException {
        return findOrders(null, null);
    }

    public List<Order> findOrdersByUserId(int userId) throws SQLException {
        return findOrders("WHERE o.user_id = ?", userId);
    }

    private List<Order> findOrders(String whereClause, Integer userId) throws SQLException {
        try (Connection connection = DbUtil.getConnection()) {
            boolean hasStatusColumn = hasOrderStatusColumn(connection);
            String statusSelect = hasStatusColumn ? "COALESCE(o.status, 'PENDING') AS status," : "'PENDING' AS status,";
            String sql = """
                SELECT o.id AS order_id,
                       o.user_id,
                       o.total,
                       %s
                       o.created_at,
                       u.name AS user_name,
                       u.email AS user_email,
                       oi.id AS item_id,
                       oi.product_id,
                       oi.quantity,
                       oi.price,
                       p.name AS product_name
                FROM orders o
                JOIN users u ON u.id = o.user_id
                LEFT JOIN order_items oi ON oi.order_id = o.id
                LEFT JOIN products p ON p.id = oi.product_id
                %s
                ORDER BY o.created_at DESC, o.id DESC, oi.id ASC
                """.formatted(statusSelect, whereClause == null ? "" : whereClause);

            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ) {
                if (userId != null) {
                    statement.setInt(1, userId);
                }
                try (ResultSet resultSet = statement.executeQuery()) {
                Map<Integer, Order> orders = new LinkedHashMap<>();
                while (resultSet.next()) {
                    int orderId = resultSet.getInt("order_id");
                    Order order = orders.computeIfAbsent(orderId, ignored -> {
                        Order createdOrder = new Order();
                        createdOrder.setId(orderId);
                        createdOrder.setUserId(resultSetSafeInt(resultSet, "user_id"));
                        createdOrder.setUserName(resultSetSafeString(resultSet, "user_name"));
                        createdOrder.setUserEmail(resultSetSafeString(resultSet, "user_email"));
                        createdOrder.setTotal(resultSetSafeBigDecimal(resultSet, "total"));
                        createdOrder.setStatus(resultSetSafeString(resultSet, "status"));
                        Timestamp createdAt = resultSetSafeTimestamp(resultSet, "created_at");
                        if (createdAt != null) {
                            createdOrder.setCreatedAt(createdAt.toLocalDateTime());
                        }
                        return createdOrder;
                    });

                    int itemId = resultSet.getInt("item_id");
                    if (!resultSet.wasNull()) {
                        OrderItem item = new OrderItem();
                        item.setId(itemId);
                        item.setOrderId(orderId);
                        item.setProductId(resultSet.getInt("product_id"));
                        item.setProductName(resultSet.getString("product_name"));
                        item.setQuantity(resultSet.getInt("quantity"));
                        item.setPrice(resultSet.getBigDecimal("price"));
                        order.getItems().add(item);
                    }
                }
                return new ArrayList<>(orders.values());
                }
            }
        }
    }

    public boolean markDelivered(int orderId) throws SQLException {
        try (Connection connection = DbUtil.getConnection()) {
            ensureOrderStatusColumn(connection);
            String sql = "UPDATE orders SET status = 'DELIVERED' WHERE id = ? AND UPPER(COALESCE(status, 'PENDING')) <> 'DELIVERED'";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, orderId);
                return statement.executeUpdate() > 0;
            }
        }
    }

    private boolean hasOrderStatusColumn(Connection connection) throws SQLException {
        String sql = """
                SELECT COUNT(*) 
                FROM information_schema.columns
                WHERE table_schema = DATABASE()
                  AND table_name = 'orders'
                  AND column_name = 'status'
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1) > 0;
        }
    }

    private void ensureOrderStatusColumn(Connection connection) throws SQLException {
        if (hasOrderStatusColumn(connection)) {
            return;
        }

        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate("ALTER TABLE orders ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'PENDING' AFTER total");
            statement.executeUpdate("UPDATE orders SET status = 'PENDING' WHERE status IS NULL OR TRIM(status) = ''");
        }
        if (!hasOrderStatusColumn(connection)) {
            throw new SQLException("Order status column could not be created.");
        }
    }

    public boolean deleteOrder(int orderId) throws SQLException {
        String sql = "DELETE FROM orders WHERE id = ?";
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            return statement.executeUpdate() > 0;
        }
    }

    private int resultSetSafeInt(ResultSet resultSet, String column) {
        try {
            return resultSet.getInt(column);
        } catch (SQLException exception) {
            throw new IllegalStateException(exception);
        }
    }

    private String resultSetSafeString(ResultSet resultSet, String column) {
        try {
            return resultSet.getString(column);
        } catch (SQLException exception) {
            throw new IllegalStateException(exception);
        }
    }

    private BigDecimal resultSetSafeBigDecimal(ResultSet resultSet, String column) {
        try {
            return resultSet.getBigDecimal(column);
        } catch (SQLException exception) {
            throw new IllegalStateException(exception);
        }
    }

    private Timestamp resultSetSafeTimestamp(ResultSet resultSet, String column) {
        try {
            return resultSet.getTimestamp(column);
        } catch (SQLException exception) {
            throw new IllegalStateException(exception);
        }
    }
}
