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
        <title>UiTM FYP System - Examiner</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #eee;
        }
        .edit-btn {
            background-color: green;
            color: white;
            padding: 5px 10px;
            border: none;
            margin-right: 5px;
            cursor: pointer;
        }
        .delete-btn {
            background-color: red;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }
        .quota-btn {
            background-color: blue;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }
    </style>
    </head>
    <body>
        <!-- Topbar -->
    <header id="topbar">
        <jsp:include page="topbar.jsp" />
    </header>
    
    <!-- Sidebar -->
    <aside id="sidebar">
        <jsp:include page="navbar.jsp" />
    </aside>
    
    <!-- Overlay -->
    <div id="sidebarOverlay"></div>

        <div class="main-content">
        <h2>LIST OF EXAMINERS</h2>

        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Staff ID</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <% if ("admin".equals(userRole)) { %>
                        <th>Actions</th>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <th>Add Quota</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Prof. Muhammad Ali</td>
                    <td>5751289</td>
                    <td>+60 123456789</td>
                    <td>muhdali79@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Tuan Haji Abdul Rahman</td>
                    <td>5759234</td>
                    <td>+60 177788992</td>
                    <td>abdrahnan@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Madam Tan Mei Ling</td>
                    <td>5755672</td>
                    <td>+60 112233445</td>
                    <td>tanmeiling@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Dr. Raja Nurul Ain binti Tengku Ibrahim</td>
                    <td>5753122</td>
                    <td>+60 1011223545</td>
                    <td>rajanurul@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Madam Lim Siew Fong</td>
                    <td>5750221</td>
                    <td>+60 1345901234</td>
                    <td>limsiewfong@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Ms. Malarvili a/p Suppiah</td>
                    <td>5754827</td>
                    <td>+60 1423456789</td>
                    <td>malarvilisup@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <td>Puan Siti Aminah binti Abdullah</td>
                    <td>5752716</td>
                    <td>+60 1890123455</td>
                    <td>sitiaminahabd@gmail.com</td>
                    <% if ("admin".equals(userRole)) { %>
                        <td>
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </td>
                    <% } else if ("lecturer".equals(userRole)) { %>
                        <td>
                            <button class="quota-btn">Add Quota</button>
                        </td>
                    <% } %>
                </tr>
            </tbody>
        </table>
        </div>
    </body>
</html>
