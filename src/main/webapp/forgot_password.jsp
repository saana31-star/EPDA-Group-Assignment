<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Course Recovery System</title>
    <style>
        /* Matching the Flexbox Grid approach of the CRS */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9; /* Presentation Tier Background */
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
            background-color: #D88DB4; /* Custom palette color */
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background-color: #c77a9f;
        }
        .message {
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 4px;
            background-color: #e2f3e5;
            color: #2e7d32;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            color: #AE82A4;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="reset-container">
    <h2>Recover Account</h2>
    <p style="color: #666; margin-bottom: 20px;">Enter your registered email address to receive a password reset link.</p>

    <% 
        String msg = request.getParameter("msg");
        if ("CheckEmail".equals(msg)) {
    %>
        <div class="message">
            If an account matches that email, a reset link has been sent. Please check your inbox.
        </div>
    <% } %>

    <form action="ForgotPasswordServlet" method="POST">
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required placeholder="Enter your email">
        </div>
        <button type="submit" class="btn-submit">Send Reset Link</button>
    </form>
    
    <a href="login.jsp" class="back-link">&larr; Back to Login</a>
</div>

</body>
</html>