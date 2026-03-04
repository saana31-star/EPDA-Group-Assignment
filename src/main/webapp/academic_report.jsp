<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Academic Reports</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; padding: 40px; display: flex; justify-content: center; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 400px; text-align: center; }
        input[type="text"] { width: 80%; padding: 10px; margin: 15px 0; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #007bff; color: white; border: none; padding: 10px 20px; cursor: pointer; width: 100%; }
        button:hover { background: #0056b3; }
        .back-link { display: block; margin-top: 15px; color: #666; text-decoration: none; }
    </style>
</head>
<body>

<div class="card">
    <h2>Generate Academic Report</h2>
    <p>Enter Student ID to view full transcript.</p>
    
    <form action="GenerateReportServlet" method="get">
        <input type="text" name="studentId" placeholder="e.g. 2025A1234" required>
        <button type="submit">Generate Report</button>
    </form>
    
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="back-link">← Back to Dashboard</a>
</div>

</body>
</html>