package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.ejb.EJB;

import com.crs.dao.UserDAO;
import com.crs.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @EJB
    private UserDAO userDAO;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // In real app, hash this before sending to DAO

        User user = userDAO.validateUser(username, password);

        if (user != null) {
            // Login Success: Create Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Role-Based Redirection
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("OFFICER".equals(user.getRole())) {
                response.sendRedirect("officer_dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=UnknownRole");
            }
        } else {
            // Login Failed
            request.setAttribute("errorMessage", "Invalid Username or Password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	// Redirect GET requests to login page
    	response.sendRedirect("login.jsp");
    }
}