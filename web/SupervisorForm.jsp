

<%-- 
    Document   : SupervisorForm
    Created on : May 28, 2025, 10:30:08 AM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Supervisor - Forms Review</title>
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
            /* Consider removing overflow: hidden if content can exceed screen height and you want scroll */
            /* For now, keeping it based on previous request, but often adjusted per page */
            overflow: hidden;
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
            position: relative; /* Needed for dropdown positioning */
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

        /* Dropdown specific styles */
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
        /* Active state for the parent link when its submenu is open/active */
        .dropdown.active .parent-link {
            background-color: #5e4b75;
        }

        .arrow {
            margin-left: auto;
            font-size: 12px;
            transition: transform 0.3s ease; /* For arrow rotation */
        }
        .dropdown.active .arrow {
            transform: rotate(180deg); /* Rotate arrow up when active */
        }


        /* Submenu - Corrected styling based on the image */
        .submenu {
            display: none; /* hides it by default, toggled by JS */
            flex-direction: column;
            padding: 10px 0; /* Padding around the submenu links */
            margin-top: 5px;
            background-color: #6e549f; /* Darker purple block background as per image */
            border-radius: 8px; /* Consistent border-radius for the entire submenu block */
            overflow: hidden;
            width: calc(100% - 15px); /* Adjust width if needed, or match parent width */
            margin-left: auto; /* Center if width is adjusted */
            margin-right: auto;
            text-align: center; /* Center the text within the submenu block */
        }

        .submenu a { /* Targeting direct anchor tags within submenu */
            color: #c0f0ff; /* Light blue text as per image */
            text-decoration: none;
            padding: 5px 0; /* Padding for each link within the submenu block */
            display: block; /* Make links block-level for full clickable area and vertical stack */
            font-size: 0.9em; /* Adjust font size */
            transition: color 0.3s ease;
        }

        .submenu a:hover {
            color: white; /* White on hover for submenu links */
        }
        .submenu a.active { /* For the currently active sub-link */
            color: white;
            font-weight: bold; /* Make active sub-link bold */
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

        /* Review Page Specific Styles */
        .review-container {
            padding: 20px;
            flex-grow: 1;
            overflow-y: auto; /* Allow scrolling within this content area */
        }

        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            gap: 20px;
        }

        .review-header p {
            margin: 0;
            font-size: 1.1em;
            color: #333;
        }

        .switch-btn {
            background-color: #6a0dad; /* A shade of purple */
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.95em;
            transition: background-color 0.3s ease;
        }
        .switch-btn:hover {
            background-color: #5e4b75;
        }

        .forms-section {
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .forms-grid {
            display: grid;
            grid-template-columns: 1fr 2fr auto; /* Category | Forms | Edit Button */
            gap: 15px 20px;
            align-items: center;
        }

        .forms-grid strong {
            font-size: 1.1em;
            color: #444;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .forms-grid .grid-header {
             font-weight: bold;
        }

        .forms-grid .category-item {
            color: #555;
            padding-top: 5px;
            padding-bottom: 5px;
        }
        .forms-grid .form-description {
            color: #333;
            padding-top: 5px;
            padding-bottom: 5px;
        }
        .forms-grid .edit-btn-container {
            text-align: right;
            padding-top: 5px;
            padding-bottom: 5px;
        }

        .forms-grid .edit-btn {
            background-color: #4CAF50; /* Green color for edit */
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9em;
            transition: background-color 0.3s ease;
        }
        .forms-grid .edit-btn:hover {
            background-color: #45a049;
        }

    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Get the specific dropdown elements for "Review"
            const reviewDropdown = document.querySelector(".review-dropdown"); // The entire dropdown div
            const reviewParentLink = document.querySelector(".review-dropdown .parent-link");
            const reviewSubmenu = document.querySelector(".review-dropdown .submenu");
            const reviewArrow = document.querySelector(".review-dropdown .arrow");

            if (reviewParentLink && reviewSubmenu && reviewArrow) {
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

                <div class="dropdown review-dropdown active"> <div class="nav-link parent-link">
                        <span>📄 Review</span>
                        <span class="arrow">&#9652;</span> </div>
                    <div class="submenu" style="display: flex;"> <a href="SupervisorForm.jsp" class="active">Form</a>
                        <a href="#">Plagiarism</a>
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

        <div class="review-container">
            <div class="review-header">
                <p>You are currently reviewing as: <strong>Supervisor</strong></p>
                <button class="switch-btn">Switch to Examiner</button>
            </div>

            <div class="forms-section">
                <div class="forms-grid">
                    <div class="grid-header">Category</div>
                    <div class="grid-header">Forms</div>
                    <div class="grid-header"></div> <div class="category-item">Acceptance</div>
                    <div class="form-description">F1 - MUTUAL ACCEPTANCE FORM</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>

                    <div class="category-item">Progress</div>
                    <div class="form-description">F5 - PROPOSAL / PROJECT IN-PROGRESS FORM</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>

                    <div class="category-item">Presentation</div>
                    <div class="form-description">F7 - PROJECT FORMULATION PRESENTATION FORM</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>
                    <div></div> <div class="form-description">F10 - FINAL PROJECT PRESENTATION</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>

                    <div class="category-item">Evaluation</div>
                    <div class="form-description">F8 - FORMULATION REPORT EVALUATION</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>
                    <div></div>
                    <div class="form-description">F11 - REPORT EVALUATION</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>

                    <div class="category-item">Completion</div>
                    <div class="form-description">F12 - REPORT CORRECTION CONFIRMATION</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>

                    <div class="category-item">Submission</div>
                    <div class="form-description">F6(a) - PROJECT FORMULATION REPORT SUBMISSION FORM</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>
                    <div></div>
                    <div class="form-description">F6(b) - PROJECT REPORT SUBMISSION FORM</div>
                    <div class="edit-btn-container"><button class="edit-btn">Edit</button></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>