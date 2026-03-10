<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.crs.config.DBConnection" %>
<%@ page import="com.crs.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"OFFICER".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Unauthorized");
        return;
    }

    String studentId = request.getParameter("studentId");
    String studentName = ""; String failedCourse = ""; String failedCourseCode = "";

    if (studentId != null) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement("SELECT name FROM students WHERE student_id = ?");
            ps1.setString(1, studentId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) studentName = rs1.getString("name");

            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT c.course_code, c.course_title FROM academic_records r JOIN courses c ON r.course_code = c.course_code WHERE r.student_id = ? AND r.status = 'FAIL' LIMIT 1");
            ps2.setString(1, studentId);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                failedCourseCode = rs2.getString("course_code");
                failedCourse = rs2.getString("course_title");
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Recovery Plan</title>
    <style>
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4; 
            --dusty-purple: #AE82A4; --dark-blue: #5C617B; 
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); padding: 40px 20px; }
        
        .container { 
            max-width: 650px; margin: 0 auto; background: white; padding: 40px; 
            border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-top: 5px solid var(--dusty-purple);
        }
        
        h2 { color: var(--dark-blue); margin-top: 0; border-bottom: 2px solid var(--light-blue); padding-bottom: 15px; }
        
        .info-box { background: var(--peach); color: var(--dark-blue); padding: 20px; border-radius: 0 8px 8px 0; border-left: 6px solid var(--dusty-purple); margin-bottom: 25px; font-size: 1.05em; line-height: 1.5; }
        
        label { display: block; margin-top: 20px; font-weight: bold; color: var(--dark-blue); font-size: 0.95em; margin-bottom: 8px; }
        input[type="text"], textarea, select { width: 100%; padding: 12px; border: 1px solid var(--light-blue); border-radius: 6px; box-sizing: border-box; font-family: inherit; transition: 0.3s; outline: none; }
        input[type="text"]:focus, textarea:focus, select:focus { border-color: var(--dusty-purple); box-shadow: 0 0 5px rgba(174, 130, 164, 0.3); }
        
        button { background-color: var(--dusty-purple); color: white; border: none; padding: 15px; margin-top: 30px; border-radius: 6px; cursor: pointer; width: 100%; font-size: 16px; font-weight: bold; transition: 0.3s; }
        button:hover { opacity: 0.85; transform: translateY(-2px); }
        
        .btn-back { color: var(--med-blue); text-decoration: none; font-weight: bold; display: inline-block; margin-bottom: 20px; transition: 0.3s; }
        .btn-back:hover { color: var(--dark-blue); }
    </style>
</head>
<body>

<div class="container">
    <a href="checkEligibility" class="btn-back">← Back to List</a>
    
    <h2>Create Course Recovery Plan</h2>
    
    <div class="info-box">
        <strong>Student:</strong> <%= studentName %> (<%= studentId %>)<br>
        <strong>Failed Course:</strong> <%= failedCourseCode %> - <%= failedCourse %>
    </div>

    <form action="SavePlanServlet" method="post">
        <input type="hidden" name="studentId" value="<%= studentId %>">
        <input type="hidden" name="courseCode" value="<%= failedCourseCode %>">

        <label>Identify Failed Components</label>
        <input type="text" name="failedComponents" placeholder="e.g. Final Exam, Assignment 2" required>

        <label>Recovery Strategy (Action Plan)</label>
        <textarea name="strategy" rows="4" placeholder="Describe the recovery steps (e.g. Week 1: Review, Week 2: Resubmit)..." required></textarea>

        <label>Target Semester</label>
        <select name="semester">
            <option>Sem 2 2025</option>
            <option>Sem 3 2025</option>
        </select>

        <button type="submit">Save Recovery Plan & Notify Student</button>
    </form>
</div>

</body>
</html>