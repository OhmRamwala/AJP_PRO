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
import java.util.Optional;

@WebServlet("/admin/product/edit")
public class AdminProductEditServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        int productId = parseInt(request.getParameter("id"), -1);
        if (productId <= 0) {
            setFlash(request.getSession(), "danger", "Please choose a valid product to edit.");
            redirect(request, response, "/admin");
            return;
        }

        try {
            Optional<Product> product = productDao.findById(productId);
            if (product.isEmpty()) {
                setFlash(request.getSession(), "warning", "That product is no longer available for editing.");
                redirect(request, response, "/admin");
                return;
            }

            request.setAttribute("product", product.get());
            request.setAttribute("pageTitle", "Edit Product");
            forward(request, response, "edit-product.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load product editor", exception);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        int productId = parseInt(request.getParameter("id"), -1);
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
            redirect(request, response, "/admin/product/edit?id=" + productId);
            return;
        }

        if (productId <= 0
                || name.isBlank()
                || description.isBlank()
                || category.isBlank()
                || CatalogUtil.findByName(category).isEmpty()
                || stock < 0
                || price.compareTo(BigDecimal.ZERO) < 0) {
            setFlash(request.getSession(), "danger", "All product fields are required and values must be valid.");
            redirect(request, response, "/admin/product/edit?id=" + productId);
            return;
        }

        Product product = new Product();
        product.setId(productId);
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        product.setCategory(CatalogUtil.normalizeCategoryName(category));
        product.setImageUrl(imageUrl);

        try {
            if (!productDao.update(product)) {
                setFlash(request.getSession(), "warning", "That product could not be updated.");
                redirect(request, response, "/admin");
                return;
            }

            setFlash(request.getSession(), "success", "Product updated successfully.");
            redirect(request, response, "/admin");
        } catch (SQLException exception) {
            throw new ServletException("Unable to update product", exception);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
