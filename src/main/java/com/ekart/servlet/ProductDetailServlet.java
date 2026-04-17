package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import com.ekart.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/product")
public class ProductDetailServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = parseInt(request.getParameter("id"), -1);
        if (productId <= 0) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            Optional<Product> product = productDao.findById(productId);
            if (product.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            Product selectedProduct = product.get();
            List<Product> relatedProducts = new ArrayList<>();
            for (Product relatedProduct : productDao.getProductsByCategory(selectedProduct.getCategory())) {
                if (relatedProduct.getId() != selectedProduct.getId() && relatedProducts.size() < 4) {
                    relatedProducts.add(relatedProduct);
                }
            }
            request.setAttribute("product", selectedProduct);
            request.setAttribute("relatedProducts", relatedProducts);
            forward(request, response, "product.jsp");
        } catch (SQLException exception) {
            throw new ServletException("Unable to load product details", exception);
        }
    }
}
