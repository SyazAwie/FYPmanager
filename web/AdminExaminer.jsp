AdminExaminer.jsp

<%-- 
    Document   : AdminExaminer
    Created on : May 28, 2025
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 
    // Session check
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
--%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Examiners</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-color: #f4f4f4;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            background-color: #7c6593;
            width: 220px;
            padding: 20px 10px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .sidebar img {
            width: 100px;
            margin-bottom: 15px;
        }

        .sidebar h2 {
            font-size: 14px;
            text-align: center;
            margin-bottom: 30px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 10px;
            width: 100%;
            color: white;
            text-decoration: none;
            margin: 5px 0;
            border-radius: 8px;
        }

        .nav-link:hover, .nav-link.active {
            background-color: #5e4b75;
        }

        .nav-link i {
            margin-right: 10px;
        }

        /* Top bar */
        .top-bar {
            background-color: #b0b0b0;
            height: 60px;
            width: 100%;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .search-box input {
            padding: 10px;
            border-radius: 8px;
            border: none;
            width: 300px;
        }

        .top-icons {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .dashboard {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            padding: 20px;
        }

        .cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .card {
            flex: 1;
            min-width: 160px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .card.purple { background: linear-gradient(to bottom, #c59aff, #8f6dd1); }
        .card.blue { background: linear-gradient(to bottom, #c3d4ff, #849bcf); }
        .card.yellow { background: linear-gradient(to bottom, #fff49a, #d4b400); }
        .card.cyan { background: linear-gradient(to bottom, #c0f0ff, #7fb3c4); }
        .card.grey { background: linear-gradient(to bottom, #dcdcdc, #a3a3a3); }

        .card h3 {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .card span {
            font-size: 24px;
            font-weight: bold;
        }

        .widgets {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .widget-box {
            flex: 1;
            background-color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            min-width: 260px;
        }

        .widget-box h4 {
            margin-bottom: 10px;
        }

        .announcement {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            width: 250px;
        }

        .announcement input {
            width: 100%;
            padding: 8px;
            margin: 8px 0;
        }

        .announcement button {
            padding: 8px 12px;
            background: black;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 6px;
        }
        
        .dropdown {
            width: 100%;
        }

        .parent-link {
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            width: 100%;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .arrow {
            margin-left: auto;
            font-size: 12px;
        }

        .submenu {
            display: none; /* hides it by default */
            flex-direction: column;
            padding-left: 15px;
            margin-top: 5px;
        }

        .submenu .nav-link {
            font-size: 14px;
            background-color: #6e549f;
            padding-left: 30px;
        }

        .submenu .nav-link.active {
            background-color: #5e4b75;
    }

    </style>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const parentLink = document.querySelector(".parent-link");
            const submenu = document.querySelector(".submenu");
            const arrow = document.querySelector(".arrow");

            parentLink.addEventListener("click", function () {
                submenu.style.display = submenu.style.display === "flex" ? "none" : "flex";
                arrow.innerHTML = submenu.style.display === "flex" ? "&#9652;" : "&#9662;";
            });

            const currentUrl = "<%= request.getRequestURI() %>";
            if (currentUrl.includes("AdminSupervisor.jsp") || currentUrl.includes("AdminExaminer.jsp")) {
                submenu.style.display = "flex";
                arrow.innerHTML = "&#9652;";
            }
        });
    </script>

</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <img src="images/UiTM-Logo.png" alt="UiTM Logo">
    <h2>UNIVERSITI TEKNOLOGI MARA</h2>

    <a class="nav-link" href="AdminDashboard.jsp"><i>🏠</i> Home</a>
    <a class="nav-link" href="AdminStudent.jsp"><i>👨‍🎓</i> Students</a>
    
    <div class="dropdown">
        <div class="nav-link parent-link">
            <span>👨‍🏫 Supervisors</span>
            <span class="arrow">&#9662;</span>
        </div>
        <div class="submenu">
            <a href="AdminSupervisor.jsp" class="nav-link <% if(request.getRequestURI().contains("AdminSupervisor.jsp")) { %> active <% } %>">Supervisors</a>
            <a href="AdminExaminer.jsp" class="nav-link <% if(request.getRequestURI().contains("AdminExaminer.jsp")) { %> active <% } %>">Examiners</a>
        </div>
    </div>

    <a class="nav-link" href="AdminPresentation.jsp"><i>🖥️</i> Presentations</a>
    <a class="nav-link" href="#"><i>📄</i> Submissions</a>
    <a class="nav-link" href="LogoutServlet"><i>🚪</i> Logout</a>
</div>

<!-- Main content -->
<div class="dashboard">
    <div class="top-bar">
        <div class="search-box">
            <input type="text" placeholder="Search">
        </div>
        <div class="top-icons">
            <i>🔔</i>
            <i style="background-color:#ccc; border-radius: 50%; width: 35px; height: 35px; display: inline-block;"></i>
        </div>
    </div>

    <div class="main-content">
        <h2>LIST OF EXAMINERS</h2>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Staff ID</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Sample data -->
                <tr>
                    <td>Tuan Haji Abdul Rahman</td>
                    <td>5759234</td>
                    <td>+60 177788992</td>
                    <td>abdrhman@gmail.com</td>
                    <td class="action-buttons">
                        <button class="btn edit-btn">Edit</button>
                        <button class="btn delete-btn">Delete</button>
                    </td>
                </tr>
                <!-- Add more rows as needed -->
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
