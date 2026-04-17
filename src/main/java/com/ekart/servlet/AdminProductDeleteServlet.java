package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/product/delete")
public class AdminProductDeleteServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        int productId = parseInt(request.getParameter("id"), -1);
        if (productId <= 0) {
            setFlash(request.getSession(), "danger", "Invalid product selected.");
            redirect(request, response, "/admin");
            return;
        }

        try {
            boolean deleted = productDao.deleteById(productId);
            if (deleted) {
                setFlash(request.getSession(), "success", "Product removed from the storefront successfully.");
            } else {
                setFlash(request.getSession(), "warning", "Product not found.");
            }
            redirect(request, response, "/admin");
        } catch (SQLException exception) {
            setFlash(request.getSession(), "danger", "Unable to remove this product right now.");
            redirect(request, response, "/admin");
        }
    }
}
