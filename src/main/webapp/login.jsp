<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRS Login</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; padding-top: 50px; }
        .login-container { width: 300px; padding: 20px; border: 1px solid #ccc; border-radius: 5px; box-shadow: 2px 2px 10px #eee; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; margin: 10px 0; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .error { color: red; font-size: 0.9em; text-align: center;}
    </style>
</head>
<body>

<div class="login-container">
    <h2 style="text-align:center;">CRS Login</h2>
    
    <%-- Display Error Message if Login Fails --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="login" method="post">
        <label>Username</label>
        <input type="text" name="username" required placeholder="Enter username">
        
        <label>Password</label>
        <input type="password" name="password" required placeholder="Enter password">
        
        <button type="submit">Login</button>
    </form>
    
    <div style="margin-top: 15px; font-size: 0.8em; color: #666;">
        <b>Demo Credentials:</b><br>
        Admin: admin / admin123<br>
        Officer: officer / officer123
    </div>
</div>

</body>
</html>