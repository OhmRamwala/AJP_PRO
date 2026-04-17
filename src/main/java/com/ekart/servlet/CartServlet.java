package com.ekart.servlet;

import com.ekart.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CartItem> items = new ArrayList<>(getCart(request).values());
        BigDecimal cartTotal = BigDecimal.ZERO;
        for (CartItem item : items) {
            cartTotal = cartTotal.add(item.getSubtotal());
        }

        request.setAttribute("cartItems", items);
        request.setAttribute("cartTotal", cartTotal);
        forward(request, response, "cart.jsp");
    }
}
