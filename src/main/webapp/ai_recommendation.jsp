<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.crs.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String studentId    = (String)  request.getAttribute("studentId");
    String studentName  = (String)  request.getAttribute("studentName");
    String program      = (String)  request.getAttribute("program");
    double cgpa         = (Double)  request.getAttribute("cgpa");
    int    failCount    = (Integer) request.getAttribute("failCount");
    String riskLevel    = (String)  request.getAttribute("riskLevel");
    List<String> recommendations = (List<String>) request.getAttribute("recommendations");
    List<String> failedCourses   = (List<String>) request.getAttribute("failedCourses");

    String riskColor = riskLevel.equals("HIGH") ? "#c0392b" : riskLevel.equals("MEDIUM") ? "#e67e22" : "#27ae60";
    String riskBg    = riskLevel.equals("HIGH") ? "#fdecea" : riskLevel.equals("MEDIUM") ? "#fef3e2" : "#eafaf1";
%>
<!DOCTYPE html>
<html>
<head>
    <title>AI Recommendation</title>
    <style>
        :root {
            --mauve: #D88DB4; --dusty-purple: #AE82A4;
            --dark-blue: #5C617B; --med-blue: #828CA0; --bg-color: #f4f6f9;
        }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 40px 20px; margin: 0; }
        .paper { background: white; max-width: 800px; margin: 0 auto; padding: 50px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 10px; border-top: 6px solid var(--dusty-purple); }
        .header { text-align: center; margin-bottom: 35px; }
        .header h1 { color: var(--dark-blue); margin: 0 0 5px 0; font-size: 1.8em; }
        .header p  { color: var(--med-blue); margin: 0; font-size: 0.95em; }
        .student-info { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 25px; }
        .student-info div { color: #333; font-size: 1em; }
        .risk-badge { text-align: center; padding: 18px; border-radius: 10px; margin-bottom: 25px; font-size: 1.4em; font-weight: bold; }
        .section-title { color: var(--dark-blue); font-size: 1.1em; font-weight: bold; margin-bottom: 12px; border-bottom: 2px solid #eee; padding-bottom: 6px; }
        .rec-list { list-style: none; padding: 0; margin: 0 0 25px 0; }
        .rec-list li { background: #f9f9f9; padding: 14px 18px; border-radius: 8px; margin-bottom: 10px; color: #333; font-size: 0.97em; border-left: 4px solid var(--dusty-purple); line-height: 1.5; }
        .failed-list { list-style: none; padding: 0; margin: 0 0 25px 0; }
        .failed-list li { background: #fdecea; padding: 10px 15px; border-radius: 6px; margin-bottom: 8px; color: #c0392b; font-size: 0.95em; border-left: 4px solid #c0392b; }
        .no-fail { background: #eafaf1; padding: 12px 15px; border-radius: 6px; color: #27ae60; font-weight: bold; border-left: 4px solid #27ae60; margin-bottom: 25px; }
        .button-group { text-align: center; margin-top: 35px; }
        .action-btn { display: inline-block; margin: 0 8px; padding: 12px 25px; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; font-weight: bold; font-size: 15px; transition: 0.3s; }
        .action-btn:hover { opacity: 0.85; transform: translateY(-2px); }
        .ai-badge { text-align:center; margin-bottom: 20px; }
        .ai-badge span { background: var(--dusty-purple); color: white; padding: 6px 18px; border-radius: 20px; font-size: 0.85em; font-weight: bold; letter-spacing: 1px; }
        @media print { .button-group { display: none; } body { background: white; } .paper { box-shadow: none; } }
    </style>
</head>
<body>

<div class="paper">
    <div class="header">
        <h1>🤖 AI Academic Recommendation</h1>
        <p>Automatically generated based on academic performance analysis</p>
    </div>

    <div class="ai-badge"><span>⚡ POWERED BY RULE-BASED AI ENGINE</span></div>

    <div class="student-info">
        <div><strong>Student Name:</strong> <%= studentName %></div>
        <div><strong>Student ID:</strong> <%= studentId %></div>
        <div><strong>Program:</strong> <%= program %></div>
        <div><strong>CGPA:</strong> <%= String.format("%.2f", cgpa) %></div>
    </div>

    <div class="risk-badge" style="background:<%= riskBg %>; color:<%= riskColor %>;">
        ⚠️ Risk Level: <%= riskLevel %>
    </div>

    <div class="section-title">📋 AI Recommendations</div>
    <ul class="rec-list">
        <% for (String rec : recommendations) { %>
            <li><%= rec %></li>
        <% } %>
    </ul>

</div>

<div class="button-group">
    <button onclick="window.print()" class="action-btn" style="background: var(--med-blue);">🖨️ Print</button>
    <%-- Back to the actual report page for this student --%>
    <a href="GenerateReportServlet?studentId=<%= studentId %>" class="action-btn" style="background: var(--dusty-purple);">← Back to Report</a>
    <a href="<%= user.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "officer_dashboard.jsp" %>" class="action-btn" style="background: var(--dark-blue);">🏠 Dashboard</a>
</div>

</body>
</html>