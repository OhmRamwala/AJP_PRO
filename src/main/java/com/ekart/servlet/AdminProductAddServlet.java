package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import com.ekart.model.Product;
import com.ekart.util.CatalogUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/admin/product/add")
public class AdminProductAddServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String name = safeTrim(request.getParameter("name"));
        String description = safeTrim(request.getParameter("description"));
        String imageUrl = safeTrim(request.getParameter("imageUrl"));
        String category = safeTrim(request.getParameter("category"));
        int stock = parseInt(request.getParameter("stock"), -1);
        BigDecimal price;

        try {
            price = new BigDecimal(request.getParameter("price"));
        } catch (Exception exception) {
            setFlash(request.getSession(), "danger", "Please provide a valid product price.");
            redirect(request, response, "/admin");
            return;
        }

        if (name.isBlank()
                || description.isBlank()
                || category.isBlank()
                || CatalogUtil.findByName(category).isEmpty()
                || stock < 0
                || price.compareTo(BigDecimal.ZERO) < 0) {
            setFlash(request.getSession(), "danger", "All product fields are required and values must be valid.");
            redirect(request, response, "/admin");
            return;
        }

        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        product.setCategory(CatalogUtil.normalizeCategoryName(category));
        product.setImageUrl(imageUrl);

        try {
            productDao.create(product);
            setFlash(request.getSession(), "success", "Product added successfully.");
            redirect(request, response, "/admin");
        } catch (SQLException exception) {
            throw new ServletException("Unable to add product", exception);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
