package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.crs.config.DBConnection;
import com.crs.model.Milestone;
import com.crs.model.User;

@WebServlet("/MilestoneServlet")
public class MilestoneServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"OFFICER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String planId = request.getParameter("planId");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String milestoneId = request.getParameter("id");
            executeSingle("DELETE FROM recovery_milestones WHERE milestone_id = ?", milestoneId);
            response.sendRedirect("MilestoneServlet?planId=" + planId);
            return;
        }

        if ("toggle".equals(action)) {
            String milestoneId = request.getParameter("id");
            executeSingle("UPDATE recovery_milestones SET is_completed = NOT is_completed WHERE milestone_id = ?", milestoneId);
            response.sendRedirect("MilestoneServlet?planId=" + planId);
            return;
        }

        // Default: Load plan info + milestones
        try (Connection conn = DBConnection.getConnection()) {

            // Fetch plan details
            PreparedStatement planStmt = conn.prepareStatement(
                "SELECT p.plan_id, s.name, c.course_title, p.semester, p.status " +
                "FROM recovery_plans p " +
                "JOIN students s ON p.student_id = s.student_id " +
                "JOIN courses c ON p.course_code = c.course_code " +
                "WHERE p.plan_id = ?");
            planStmt.setInt(1, Integer.parseInt(planId));
            ResultSet planRs = planStmt.executeQuery();

            if (planRs.next()) {
                request.setAttribute("planId", planId);
                request.setAttribute("studentName", planRs.getString("name"));
                request.setAttribute("courseTitle", planRs.getString("course_title"));
                request.setAttribute("semester", planRs.getString("semester"));
                request.setAttribute("planStatus", planRs.getString("status"));
            }

            // Fetch milestones
            PreparedStatement msStmt = conn.prepareStatement(
                "SELECT * FROM recovery_milestones WHERE plan_id = ? ORDER BY milestone_id ASC");
            msStmt.setInt(1, Integer.parseInt(planId));
            ResultSet msRs = msStmt.executeQuery();

            List<Milestone> milestones = new ArrayList<>();
            while (msRs.next()) {
                milestones.add(new Milestone(
                    msRs.getInt("milestone_id"),
                    msRs.getInt("plan_id"),
                    msRs.getString("week"),
                    msRs.getString("task"),
                    msRs.getBoolean("is_completed")
                ));
            }
            request.setAttribute("milestones", milestones);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("manage_milestones.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String planId = request.getParameter("planId");
        String week   = request.getParameter("week");
        String task   = request.getParameter("task");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO recovery_milestones (plan_id, week, task, is_completed) VALUES (?, ?, ?, FALSE)");
            stmt.setInt(1, Integer.parseInt(planId));
            stmt.setString(2, week);
            stmt.setString(3, task);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("MilestoneServlet?planId=" + planId + "&msg=added");
    }

    // Helper: run a single-param DELETE or UPDATE
    private void executeSingle(String sql, String id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id));
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}