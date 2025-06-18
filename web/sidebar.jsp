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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UiTM FYP System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css"> 
</head>
<body>
    <!-- Mobile Toggle Button -->
    <div class="mobile-toggle" onclick="showSidebar()">
        <i class="fas fa-bars"></i>
    </div>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="close-sidebar" onclick="hideSidebar()">
            <i class="fas fa-times"></i>
        </div>
        
        <div class="logo">
            <img src="images/UiTM-Logo.png" alt="UiTM Logo">
            <p>UNIVERSITI TEKNOLOGI MARA</p>
           <div class="role-badge"><%= displayRole %> Dashboard</div>
        </div>
        
        <nav>
            <ul>
                <!-- Dashboard - Common to all roles -->
                <li>
                    <a href="Dashboard.jsp" class="nav-link <%= request.getRequestURI().endsWith("Dashboard.jsp") ? "active" : "" %>">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                
                <!-- Supervisor Menu -->
                <% if ("supervisor".equals(userRole)) { %>
                    <li>
                        <a href="ProfileServlet" class="nav-link">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="SupervisorStudent.jsp" class="nav-link">
                            <i class="fas fa-user-graduate"></i>
                            <span>Students</span>
                        </a>
                    </li>
                    
                    <!-- ADDED FORM LINK -->
                    <li>
                        <a href="Form.jsp" class="nav-link <%= request.getRequestURI().toLowerCase().endsWith("form.jsp") ? "active" : "" %>">
                            <i class="fas fa-file-alt"></i>
                            <span>Forms</span>
                        </a>
                    </li>
                    
                    <li class="dropdown">
                        <div class="nav-link parent-link" onclick="toggleDropdown(this)">
                            <div>
                                <i class="fas fa-file-alt"></i>
                                <span>Review</span>
                            </div>
                            <span class="arrow">&#9662;</span>
                        </div>
                        <div class="submenu">
                            <a href="SupervisorReview.jsp" class="nav-link">Form</a>
                            <a href="#" class="nav-link">Plagiarism</a>
                        </div>
                    </li>
                    
                    <li>
                        <a href="#" class="nav-link">
                            <i class="fas fa-folder-open"></i>
                            <span>Past Project</span>
                        </a>
                    </li>
                <% } %>
                
                <!-- Student Menu -->
                <% if ("student".equals(userRole)) { %>
                    <li>
                        <a href="ProfileServlet" class="nav-link">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>

                    <li>
                        <a href="ProposalIdea.jsp" class="nav-link">
                            <i class="fas fa-lightbulb"></i>
                            <span>Proposal Idea</span>
                        </a>
                    </li>
                    
                    <!-- ADDED FORM LINK -->
                    <li>
                        <a href="Form.jsp" class="nav-link <%= request.getRequestURI().toLowerCase().endsWith("form.jsp") ? "active" : "" %>">
                            <i class="fas fa-file-alt"></i>
                            <span>Forms</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="ProgressReportSubmission.jsp" class="nav-link">
                            <i class="fas fa-tasks"></i>
                            <span>Progress Report</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="SubmitFinalReports.jsp" class="nav-link">
                            <i class="fas fa-file-pdf"></i>
                            <span>Final Reports</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="Evaluation.jsp" class="nav-link">
                            <i class="fas fa-check-circle"></i>
                            <span>Evaluation</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="Guideline.jsp" class="nav-link">
                            <i class="fas fa-book"></i>
                            <span>Guideline</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="StudentConsultationLog.jsp" class="nav-link">
                            <i class="fas fa-comments"></i>
                            <span>Consultation Log</span>
                        </a>
                    </li>
                    
                    <!-- ADDED PAST REPORTS LINK -->
                    <li>
                        <a href="PastReports.jsp" class="nav-link">
                            <i class="fas fa-archive"></i>
                            <span>Past Reports</span>
                        </a>
                    </li>
                <% } %>
                
                <!-- Lecturer Menu -->
                <% if ("lecturer".equals(userRole)) { %>
                    <li>
                        <a href="ProfileServlet" class="nav-link">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>

                    <li class="dropdown">
                        <div class="nav-link parent-link" onclick="toggleDropdown(this)">
                            <div>
                                <i class="fas fa-user-graduate"></i>
                                <span>Students</span>
                            </div>
                            <span class="arrow">&#9662;</span>
                        </div>
                        <div class="submenu">
                            <a href="StudentList?course=1" class="nav-link">CSP600</a>
                            <a href="StudentList?course=2" class="nav-link">CSP650</a>
                        </div>
                    </li>
                    
                    <li class="dropdown">
                        <div class="nav-link parent-link" onclick="toggleDropdown(this)">
                            <div>
                                <i class="fas fa-chalkboard-teacher"></i>
                                <span>Supervisors</span>
                            </div>
                            <span class="arrow">&#9662;</span>
                        </div>
                        <div class="submenu">
                            <a href="SupervisorList.jsp" class="nav-link">Supervisors</a>
                            <a href="LecturerExaminers.jsp" class="nav-link">Examiners</a>
                        </div>
                    </li>
                    
                    <!-- ADDED FORM LINK -->
                    <li>
                        <a href="Form.jsp" class="nav-link <%= request.getRequestURI().toLowerCase().endsWith("form.jsp") ? "active" : "" %>">
                            <i class="fas fa-file-alt"></i>
                            <span>Forms</span>
                        </a>
                    </li>
                    
                    <li>
                        <a href="LecturerReports.jsp" class="nav-link">
                            <i class="fas fa-chart-bar"></i>
                            <span>Report</span>
                        </a>
                    </li>
                <% } %>
                
                <!-- Common Settings -->
                
                <!-- Logout - Common to all -->
                <li>
                    <a href="Login.jsp" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
            
    <div class="main-content">
        <div class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search">
            </div>
            <div class="icons">
                <span class="icon">&#128276;</span>
                <span class="user-avatar">
                    <img src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>" 
                        alt="Avatar" style="width:35px; height:35px; border-radius:50%; object-fit:cover;" />
                </span>
            </div>
        </div>
                        
    <script>
        // Sidebar toggle functions
        function showSidebar() {
            const sidebar = document.querySelector('.sidebar');
            sidebar.classList.add('active');
        }
        
        function hideSidebar() {
            const sidebar = document.querySelector('.sidebar');
            sidebar.classList.remove('active');
        }
        
        // Dropdown toggle functionality
        function toggleDropdown(element) {
            element.parentElement.classList.toggle('active');
        }
        
        // Close sidebar when clicking outside
        document.addEventListener('click', function(event) {
            const sidebar = document.querySelector('.sidebar');
            const mobileToggle = document.querySelector('.mobile-toggle');
            
            if (window.innerWidth <= 992 && sidebar.classList.contains('active') && 
                !sidebar.contains(event.target) && 
                event.target !== mobileToggle && 
                !mobileToggle.contains(event.target)) {
                hideSidebar();
            }
        });
    </script>
</body>
</html>