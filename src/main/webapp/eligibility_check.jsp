<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.crs.model.Student, com.crs.model.User" %>
<%
    // Security Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Student> list = (List<Student>) request.getAttribute("studentList");
    
    // Check if the user is an OFFICER (to decide whether to show the Action column)
    boolean isOfficer = "OFFICER".equals(user.getRole());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eligibility Check</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; margin-bottom: 20px;}
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background-color: #007bff; color: white; }
        .status-pass { color: green; font-weight: bold; }
        .status-fail { color: red; font-weight: bold; }
        .btn-back { display: inline-block; margin-bottom: 15px; padding: 10px 15px; background: #6c757d; color: white; text-decoration: none; border-radius: 4px; }
        .recover-link { color: #007bff; font-weight: bold; text-decoration: none; border: 1px solid #007bff; padding: 5px 10px; border-radius: 4px; transition: 0.3s; }
        .recover-link:hover { background-color: #007bff; color: white; }
    </style>
</head>
<body>

<div class="container">
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="btn-back">← Back to Dashboard</a>
    
    <h2>Student Eligibility Status</h2>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Program</th>
                <th>CGPA</th>
                <th>Failed Courses</th>
                <th>Status</th>
                
                <%-- ONLY SHOW Action Header if user is an OFFICER --%>
                <% if (isOfficer) { %>
                    <th>Action</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
        <% if (list != null) { for (Student s : list) { %>
            <tr>
                <td><%= s.getStudentId() %></td>
                <td><%= s.getName() %></td>
                <td><%= s.getProgram() %></td>
                <td><%= s.getCgpa() %></td>
                <td style="<%= s.getFailedCount() > 0 ? "color:red; font-weight:bold;" : "" %>"><%= s.getFailedCount() %></td>
                
                <td>
                    <% if (s.isEligible()) { %>
                        <span class="status-pass">ELIGIBLE</span>
                    <% } else { %>
                        <span class="status-fail">AT RISK</span>
                    <% } %>
                </td>
                
                <%-- ONLY SHOW Action Cell if user is an OFFICER --%>
                <% if (isOfficer) { %>
                <td>
                    <% if (s.getFailedCount() > 0 || !s.isEligible()) { %>
                        <a href="recovery_plan.jsp?studentId=<%= s.getStudentId() %>" class="recover-link">Recover</a>
                    <% } else { %>
                        <span style="color:#aaa;">-</span>
                    <% } %>
                </td>
                <% } %>
                
            </tr>
        <% }} else { %>
            <tr><td colspan="<%= isOfficer ? 7 : 6 %>" style="text-align:center;">No records found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>