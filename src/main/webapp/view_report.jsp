<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.Student" %>
<%@ page import="com.crs.model.AcademicRecord" %>  <%-- IMPORT ADDED HERE --%>
<%@ page import="java.util.List" %>

<%
    // Retrieve data from request
    Student s = (Student) request.getAttribute("student");
    List<AcademicRecord> records = (List<AcademicRecord>) request.getAttribute("records");

    // Safety check to prevent NullPointer if accessed directly without Servlet
    if (s == null) {
        response.sendRedirect("academic_report.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Academic Performance Report</title>
    <style>
        body { font-family: 'Times New Roman', serif; background: #555; padding: 20px; }
        .paper { background: white; max-width: 800px; margin: 0 auto; padding: 50px; box-shadow: 0 0 15px rgba(0,0,0,0.5); }
        h1 { text-align: center; text-transform: uppercase; border-bottom: 2px solid black; padding-bottom: 10px; }
        .header-info { margin-bottom: 30px; line-height: 1.6; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #eee; }
        .cgpa-box { margin-top: 20px; text-align: right; font-size: 1.2em; font-weight: bold; }
        .print-btn { display: block; margin: 20px auto; padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; width: 200px; text-align: center; text-decoration: none; font-family: Arial, sans-serif;}
        @media print { .print-btn { display: none; } body { background: white; } .paper { box-shadow: none; } }
    </style>
</head>
<body>

<div class="paper">
    <h1>Academic Performance Report</h1>
    
    <div class="header-info">
        <strong>Student Name:</strong> <%= s.getName() %><br>
        <strong>Student ID:</strong> <%= s.getStudentId() %><br>
        <strong>Program:</strong> <%= s.getProgram() %><br>
        <strong>Date Generated:</strong> <%= new java.util.Date() %>
    </div>

    <h3>Semester 1 Results</h3>
    <table>
        <thead>
            <tr>
                <th>Course Code</th>
                <th>Course Title</th>
                <th>Credit Hours</th>
                <th>Grade</th>
                <th>Grade Point</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (records != null) {
                for (AcademicRecord r : records) { 
            %>
            <tr>
                <td><%= r.getCourseCode() %></td> 
                <td><%= r.getCourseTitle() %></td>
                <td><%= r.getCreditHours() %></td>
                <td><%= r.getGrade() %></td>
                <td><%= r.getGradePoint() %></td>
            </tr>
            <% 
                } 
            } 
            %>
        </tbody>
    </table>

    <div class="cgpa-box">
        Cumulative GPA (CGPA): <%= s.getCgpa() %>
    </div>
</div>

<a href="#" onclick="window.print()" class="print-btn">Print Report</a>

<% 
    com.crs.model.User currentUser = (com.crs.model.User) session.getAttribute("user");
    String dashboardLink = (currentUser != null && "ADMIN".equals(currentUser.getRole())) ? "admin_dashboard.jsp" : "officer_dashboard.jsp";
%>
<a href="<%= dashboardLink %>" class="print-btn" style="background:#6c757d;">Back to Dashboard</a>

</body>
</html>