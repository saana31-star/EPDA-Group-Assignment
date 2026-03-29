package com.crs.controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.crs.dao.UserDAO;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    
    @EJB
    private UserDAO userDAO;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        
        boolean success = userDAO.resetPasswordIfValid(token, newPassword);
        
        if (success) {
            response.sendRedirect("login.jsp?msg=PasswordUpdated");
        } else {
            response.sendRedirect("login.jsp?error=InvalidToken");
        }
    }
}