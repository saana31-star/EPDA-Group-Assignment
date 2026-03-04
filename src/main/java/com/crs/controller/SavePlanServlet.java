package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.crs.config.DBConnection;
import com.crs.util.EmailUtility;

@WebServlet("/SavePlanServlet")
public class SavePlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String courseCode = request.getParameter("courseCode");
        String components = request.getParameter("failedComponents");
        String strategy = request.getParameter("strategy");
        String semester = request.getParameter("semester");

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Insert the Plan into Database
            String sql = "INSERT INTO recovery_plans (student_id, course_code, semester, failed_components, status) VALUES (?, ?, ?, ?, 'APPROVED')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, studentId);
            stmt.setString(2, courseCode);
            stmt.setString(3, semester);
            stmt.setString(4, components);
            stmt.executeUpdate();
            
            // 2. Fetch Student Email for Notification
            String emailSql = "SELECT name, email FROM students WHERE student_id = ?";
            PreparedStatement emailStmt = conn.prepareStatement(emailSql);
            emailStmt.setString(1, studentId);
            ResultSet rs = emailStmt.executeQuery();
            
            if (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                
                // 3. Send Email (Simulation)
                EmailUtility.sendRecoveryNotification(email, name, courseCode, strategy);
            }

            // 4. Redirect back to Dashboard with success message
            response.sendRedirect("officer_dashboard.jsp?msg=PlanSaved");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recovery_plan.jsp?error=DatabaseError");
        }
    }
}