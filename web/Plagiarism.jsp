

<%-- 
    Document   : plagisrism
    Created on : May 28, 2025, 10:51:31 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String currentPage = request.getRequestURI();
%>
<!DOCTYPE html>
<html>
<head>
    
    <jsp:include page="sidebar.jsp" />
    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <title>Supervisor - Plagiarism Reports</title>
    <style>
        /* General styles (Copied from previous templates) */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            display: flex;
            min-height: 100vh;
            overflow: hidden; /* Prevent overall page scroll */
        }

        /* Sidebar (Copied from previous templates) */
        .sidebar {
            background-color: #7c6593;
            width: 220px;
            padding: 20px 10px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: sticky;
            top: 0;
            height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .sidebar .logo {
            text-align: center;
            margin-bottom: 30px;
            padding: 0;
        }
        .sidebar .logo img {
            width: 100px;
            height: auto;
            margin-bottom: 15px;
        }
        .sidebar .logo p {
            font-size: 14px;
            text-align: center;
            margin-bottom: 30px;
            margin-top: 0;
            font-weight: normal;
        }

        .sidebar nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
            width: 100%;
        }
        .sidebar nav ul li {
            margin-bottom: 5px;
            position: relative;
        }
        .sidebar nav ul li a {
            display: flex;
            align-items: center;
            padding: 10px;
            width: 100%;
            color: white;
            text-decoration: none;
            margin: 5px 0;
            border-radius: 8px;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }
        .sidebar nav ul li a:hover,
        .sidebar nav ul li.active a {
            background-color: #5e4b75;
        }
        .sidebar nav ul li a i {
            margin-right: 10px;
        }

        /* Dropdown specific styles */
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
            margin: 5px 0;
            transition: background-color 0.3s ease;
        }
        .parent-link:hover {
            background-color: #5e4b75;
        }
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
            padding: 10px 0;
            margin-top: 5px;
            background-color: #6e549f;
            border-radius: 8px;
            overflow: hidden;
            width: calc(100% - 15px);
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }

        .submenu a {
            color: #c0f0ff;
            text-decoration: none;
            padding: 5px 0;
            display: block;
            font-size: 0.9em;
            transition: color 0.3s ease;
        }

        .submenu a:hover {
            color: white;
        }
        .submenu a.active {
            color: white;
            font-weight: bold;
        }

        /* Main Content Area */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        /* Top Bar (Copied from previous templates) */
        .header {
            background-color: #b0b0b0;
            height: 60px;
            width: 100%;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header .search-bar {
            flex-grow: 1;
            margin-right: 20px;
        }
        .header .search-bar input {
            padding: 10px;
            border-radius: 8px;
            border: none;
            width: 300px;
            outline: none;
        }
        .header .icons {
            display: flex;
            gap: 20px;
        }
        .header .icons .icon {
            font-size: 1.5em;
            color: #555;
            cursor: pointer;
        }
         .header .icons .user-avatar {
            background-color: #ccc;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: inline-block;
        }

        /* Plagiarism Page Specific Styles */
        .plagiarism-container {
            padding: 20px;
            flex-grow: 1;
            display: flex; /* Use flexbox to arrange table and right sidebar */
            gap: 20px;
            overflow: hidden; /* Prevent scrolling of this container itself */
        }

        .plagiarism-table-section {
            flex: 3; /* Takes more space for the table */
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow-y: auto; /* Allow table section to scroll if content overflows */
        }

        .plagiarism-table-section h2 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #333;
            font-size: 1.5em;
        }

        .plagiarism-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
            color: #333;
        }

        .plagiarism-table th,
        .plagiarism-table td {
            padding: 12px 0;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .plagiarism-table th {
            color: #777;
            font-weight: normal;
            font-size: 0.9em;
        }

        .plagiarism-table tr:last-child td {
            border-bottom: none;
        }

        /* Status Badges for Plagiarism Table */
        .plagiarism-status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
            font-size: 0.85em;
            text-align: center;
            min-width: 80px;
        }
        .plagiarism-status-badge.verified {
            background-color: #e8f5e9; /* Light green */
            color: #4caf50; /* Green text */
        }
        .plagiarism-status-badge.pending {
            background-color: #fffde7; /* Light yellow */
            color: #ffc107; /* Yellow text */
        }
        .plagiarism-status-badge.flagged {
            background-color: #ffebee; /* Light red */
            color: #f44336; /* Red text */
        }

        /* Right Sidebar for Plagiarism Details */
        .plagiarism-details-sidebar {
            flex: 1.5; /* Takes less space than the table */
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            gap: 20px;
            overflow-y: auto; /* Allow this sidebar to scroll if its content overflows */
        }

        .plagiarism-details-sidebar h3 {
            margin-top: 0;
            margin-bottom: 5px;
            color: #333;
            font-size: 1.2em;
        }
        .plagiarism-details-sidebar p {
            margin: 0;
            color: #555;
            font-size: 0.95em;
        }

        .similarity-breakdown-box {
            background-color: #f0f2f5; /* Light grey background */
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 150px; /* Ensure some height */
            color: #777;
        }
        .similarity-breakdown-box img {
            max-width: 80px;
            margin-bottom: 10px;
        }

        .comment-section textarea {
            width: 100%;
            min-height: 100px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 0.9em;
            resize: vertical; /* Allow vertical resizing */
            outline: none;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: auto; /* Push buttons to the bottom */
        }

        .action-buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .action-buttons .accept-btn {
            background-color: #4CAF50; /* Green */
            color: white;
        }
        .action-buttons .accept-btn:hover {
            background-color: #45a049;
        }

        .action-buttons .reject-btn {
            background-color: #f44336; /* Red */
            color: white;
        }
        .action-buttons .reject-btn:hover {
            background-color: #da190b;
        }

    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Get the specific dropdown elements for "Review"
            const reviewDropdown = document.querySelector(".review-dropdown"); // The entire dropdown div
            const reviewParentLink = document.querySelector(".review-dropdown .parent-link");
            const reviewSubmenu = document.querySelector(".review-dropdown .submenu");
            const reviewArrow = document.querySelector(".review-dropdown .arrow");

            // Check if the current page is part of the review dropdown (using substring for JS)
            const isReviewPage = window.location.pathname.includes("SupervisorForm.jsp") || window.location.pathname.includes("SupervisorPlagiarism.jsp");

            if (reviewParentLink && reviewSubmenu && reviewArrow) {
                // Set initial state based on current page
                if (isReviewPage) {
                    reviewDropdown.classList.add("active");
                    reviewSubmenu.style.display = "flex";
                    reviewArrow.innerHTML = "&#9652;"; // Up arrow
                } else {
                    reviewDropdown.classList.remove("active");
                    reviewSubmenu.style.display = "none";
                    reviewArrow.innerHTML = "&#9662;"; // Down arrow
                }

                reviewParentLink.addEventListener("click", function (event) {
                    event.preventDefault(); // Prevent default link behavior

                    // Toggle the 'active' class on the dropdown parent
                    reviewDropdown.classList.toggle("active");

                    if (reviewSubmenu.style.display === "flex") {
                        reviewSubmenu.style.display = "none";
                        reviewArrow.innerHTML = "&#9662;"; // Down arrow
                    } else {
                        reviewSubmenu.style.display = "flex";
                        reviewArrow.innerHTML = "&#9652;"; // Up arrow
                    }
                });
            }
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
                <li><a href="SupervisorDashboard.jsp">🏠 Dashboard</a></li>
                <li><a href="SupervisorStudent.jsp">👨‍🎓 Students</a></li>

                <div class="dropdown review-dropdown <%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "active" : "" %>"> <div class="nav-link parent-link">
                        <span>📄 Review</span>
                        <span class="arrow"><%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "&#9652;" : "&#9662;" %></span>
                    </div>
                    <div class="submenu" style="display: <%= currentPage.contains("SupervisorForm.jsp") || currentPage.contains("SupervisorPlagiarism.jsp") ? "flex" : "none" %>;"> <a href="SupervisorForm.jsp" class="nav-link <%= currentPage.endsWith("SupervisorForm.jsp") ? "active" : "" %>">Form</a>
                        <a href="SupervisorPlagiarism.jsp" class="nav-link <%= currentPage.endsWith("SupervisorPlagiarism.jsp") ? "active" : "" %>">Plagiarism</a>
                    </div>
                </div>

                <li><a href="#">📁 Past Project</a></li>
                <li><a href="LogoutServlet">🚪 Logout</a></li>
            </ul>
        </nav>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search">
            </div>
            <div class="icons">
                <span class="icon">&#128276;</span> <span class="user-avatar"></span> </div>
        </div>

        <div class="plagiarism-container">
            <div class="plagiarism-table-section">
                <h2>Plagiarism Reports</h2>
                <table class="plagiarism-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Student ID</th>
                            <th>Title</th>
                            <th>Similarity</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Mohd Azlan Shah Bin Ismail</td>
                            <td>2023439172</td>
                            <td>Smart Bug Detector: A Static Code Analyzer for Java and Python</td>
                            <td>8 %</td>
                            <td><span class="plagiarism-status-badge verified">Verified</span></td>
                        </tr>
                        <tr>
                            <td>Nur Aisyah Binti Khalid</td>
                            <td>2023439018</td>
                            <td>AI-Based Attendance Monitoring System Using Face Recognition</td>
                            <td>12 %</td>
                            <td><span class="plagiarism-status-badge pending">Pending</span></td>
                        </tr>
                        <tr>
                            <td>Ahmad Faris Bin Zulkifli</td>
                            <td>2023439005</td>
                            <td>IoT-Based Smart Irrigation System for Agriculture</td>
                            <td>7 %</td>
                            <td><span class="plagiarism-status-badge verified">Verified</span></td>
                        </tr>
                        <tr>
                            <td>Siti Nur Alia Binti Rahman</td>
                            <td>2023439123</td>
                            <td>Mobile Application for Mental Health Support Among University Students</td>
                            <td>10 %</td>
                            <td><span class="plagiarism-status-badge verified">Verified</span></td>
                        </tr>
                        <tr>
                            <td>Muhammad Hafiz Bin Roslan</td>
                            <td>2023439344</td>
                            <td>Blockchain-Based Certificate Verification System</td>
                            <td>18 %</td>
                            <td><span class="plagiarism-status-badge flagged">Flagged</span></td>
                        </tr>
                        <tr>
                            <td>Aina Sofea Binti Ariffin</td>
                            <td>2023439287</td>
                            <td>E-Wallet Android App for Campus Vendors</td>
                            <td>9 %</td>
                            <td><span class="plagiarism-status-badge verified">Verified</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="plagiarism-details-sidebar">
                <h3>Muhammad Azlan Shah bin Ismail</h3>
                <p>Similarity: 8%</p>

                <div class="similarity-breakdown-box">
                    <img src="https://placehold.co/80x80/f0f2f5/777?text=📄" alt="Document Icon">
                    Full similarity breakdown text here.
                </div>

                <div class="comment-section">
                    <label for="comment">Add comment</label>
                    <textarea id="comment" placeholder="Type your comment here..."></textarea>
                </div>

                <div class="action-buttons">
                    <button class="accept-btn">Accept</button>
                    <button class="reject-btn">Reject</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
