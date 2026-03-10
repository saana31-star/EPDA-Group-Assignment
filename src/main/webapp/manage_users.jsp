<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.crs.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) { response.sendRedirect("login.jsp"); return; }
    
    List<User> list = (List<User>) request.getAttribute("userList");
    if (list == null) { response.sendRedirect("UserManagementServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4; 
            --dusty-purple: #AE82A4; --dark-blue: #5C617B; 
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 30px 20px; }
        
        .main-wrapper { max-width: 1200px; margin: 0 auto; }
        .container { display: flex; gap: 30px; flex-wrap: wrap; }
        
        .panel { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid var(--dark-blue); }
        .form-panel { flex: 1; min-width: 300px; height: fit-content; }
        .table-panel { flex: 2; min-width: 500px; }
        
        h3 { margin-top: 0; color: var(--dark-blue); border-bottom: 2px solid var(--light-blue); padding-bottom: 15px; margin-bottom: 25px; }
        
        label { display: block; margin-top: 15px; font-weight: bold; color: var(--dark-blue); font-size: 0.9em; margin-bottom: 5px; }
        input, select { width: 100%; padding: 12px; border: 1px solid var(--light-blue); border-radius: 6px; box-sizing: border-box; transition: 0.3s; outline: none; }
        input:focus, select:focus { border-color: var(--dark-blue); }
        
        button { background: var(--dark-blue); color: white; border: none; padding: 12px; border-radius: 6px; width: 100%; margin-top: 25px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        button:hover { opacity: 0.85; transform: translateY(-2px); }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: var(--dark-blue); color: white; text-transform: uppercase; font-size: 0.85em; letter-spacing: 0.5px; }
        
        .badge { padding: 5px 12px; border-radius: 15px; font-size: 0.8em; font-weight: bold; color: white; }
        .badge-admin { background: var(--mauve); }
        .badge-officer { background: var(--med-blue); }
        
        .delete-btn { color: var(--pink); font-weight: bold; text-decoration: none; padding: 5px 10px; border: 1px solid var(--pink); border-radius: 6px; transition: 0.3s; }
        .delete-btn:hover { background: var(--pink); color: white; }
        
        .btn-back { display: inline-block; margin-bottom: 20px; padding: 10px 15px; background: var(--med-blue); color: white; text-decoration: none; border-radius: 6px; transition: 0.3s; }
        .btn-back:hover { opacity: 0.85; }
    </style>
</head>
<body>

    <div class="main-wrapper">
        <a href="<%= currentUser.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="btn-back">← Back to Dashboard</a>

        <div class="container">
            
            <div class="panel form-panel">
                <h3>Add New User</h3>
                <% if ("UserAdded".equals(request.getParameter("msg"))) { %>
                    <div style="background: var(--light-blue); color: var(--dark-blue); padding: 10px; border-radius: 6px; text-align: center; font-weight: bold; margin-bottom: 15px;">✅ User created successfully!</div>
                <% } %>
                
                <form action="UserManagementServlet" method="post">
                    <label>Username</label> <input type="text" name="username" required placeholder="e.g. staff_john">
                    <label>Email</label> <input type="email" name="email" required placeholder="john@crs.edu">
                    <label>Password</label> <input type="password" name="password" required placeholder="Set temporary password">
                    <label>Role</label>
                    <select name="role">
                        <option value="OFFICER">Academic Officer</option>
                        <option value="ADMIN">Course Administrator</option>
                    </select>
                    <button type="submit">Create Account</button>
                </form>
            </div>

            <div class="panel table-panel">
                <h3>System Users</h3>
                <table>
                    <thead>
                        <tr><th>ID</th> <th>Username</th> <th>Role</th> <th>Email</th> <th>Action</th></tr>
                    </thead>
                    <tbody>
                        <% for (User u : list) { %>
                        <tr>
                            <td><strong><%= u.getUserId() %></strong></td>
                            <td><%= u.getUsername() %></td>
                            <td><span class="badge <%= u.getRole().equals("ADMIN") ? "badge-admin" : "badge-officer" %>"><%= u.getRole() %></span></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <% if (u.getUserId() != currentUser.getUserId()) { %>
                                    <a href="UserManagementServlet?action=delete&id=<%= u.getUserId() %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                <% } else { %>
                                    <span style="color: var(--light-blue); font-size:0.9em; font-style: italic;">(You)</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
        </div>
    </div>

</body>
</html>