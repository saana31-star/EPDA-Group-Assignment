# EPDA-Group-Assignment


---

## ⚙️ Setup Instructions

### 1. Prerequisites
- JDK 17 or above
- Apache Tomcat 10+
- MySQL 8.0+
- IDE (IntelliJ IDEA / Eclipse recommended)

### 2. Database Setup
1. Open MySQL Workbench or any MySQL client
2. Create a new database:
   ```sql
   CREATE DATABASE crs_db;
   ```
3. Import the provided SQL file:
   ```sql
   SOURCE /path/to/crs_db.sql;
   ```

### 3. Configure DB Password
Find all occurrences of this line across servlet files and replace `your_password` with your MySQL password:
```java
DriverManager.getConnection("jdbc:mysql://localhost:3306/crs_db", "root", "your_password");
```

### 4. Configure Email (SMTP)
Open `EmailUtility.java` and update:
```java
String senderEmail    = "your_email@gmail.com";
String senderPassword = "your_app_password";
```
> ⚠️ Use a Gmail App Password, not your actual Gmail password.

### 5. Deploy
1. Build the project as a `.war` file
2. Drop it into Tomcat's `webapps/` directory
3. Start Tomcat and navigate to:


---

## 🔐 Default Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Administrator | admin | admin123 |
| Academic Officer | officer | officer123 |

> ⚠️ Change these credentials after first login.

---

## ✅ Features Implemented

### Core Features
- 🔐 **User Management** — Add, update, deactivate staff accounts with role-based access
- 📋 **Course Recovery Plan** — Create and manage student recovery plans
- 🏁 **Milestone Tracker** — Add, update, remove milestones for each recovery plan
- 📊 **Eligibility Check** — Auto-check student CGPA and failed course eligibility
- 📄 **Academic Performance Report** — Generate full student transcript by semester
- 📧 **Email Notifications** — Send recovery plans and academic reports to students via email

### Bonus Features
- 🤖 **AI Academic Recommendation** — Rule-based AI engine that analyses student CGPA and performance to generate personalised improvement recommendations
- 📈 **Dashboard Statistics** — Live database stats displayed on both Admin and Officer dashboards

---

## 🗄️ Database Tables

| Table | Description |
|-------|-------------|
| `users` | System user accounts (Admin/Officer) |
| `students` | Student profiles and CGPA |
| `academic_records` | Course grades and credit hours per student |
| `recovery_plans` | Student course recovery plans |
| `recovery_milestones` | Milestones linked to each recovery plan |

---

## 📌 Known Limitations

- Email feature requires an active internet connection and valid SMTP credentials
- AI Recommendation is rule-based (not machine learning) and relies on existing DB data
- System currently supports report generation only

---

## 📜 License

This project is developed for academic purposes only as part of the CT027-3-3 EPDA assignment at APU.