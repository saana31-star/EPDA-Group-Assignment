package com.crs.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.crs.config.DBConnection;
import com.crs.model.Student;
import jakarta.ejb.Stateless;

@Stateless
public class StudentDAO {

    public List<Student> getAllStudentsWithEligibility() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Student s = new Student();
                s.setStudentId(rs.getString("student_id"));
                s.setName(rs.getString("name"));
                s.setProgram(rs.getString("program"));
                s.setEmail(rs.getString("email"));

                // Calculate Eligibility for this student
                calculateAcademicStatus(s, conn);
                
                students.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return students;
    }

    private void calculateAcademicStatus(Student s, Connection conn) {
        String sql = "SELECT r.grade_point, r.status, c.credit_hours " +
                     "FROM academic_records r " +
                     "JOIN courses c ON r.course_code = c.course_code " +
                     "WHERE r.student_id = ?";
        
        double totalPoints = 0;
        int totalCredits = 0;
        int failCount = 0;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, s.getStudentId());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                double gradePoint = rs.getDouble("grade_point");
                String status = rs.getString("status");
                int credits = rs.getInt("credit_hours");

                // CGPA Calculation Formula: (Grade Point * Credits) / Total Credits
                totalPoints += (gradePoint * credits);
                totalCredits += credits;

                if ("FAIL".equalsIgnoreCase(status)) {
                    failCount++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Final Calculations
        double cgpa = (totalCredits > 0) ? (totalPoints / totalCredits) : 0.0;
        s.setCgpa(Math.round(cgpa * 100.0) / 100.0); // Round to 2 decimals
        s.setFailedCount(failCount);

        // Rule: CGPA >= 2.0 AND Failed Courses <= 3
        boolean isEligible = (cgpa >= 2.0 && failCount <= 3);
        s.setEligible(isEligible);
    }
}