<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    // ===== DESIGN MODE =====
    boolean designMode = true; // Tukar kepada false bila masuk sistem sebenar

    String userId = designMode ? "123" : String.valueOf(session.getAttribute("userId"));
    String userRole = designMode ? "student" : (String) session.getAttribute("role");
    String userName = designMode ? "Test User" : (String) session.getAttribute("userName");
    String userAvatar = designMode ? "avatar1.png" : (String) session.getAttribute("avatar");

    if (!designMode && (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole))) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    if (userName == null || "null".equals(userName)) {
        userName = "User";
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
<html>
<head>
    <title>Past Reports | UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <link rel="stylesheet" href="sidebarStyle.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            /* Primary Colors */
            --primary: #4b2e83;       /* Dark Purple (UiTM Brand) */
            --secondary: #6d4ac0;     /* Medium Purple */
            --accent: #b399d4;        /* Light Purple */
            
            /* Neutral Colors */
            --light: #f9f7fd;         /* Very Light Purple (Background) */
            --dark: #1a0d3f;          /* Very Dark Purple (Text) */
            --white: #ffffff;         /* Pure White */
            --gray-light: #f5f5f5;    /* Light Gray */
            --gray-medium: #e0e0e0;   /* Medium Gray */
            --gray-dark: #757575;     /* Dark Gray */
            
            /* Status Colors */
            --success: #4CAF50;       /* Green */
            --warning: #FFC107;       /* Amber */
            --danger: #F44336;        /* Red */
            --info: #2196F3;         /* Blue */
            
            /* Component Colors */
            --sidebar-width: 250px;
            --sidebar-collapsed: 70px;
            --topbar-height: 70px;
            --transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .main-content {
            padding: 20px;
            background-color: var(--light);
        }

        .reports-container {
            background: var(--white);
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px;
            margin-bottom: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--gray-light);
        }

        .page-header h2 {
            color: var(--primary);
            font-size: 1.8rem;
            margin: 0;
        }

        .search-filter {
            display: flex;
            gap: 15px;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 8px 15px 8px 35px;
            border: 1px solid var(--gray-medium);
            border-radius: 5px;
            width: 250px;
            transition: var(--transition);
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(109, 74, 192, 0.2);
        }

        .search-box i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-dark);
        }

        .filter-dropdown select {
            padding: 8px 15px;
            border: 1px solid var(--gray-medium);
            border-radius: 5px;
            background-color: var(--white);
            cursor: pointer;
            transition: var(--transition);
        }

        .filter-dropdown select:focus {
            outline: none;
            border-color: var(--secondary);
        }

        .reports-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .reports-table th {
            background-color: var(--primary);
            color: var(--white);
            padding: 12px 15px;
            text-align: left;
            font-weight: 500;
            position: sticky;
            top: 0;
        }

        .reports-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--gray-light);
            color: var(--dark);
        }

        .reports-table tr:not(:first-child):hover {
            background-color: rgba(107, 74, 192, 0.05);
        }

        .action-cell {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--secondary);
            font-size: 1.1rem;
            transition: var(--transition);
            padding: 5px;
            border-radius: 4px;
        }

        .action-btn:hover {
            color: var(--primary);
            background-color: rgba(107, 74, 192, 0.1);
        }

        .view-btn:hover {
            color: var(--info);
        }

        .download-btn:hover {
            color: var(--success);
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 25px;
            gap: 5px;
        }

        .pagination button {
            padding: 8px 12px;
            border: 1px solid var(--gray-medium);
            background-color: var(--white);
            color: var(--dark);
            border-radius: 4px;
            cursor: pointer;
            transition: var(--transition);
        }

        .pagination button:hover {
            background-color: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .pagination button.active {
            background-color: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: var(--white);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            border-left: 4px solid var(--primary);
        }

        .stat-card h3 {
            margin: 0 0 10px 0;
            color: var(--gray-dark);
            font-size: 1rem;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
            margin: 5px 0;
        }

        .stat-card .change {
            font-size: 0.9rem;
            color: var(--success);
            display: flex;
            align-items: center;
        }

        .stat-card .change.down {
            color: var(--danger);
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .search-filter {
                width: 100%;
                flex-direction: column;
                gap: 10px;
            }
            
            .search-box input {
                width: 100%;
            }
            
            .stats-cards {
                grid-template-columns: 1fr;
            }
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

    <!-- Main Content -->
    <main class="main-content">
        <div class="reports-container">
            <div class="page-header">
                <h2><i class="fas fa-file-alt"></i> Past Reports</h2>
                <div class="search-filter">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search reports...">
                    </div>
                    <div class="filter-dropdown">
                        <select>
                            <option>All Semesters</option>
                            <option>March 2024</option>
                            <option>April 2023</option>
                            <option>October 2023</option>
                        </select>
                    </div>
                </div>
            </div>

            <table class="reports-table">
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Student ID</th>
                        <th>Semester</th>
                        <th>Project Title</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Aisyah Mohd Nor</td>
                        <td>2021B123</td>
                        <td>March 2024</td>
                        <td>Smart Waste Bin System Using IoT</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>Faizal Ridzuan</td>
                        <td>2021B234</td>
                        <td>March 2024</td>
                        <td>Task Manager App with Cloud Storage</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>Nurin Liyana</td>
                        <td>2021B001</td>
                        <td>March 2024</td>
                        <td>File Sharing App with Blockchain</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>Haris Daniel</td>
                        <td>2021T988</td>
                        <td>April 2023</td>
                        <td>Food Expiry Detection App Using AI</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>Siti Amalina Yusof</td>
                        <td>2021B321</td>
                        <td>April 2023</td>
                        <td>Quran Learning App for Kids</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>Adam Hakim</td>
                        <td>2021B456</td>
                        <td>April 2023</td>
                        <td>Face Recognition Attendance System</td>
                        <td class="action-cell">
                            <button class="action-btn view-btn" title="View Report"><i class="fas fa-eye"></i></button>
                            <button class="action-btn download-btn" title="Download"><i class="fas fa-download"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button><i class="fas fa-angle-double-left"></i></button>
                <button>1</button>
                <button class="active">2</button>
                <button>3</button>
                <button><i class="fas fa-angle-double-right"></i></button>
            </div>
        </div>
    </main>

    <!-- Sidebar Script -->
    <jsp:include page="sidebarScript.jsp" />

    <script>
        // Search functionality
        document.querySelector('.search-box input').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.reports-table tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Filter functionality
        document.querySelector('.filter-dropdown select').addEventListener('change', function(e) {
            const semester = e.target.value;
            const rows = document.querySelectorAll('.reports-table tbody tr');
            
            if (semester === 'All Semesters') {
                rows.forEach(row => row.style.display = '');
                return;
            }
            
            rows.forEach(row => {
                const rowSemester = row.cells[2].textContent;
                if (rowSemester === semester) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // View button functionality
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                Swal.fire({
                    title: 'Report Preview',
                    html: '<p>This would show a preview of the selected report.</p>',
                    icon: 'info',
                    confirmButtonColor: '#4b2e83'
                });
            });
        });

        // Download button functionality
        document.querySelectorAll('.download-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                Swal.fire({
                    title: 'Download Report',
                    text: 'The report will be downloaded shortly.',
                    icon: 'success',
                    confirmButtonColor: '#4b2e83',
                    timer: 1500
                });
            });
        });
    </script>
</body>
</html>