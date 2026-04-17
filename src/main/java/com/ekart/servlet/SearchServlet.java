package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/search")
public class SearchServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        String normalizedQuery = query == null ? "" : query.trim();
        request.setAttribute("searchQuery", normalizedQuery);

        try {
            if (normalizedQuery.isBlank()) {
                request.setAttribute("products", productDao.findFeatured(8));
            } else {
                request.setAttribute("products", productDao.searchProducts(normalizedQuery));
            }
            forward(request, response, "search.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to search products", exception);
        }
    }
}
