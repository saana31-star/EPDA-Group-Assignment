<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CRS Portal - Login</title>
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

body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: var(--bg-color);
	height: 100vh;
	margin: 0;
	display: flex;
	align-items: center;
	justify-content: center;
}

.login-wrapper {
	width: 100%;
	max-width: 400px;
	padding: 20px;
	box-sizing: border-box;
}

.login-card {
	background: white;
	padding: 40px 30px;
	border-radius: 12px;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
	text-align: center;
	border-top: 6px solid var(--dark-blue);
}

.logo-area {
	margin-bottom: 25px;
}

.logo-area h1 {
	color: var(--dark-blue);
	margin: 0;
	font-size: 28px;
}

.logo-area p {
	color: var(--med-blue);
	margin-top: 5px;
	font-size: 14px;
}

.error-msg {
	background: #ffebee;
	color: #c62828;
	padding: 10px;
	border-radius: 6px;
	font-size: 0.9em;
	font-weight: bold;
	margin-bottom: 20px;
}

form {
	text-align: left;
}

label {
	display: block;
	font-weight: bold;
	color: var(--dark-blue);
	margin-bottom: 8px;
	font-size: 0.9em;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 12px 15px;
	margin-bottom: 20px;
	border: 1px solid var(--light-blue);
	border-radius: 6px;
	box-sizing: border-box;
	font-size: 15px;
	outline: none;
	transition: 0.3s;
}

input[type="text"]:focus, input[type="password"]:focus {
	border-color: var(--dark-blue);
	box-shadow: 0 0 5px rgba(92, 97, 123, 0.2);
}

button {
	width: 100%;
	padding: 14px;
	background-color: var(--dark-blue);
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

button:hover {
	opacity: 0.9;
	transform: translateY(-2px);
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.demo-credentials {
	margin-top: 25px;
	padding-top: 20px;
	border-top: 1px solid #eee;
	font-size: 0.85em;
	color: var(--med-blue);
	line-height: 1.6;
}

.demo-credentials b {
	color: var(--dark-blue);
}
</style>
</head>
<body>

	<div class="login-wrapper">
		<div class="login-card">
			<div class="logo-area">
				<h1>CRS Portal</h1>
				<p>Course Recovery Management System</p>
			</div>

			<%
			if (request.getAttribute("errorMessage") != null) {
			%>
			<div class="error-msg">
				⚠️
				<%=request.getAttribute("errorMessage")%></div>
			<%
			}
			%>

			<form action="login" method="post">
				<label>Username</label> <input type="text" name="username" required
					placeholder="Enter username" autocomplete="off"> <label>Password</label>
				<input type="password" name="password" required
					placeholder="Enter password">

				<div style="text-align: right; margin-bottom: 15px;">
					<a href="forgot_password.jsp"
						style="color: #AE82A4; text-decoration: none; font-size: 14px;">Forgot
						Password?</a>
				</div>

				<button type="submit">Sign In</button>
			</form>

			<div class="demo-credentials">
				<b>Demo Accounts</b><br> Admin: admin / admin123<br>
				Officer: officer / officer123
			</div>
		</div>
	</div>

</body>
</html>