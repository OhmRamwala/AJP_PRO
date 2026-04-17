package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import com.ekart.model.Category;
import com.ekart.util.CatalogUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/category")
public class CategoryServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String slug = request.getParameter("slug");
        Optional<Category> selectedCategory = CatalogUtil.findBySlug(slug);
        if (selectedCategory.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            request.setAttribute("selectedCategory", selectedCategory.get());
            request.setAttribute("products", productDao.getProductsByCategory(selectedCategory.get().getName()));
            forward(request, response, "category.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load category page", exception);
        }
    }
}
