package com.ekart.servlet;

import com.ekart.model.CartItem;
import com.ekart.model.Category;
import com.ekart.model.Product;
import com.ekart.model.User;
import com.ekart.util.CatalogUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public abstract class BaseServlet extends HttpServlet {
    protected void forward(HttpServletRequest request, HttpServletResponse response, String view)
            throws ServletException, IOException {
        populateCommonAttributes(request);
        request.getRequestDispatcher("/WEB-INF/views/" + view).forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    protected User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    @SuppressWarnings("unchecked")
    protected Map<Integer, CartItem> getCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Object existing = session.getAttribute("cart");
        if (existing instanceof Map<?, ?>) {
            return (Map<Integer, CartItem>) existing;
        }

        Map<Integer, CartItem> cart = new LinkedHashMap<>();
        session.setAttribute("cart", cart);
        return cart;
    }

    protected boolean requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (getLoggedInUser(request) == null) {
            setFlash(request.getSession(), "warning", "Please log in to continue.");
            redirect(request, response, "/login");
            return false;
        }
        return true;
    }

    protected boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getLoggedInUser(request);
        if (user == null) {
            setFlash(request.getSession(), "warning", "Admin access requires login.");
            redirect(request, response, "/login");
            return false;
        }
        if (!user.isAdmin()) {
            setFlash(request.getSession(), "danger", "You do not have access to the admin panel.");
            redirect(request, response, "/home");
            return false;
        }
        return true;
    }

    protected void setFlash(HttpSession session, String type, String message) {
        session.setAttribute("flashType", type);
        session.setAttribute("flashMessage", message);
    }

    protected int parseInt(String rawValue, int fallback) {
        try {
            return Integer.parseInt(rawValue);
        } catch (NumberFormatException exception) {
            return fallback;
        }
    }

    protected Map<String, List<Product>> buildProductsByCategory(List<Product> products, int perCategoryLimit) {
        Map<String, List<Product>> groupedProducts = new LinkedHashMap<>();
        for (Category category : CatalogUtil.getCategories()) {
            groupedProducts.put(category.getName(), new ArrayList<>());
        }

        if (products == null) {
            return groupedProducts;
        }

        for (Product product : products) {
            String categoryName = CatalogUtil.normalizeCategoryName(product.getCategory());
            List<Product> bucket = groupedProducts.computeIfAbsent(categoryName, ignored -> new ArrayList<>());
            if (perCategoryLimit <= 0 || bucket.size() < perCategoryLimit) {
                bucket.add(product);
            }
        }
        return groupedProducts;
    }

    private void populateCommonAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        request.setAttribute("currentUser", getLoggedInUser(request));
        request.setAttribute("cartCount", calculateCartCount(session));
        request.setAttribute("categories", CatalogUtil.getCategories());

        if (session != null) {
            request.setAttribute("flashType", session.getAttribute("flashType"));
            request.setAttribute("flashMessage", session.getAttribute("flashMessage"));
            session.removeAttribute("flashType");
            session.removeAttribute("flashMessage");
        }
    }

    private int calculateCartCount(HttpSession session) {
        if (session == null) {
            return 0;
        }
        Object existing = session.getAttribute("cart");
        if (!(existing instanceof Map<?, ?> cart)) {
            return 0;
        }

        int count = 0;
        for (Object value : cart.values()) {
            if (value instanceof CartItem item) {
                count += item.getQuantity();
            }
        }
        return count;
    }
}
