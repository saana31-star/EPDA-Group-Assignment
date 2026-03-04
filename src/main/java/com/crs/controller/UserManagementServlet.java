package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.crs.config.DBConnection;
import com.crs.model.User;

@WebServlet("/UserManagementServlet")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 1. LIST USERS (GET Request)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> userList = new ArrayList<>();
        
        // Check for specific actions like "edit" or "delete"
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteUser(request, response);
            return;
        }

        // Default: Fetch all users
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {
            
            while (rs.next()) {
                userList.add(new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"), // Showing password for demo/debugging only
                    rs.getString("role"),
                    rs.getString("email")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("manage_users.jsp").forward(request, response);
    }

    // 2. ADD / UPDATE USER (POST Request)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password, role, email) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role);
            stmt.setString(4, email);
            stmt.executeUpdate();
            
            // Redirect with success message
            response.sendRedirect("UserManagementServlet?msg=UserAdded");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?error=DatabaseError");
        }
    }
    
    // Helper to delete user
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE user_id = ?");
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("UserManagementServlet?msg=UserDeleted");
    }
}