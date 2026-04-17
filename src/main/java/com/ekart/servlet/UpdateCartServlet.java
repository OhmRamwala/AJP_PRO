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

@WebServlet("/cart/update")
public class UpdateCartServlet extends BaseServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = parseInt(request.getParameter("productId"), -1);
        int quantity = parseInt(request.getParameter("quantity"), 1);
        Map<Integer, CartItem> cart = getCart(request);

        if (!cart.containsKey(productId)) {
            redirect(request, response, "/cart");
            return;
        }

        if (quantity <= 0) {
            cart.remove(productId);
            setFlash(request.getSession(), "success", "Item removed from cart.");
            redirect(request, response, "/cart");
            return;
        }

        try {
            Optional<Product> productOptional = productDao.findById(productId);
            if (productOptional.isEmpty()) {
                cart.remove(productId);
                setFlash(request.getSession(), "warning", "Product no longer exists and was removed from your cart.");
                redirect(request, response, "/cart");
                return;
            }

            Product product = productOptional.get();
            int finalQuantity = Math.min(quantity, product.getStock());
            if (finalQuantity <= 0) {
                cart.remove(productId);
                setFlash(request.getSession(), "warning", "Product is out of stock and was removed from your cart.");
            } else {
                cart.put(productId, new CartItem(product, finalQuantity));
                if (finalQuantity < quantity) {
                    setFlash(request.getSession(), "warning", "Quantity adjusted to match current stock.");
                } else {
                    setFlash(request.getSession(), "success", "Cart updated successfully.");
                }
            }
            redirect(request, response, "/cart");
        } catch (SQLException exception) {
            throw new ServletException("Unable to update cart", exception);
        }
    }
}
