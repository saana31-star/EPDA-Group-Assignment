package com.crs.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.crs.dao.StudentDAO;
import com.crs.model.Student;

@WebServlet("/checkEligibility")
public class EligibilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;

    public void init() {
        studentDAO = new StudentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> students = studentDAO.getAllStudentsWithEligibility();
        request.setAttribute("studentList", students);
        
        // Forward to the JSP view
        request.getRequestDispatcher("eligibility_check.jsp").forward(request, response);
    }
}