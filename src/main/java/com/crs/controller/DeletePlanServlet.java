package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.crs.config.DBConnection;

@WebServlet("/DeletePlanServlet")
public class DeletePlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String planId = request.getParameter("id");
        
        if (planId != null) {
            try (Connection conn = DBConnection.getConnection()) {
                
                // 1. First, delete related milestones (to prevent Foreign Key error)
                String sqlMilestones = "DELETE FROM recovery_milestones WHERE plan_id = ?";
                try (PreparedStatement stmt1 = conn.prepareStatement(sqlMilestones)) {
                    stmt1.setString(1, planId);
                    stmt1.executeUpdate();
                }

                // 2. Then, delete the plan itself
                String sqlPlan = "DELETE FROM recovery_plans WHERE plan_id = ?";
                try (PreparedStatement stmt2 = conn.prepareStatement(sqlPlan)) {
                    stmt2.setString(1, planId);
                    stmt2.executeUpdate();
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Redirect back to the list
        response.sendRedirect("view_plans.jsp");
    }
}