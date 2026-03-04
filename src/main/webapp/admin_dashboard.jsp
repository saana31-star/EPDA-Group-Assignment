<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.User" %>
<%
    // 1. Session Security Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - CRS</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; }
        .header { background-color: #343a40; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .container { padding: 40px; display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; }
        .card { background: white; width: 250px; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; transition: transform 0.2s; }
        .card:hover { transform: translateY(-5px); }
        .card h3 { color: #007bff; margin-bottom: 10px; }
        .card p { color: #666; font-size: 0.9em; }
        .btn { display: inline-block; margin-top: 15px; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background-color: #0056b3; }
        .logout-btn { color: #ff6b6b; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <div class="header">
        <h2>CRS Admin Panel</h2>
        <span>Welcome, <%= user.getUsername() %> | <a href="logout" class="logout-btn">Logout</a></span>
    </div>

    <div class="container">
        <div class="card">
            <h3>User Management</h3>
            <p>Manage Staff Accounts (Add/Edit/Delete).</p>
            <a href="manage_users.jsp" class="btn">Go to Users</a>
        </div>

        <div class="card">
            <h3>Eligibility Check</h3>
            <p>Check student progression status.</p>
            <a href="checkEligibility" class="btn">Check Eligibility</a>
        </div>

        <div class="card">
            <h3>Academic Reports</h3>
            <p>Generate performance reports.</p>
            <a href="academic_report.jsp" class="btn">View Reports</a>
        </div>
    </div>

</body>
</html>