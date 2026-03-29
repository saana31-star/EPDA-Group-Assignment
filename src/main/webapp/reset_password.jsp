<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set New Password - Course Recovery System</title>
    <style>
        /* Inheriting the exact same clean UI */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .reset-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #5C617B;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-submit {
            background-color: #AE82A4; 
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .btn-submit:hover {
            background-color: #966f8d;
        }
    </style>
</head>
<body>

<div class="reset-container">
    <h2>Set New Password</h2>
    <p style="color: #666; margin-bottom: 20px;">Please enter your new secure password below.</p>

    <form action="ResetPasswordServlet" method="POST">
        <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
        
        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" required placeholder="Enter new password" minlength="6">
        </div>
        
        <button type="submit" class="btn-submit">Update Password</button>
    </form>
</div>

</body>
</html>