<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.crs.model.Student, com.crs.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Student> list = (List<Student>) request.getAttribute("studentList");
    boolean isOfficer = "OFFICER".equals(user.getRole());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eligibility Check</title>
    <style>
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4; 
            --dusty-purple: #AE82A4; --dark-blue: #5C617B; 
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); padding: 20px; }
        
        .container { 
            max-width: 950px; margin: 0 auto; background: white; padding: 30px; 
            border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-top: 5px solid var(--med-blue);
        }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--light-blue); padding-bottom: 15px; margin-bottom: 20px; }
        .header-section h2 { color: var(--dark-blue); margin: 0; }
        
        #searchInput { width: 300px; padding: 10px 15px; border: 1px solid var(--light-blue); border-radius: 20px; font-size: 14px; outline: none; transition: border-color 0.3s; }
        #searchInput:focus { border-color: var(--med-blue); }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 15px 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background-color: var(--dark-blue); color: white; text-transform: uppercase; font-size: 0.9em; letter-spacing: 0.5px; }
        
        /* New Badge Styles */
        .status-pass { background-color: var(--light-blue); color: var(--dark-blue); padding: 5px 12px; border-radius: 15px; font-weight: bold; font-size: 0.85em; }
        .status-fail { background-color: var(--pink); color: white; padding: 5px 12px; border-radius: 15px; font-weight: bold; font-size: 0.85em; }
        
        .btn-back { display: inline-block; margin-bottom: 15px; padding: 10px 15px; background: var(--med-blue); color: white; text-decoration: none; border-radius: 6px; transition: 0.3s; }
        .btn-back:hover { opacity: 0.85; }
        
        .recover-btn { background-color: var(--dusty-purple); color: white; text-decoration: none; padding: 8px 15px; border-radius: 6px; font-weight: bold; font-size: 0.9em; transition: 0.3s; display: inline-block; }
        .recover-btn:hover { opacity: 0.85; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        
        .fail-count-alert { color: var(--pink); font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="btn-back">← Back to Dashboard</a>
    
    <div class="header-section">
        <h2>Student Eligibility Status</h2>
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Search ID or Name...">
    </div>
    
    <table id="eligibilityTable">
        <thead>
            <tr>
                <th>ID</th> <th>Name</th> <th>Program</th> <th>CGPA</th> <th>Failed Courses</th> <th>Status</th>
                <% if (isOfficer) { %><th>Action</th><% } %>
            </tr>
        </thead>
        <tbody>
        <% if (list != null) { for (Student s : list) { %>
            <tr>
                <td><strong><%= s.getStudentId() %></strong></td>
                <td><%= s.getName() %></td>
                <td><%= s.getProgram() %></td>
                <td><%= s.getCgpa() %></td>
                <td class="<%= s.getFailedCount() > 0 ? "fail-count-alert" : "" %>"><%= s.getFailedCount() %></td>
                
                <td>
                    <% if (s.isEligible()) { %>
                        <span class="status-pass">ELIGIBLE</span>
                    <% } else { %>
                        <span class="status-fail">AT RISK</span>
                    <% } %>
                </td>
                
                <% if (isOfficer) { %>
                <td>
                    <% if (s.getFailedCount() > 0 || !s.isEligible()) { %>
                        <a href="recovery_plan.jsp?studentId=<%= s.getStudentId() %>" class="recover-btn">Recover</a>
                    <% } else { %>
                        <span style="color:#aaa;">-</span>
                    <% } %>
                </td>
                <% } %>
            </tr>
        <% }} else { %>
            <tr><td colspan="<%= isOfficer ? 7 : 6 %>" style="text-align:center; padding: 20px;">No records found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<script>
function filterTable() {
    var input, filter, table, tr, tdId, tdName, i, txtValueId, txtValueName;
    input = document.getElementById("searchInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("eligibilityTable");
    tr = table.getElementsByTagName("tr");

    for (i = 1; i < tr.length; i++) { 
        tdId = tr[i].getElementsByTagName("td")[0];
        tdName = tr[i].getElementsByTagName("td")[1];
        if (tdId || tdName) {
            txtValueId = tdId.textContent || tdId.innerText;
            txtValueName = tdName.textContent || tdName.innerText;
            if (txtValueId.toUpperCase().indexOf(filter) > -1 || txtValueName.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
}
</script>

</body>
</html>