<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.crs.config.DBConnection" %>
<%@ page import="com.crs.model.User" %>
<%
    // Security Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"OFFICER".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Unauthorized");
        return;
    }

    String studentId = request.getParameter("studentId");
    String studentName = "";
    String failedCourse = "";
    String failedCourseCode = "";

    // Quick inline database fetch to get the failed course details for this student
    if (studentId != null) {
        try (Connection conn = DBConnection.getConnection()) {
            // 1. Get Student Name
            PreparedStatement ps1 = conn.prepareStatement("SELECT name FROM students WHERE student_id = ?");
            ps1.setString(1, studentId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) studentName = rs1.getString("name");

            // 2. Get the specific FAILED course
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT c.course_code, c.course_title FROM academic_records r " +
                "JOIN courses c ON r.course_code = c.course_code " +
                "WHERE r.student_id = ? AND r.status = 'FAIL' LIMIT 1");
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
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { border-bottom: 2px solid #e67e22; padding-bottom: 10px; color: #d35400; }
        .info-box { background: #fff3cd; padding: 15px; border-left: 5px solid #ffc107; margin-bottom: 20px; }
        label { display: block; margin-top: 15px; font-weight: bold; }
        input, textarea, select { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { background-color: #e67e22; color: white; border: none; padding: 12px 20px; margin-top: 20px; cursor: pointer; width: 100%; font-size: 16px; }
        button:hover { background-color: #d35400; }
    </style>
</head>
<body>

<div class="container">
    <a href="checkEligibility" style="text-decoration:none; color:#666;">← Back to List</a>
    
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