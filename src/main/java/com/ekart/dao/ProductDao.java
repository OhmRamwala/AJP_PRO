package com.ekart.dao;

import com.ekart.model.Product;
import com.ekart.util.CatalogUtil;
import com.ekart.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class ProductDao {
    private static final String PRODUCT_COLUMNS = "id, name, description, price, stock, category, image_url";

    public List<Product> findAll() throws SQLException {
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT " + PRODUCT_COLUMNS + " FROM products" + activeWhereClause(connection) + " ORDER BY id DESC"
             );
             ResultSet resultSet = statement.executeQuery()) {
            List<Product> products = new ArrayList<>();
            while (resultSet.next()) {
                products.add(mapProduct(resultSet));
            }
            products.sort(Comparator.comparing(Product::getCategory).thenComparing(Product::getId, Comparator.reverseOrder()));
            return products;
        }
    }

    public List<Product> findFeatured(int limit) throws SQLException {
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT " + PRODUCT_COLUMNS + " FROM products" + activeWhereClause(connection) + " ORDER BY id DESC LIMIT ?"
             )) {
            statement.setInt(1, limit);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<Product> products = new ArrayList<>();
                while (resultSet.next()) {
                    products.add(mapProduct(resultSet));
                }
                return products;
            }
        }
    }

    public List<Product> getProductsByCategory(String category) throws SQLException {
        List<Product> products = new ArrayList<>();
        String resolvedCategory = CatalogUtil.normalizeCategoryName(category);
        for (Product product : findAll()) {
            if (resolvedCategory.equals(product.getCategory())) {
                products.add(product);
            }
        }
        return products;
    }

    public List<Product> searchProducts(String query) throws SQLException {
        String keyword = "%" + query.trim().toLowerCase() + "%";
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT " + PRODUCT_COLUMNS + " FROM products WHERE (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)"
                             + activeAndClause(connection)
                             + " ORDER BY id DESC"
             )) {
            statement.setString(1, keyword);
            statement.setString(2, keyword);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<Product> products = new ArrayList<>();
                while (resultSet.next()) {
                    products.add(mapProduct(resultSet));
                }
                return products;
            }
        }
    }

    public Optional<Product> findById(int id) throws SQLException {
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT " + PRODUCT_COLUMNS + " FROM products WHERE id = ?" + activeAndClause(connection)
             )) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapProduct(resultSet));
                }
                return Optional.empty();
            }
        }
    }

    public Product create(Product product) throws SQLException {
        String sql = "INSERT INTO products (name, description, price, stock, category, image_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, product.getName());
            statement.setString(2, product.getDescription());
            statement.setBigDecimal(3, product.getPrice());
            statement.setInt(4, product.getStock());
            statement.setString(5, product.getCategory());
            statement.setString(6, product.getImageUrl());
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    product.setId(keys.getInt(1));
                }
            }
            return product;
        }
    }

    public boolean update(Product product) throws SQLException {
        try (Connection connection = DbUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "UPDATE products SET name = ?, description = ?, price = ?, stock = ?, category = ?, image_url = ? WHERE id = ?"
                             + activeAndClause(connection)
             )) {
            statement.setString(1, product.getName());
            statement.setString(2, product.getDescription());
            statement.setBigDecimal(3, product.getPrice());
            statement.setInt(4, product.getStock());
            statement.setString(5, product.getCategory());
            statement.setString(6, product.getImageUrl());
            statement.setInt(7, product.getId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean deleteById(int id) throws SQLException {
        try (Connection connection = DbUtil.getConnection()) {
            ensureProductActiveColumn(connection);
            PreparedStatement statement = connection.prepareStatement("UPDATE products SET active = FALSE WHERE id = ? AND active = TRUE");
            statement.setInt(1, id);
            try (statement) {
                return statement.executeUpdate() > 0;
            }
        }
    }

    private String activeWhereClause(Connection connection) throws SQLException {
        return hasProductActiveColumn(connection) ? " WHERE active = TRUE" : "";
    }

    private String activeAndClause(Connection connection) throws SQLException {
        return hasProductActiveColumn(connection) ? " AND active = TRUE" : "";
    }

    private boolean hasProductActiveColumn(Connection connection) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM information_schema.columns
                WHERE table_schema = DATABASE()
                  AND table_name = 'products'
                  AND column_name = 'active'
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1) > 0;
        }
    }

    private void ensureProductActiveColumn(Connection connection) throws SQLException {
        if (hasProductActiveColumn(connection)) {
            return;
        }

        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate("ALTER TABLE products ADD COLUMN active BOOLEAN NOT NULL DEFAULT TRUE AFTER image_url");
            statement.executeUpdate("UPDATE products SET active = TRUE WHERE active IS NULL");
        }
    }

    private Product mapProduct(ResultSet resultSet) throws SQLException {
        Product product = new Product();
        product.setId(resultSet.getInt("id"));
        product.setName(resultSet.getString("name"));
        product.setDescription(resultSet.getString("description"));
        product.setPrice(resultSet.getBigDecimal("price"));
        product.setStock(resultSet.getInt("stock"));
        product.setCategory(CatalogUtil.resolveCategory(
                resultSet.getString("category"),
                product.getName(),
                product.getDescription()
        ));
        product.setImageUrl(CatalogUtil.resolveImageUrl(
                resultSet.getString("image_url"),
                product.getCategory(),
                product.getName(),
                product.getDescription()
        ));
        return product;
    }
}
