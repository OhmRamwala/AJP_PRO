package com.ekart.servlet;

import com.ekart.dao.UserDao;
import com.ekart.model.User;
import com.ekart.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        forward(request, response, "register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = safeTrim(request.getParameter("name"));
        String email = safeTrim(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");

        request.setAttribute("formName", name);
        request.setAttribute("formEmail", email);

        if (name.isBlank() || email.isBlank() || password == null || password.length() < 6) {
            request.setAttribute("pageError", "Name, valid email, and a password of at least 6 characters are required.");
            forward(request, response, "register.jsp");
            return;
        }

        try {
            if (userDao.emailExists(email)) {
                request.setAttribute("pageError", "An account with this email already exists.");
                forward(request, response, "register.jsp");
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hash(password));
            user.setRole("CUSTOMER");
            userDao.create(user);

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            setFlash(session, "success", "Account created successfully. You are now logged in.");
            redirect(request, response, "/products");
        } catch (SQLException exception) {
            throw new ServletException("Unable to register user", exception);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
