CREATE DATABASE IF NOT EXISTS crs_db;
USE crs_db;

-- 1. Users Table (Staff Only)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- In real app, hash this. For now, plain text for simplicity.
    role ENUM('ADMIN', 'OFFICER') NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- 2. Students Table
CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY, -- e.g., 2025A1234
    name VARCHAR(100) NOT NULL,
    program VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- 3. Courses Table
CREATE TABLE courses (
    course_code VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    credit_hours INT NOT NULL
);

-- 4. Academic Records (Grades per Semester)
CREATE TABLE academic_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    course_code VARCHAR(10),
    semester VARCHAR(20) NOT NULL, -- e.g., "Sem 1 2025"
    grade VARCHAR(2), -- A, B+, C, F, etc.
    grade_point DECIMAL(3,2), -- 4.00, 3.67, etc.
    status ENUM('PASS', 'FAIL') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_code) REFERENCES courses(course_code)
);

-- 5. Course Recovery Plans
CREATE TABLE recovery_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    course_code VARCHAR(10),
    semester VARCHAR(20),
    failed_components VARCHAR(255), -- e.g., "Final Exam, Assignment 1"
    status ENUM('PENDING', 'APPROVED', 'COMPLETED') DEFAULT 'PENDING',
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_code) REFERENCES courses(course_code)
);

-- 6. Recovery Milestones (The "Action Plan")
CREATE TABLE recovery_milestones (
    milestone_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT,
    week VARCHAR(50), -- e.g., "Week 1-2"
    task TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (plan_id) REFERENCES recovery_plans(plan_id)
);

