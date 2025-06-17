

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Supervisor Dashboard</title>
    <style>
        /* General styles (Copied from previous templates) */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif; /* Changed font */
            margin: 0;
            padding: 0;
            background-color: #f4f4f4; /* Light grey background from AdminDashboard */
            display: flex;
            min-height: 100vh;
            overflow: hidden; /* Added to prevent scrolling by default, can be adjusted for specific content areas */
        }

        /* Sidebar (Copied from previous templates) */
        .sidebar {
            background-color: #7c6593; /* AdminDashboard purple */
            width: 220px; /* AdminDashboard width */
            padding: 20px 10px; /* AdminDashboard padding */
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
            background-color: #5e4b75; /* Darker purple from AdminDashboard */
        }
        .sidebar nav ul li a i {
            margin-right: 10px;
        }

        /* Dropdown specific styles (Copied/Adapted from AdminDashboard.jsp) */
        .dropdown {
            width: 100%;
        }

        .parent-link {
            cursor: pointer;
            display: flex;
            justify-content: space-between; /* Space out text and dropdown arrow */
            align-items: center;
            padding: 10px;
            width: 100%;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            margin: 5px 0; /* Match nav-link margin */
            transition: background-color 0.3s ease;
        }
        .parent-link:hover {
            background-color: #5e4b75;
        }


        .arrow {
            margin-left: auto;
            font-size: 12px;
            transition: transform 0.3s ease; /* For arrow rotation */
        }

        .submenu {
            display: none; /* hides it by default, toggled by JS */
            flex-direction: column;
            padding-left: 15px; /* Indent submenu */
            margin-top: 5px;
            background-color: #6e549f; /* Slightly lighter purple for submenu background */
            border-radius: 8px; /* Consistent border-radius */
            overflow: hidden; /* Ensures smooth transition if content overflows */
        }

        .submenu .nav-link {
            font-size: 14px; /* Smaller font for sub-items */
            background-color: transparent; /* Submenu links don't need their own background as parent submenu has it */
            padding-left: 30px; /* Further indent sub-items */
            margin: 0; /* Reset margin */
            border-radius: 0; /* Remove border-radius for individual sub-links unless specific corners are needed */
        }

        .submenu .nav-link:hover, .submenu .nav-link.active {
            background-color: #5e4b75; /* Hover/active for submenu items */
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

        /* Content within main-content */
        .dashboard-body {
            padding: 20px;
            flex-grow: 1;
            overflow-y: auto; /* Allow scrolling for dashboard content if it overflows */
        }

        .welcome-info {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            color: #333;
        }
        .welcome-info h2 {
            margin: 0 0 5px 0;
            color: #444;
        }
        .welcome-info p {
            margin: 0;
            color: #777;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr; /* Approximately 2:1:1 ratio for the top row */
            grid-template-rows: auto auto auto; /* Three rows for panels */
            gap: 20px;
            margin-bottom: 20px;
        }

        .panel {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .panel h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #444;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Specific panel placement */
        .announcements-panel {
            grid-column: 1 / 2; /* Occupies the first column */
            grid-row: 1 / span 2; /* Spans two rows */
        }

        .my-students-panel {
            grid-column: 2 / 3; /* Occupies the second column */
            grid-row: 1 / 2; /* First row */
        }

        .pending-reviews-panel {
            grid-column: 3 / 4; /* Occupies the third column */
            grid-row: 1 / 2; /* First row */
        }

        .plagiarism-alerts-panel {
            grid-column: 2 / 3; /* Occupies the second column */
            grid-row: 2 / 3; /* Second row */
        }

        .next-deadline-panel {
            grid-column: 3 / 4; /* Occupies the third column */
            grid-row: 2 / 3; /* Second row */
        }

        .upcoming-schedule-panel {
            grid-column: 1 / -1; /* Spans all columns at the bottom */
            grid-row: 3 / 4; /* Third row */
        }

        /* Specific panel styles (adjusting background colors) */
        .announcements-panel table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9em;
        }
        .announcements-panel table th,
        .announcements-panel table td {
            padding: 8px 0;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .announcements-panel table th {
            color: #777;
            font-weight: normal;
        }
        .announcements-panel table tr:last-child td {
            border-bottom: none;
        }

        .my-students-panel {
            background-color: #ffe6e6; /* Light red */
            color: #a00;
        }
        .pending-reviews-panel {
            background-color: #e6e6ff; /* Light blue/purple */
            color: #6a0dad; /* Purple */
        }
        .plagiarism-alerts-panel {
            background-color: #e6ffe6; /* Light green */
            color: #0a0;
        }
        .next-deadline-panel {
            background-color: #ffffe6; /* Light yellow */
            color: #a80;
        }

        .summary-box p {
            font-size: 2em;
            margin: 0;
            font-weight: bold;
        }
        .summary-box span {
            font-size: 0.9em;
            color: #666;
        }
        /* Style for different summary boxes */
        .my-students-panel p { color: #a00; }
        .pending-reviews-panel p { color: #6a0dad; }
        .plagiarism-alerts-panel p { color: #0a0; }
        .next-deadline-panel p { color: #a80; }


        .upcoming-schedule-panel table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
        }
        .upcoming-schedule-panel table th,
        .upcoming-schedule-panel table td {
            padding: 10px 0;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .upcoming-schedule-panel table th {
            color: #777;
            font-weight: normal;
        }
        .upcoming-schedule-panel table tr:last-child td {
            border-bottom: none;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Get the specific dropdown elements for "Review"
            const reviewParentLink = document.querySelector(".review-dropdown .parent-link");
            const reviewSubmenu = document.querySelector(".review-dropdown .submenu");
            const reviewArrow = document.querySelector(".review-dropdown .arrow");

            if (reviewParentLink && reviewSubmenu && reviewArrow) {
                reviewParentLink.addEventListener("click", function (event) {
                    // Prevent default link behavior if parent-link was an <a> tag
                    event.preventDefault();
                    
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
                <li class="active"><a href="#">🏠 Dashboard</a></li>
                <li><a href="SupervisorStudent.jsp">👨‍🎓 Students</a></li>

                <div class="dropdown review-dropdown">
                    <div class="nav-link parent-link">
                        <span>📄 Review</span>
                        <span class="arrow">&#9662;</span> </div>
                    <div class="submenu">
                        <a href="SupervisorReview.jsp" class="nav-link">Form</a>
                        <a href="#" class="nav-link">Plagiarism</a>
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

        <div class="dashboard-body">
            <div class="welcome-info">
                <h2>Welcome, Dr. Nurul Huda</h2>
                <p>Supervisor + Examiner</p>
            </div>

            <div class="dashboard-grid">
                <div class="panel announcements-panel">
                    <h3>Announcements Panel <span class="icon">&#128276;</span></h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Announcement Message</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>17 May</td>
                                <td>FYP Briefing Slides have been uploaded</td>
                            </tr>
                            <tr>
                                <td>18 May</td>
                                <td>Reminder: FYP (a) submission closes in 2 days</td>
                            </tr>
                            <tr>
                                <td>21 May</td>
                                <td>New plagiarism policy: reports over 30% must be flagged</td>
                            </tr>
                            <tr>
                                <td>23 May</td>
                                <td>Final Year exhibition schedule released</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="panel my-students-panel summary-box">
                    <h3>My Students</h3>
                    <p>4</p>
                    <span>assigned</span>
                </div>

                <div class="panel pending-reviews-panel summary-box">
                    <h3>Pending Reviews</h3>
                    <p>3</p>
                    <span>forms</span>
                </div>

                <div class="panel plagiarism-alerts-panel summary-box">
                    <h3>Plagiarism Alerts</h3>
                    <p>1</p>
                    <span>flagged report</span>
                </div>

                <div class="panel next-deadline-panel summary-box">
                    <h3>Next Deadline</h3>
                    <p>Proposal Review</p>
                    <span>by 20 May</span>
                </div>

                <div class="panel upcoming-schedule-panel">
                    <h3>Upcoming Schedule <span class="icon">&#9200;</span></h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Event</th>
                                <th>Type</th>
                                <th>Student</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>20 May</td>
                                <td>FYP(a) Submission Due</td>
                                <td>Submission</td>
                                <td><a href="#">Nur Aisyah Binti Khalid</a></td>
                            </tr>
                            <tr>
                                <td>21 May</td>
                                <td>Progress Review Checkpoint</td>
                                <td>Evaluation</td>
                                <td>Nurul Huda Binti Firdaus</td>
                            </tr>
                            <tr>
                                <td>22 May</td>
                                <td>Proposal Review</td>
                                <td>Evaluation</td>
                                <td>Siti Nur Aila Binti Rahmah</td>
                            </tr>
                            <tr>
                                <td>25 May</td>
                                <td>Plagiarism Verification</td>
                                <td>Plagiarism</td>
                                <td>Ahmad Faris Bin Zulkifli</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>