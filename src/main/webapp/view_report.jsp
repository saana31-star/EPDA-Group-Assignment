<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.Student" %>
<%@ page import="com.crs.model.User" %>
<%@ page import="com.crs.model.AcademicRecord" %>
<%@ page import="java.util.List" %>
<%
	User user = (User) session.getAttribute("user");
	if (user == null) { response.sendRedirect("login.jsp"); return; }

    Student s = (Student) request.getAttribute("student");
    List<AcademicRecord> records = (List<AcademicRecord>) request.getAttribute("records");
    if (s == null) { response.sendRedirect("academic_report.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Academic Performance Report</title>
    <style>
        :root {
            --mauve: #D88DB4; --dark-blue: #5C617B; --med-blue: #828CA0; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 40px 20px; margin: 0; }
        
        .paper { 
            background: white; max-width: 850px; margin: 0 auto; padding: 60px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 4px;
        }
        
        h1 { text-align: center; color: var(--dark-blue); text-transform: uppercase; border-bottom: 3px solid var(--dark-blue); padding-bottom: 15px; margin-top: 0; letter-spacing: 1px; }
        
        .header-info { margin-bottom: 40px; line-height: 1.8; color: #333; font-size: 1.1em; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        
        h3 { color: var(--dark-blue); border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; margin-bottom: 30px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f9f9f9; color: var(--dark-blue); text-transform: uppercase; font-size: 0.9em; }
        
        .cgpa-box { text-align: right; font-size: 1.3em; color: var(--dark-blue); border-top: 2px solid var(--dark-blue); padding-top: 15px; }
        
        .button-group { text-align: center; margin-top: 40px; }
        .action-btn { 
            display: inline-block; margin: 0 10px; padding: 12px 25px; 
            background: var(--mauve); color: white; border: none; border-radius: 6px; 
            cursor: pointer; text-decoration: none; font-weight: bold; font-size: 15px; transition: 0.3s;
        }
        .action-btn:hover { opacity: 0.85; transform: translateY(-2px); }
        .btn-secondary { background: var(--med-blue); }

        /* Print styles */
        @media print { 
            body { background: white; padding: 0; } 
            .paper { box-shadow: none; padding: 0; max-width: 100%; } 
            .button-group { display: none; } 
            th { background-color: #eee !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<div class="paper">
    <h1>Academic Performance Report</h1>
    
    <div class="header-info">
        <div><strong>Student Name:</strong> <%= s.getName() %></div>
        <div><strong>Student ID:</strong> <%= s.getStudentId() %></div>
        <div><strong>Program:</strong> <%= s.getProgram() %></div>
        <div><strong>Date Generated:</strong> <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></div>
    </div>

    <h3>Semester 1 Results</h3>
    <table>
        <thead>
            <tr>
                <th>Course Code</th> <th>Course Title</th> <th>Credit Hours</th> <th>Grade</th> <th>Grade Point</th>
            </tr>
        </thead>
        <tbody>
            <% if (records != null) { for (AcademicRecord r : records) { %>
            <tr>
                <td><strong><%= r.getCourseCode() %></strong></td> 
                <td><%= r.getCourseTitle() %></td>
                <td><%= r.getCreditHours() %></td>
                <td><strong><%= r.getGrade() %></strong></td>
                <td><%= String.format("%.2f", r.getGradePoint()) %></td>
            </tr>
            <% } } %>
        </tbody>
    </table>

    <div class="cgpa-box">
        <strong>Cumulative GPA (CGPA): <%= String.format("%.2f", s.getCgpa()) %></strong>
    </div>
</div>

<div class="button-group">
    <button onclick="window.print()" class="action-btn">🖨️ Print Report</button>
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="action-btn btn-secondary">← Back to Dashboard</a>
</div>

</body>
</html>