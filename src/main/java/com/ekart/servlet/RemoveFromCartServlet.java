package com.ekart.servlet;

import com.ekart.model.CartItem;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/cart/remove")
public class RemoveFromCartServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = parseInt(request.getParameter("productId"), -1);
        Map<Integer, CartItem> cart = getCart(request);
        if (cart.remove(productId) != null) {
            setFlash(request.getSession(), "success", "Item removed from cart.");
        }
        redirect(request, response, "/cart");
    }
}
