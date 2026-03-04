<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.crs.config.DBConnection, com.crs.model.User" %>
<%
    // Security Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"OFFICER".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Monitor Recovery Plans</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { border-bottom: 2px solid #e67e22; padding-bottom: 10px; color: #d35400; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background-color: #e67e22; color: white; }
        .status-badge { padding: 4px 8px; border-radius: 4px; font-size: 0.9em; font-weight: bold; background: #28a745; color: white; }
        .btn-back { display: inline-block; margin-bottom: 15px; padding: 8px 15px; background: #6c757d; color: white; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>

<div class="container">
    <a href="officer_dashboard.jsp" class="btn-back">← Back to Dashboard</a>
    
    <h2>Active Course Recovery Plans</h2>
    
    <table>
        <thead>
            <tr>
                <th>Plan ID</th>
                <th>Student Name</th>
                <th>Failed Course</th>
                <th>Target Semester</th>
                <th>Action Plan</th>
                <th>Status</th>
                <th>Action</th> </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                String sql = "SELECT p.plan_id, s.name, c.course_title, p.semester, p.failed_components, p.status " +
                             "FROM recovery_plans p " +
                             "JOIN students s ON p.student_id = s.student_id " +
                             "JOIN courses c ON p.course_code = c.course_code";
                
                ResultSet rs = stmt.executeQuery(sql);
                boolean hasRecords = false;
                
                while (rs.next()) {
                    hasRecords = true;
                    int planId = rs.getInt("plan_id");
        %>
            <tr>
                <td>#<%= planId %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("course_title") %></td>
                <td><%= rs.getString("semester") %></td>
                <td><%= rs.getString("failed_components") %></td>
                <td><span class="status-badge"><%= rs.getString("status") %></span></td>
                <td>
                    <a href="DeletePlanServlet?id=<%= planId %>" 
                       onclick="return confirm('Are you sure you want to remove this recovery plan?');"
                       style="color:red; text-decoration:none; font-weight:bold;">
                       Remove
                    </a>
                </td>
            </tr>
        <% 
                }
                if (!hasRecords) {
        %>
            <tr><td colspan="7" style="text-align:center; padding: 20px;">No active recovery plans found.</td></tr>
        <%
                }
            } catch (Exception e) { e.printStackTrace(); }
        %>
        </tbody>
    </table>
    
    <div style="margin-top: 20px; font-size: 0.9em; color: #666;">
        To create a <b>New Plan</b>, go to "Eligibility Check" and select a student marked as "At Risk".
    </div>
</div>

</body>
</html>