package com.sunrisedental.servlet;

import com.sunrisedental.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean isValid = userDAO.validateUser(username, password);

        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("dashboard.jsp");
        } else {
            response.sendRedirect("index.jsp?error=InvalidCredentials");
        }
    }
}