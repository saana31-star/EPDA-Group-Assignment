package com.crs.model;

public class Student {
    private String studentId;
    private String name;
    private String program;
    private String email;
    
    // These are calculated fields, not stored directly in the 'students' table
    private double cgpa;
    private int failedCount;
    private boolean isEligible;

    public Student() {}

    public Student(String studentId, String name, String program, String email) {
        this.studentId = studentId;
        this.name = name;
        this.program = program;
        this.email = email;
    }

    // Getters and Setters
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }

    public int getFailedCount() { return failedCount; }
    public void setFailedCount(int failedCount) { this.failedCount = failedCount; }

    public boolean isEligible() { return isEligible; }
    public void setEligible(boolean isEligible) { this.isEligible = isEligible; }
}