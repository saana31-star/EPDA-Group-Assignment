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
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4; 
            --dusty-purple: #AE82A4; --dark-blue: #5C617B; 
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 60px 20px; display: flex; justify-content: center; margin: 0; }
        
        .card { 
            background: white; padding: 40px; border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 450px; text-align: center;
            border-top: 5px solid var(--mauve);
        }
        
        h2 { color: var(--dark-blue); margin-top: 0; margin-bottom: 10px; }
        p { color: var(--med-blue); margin-bottom: 30px; }
        
        input[type="text"] { 
            width: 100%; padding: 15px; margin-bottom: 20px; border: 1px solid var(--light-blue); 
            border-radius: 8px; box-sizing: border-box; font-size: 16px; transition: 0.3s; outline: none;
        }
        input[type="text"]:focus { border-color: var(--mauve); box-shadow: 0 0 8px rgba(216, 141, 180, 0.3); }
        
        button { 
            background: var(--mauve); color: white; border: none; padding: 15px 20px; 
            cursor: pointer; width: 100%; border-radius: 8px; font-weight: bold; font-size: 16px; transition: 0.3s;
        }
        button:hover { opacity: 0.85; transform: translateY(-2px); }
        
        .back-link { display: inline-block; margin-top: 25px; color: var(--med-blue); text-decoration: none; font-weight: bold; transition: 0.3s; }
        .back-link:hover { color: var(--dark-blue); }
    </style>
</head>
<body>

<div class="card">
    <h2>Generate Academic Report</h2>
    <p>Enter Student ID to view their full transcript.</p>
    
    <form action="GenerateReportServlet" method="get">
        <input type="text" name="studentId" placeholder="e.g. 2025A1234" required>
        <button type="submit">Generate Report</button>
    </form>
    
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="back-link">← Back to Dashboard</a>
</div>

</body>
</html>