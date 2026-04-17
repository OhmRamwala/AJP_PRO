package com.ekart.servlet;

import com.ekart.dao.OrderDao;
import com.ekart.dao.ProductDao;
import com.ekart.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin")
public class AdminServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        try {
            request.setAttribute("products", productDao.findAll());
            request.setAttribute("orders", orderDao.findAllOrders());
            request.setAttribute("users", userDao.findAllUsers());
            forward(request, response, "admin.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load admin dashboard", exception);
        }
    }
}