-- 7. Password Reset Tokens
CREATE TABLE password_reset_tokens (
    token VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    expiry_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================================
-- DUMMY DATA INSERTION
-- =========================================

-- 1. Users (Staff)
INSERT INTO users (username, password, role, email) VALUES 
('admin', 'admin123', 'ADMIN', 'admin@crs.edu'),
('officer', 'officer123', 'OFFICER', 'officer@crs.edu');

-- 2. Courses (10 Courses)
INSERT INTO courses (course_code, course_title, credit_hours) VALUES 
('CS201', 'Data Structures', 3),
('CS205', 'Database Systems', 3),
('CS210', 'Software Engineering', 3),
('MA202', 'Discrete Mathematics', 4),
('IT101', 'Introduction to IT', 3),
('SE301', 'Agile Methodologies', 3),
('DS400', 'Machine Learning', 4),
('NT200', 'Computer Networks', 3),
('CS305', 'Operating Systems', 4),
('CY101', 'Cybersecurity Basics', 3);

-- 3. Students (30 Students)
INSERT INTO students (student_id, name, program, email) VALUES 
('2025A1001', 'Alex Tan', 'Bachelor of CS', 'alex.t@student.edu'),
('2025A1002', 'Sarah Lee', 'Bachelor of IT', 'sarah.l@student.edu'),
('2025A1003', 'Michael Chen', 'Bachelor of SE', 'michael.c@student.edu'),
('2025A1004', 'Emma Wong', 'Bachelor of CS', 'emma.w@student.edu'),
('2025A1005', 'Daniel Gomez', 'Bachelor of IT', 'daniel.g@student.edu'),
('2025A1006', 'Olivia Smith', 'Bachelor of SE', 'olivia.s@student.edu'),
('2025A1007', 'Liam Johnson', 'Bachelor of CS', 'liam.j@student.edu'),
('2025A1008', 'Sophia Patel', 'Bachelor of IT', 'sophia.p@student.edu'),
('2025A1009', 'Noah Williams', 'Bachelor of CS', 'noah.w@student.edu'),
('2025A1010', 'Ava Brown', 'Bachelor of SE', 'ava.b@student.edu'),
('2025A1011', 'William Davis', 'Bachelor of CS', 'william.d@student.edu'),
('2025A1012', 'Isabella Miller', 'Bachelor of IT', 'isabella.m@student.edu'),
('2025A1013', 'James Wilson', 'Bachelor of SE', 'james.w@student.edu'),
('2025A1014', 'Mia Moore', 'Bachelor of CS', 'mia.m@student.edu'),
('2025A1015', 'Benjamin Taylor', 'Bachelor of IT', 'benjamin.t@student.edu'),
('2025A1016', 'Charlotte Anderson', 'Bachelor of SE', 'charlotte.a@student.edu'),
('2025A1017', 'Lucas Thomas', 'Bachelor of CS', 'lucas.t@student.edu'),
('2025A1018', 'Amelia Jackson', 'Bachelor of IT', 'amelia.j@student.edu'),
('2025A1019', 'Henry White', 'Bachelor of SE', 'henry.w@student.edu'),
('2025A1020', 'Harper Harris', 'Bachelor of CS', 'harper.h@student.edu'),
('2025A1021', 'Alexander Martin', 'Bachelor of IT', 'alexander.m@student.edu'),
('2025A1022', 'Evelyn Thompson', 'Bachelor of SE', 'evelyn.t@student.edu'),
('2025A1023', 'Demetrius Koh', 'Bachelor of CS', 'demetriuskoh@gmail.com'),
('2025A1024', 'Abigail Martinez', 'Bachelor of IT', 'abigail.m@student.edu'),
('2025A1025', 'Sebastian Robinson', 'Bachelor of SE', 'sebastian.r@student.edu'),
('2025A1026', 'Shrinivas Hoh', 'Bachelor of CS', 'shrinivashoh@gmail.com'),
('2025A1027', 'Chaw Yan Cheng', 'Bachelor of IT', 'chawyancheng@gmail.com'),
('2025A1028', 'Tan Wai Ken', 'Bachelor of SE', 'tanwaiken552@gmail.com'),
('2025A1029', 'Damien See', 'Bachelor of CS', 'damiensee88@gmail.com'),
('2025A1030', 'Lucius Wilbert', 'Bachelor of IT', 'luciuswilbert@gmail.com');

-- 4. Academic Records
-- Group A: High Achievers (No fails, high CGPA)
INSERT INTO academic_records (student_id, course_code, semester, grade, grade_point, status) VALUES 
('2025A1001', 'CS201', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1001', 'CS205', 'Sem 1 2025', 'B+', 3.33, 'PASS'),
('2025A1001', 'MA202', 'Sem 1 2025', 'A-', 3.67, 'PASS'),
('2025A1002', 'IT101', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1002', 'CS205', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1002', 'CY101', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1003', 'SE301', 'Sem 1 2025', 'A-', 3.67, 'PASS'),
('2025A1003', 'NT200', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1003', 'CS210', 'Sem 1 2025', 'B+', 3.33, 'PASS'),
('2025A1004', 'CS201', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1004', 'DS400', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1005', 'IT101', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1005', 'CY101', 'Sem 1 2025', 'B+', 3.33, 'PASS');

-- Group B: Minor Setbacks (Eligible, but 1-2 failed courses)
INSERT INTO academic_records (student_id, course_code, semester, grade, grade_point, status) VALUES 
('2025A1006', 'SE301', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1006', 'CS305', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1007', 'CS201', 'Sem 1 2025', 'C', 2.00, 'PASS'),
('2025A1007', 'MA202', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1007', 'DS400', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1008', 'IT101', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1008', 'NT200', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1008', 'CY101', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1009', 'CS201', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1009', 'CS205', 'Sem 1 2025', 'C+', 2.33, 'PASS'),
('2025A1009', 'CS210', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1010', 'SE301', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1010', 'DS400', 'Sem 1 2025', 'C', 2.00, 'PASS');

-- Group C: Severely At Risk (Ineligible due to >3 Fails OR low CGPA)
INSERT INTO academic_records (student_id, course_code, semester, grade, grade_point, status) VALUES 
('2025A1011', 'CS201', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1011', 'CS205', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1011', 'MA202', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1011', 'CS210', 'Sem 1 2025', 'F', 0.00, 'FAIL'), -- 4 Fails, ineligible
('2025A1012', 'IT101', 'Sem 1 2025', 'C-', 1.67, 'FAIL'), 
('2025A1012', 'CY101', 'Sem 1 2025', 'D', 1.00, 'FAIL'), -- Low CGPA, ineligible
('2025A1013', 'SE301', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1013', 'NT200', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1013', 'CS305', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1013', 'DS400', 'Sem 1 2025', 'F', 0.00, 'FAIL');

-- Group D: Average Students (Mix of B, C, and occasional Fail)
INSERT INTO academic_records (student_id, course_code, semester, grade, grade_point, status) VALUES 
('2025A1014', 'CS201', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1015', 'IT101', 'Sem 1 2025', 'C', 2.00, 'PASS'),
('2025A1016', 'SE301', 'Sem 1 2025', 'B+', 3.33, 'PASS'),
('2025A1017', 'CS201', 'Sem 1 2025', 'C', 2.00, 'PASS'),
('2025A1017', 'CS205', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1018', 'IT101', 'Sem 1 2025', 'A-', 3.67, 'PASS'),
('2025A1019', 'SE301', 'Sem 1 2025', 'C+', 2.33, 'PASS'),
('2025A1020', 'CS201', 'Sem 1 2025', 'B-', 2.67, 'PASS'),
('2025A1021', 'IT101', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1022', 'SE301', 'Sem 1 2025', 'C', 2.00, 'PASS'),
('2025A1023', 'CS201', 'Sem 1 2025', 'F', 0.00, 'FAIL'),
('2025A1024', 'IT101', 'Sem 1 2025', 'B+', 3.33, 'PASS'),
('2025A1025', 'SE301', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1026', 'CS201', 'Sem 1 2025', 'C-', 1.67, 'FAIL'),
('2025A1027', 'IT101', 'Sem 1 2025', 'C', 2.00, 'PASS'),
('2025A1028', 'SE301', 'Sem 1 2025', 'B', 3.00, 'PASS'),
('2025A1029', 'CS201', 'Sem 1 2025', 'A', 4.00, 'PASS'),
('2025A1030', 'IT101', 'Sem 1 2025', 'C+', 2.33, 'PASS');