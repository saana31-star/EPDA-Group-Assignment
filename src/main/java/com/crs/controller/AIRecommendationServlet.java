package com.crs.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/AIRecommendationServlet")
public class AIRecommendationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get student info directly from request params (passed from view_report.jsp)
        String studentId   = request.getParameter("studentId");
        String studentName = request.getParameter("studentName");
        String program     = request.getParameter("program");
        double cgpa = 0.0;
        try { cgpa = Double.parseDouble(request.getParameter("cgpa")); } catch (Exception e) {}

        int failCount = 0;
        List<String> failedCourses   = new ArrayList<>();
        List<String> recommendations = new ArrayList<>();
        String riskLevel = "";

        // Only query DB for failed courses
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/crs_db", "root", "your_password");

            PreparedStatement ps = conn.prepareStatement(
                "SELECT course_code, course_title FROM academic_records WHERE student_id = ? AND grade_point < 2.0");
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                failedCourses.add(rs.getString("course_code") + " - " + rs.getString("course_title"));
                failCount++;
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }

        // ── Smart Rule-Based AI Logic ─────────────────────────

        // Risk level
        if (cgpa < 2.0 || failCount >= 3) {
            riskLevel = "HIGH";
        } else if (cgpa < 2.5 || failCount >= 1) {
            riskLevel = "MEDIUM";
        } else {
            riskLevel = "LOW";
        }

        // CGPA-based recommendations
        if (cgpa < 2.0) {
            recommendations.add("⚠️ CGPA is critically below 2.0. Immediate academic counselling is strongly recommended.");
            recommendations.add("📚 Enrol in all at-risk courses under the Course Recovery Programme.");
            recommendations.add("🗓️ Schedule bi-weekly check-in meetings with your academic advisor.");
        } else if (cgpa < 2.5) {
            recommendations.add("📈 CGPA is below 2.5. Focus on improving grades in weaker subjects this semester.");
            recommendations.add("📝 Attend supplementary classes or peer tutoring sessions to boost performance.");
        } else if (cgpa < 3.0) {
            recommendations.add("✅ CGPA is satisfactory. Push for above 3.0 by staying consistent this semester.");
        } else {
            recommendations.add("🌟 Excellent CGPA! Maintain this level of performance and consider advanced modules.");
        }

        // Failed course recommendations (only if applicable)
        if (failCount >= 3) {
            recommendations.add("🚫 " + failCount + " at-risk courses detected — progression to next level is at risk.");
            recommendations.add("📋 A formal Course Recovery Plan must be initiated immediately for all affected courses.");
        } else if (failCount > 0) {
            recommendations.add("🔁 " + failCount + " at-risk course(s) detected. Enrol in course recovery for: " + String.join(", ", failedCourses) + ".");
        }

        // Always include general tip
        recommendations.add("💡 Review lecture materials regularly, submit assignments on time, and actively seek lecturer feedback.");

        // Pass everything to JSP
        request.setAttribute("studentId",       studentId);
        request.setAttribute("studentName",     studentName);
        request.setAttribute("program",         program);
        request.setAttribute("cgpa",            cgpa);
        request.setAttribute("failCount",       failCount);
        request.setAttribute("failedCourses",   failedCourses);
        request.setAttribute("riskLevel",       riskLevel);
        request.setAttribute("recommendations", recommendations);

        request.getRequestDispatcher("ai_recommendation.jsp").forward(request, response);
    }
}