package com.crs.controller;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EmailReportServlet")
public class EmailReportServlet extends HttpServlet {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/crs_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "admin";  // CHANGE THIS to your actual password in MySQL

    private static final String SENDER_EMAIL = "crsgroupbm@gmail.com";
    private static final String SENDER_PASSWORD  = "loyu hmtq mppr zxpl"; 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentId = request.getParameter("studentId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Fetch student info
            String studentName = "", program = "", studentEmail = "";
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT name, program, email FROM students WHERE student_id = ?");
            ps1.setString(1, studentId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                studentName  = rs1.getString("name");
                program      = rs1.getString("program");
                studentEmail = rs1.getString("email");
            }

            // Fetch academic records
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT c.course_code, c.course_title, c.credit_hours, " +
                "ar.grade, ar.grade_point, ar.status " +
                "FROM academic_records ar " +
                "JOIN courses c ON ar.course_code = c.course_code " +
                "WHERE ar.student_id = ?");
            ps2.setString(1, studentId);
            ResultSet rs2 = ps2.executeQuery();

            // Build table rows + calculate CGPA
            StringBuilder rows = new StringBuilder();
            double totalGradePoints = 0;
            int totalCreditHours = 0;

            while (rs2.next()) {
                String code   = rs2.getString("course_code");
                String title  = rs2.getString("course_title");
                int credits   = rs2.getInt("credit_hours");
                String grade  = rs2.getString("grade");
                double gp     = rs2.getDouble("grade_point");
                String status = rs2.getString("status");

                totalGradePoints += (gp * credits);
                totalCreditHours += credits;

                String rowColor = "FAIL".equals(status) ? "#fff0f0" : "#ffffff";
                String gradeColor = "FAIL".equals(status) ? "color:#cc0000;font-weight:bold;" : "";

                rows.append("<tr style='background:").append(rowColor).append(";'>")
                    .append("<td style='padding:10px;border:1px solid #ddd;'>").append(code).append("</td>")
                    .append("<td style='padding:10px;border:1px solid #ddd;'>").append(title).append("</td>")
                    .append("<td style='padding:10px;border:1px solid #ddd;text-align:center;'>").append(credits).append("</td>")
                    .append("<td style='padding:10px;border:1px solid #ddd;text-align:center;").append(gradeColor).append("'>").append(grade).append("</td>")
                    .append("<td style='padding:10px;border:1px solid #ddd;text-align:center;'>").append(String.format("%.2f", gp)).append("</td>")
                    .append("</tr>");
            }

            double cgpa = totalCreditHours > 0 ? totalGradePoints / totalCreditHours : 0.0;
            conn.close();

            // Build HTML email
            String date = new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date());
            String htmlBody =
                "<div style='font-family:Segoe UI,sans-serif;max-width:700px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden;'>" +
                "<div style='background:#5C617B;padding:25px;text-align:center;'>" +
                "<h1 style='color:white;margin:0;letter-spacing:1px;font-size:20px;'>ACADEMIC PERFORMANCE REPORT</h1></div>" +
                "<div style='padding:30px;'>" +
                "<table style='width:100%;margin-bottom:25px;'><tr>" +
                "<td><strong>Student Name:</strong> " + studentName + "</td>" +
                "<td><strong>Student ID:</strong> " + studentId + "</td></tr><tr>" +
                "<td><strong>Program:</strong> " + program + "</td>" +
                "<td><strong>Date Generated:</strong> " + date + "</td></tr></table>" +
                "<table style='width:100%;border-collapse:collapse;'>" +
                "<thead><tr style='background:#f0f0f0;'>" +
                "<th style='padding:10px;border:1px solid #ddd;text-align:left;'>Course Code</th>" +
                "<th style='padding:10px;border:1px solid #ddd;text-align:left;'>Course Title</th>" +
                "<th style='padding:10px;border:1px solid #ddd;text-align:center;'>Credits</th>" +
                "<th style='padding:10px;border:1px solid #ddd;text-align:center;'>Grade</th>" +
                "<th style='padding:10px;border:1px solid #ddd;text-align:center;'>Grade Point</th>" +
                "</tr></thead><tbody>" + rows.toString() + "</tbody></table>" +
                "<div style='text-align:right;margin-top:20px;font-size:1.1em;color:#5C617B;border-top:2px solid #5C617B;padding-top:15px;'>" +
                "<strong>Cumulative GPA (CGPA): " + String.format("%.2f", cgpa) + "</strong></div>" +
                "<p style='color:#888;font-size:0.85em;margin-top:30px;'>This is an automated email from the Course Recovery System. Please do not reply.</p>" +
                "</div></div>";

            // Send email via Jakarta Mail
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });

            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(SENDER_EMAIL, "Course Recovery System"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(studentEmail));
            msg.setSubject("Your Academic Performance Report — " + studentId);
            msg.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(msg);

            response.sendRedirect("GenerateReportServlet?studentId=" + studentId + "&msg=emailed");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("GenerateReportServlet?studentId=" + studentId + "&msg=error");
        }
    }
}