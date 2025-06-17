<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }

    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Past Reports</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .main-content {
            margin-left: 220px;
            padding: 20px;
            width: calc(100% - 220px);
            box-sizing: border-box;
            min-height: 100vh;
        }

        .card {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }

        h2 {
            margin-top: 0;
            text-align: center;
            color: #1f2937;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #3b82f6;
            color: white;
        }

        td {
            background-color: #f9fafb;
        }

        .btn-view {
            background-color: #10b981;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            display: inline-block;
        }

        .btn-view:hover {
            background-color: #059669;
        }
    </style>
</head>
<body>

    <!--SIDEBAR-->
    <jsp:include page="sidebar.jsp" />

    <!-- STUDENT ONLY SECTION -->
    <% if ("student".equals(userRole)) { %>
    <div class="main-content">
        <div class="card">
            <h2>Past Final Year Project Reports</h2>
            <table>
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Project Title</th>
                        <th>Student Name</th>
                        <th>Semester</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Smart Attendance System with QR Code</td>
                        <td>Ali Zulkarnain</td>
                        <td>2023/2024</td>
                        <td>
                            <a href="past_reports/SmartAttendanceSystem.pdf" class="btn-view" target="_blank">View</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Mobile App for Campus Navigation</td>
                        <td>Siti Mariam</td>
                        <td>2023/2024</td>
                        <td>
                            <a href="past_reports/CampusNavigationApp.pdf" class="btn-view" target="_blank">View</a>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>FYP Management System Dashboard</td>
                        <td>Imran Azmi</td>
                        <td>2022/2023</td>
                        <td>
                            <a href="past_reports/FYPManagementDashboard.pdf" class="btn-view" target="_blank">View</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

</body>
</html>
