<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String currentPage = request.getRequestURI();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Supervisor - Students</title>
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            display: flex;
            min-height: 100vh;
            background-color: #f4f4f4;
            overflow: hidden;
        }

        .sidebar {
            background-color: #7c6593;
            width: 220px;
            padding: 20px 10px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .sidebar .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar .logo img {
            width: 100px;
            margin-bottom: 15px;
        }

        .sidebar .logo p {
            font-size: 14px;
            margin: 0;
        }

        .sidebar nav ul {
            list-style: none;
            padding: 0;
            width: 100%;
        }

        .sidebar nav ul li,
        .sidebar .dropdown {
            margin-bottom: 5px;
        }

        .sidebar nav ul li a,
        .parent-link {
            display: flex;
            align-items: center;
            padding: 10px;
            width: 100%;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: background-color 0.3s ease;
            font-size: 1em;
            gap: 10px;
        }

        .sidebar nav ul li a:hover,
        .sidebar nav ul li.active a,
        .dropdown.active .parent-link {
            background-color: #5e4b75;
        }

        .arrow {
            margin-left: auto;
            font-size: 12px;
            transition: transform 0.3s ease;
        }

        .dropdown.active .arrow {
            transform: rotate(180deg);
        }

        .submenu {
            display: none;
            flex-direction: column;
            background-color: #6e549f;
            border-radius: 8px;
            padding: 10px 0;
            margin-top: 5px;
            text-align: center;
        }

        .submenu a {
            color: #c0f0ff;
            text-decoration: none;
            padding: 5px 0;
            display: block;
            font-size: 0.9em;
        }

        .submenu a:hover,
        .submenu a.active {
            color: white;
            font-weight: bold;
        }

        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .header {
            background-color: #b0b0b0;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
        }

        .search-bar input {
            padding: 10px;
            border-radius: 8px;
            border: none;
            width: 300px;
        }

        .icons {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .icons .icon {
            font-size: 1.5em;
            color: #555;
            cursor: pointer;
        }

        .user-avatar {
            background-color: #ccc;
            border-radius: 50%;
            width: 35px;
            height: 35px;
        }

        .student-list-container {
            padding: 20px;
            flex-grow: 1;
            overflow-y: auto;
        }

        .student-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .quota-info {
            font-size: 0.9em;
            color: #555;
        }

        .edit-quota-btn {
            background-color: #6a0dad;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9em;
        }

        .edit-quota-btn:hover {
            background-color: #5e4b75;
        }

        .student-table-panel {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .student-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
        }

        .student-table th,
        .student-table td {
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
            font-size: 0.85em;
            min-width: 100px;
        }

        .status-badge.in-progress {
            background-color: #e0f2f7;
            color: #2196f3;
        }

        .status-badge.completed {
            background-color: #e8f5e9;
            color: #4caf50;
        }

        .status-badge.proposal {
            background-color: #fffde7;
            color: #ffc107;
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const reviewDropdown = document.querySelector(".review-dropdown");
            const reviewParentLink = document.querySelector(".review-dropdown .parent-link");
            const reviewSubmenu = document.querySelector(".review-dropdown .submenu");
            const reviewArrow = document.querySelector(".review-dropdown .arrow");

            const isReviewPage = window.location.pathname.includes("SupervisorForm.jsp") || window.location.pathname.includes("SupervisorPlagiarism.jsp");

            if (isReviewPage) {
                reviewDropdown.classList.add("active");
                reviewSubmenu.style.display = "flex";
                reviewArrow.innerHTML = "&#9652;";
            }

            reviewParentLink.addEventListener("click", function (e) {
                e.preventDefault();
                reviewDropdown.classList.toggle("active");
                reviewSubmenu.style.display = (reviewSubmenu.style.display === "flex") ? "none" : "flex";
                reviewArrow.innerHTML = (reviewSubmenu.style.display === "flex") ? "&#9652;" : "&#9662;";
            });
        });
    </script>
</head>
<body>
    <div class="sidebar">
        <div class="logo">
            <img src="images/UiTM-Logo.png" alt="University Logo">
            <p>UNIVERSITI<br>TEKNOLOGI MARA</p>
        </div>
        <nav>
            <ul>
                <li class="<%= currentPage.endsWith("SupervisorDashboard.jsp") ? "active" : "" %>">
                    <a href="SupervisorDashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
                </li>
                <li class="<%= currentPage.endsWith("SupervisorStudent.jsp") ? "active" : "" %>">
                    <a href="SupervisorStudent.jsp"><i class="fas fa-user-graduate"></i> Students</a>
                </li>
                <div class="dropdown review-dropdown <%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "active" : "" %>">
                    <div class="parent-link">
                        <i class="fas fa-file-alt"></i> <span>Review</span>
                        <span class="arrow"><%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "&#9652;" : "&#9662;" %></span>
                    </div>
                    <div class="submenu" style="display: <%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "flex" : "none" %>;">
                        <a href="SupervisorForm.jsp" class="<%= currentPage.endsWith("SupervisorForm.jsp") ? "active" : "" %>">Form</a>
                        <a href="SupervisorPlagiarism.jsp" class="<%= currentPage.endsWith("SupervisorPlagiarism.jsp") ? "active" : "" %>">Plagiarism</a>
                    </div>
                </div>
                <li><a href="#"><i class="fas fa-folder-open"></i> Past Project</a></li>
                <li><a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search">
            </div>
            <div class="icons">
                <span class="icon"><i class="fas fa-bell"></i></span>
                <span class="user-avatar"></span>
            </div>
        </div>

        <div class="student-list-container">
            <div class="student-list-header">
                <h2>List of Supervises</h2>
                <div>
                    <span class="quota-info">Currently supervising: 4 / 6 Students</span>
                    <button class="edit-quota-btn">Edit Quota</button>
                </div>
            </div>

            <div class="student-table-panel">
                <table class="student-table">
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
                            <td><span class="status-badge in-progress">In Progress (50%)</span></td>
                        </tr>
                        <tr>
                            <td>Ahmad Faris Bin Zulkifli</td>
                            <td>2023123477</td>
                            <td>Analysis of Wireless Network Security in UiTM Kampus Kuala Terengganu</td>
                            <td><span class="status-badge completed">Completed</span></td>
                        </tr>
                        <tr>
                            <td>Siti Nur Aila Binti Rahmah</td>
                            <td>2021123499</td>
                            <td>Development of a Secure File Sharing System for Research Data</td>
                            <td><span class="status-badge proposal">Proposal</span></td>
                        </tr>
                        <tr>
                            <td>Nurul Huda Binti Firdaus</td>
                            <td>2023230569</td>
                            <td>Analysis of Traffic Patterns in Kuala Terengganu Using Big Data Analytics</td>
                            <td><span class="status-badge in-progress">In Progress (50%)</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
