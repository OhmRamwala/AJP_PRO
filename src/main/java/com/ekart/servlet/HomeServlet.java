package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/home")
public class HomeServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("featuredProducts", productDao.findFeatured(8));
            request.setAttribute("productsByCategory", buildProductsByCategory(productDao.findAll(), 4));
            forward(request, response, "index.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load home page", exception);
        }
    }
}
