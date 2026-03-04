package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.crs.config.DBConnection;
import com.crs.model.Student;
import com.crs.model.AcademicRecord;

@WebServlet("/GenerateReportServlet")
public class GenerateReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        Student student = null;
        List<AcademicRecord> records = new ArrayList<>();
        double totalPoints = 0;
        int totalCredits = 0;

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Fetch Student Info
            PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM students WHERE student_id = ?");
            ps1.setString(1, studentId);
            ResultSet rs1 = ps1.executeQuery();
            
            if (rs1.next()) {
                student = new Student();
                student.setStudentId(rs1.getString("student_id"));
                student.setName(rs1.getString("name"));
                student.setProgram(rs1.getString("program"));
            } else {
                response.sendRedirect("academic_report.jsp?error=NotFound");
                return;
            }

            // 2. Fetch Academic Records
            String sql = "SELECT r.grade, r.grade_point, c.course_code, c.course_title, c.credit_hours " +
                         "FROM academic_records r JOIN courses c ON r.course_code = c.course_code " +
                         "WHERE r.student_id = ?";
            PreparedStatement ps2 = conn.prepareStatement(sql);
            ps2.setString(1, studentId);
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                String g = rs2.getString("grade");
                double gp = rs2.getDouble("grade_point");
                int ch = rs2.getInt("credit_hours");
                
                // Using the public Model class
                records.add(new AcademicRecord(
                    rs2.getString("course_code"),
                    rs2.getString("course_title"),
                    ch, g, gp
                ));

                totalPoints += (gp * ch);
                totalCredits += ch;
            }
            
            // 3. Calculate Final CGPA
            double cgpa = (totalCredits > 0) ? (totalPoints / totalCredits) : 0.00;
            student.setCgpa(Math.round(cgpa * 100.0) / 100.0);

            // 4. Forward to View
            request.setAttribute("student", student);
            request.setAttribute("records", records);
            request.getRequestDispatcher("view_report.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}