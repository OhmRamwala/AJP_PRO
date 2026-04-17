package com.ekart.servlet;

import com.ekart.dao.UserDao;
import com.ekart.model.CartItem;
import com.ekart.model.User;
import com.ekart.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("adminEmail", "admin@ekart.com");
        request.setAttribute("adminPassword", "admin123");
        forward(request, response, "login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = normalizeEmail(request.getParameter("email"));
        String password = request.getParameter("password");
        request.setAttribute("formEmail", email);

        if (email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("pageError", "Email and password are required.");
            request.setAttribute("adminEmail", "admin@ekart.com");
            request.setAttribute("adminPassword", "admin123");
            forward(request, response, "login.jsp");
            return;
        }

        try {
            Optional<User> userOptional = userDao.findByEmail(email);
            if (userOptional.isEmpty() || !PasswordUtil.matches(password, userOptional.get().getPassword())) {
                request.setAttribute("pageError", "Invalid email or password.");
                request.setAttribute("adminEmail", "admin@ekart.com");
                request.setAttribute("adminPassword", "admin123");
                forward(request, response, "login.jsp");
                return;
            }

            User user = userOptional.get();
            HttpSession previousSession = request.getSession(false);
            Map<Integer, CartItem> existingCart = new LinkedHashMap<>();
            if (previousSession != null) {
                Object cart = previousSession.getAttribute("cart");
                if (cart instanceof Map<?, ?> cartMap) {
                    for (Map.Entry<?, ?> entry : cartMap.entrySet()) {
                        if (entry.getKey() instanceof Integer key && entry.getValue() instanceof CartItem value) {
                            existingCart.put(key, value);
                        }
                    }
                }
                previousSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("cart", existingCart);
            setFlash(session, "success", "Welcome back, " + user.getName() + ".");
            redirect(request, response, user.isAdmin() ? "/admin" : "/products");
        } catch (SQLException exception) {
            throw new ServletException("Unable to process login", exception);
        }
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }
}
