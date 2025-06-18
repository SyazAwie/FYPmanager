<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");
    
    // Set default values if null
    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    // Check login/session
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    // Set default avatar
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png"; // fallback kalau tak ada gambar
    }
    
    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>UiTM FYP System -CSP600</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>
                /* Container Styles */
            .page-title {
                color: #2c3e50;
                font-size: 28px;
                font-weight: 600;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #3498db;
            }

            .table-container {
                overflow: hidden;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                background: white;
            }

            /* Table Styles */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                font-size: 16px;
            }

            thead {
                background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
                color: white;
            }

            thead th {
                padding: 18px 15px;
                text-align: left;
                font-weight: 600;
                letter-spacing: 0.5px;
            }

            thead th:first-child {
                border-top-left-radius: 10px;
            }

            thead th:last-child {
                border-top-right-radius: 10px;
            }

            tbody tr {
                transition: all 0.3s ease;
                border-bottom: 1px solid #eaeaea;
            }

            tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tbody tr:hover {
                background-color: #f1f8ff;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.1);
            }

            tbody td {
                padding: 16px 15px;
                color: #34495e;
                border-bottom: 1px solid #eee;
            }

            /* Action Buttons */
            .btn-edit, .btn-delete {
                padding: 10px 18px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.25s ease;
                border: none;
                outline: none;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .btn-edit {
                background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                color: white;
                margin-right: 8px;
            }

            .btn-edit:hover {
                background: linear-gradient(135deg, #2980b9 0%, #3498db 100%);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
            }

            .btn-delete {
                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
                color: white;
            }

            .btn-delete:hover {
                background: linear-gradient(135deg, #c0392b 0%, #e74c3c 100%);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .table-container {
                    overflow-x: auto;
                }

                table {
                    min-width: 600px;
                }

                .main-content {
                    padding: 20px 15px;
                }

                .page-title {
                    font-size: 24px;
                }
            }
        </style>
    </head>
    <body>
        <!--SIDEBAR-->
        <jsp:include page="sidebar.jsp" />
        
        <%-- Admin & Lecturer Part --%>
<% if ("admin".equals(userRole) || "lecturer".equals(userRole)) { %>
    <div class="main-content">
        <h2 class="page-title">List of Student CSP600</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Student ID</th>
                        <th>Programme</th>
                        <th>Supervisor</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${studentList}">
                        <tr>
                            <td>${student.name}</td>
                            <td>${student.studentId}</td>
                            <td>${student.programme}</td>
                            <td>${student.supervisorName}</td>
                            <td>
                                <button class="btn-edit">Edit</button>
                                <button class="btn-delete" onclick="return confirm('Delete student?');">Delete</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
<% } %>

        
        <%-- Supervisor Part --%>
<% if ("supervisor".equals(userRole)) { %>
    <div class="main-content">
        <h2 class="page-title">List of Supervisees</h2>
        <p>Currently supervising: 4 / 6 Students</p>
        <button class="btn-green">Edit Quota</button>

        <div class="table-container">
            <table class="supervisor-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Student ID</th>
                        <th>Title</th>
                        <th>Progress Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Nur Aisyah Binti Khalid</td>
                        <td>2023123456</td>
                        <td>Development of a Remote Patient Monitoring System</td>
                        <td><span class="status in-progress">In Progress (50%)</span></td>
                    </tr>
                    <tr>
                        <td>Ahmad Faris Bin Zulkifli</td>
                        <td>2023123477</td>
                        <td>Analysis of Wireless Network Security in UiTM Kampus Kuala Terengganu</td>
                        <td><span class="status completed">Completed</span></td>
                    </tr>
                    <tr>
                </tbody>
            </table>
        </div>
    </div>
<% } %>

            
    </body>
</html>
