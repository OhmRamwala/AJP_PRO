package com.ekart.servlet;

import com.ekart.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/order/delete")
public class AdminOrderDeleteServlet extends BaseServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        int orderId = parseInt(request.getParameter("id"), -1);
        if (orderId <= 0) {
            setFlash(request.getSession(), "warning", "Invalid order selected.");
            redirect(request, response, "/admin");
            return;
        }

        try {
            if (orderDao.deleteOrder(orderId)) {
                setFlash(request.getSession(), "success", "Order #" + orderId + " deleted.");
            } else {
                setFlash(request.getSession(), "warning", "Order #" + orderId + " could not be found.");
            }
            redirect(request, response, "/admin");
        } catch (SQLException exception) {
            throw new ServletException("Unable to delete order", exception);
        }
    }
}
