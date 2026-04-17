package com.ekart.servlet;

import com.ekart.dao.ProductDao;
import com.ekart.model.CartItem;
import com.ekart.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.Optional;

@WebServlet("/cart/add")
public class AddToCartServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = parseInt(request.getParameter("productId"), -1);
        int quantity = Math.max(1, parseInt(request.getParameter("quantity"), 1));

        try {
            Optional<Product> productOptional = productDao.findById(productId);
            if (productOptional.isEmpty()) {
                setFlash(request.getSession(), "danger", "Product not found.");
                redirect(request, response, "/products");
                return;
            }

            Product product = productOptional.get();
            if (product.getStock() <= 0) {
                setFlash(request.getSession(), "warning", "This product is currently out of stock.");
                redirect(request, response, "/product?id=" + productId);
                return;
            }

            Map<Integer, CartItem> cart = getCart(request);
            CartItem existingItem = cart.get(productId);
            int currentQuantity = existingItem == null ? 0 : existingItem.getQuantity();
            int finalQuantity = Math.min(product.getStock(), currentQuantity + quantity);

            cart.put(productId, new CartItem(product, finalQuantity));
            if (finalQuantity < currentQuantity + quantity) {
                setFlash(request.getSession(), "warning", "Cart quantity adjusted to available stock.");
            } else {
                setFlash(request.getSession(), "success", product.getName() + " added to cart.");
            }
            redirect(request, response, "/cart");
        } catch (SQLException exception) {
            throw new ServletException("Unable to add item to cart", exception);
        }
    }
}
