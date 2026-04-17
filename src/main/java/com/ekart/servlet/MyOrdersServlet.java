package com.ekart.servlet;

import com.ekart.dao.OrderDao;
import com.ekart.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/my-orders")
public class MyOrdersServlet extends BaseServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireLogin(request, response)) {
            return;
        }

        User user = getLoggedInUser(request);
        try {
            request.setAttribute("orders", orderDao.findOrdersByUserId(user.getId()));
            forward(request, response, "my-orders.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load your orders", exception);
        }
    }
}
