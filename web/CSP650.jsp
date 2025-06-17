<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
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
        <title>UiTM FYP System - CSP600</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <!--SIDEBAR-->
        <jsp:include page="sidebar.jsp" />
        
        <%-- Admin & Lecturer Part --%>
<% if ("admin".equals(userRole) || "lecturer".equals(userRole)) { %>
    <div class="main-content">
        <h2 class="page-title">List of Student CSP650</h2>
        <div class="table-container">
            <table class="supervisor-table">
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
                    <tr>
                        <td>Nur Aisyah Binti Khalid</td>
                        <td>2023123456</td>
                        <td>CS240</td>
                        <td>Dr. Rahman</td>
                        <td>
                            <button class="btn-edit">Edit</button>
                            <button class="btn-delete" onclick="return confirm('Delete student?');">Delete</button>
                        </td>
                    </tr>
                    <tr>
                        <td>Ahmad Faris Bin Zulkifli</td>
                        <td>2023123477</td>
                        <td>CS240</td>
                        <td>Dr. Rahman</td>
                        <td>
                            <button class="btn-edit">Edit</button>
                            <button class="btn-delete" onclick="return confirm('Delete student?');">Delete</button>
                        </td>
                    </tr>
                    <!-- Add more rows as needed -->
                </tbody>
            </table>
        </div>
    </div>
<% } %>


        
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
                        <td>Siti Nur Alia Binti Rahmah</td>
                        <td>2021123499</td>
                        <td>Development of a Secure File Sharing System for Research Data</td>
                        <td><span class="status proposal">Proposal</span></td>
                    </tr>
                    <tr>
                        <td>Nurul Huda Binti Firdaus</td>
                        <td>2023230569</td>
                        <td>Analysis of Traffic Patterns in Kuala Terengganu using Big Data Analytics</td>
                        <td><span class="status in-progress">In Progress (50%)</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
<% } %>

            
    </body>
</html>
