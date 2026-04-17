package com.ekart.servlet;

import com.ekart.dao.OrderDao;
import com.ekart.model.CartItem;
import com.ekart.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends BaseServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireLogin(request, response)) {
            return;
        }

        Map<Integer, CartItem> cart = getCart(request);
        if (cart.isEmpty()) {
            setFlash(request.getSession(), "warning", "Your cart is empty.");
            redirect(request, response, "/cart");
            return;
        }

        User user = getLoggedInUser(request);
        try {
            int orderId = orderDao.placeOrder(user.getId(), cart.values());
            cart.clear();
            setFlash(request.getSession(), "success", "Order #" + orderId + " placed successfully.");
            redirect(request, response, "/cart");
        } catch (SQLException exception) {
            setFlash(request.getSession(), "danger", "Checkout failed: " + exception.getMessage());
            redirect(request, response, "/cart");
        }
    }
}
