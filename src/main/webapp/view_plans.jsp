<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.crs.config.DBConnection, com.crs.model.User" %>
<%
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
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4; 
            --dusty-purple: #AE82A4; --dark-blue: #5C617B; 
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 30px 20px; margin: 0; }
        
        .container { 
            max-width: 1000px; margin: 0 auto; background: white; padding: 30px; 
            border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-top: 5px solid var(--dusty-purple);
        }
        
        h2 { color: var(--dark-blue); border-bottom: 2px solid var(--light-blue); padding-bottom: 15px; margin-top: 0; margin-bottom: 25px; }
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background-color: var(--dark-blue); color: white; text-transform: uppercase; font-size: 0.85em; letter-spacing: 0.5px; }
        
        .status-badge { padding: 5px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; background: var(--light-blue); color: var(--dark-blue); }
        
        .btn-back { display: inline-block; margin-bottom: 20px; padding: 10px 15px; background: var(--med-blue); color: white; text-decoration: none; border-radius: 6px; transition: 0.3s; }
        .btn-back:hover { opacity: 0.85; }
        
        .remove-btn { color: var(--pink); font-weight: bold; text-decoration: none; padding: 5px 10px; border: 1px solid var(--pink); border-radius: 6px; transition: 0.3s; }
        .remove-btn:hover { background: var(--pink); color: white; }
        
        .helper-text { margin-top: 25px; font-size: 0.95em; color: var(--med-blue); background: var(--bg-color); padding: 15px; border-radius: 8px; border-left: 4px solid var(--med-blue); }
    </style>
</head>
<body>

<div class="container">
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="btn-back">← Back to Dashboard</a>
    
    <h2>Active Course Recovery Plans</h2>
    
    <table>
        <thead>
            <tr>
                <th>Plan ID</th> <th>Student Name</th> <th>Failed Course</th> 
                <th>Target Semester</th> <th>Action Plan</th> <th>Status</th> <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                String sql = "SELECT p.plan_id, s.name, c.course_title, p.semester, p.failed_components, p.status " +
                             "FROM recovery_plans p JOIN students s ON p.student_id = s.student_id " +
                             "JOIN courses c ON p.course_code = c.course_code";
                
                ResultSet rs = stmt.executeQuery(sql);
                boolean hasRecords = false;
                
                while (rs.next()) {
                    hasRecords = true;
                    int planId = rs.getInt("plan_id");
        %>
            <tr>
                <td><strong>#<%= planId %></strong></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("course_title") %></td>
                <td><%= rs.getString("semester") %></td>
                <td><%= rs.getString("failed_components") %></td>
                <td><span class="status-badge"><%= rs.getString("status") %></span></td>
                <td>
                    <a href="DeletePlanServlet?id=<%= planId %>" onclick="return confirm('Remove this recovery plan?');" class="remove-btn">Remove</a>
                </td>
            </tr>
        <% 
                }
                if (!hasRecords) {
        %>
            <tr><td colspan="7" style="text-align:center; padding: 30px; color: #888;">No active recovery plans found.</td></tr>
        <%
                }
            } catch (Exception e) { e.printStackTrace(); }
        %>
        </tbody>
    </table>
    
    <div class="helper-text">
        💡 To create a <b>New Plan</b>, go to the "Eligibility Check" module and select a student marked as "At Risk".
    </div>
</div>

</body>
</html>