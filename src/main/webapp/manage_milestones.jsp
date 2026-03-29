<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.crs.model.User, com.crs.model.Milestone" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String planId     = (String) request.getAttribute("planId");
    String studentName = (String) request.getAttribute("studentName");
    String courseTitle = (String) request.getAttribute("courseTitle");
    String semester    = (String) request.getAttribute("semester");
    String planStatus  = (String) request.getAttribute("planStatus");

    List<Milestone> milestones = (List<Milestone>) request.getAttribute("milestones");

    int total = (milestones != null) ? milestones.size() : 0;
    int done  = 0;
    if (milestones != null) {
        for (Milestone m : milestones) { if (m.isCompleted()) done++; }
    }
    int progressPct = (total > 0) ? (done * 100 / total) : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Milestone Tracker</title>
    <style>
        :root {
            --peach: #F5D0C5; --pink: #F0AEB6; --mauve: #D88DB4;
            --dusty-purple: #AE82A4; --dark-blue: #5C617B;
            --med-blue: #828CA0; --light-blue: #AAB4C2; --bg-color: #f4f6f9;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg-color); padding: 30px 20px; margin: 0; }

        .main-wrapper { max-width: 1000px; margin: 0 auto; }

        .plan-info-card {
            background: white; padding: 25px 30px; border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid var(--dusty-purple);
            margin-bottom: 25px;
        }
        .plan-info-card h2 { color: var(--dark-blue); margin: 0 0 15px 0; }
        .plan-meta { display: flex; gap: 30px; flex-wrap: wrap; font-size: 0.95em; color: #555; }
        .plan-meta span strong { color: var(--dark-blue); }

        .progress-section { margin-top: 20px; }
        .progress-label { font-size: 0.9em; font-weight: bold; color: var(--dark-blue); margin-bottom: 8px; }
        .progress-bar-bg { background: #eee; border-radius: 20px; height: 14px; overflow: hidden; }
        .progress-bar-fill { height: 100%; border-radius: 20px; background: var(--dusty-purple); transition: width 0.5s ease; }

        .layout { display: flex; gap: 25px; flex-wrap: wrap; }

        .add-panel {
            background: white; padding: 25px; border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid var(--med-blue);
            flex: 1; min-width: 280px; height: fit-content;
        }
        .add-panel h3 { color: var(--dark-blue); margin-top: 0; border-bottom: 2px solid var(--light-blue); padding-bottom: 12px; }

        label { display: block; font-weight: bold; color: var(--dark-blue); font-size: 0.9em; margin-bottom: 6px; margin-top: 15px; }
        input[type="text"], textarea {
            width: 100%; padding: 11px; border: 1px solid var(--light-blue);
            border-radius: 6px; box-sizing: border-box; font-family: inherit;
            transition: 0.3s; outline: none;
        }
        input[type="text"]:focus, textarea:focus { border-color: var(--dusty-purple); }

        .add-btn {
            background: var(--dusty-purple); color: white; border: none; padding: 12px;
            margin-top: 20px; border-radius: 6px; cursor: pointer; width: 100%;
            font-size: 15px; font-weight: bold; transition: 0.3s;
        }
        .add-btn:hover { opacity: 0.85; transform: translateY(-2px); }

        .table-panel {
            background: white; padding: 25px; border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid var(--dark-blue);
            flex: 2; min-width: 400px;
        }
        .table-panel h3 { color: var(--dark-blue); margin-top: 0; border-bottom: 2px solid var(--light-blue); padding-bottom: 12px; }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 13px 12px; border-bottom: 1px solid #eee; text-align: left; vertical-align: middle; }
        th { background: var(--dark-blue); color: white; text-transform: uppercase; font-size: 0.82em; letter-spacing: 0.5px; }
        tr.completed-row td { opacity: 0.55; text-decoration: line-through; }

        .badge-done { background: #d4edda; color: #155724; padding: 4px 10px; border-radius: 12px; font-size: 0.8em; font-weight: bold; }
        .badge-pending { background: var(--peach); color: var(--dark-blue); padding: 4px 10px; border-radius: 12px; font-size: 0.8em; font-weight: bold; }

        .toggle-btn {
            padding: 5px 10px; border-radius: 6px; font-size: 0.82em; font-weight: bold;
            border: none; cursor: pointer; transition: 0.3s; text-decoration: none; display: inline-block;
        }
        .toggle-complete { background: #d4edda; color: #155724; }
        .toggle-undo { background: var(--peach); color: var(--dark-blue); }
        .toggle-btn:hover { opacity: 0.8; }

        .remove-btn { color: var(--pink); font-weight: bold; text-decoration: none; padding: 5px 10px; border: 1px solid var(--pink); border-radius: 6px; transition: 0.3s; font-size: 0.82em; margin-left: 5px; }
        .remove-btn:hover { background: var(--pink); color: white; }

        .btn-back { display: inline-block; margin-bottom: 20px; padding: 10px 15px; background: var(--med-blue); color: white; text-decoration: none; border-radius: 6px; transition: 0.3s; }
        .btn-back:hover { opacity: 0.85; }

        .success-msg { background: #d4edda; color: #155724; padding: 12px; border-radius: 6px; font-weight: bold; margin-bottom: 15px; text-align: center; }
        .empty-msg { text-align: center; color: #aaa; padding: 25px; font-style: italic; }
    </style>
</head>
<body>

<div class="main-wrapper">

    <a href="view_plans.jsp" class="btn-back">← Back to Recovery Plans</a>

    <!-- Plan Info Card -->
    <div class="plan-info-card">
        <h2>📋 Milestone Tracker — Plan #<%= planId %></h2>
        <div class="plan-meta">
            <span><strong>Student:</strong> <%= studentName %></span>
            <span><strong>Course:</strong> <%= courseTitle %></span>
            <span><strong>Semester:</strong> <%= semester %></span>
            <span><strong>Status:</strong> <%= planStatus %></span>
        </div>
        <div class="progress-section">
            <div class="progress-label">Progress: <%= done %> / <%= total %> milestones completed (<%= progressPct %>%)</div>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" style="width: <%= progressPct %>%;"></div>
            </div>
        </div>
    </div>

    <div class="layout">

        <!-- Add Milestone Form -->
        <div class="add-panel">
            <h3>➕ Add Milestone</h3>
            <% if ("added".equals(request.getParameter("msg"))) { %>
                <div class="success-msg">✅ Milestone added successfully!</div>
            <% } %>
            <form action="MilestoneServlet" method="post">
                <input type="hidden" name="planId" value="<%= planId %>">
                <label>Study Week</label>
                <input type="text" name="week" placeholder="e.g. Week 1 - 2" required>
                <label>Task Description</label>
                <textarea name="task" rows="3" placeholder="e.g. Review all lecture slides for Chapter 1-3" required></textarea>
                <button type="submit" class="add-btn">Add Milestone</button>
            </form>
        </div>

        <!-- Milestones Table -->
        <div class="table-panel">
            <h3>📅 Recovery Milestones</h3>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Week</th>
                        <th>Task</th>
                        <th>Status</th>
                        <th>Actions</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                <% if (milestones != null && !milestones.isEmpty()) {
                    int rowNum = 1;
                    for (Milestone m : milestones) { %>
                    <tr class="<%= m.isCompleted() ? "completed-row" : "" %>">
                        <td><strong><%= rowNum++ %></strong></td>
                        <td><%= m.getWeek() %></td>
                        <td><%= m.getTask() %></td>
                        <td>
                            <% if (m.isCompleted()) { %>
                                <span class="badge-done">Done</span>
                            <% } else { %>
                                <span class="badge-pending">Pending</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="MilestoneServlet?action=toggle&id=<%= m.getMilestoneId() %>&planId=<%= planId %>"
                               class="toggle-btn <%= m.isCompleted() ? "toggle-undo" : "toggle-complete" %>">
                                <%= m.isCompleted() ? "Undo" : "Done" %>
                            </a>
                        </td>
                        <td>
                            <a href="MilestoneServlet?action=delete&id=<%= m.getMilestoneId() %>&planId=<%= planId %>"
                               class="remove-btn"
                               onclick="return confirm('Remove this milestone?');">✕</a>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="5" class="empty-msg">No milestones yet. Add one using the form!</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

    </div>
</div>

</body>
</html>