package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/products")
public class ProductListServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            var products = productDao.findAll();
            request.setAttribute("products", products);
            request.setAttribute("productsByCategory", buildProductsByCategory(products, 0));
            forward(request, response, "products.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load products", exception);
        }
    }
}
