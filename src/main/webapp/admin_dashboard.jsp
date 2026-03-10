<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Dashboard</title>
    <style>
        :root {
            --peach: #F5D0C5;
            --pink: #F0AEB6;
            --mauve: #D88DB4;
            --dusty-purple: #AE82A4;
            --dark-blue: #5C617B;
            --med-blue: #828CA0;
            --light-blue: #AAB4C2;
            --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); margin: 0; }

        .navbar { 
            background-color: var(--dark-blue); 
            color: white; padding: 15px 30px; 
            display: flex; justify-content: space-between; align-items: center; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .navbar h2 { margin: 0; font-weight: normal; }
        .logout-btn { color: var(--peach); text-decoration: none; font-weight: bold; margin-left: 15px; }
        .logout-btn:hover { text-decoration: underline; }
        
        .container { max-width: 900px; margin: 0 auto; padding: 30px 20px; }

        /* The 2x2 Grid setup */
        .card-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center; /* This automatically centers the odd 3rd card */
            gap: 30px;
        }

       .card {
            background: white;
            flex: 0 1 calc(50% - 15px); /* Max 2 per row */
            min-width: 300px;
            max-width: 400px;
            padding: 40px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            text-align: center;
            border-top: 5px solid var(--med-blue);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-sizing: border-box; /* <--- THIS IS THE FIX */
        }
        
        .card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }

        .card-icon { width: 64px; height: 64px; margin-bottom: 15px; }
        .card h3 { color: var(--dark-blue); margin-top: 0; font-size: 1.4rem; }
        .card p { color: #666; margin-bottom: 25px; line-height: 1.5; font-size: 0.95rem; }

        .btn {
            display: inline-block; padding: 12px 25px; color: white; text-decoration: none;
            border-radius: 6px; font-weight: bold; transition: opacity 0.3s;
        }
        .btn:hover { opacity: 0.85; }
        
        .btn-eligibility { background-color: var(--med-blue); }
        .btn-reports { background-color: var(--mauve); }
        .btn-users { background-color: var(--dark-blue); }
    </style>
</head>
<body>

    <div class="navbar">
        <h2>Administrator Panel</h2>
        <div>Welcome, <%= user.getUsername() %> | <a href="LogoutServlet" class="logout-btn">Logout</a></div>
    </div>

    <div class="container">
        <div class="card-grid">
            
            <div class="card" style="border-color: var(--med-blue);">
                <img src="icons/eligibility.png" alt="Eligibility" class="card-icon">
                <h3>Eligibility Check</h3>
                <p>Check student progression status.</p>
                <a href="checkEligibility" class="btn btn-eligibility">Check Eligibility</a>
            </div>

            <div class="card" style="border-color: var(--mauve);">
                <img src="icons/report.png" alt="Reports" class="card-icon">
                <h3>Academic Reports</h3>
                <p>Generate formal performance reports.</p>
                <a href="academic_report.jsp" class="btn btn-reports">View Reports</a>
            </div>

            <div class="card" style="border-color: var(--dark-blue);">
                <img src="icons/users.png" alt="Users" class="card-icon">
                <h3>User Management</h3>
                <p>Manage staff accounts and permissions.</p>
                <a href="UserManagementServlet" class="btn btn-users">Go to Users</a>
            </div>

        </div>
    </div>

</body>
</html>