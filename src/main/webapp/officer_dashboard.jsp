<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.User" %>
<%
    // Session Security Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"OFFICER".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Academic Officer Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; }
        .header { background-color: #2c3e50; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .container { padding: 40px; display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; }
        .card { background: white; width: 250px; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; transition: transform 0.2s; }
        .card:hover { transform: translateY(-5px); }
        .card h3 { color: #27ae60; margin-bottom: 10px; }
        .btn { display: inline-block; margin-top: 15px; padding: 10px 20px; background-color: #27ae60; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background-color: #219150; }
        .logout-btn { color: #ff6b6b; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

	<% if ("PlanSaved".equals(request.getParameter("msg"))) { %>
	    <div style="background-color: #d4edda; color: #155724; padding: 10px; text-align: center; border-bottom: 1px solid #c3e6cb;">
	        ✅ Course Recovery Plan has been successfully created and emailed to the student!
	    </div>
	<% } %>

    <div class="header">
        <h2>Academic Officer Panel</h2>
        <span>Welcome, <%= user.getUsername() %> | <a href="logout" class="logout-btn">Logout</a></span>
    </div>

    <div class="container">
        <div class="card" style="border-top: 5px solid #e67e22;">
            <h3 style="color:#d35400">Course Recovery</h3>
            <p>Manage student recovery plans and milestones.</p>
            <a href="recovery_plan.jsp" class="btn" style="background-color:#d35400">Manage Plans</a>
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
        
         <div class="card">
            <h3>User Management</h3>
            <p>Manage Users.</p>
            <a href="manage_users.jsp" class="btn">Go to Users</a>
        </div>
    </div>

</body>
</html>