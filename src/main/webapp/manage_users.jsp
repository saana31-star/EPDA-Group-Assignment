<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.crs.model.User" %>
<%
    // Security Check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) { response.sendRedirect("login.jsp"); return; }
    
    // Fetch list from attribute (sent by Servlet)
    List<User> list = (List<User>) request.getAttribute("userList");
    
    // If list is null (meaning user accessed JSP directly), redirect to Servlet to load data
    if (list == null) {
        response.sendRedirect("UserManagementServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; padding: 20px; }
        .container { display: flex; gap: 20px; max-width: 1100px; margin: 0 auto; }
        
        /* Left Panel: Form */
        .form-panel { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); height: fit-content; }
        .form-panel h3 { margin-top: 0; color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        input, select, button { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { background: #27ae60; color: white; border: none; cursor: pointer; font-weight: bold; }
        button:hover { background: #219150; }

        /* Right Panel: Table */
        .table-panel { flex: 2; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #34495e; color: white; }
        .badge-admin { background: #e74c3c; color: white; padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
        .badge-officer { background: #f39c12; color: white; padding: 3px 8px; border-radius: 12px; font-size: 0.8em; }
        .delete-btn { color: red; text-decoration: none; font-size: 0.9em; margin-left: 10px; }
        
        .back-btn { display: inline-block; margin-bottom: 15px; text-decoration: none; color: #555; }
    </style>
</head>
<body>

    <a href="<%= currentUser.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="back-btn">← Back to Dashboard</a>

    <div class="container">
        
        <div class="form-panel">
            <h3>Add New User</h3>
            <% if ("UserAdded".equals(request.getParameter("msg"))) { %>
                <div style="color: green; margin-bottom: 10px;">✅ User created successfully!</div>
            <% } %>
            
            <form action="UserManagementServlet" method="post">
                <label>Username</label>
                <input type="text" name="username" required placeholder="e.g. staff_john">
                
                <label>Email</label>
                <input type="email" name="email" required placeholder="john@crs.edu">
                
                <label>Password</label>
                <input type="password" name="password" required placeholder="Set temporary password">
                
                <label>Role</label>
                <select name="role">
                    <option value="OFFICER">Academic Officer</option>
                    <option value="ADMIN">Course Administrator</option>
                </select>
                
                <button type="submit">Create Account</button>
            </form>
        </div>

        <div class="table-panel">
            <h3>System Users</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (User u : list) { %>
                    <tr>
                        <td><%= u.getUserId() %></td>
                        <td><%= u.getUsername() %></td>
                        <td>
                            <span class="<%= u.getRole().equals("ADMIN") ? "badge-admin" : "badge-officer" %>">
                                <%= u.getRole() %>
                            </span>
                        </td>
                        <td><%= u.getEmail() %></td>
                        <td>
                            <% if (u.getUserId() != currentUser.getUserId()) { %>
                                <a href="UserManagementServlet?action=delete&id=<%= u.getUserId() %>" 
                                   class="delete-btn"
                                   onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                            <% } else { %>
                                <span style="color:#aaa; font-size:0.9em;">(You)</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
    </div>

</body>
</html>