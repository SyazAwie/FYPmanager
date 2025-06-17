<%-- 
    Document   : ConsultationLog1
    Created on : Jun 18, 2025, 4:38:23 AM
    Author     : ASUS
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieve session info
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    if (userAvatar == null || userAvatar.trim().isEmpty() || "null".equals(userAvatar)) {
        userAvatar = "default.png";
    }

    if (userName == null || "null".equals(userName)) {
        userName = "User";
    }

    Map<String, String> roleNames = new HashMap<>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");

    String displayRole = roleNames.getOrDefault(userRole, "User");

    // Redirect if not student or supervisor
    if (!"student".equals(userRole) && !"supervisor".equals(userRole)) {
        response.sendRedirect("Dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Consultation Log - UiTM FYP System</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h2>Consultation Log</h2>
        </div>

        <div class="content">
            <%-- Student View --%>
            <% if ("student".equals(userRole)) { %>
                <h3>Your Consultation Records</h3>
                <form action="StudentAddConsultationServlet" method="post">
                    <label for="date">Date:</label>
                    <input type="date" name="date" required><br>

                    <label for="topic">Topic:</label>
                    <input type="text" name="topic" required><br>

                    <label for="summary">Summary:</label><br>
                    <textarea name="summary" rows="5" cols="60" required></textarea><br>

                    <input type="submit" value="Submit Consultation">
                </form>

                <%-- Placeholder: Table of student's consultation logs --%>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Topic</th>
                            <th>Summary</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Loop data here from backend --%>
                        <tr>
                            <td>2025-05-10</td>
                            <td>Project Scope</td>
                            <td>Discussed about narrowing down the scope to two modules.</td>
                        </tr>
                    </tbody>
                </table>

            <% } else if ("supervisor".equals(userRole)) { %>
                <h3>Supervisee Consultation Logs</h3>

                <%-- Placeholder: Filter/search supervisees' consultation logs --%>
                <form method="get" action="SupervisorConsultationServlet">
                    <label for="studentId">Select Student:</label>
                    <select name="studentId">
                        <%-- Populate options from database --%>
                        <option value="S123">S123 - John Doe</option>
                        <option value="S456">S456 - Jane Smith</option>
                    </select>
                    <input type="submit" value="View Logs">
                </form>

                <%-- Placeholder table for consultation logs --%>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Date</th>
                            <th>Topic</th>
                            <th>Summary</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Example row --%>
                        <tr>
                            <td>John Doe</td>
                            <td>2025-05-10</td>
                            <td>Progress Update</td>
                            <td>Reviewed implementation of login module.</td>
                        </tr>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
