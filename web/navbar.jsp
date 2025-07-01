<%@ page import="java.util.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
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
    roleNames.put("examiner", "Examiner");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");
    roleNames.put("examiner", "Examiner");

    String displayRole = roleNames.getOrDefault(userRole, "User");
    
    // Split name for display
    String[] nameParts = userName != null ? userName.split("\\s+") : new String[0];
    String firstLine = nameParts.length > 0 ? nameParts[0] : "";
    String secondLine = nameParts.length > 1 ? String.join(" ", Arrays.copyOfRange(nameParts, 1, nameParts.length)) : "";
    
    // Get current URI for active menu highlighting
    String currentURI = request.getRequestURI();
%>

<div class="sidebar-header">
    <div class="user-profile">
        <div class="profile-img">
            <img src="DownloadAvatar?filename=<%= userAvatar %>&background=b399d4&color=4b2e83" alt="Profile">
        </div>
        <div class="user-info">
            <div class="user-name">
                <div><%= firstLine %></div>
                <div><%= secondLine %></div>
            </div>
            <div class="user-role"><%= displayRole %></div>
        </div>
    </div>
</div>

<div class="sidebar-menu">
    <!-- Dashboard - Common to all roles -->
    <a href="Dashboard.jsp" class="menu-item <%= currentURI.endsWith("/Dashboard.jsp") ? "active" : "" %>">
        <div class="menu-icon"><i class="fas fa-home"></i></div>
        <div class="menu-text">Dashboard</div>
    </a>

    <% if ("supervisor".equals(userRole)) { %>
        <!-- Supervisor Menu -->
        <a href="ProfileServlet" class="menu-item <%= currentURI.endsWith("/Profile.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user"></i></div>
            <div class="menu-text">Profile</div>
        </a>
            
        <a href="ProposalServlet" class="menu-item <%= currentURI.endsWith("/ProposalIdea.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-lightbulb"></i></div>
            <div class="menu-text">Proposal Idea</div>
        </a>

        <a href="CSP600.jsp" class="menu-item <%= currentURI.endsWith("/ProposalIdea.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
            <div class="menu-text">Students</div>
        </a>

        <a href="Form.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/Form.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
            <div class="menu-text">Forms</div>
        </a>

        <a href="PastReport.jsp" class="menu-item">
            <div class="menu-icon"><i class="fas fa-folder-open"></i></div>
            <div class="menu-text">Past Projects</div>
        </a>
            
    <% } else if ("student".equals(userRole)) { %>
        <!-- Student Menu -->
        <a href="ProfileServlet" class="menu-item <%= currentURI.endsWith("/Profile.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user"></i></div>
            <div class="menu-text">Profile</div>
        </a>

        <a href="ProposalServlet" class="menu-item <%= currentURI.endsWith("/ProposalIdea.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-lightbulb"></i></div>
            <div class="menu-text">Proposal Idea</div>
        </a>

        <a href="Form.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/Form.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
            <div class="menu-text">Forms</div>
        </a>

        <a href="ProgressReport.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/ProgressReport.jsp") ? "active" : "" %>"">
            <div class="menu-icon"><i class="fas fa-tasks"></i></div>
            <div class="menu-text">Progress Report</div>
        </a>

        <a href="FinalReportSubmission.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("FinalReportSubmission.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-file-pdf"></i></div>
            <div class="menu-text">Final Reports</div>
        </a>

        <a href="Guideline.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/Guideline.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-book"></i></div>
            <div class="menu-text">Guideline</div>
        </a>

        <a href="ConsultationLog.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/ConsultationLog.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-comments"></i></div>
            <div class="menu-text">Consultation Log</div>
        </a>

        <a href="PastReport.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/PastReport.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-archive"></i></div>
            <div class="menu-text">Past Reports</div>
        </a>
    <% } else if ("lecturer".equals(userRole)) { %>
        <!-- Lecturer Menu -->
        <a href="ProfileServlet" class="menu-item <%= currentURI.endsWith("/Profile.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user"></i></div>
            <div class="menu-text">Profile</div>
        </a>

        <div class="menu-dropdown">
            <div class="menu-item parent-item">
                <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
                <div class="menu-text">Students</div>
                <div class="menu-arrow">&#9662;</div>
            </div>
            <div class="submenu">
                <a href="StudentList?course=1" class="submenu-item">CSP600</a>
                <a href="StudentList?course=2" class="submenu-item">CSP650</a>
            </div>
        </div>

        <div class="menu-dropdown">
            <div class="menu-item parent-item">
                <div class="menu-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                <div class="menu-text">Supervisors</div>
                <div class="menu-arrow">&#9662;</div>
            </div>
            <div class="submenu">
                <a href="SupervisorList.jsp" class="submenu-item">Supervisors</a>
                <a href="ExaminerList.jsp" class="submenu-item">Examiners</a>
            </div>
        </div>

        <a href="Form.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/Form.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
            <div class="menu-text">Forms</div>
        </a>
    <% } %>
    
    <!-- Admin-->
    
    <% if ("admin".equals(userRole)) { %>
<!-- Students Dropdown -->
<div class="menu-dropdown">
    <div class="menu-item parent-item">
        <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
        <div class="menu-text">Students</div>
        <div class="menu-arrow">&#9662;</div>
    </div>
    <div class="submenu">
        <a href="CSP600.jsp" class="submenu-item">CSP600</a>
        <a href="CSP650.jsp" class="submenu-item">CSP650</a>
    </div>
</div>

<!-- Supervisors Dropdown -->
<div class="menu-dropdown">
    <div class="menu-item parent-item">
        <div class="menu-icon"><i class="fas fa-chalkboard-teacher"></i></div>
        <div class="menu-text">Supervisors</div>
        <div class="menu-arrow">&#9662;</div>
    </div>
    <div class="submenu">
        <a href="SupervisorList.jsp" class="submenu-item">Supervisors</a>
        <a href="ExaminerList.jsp" class="submenu-item">Examiners</a>
    </div>
</div>

<!-- Presentation -->
<a href="Presentation.jsp" class="menu-item <%= currentURI.endsWith("/Presentation.jsp") ? "active" : "" %>">
    <div class="menu-icon"><i class="fas fa-calendar-alt"></i></div>
    <div class="menu-text">Presentation</div>
</a>

<!-- Submissions Dropdown -->
<div class="menu-dropdown">
    <div class="menu-item parent-item">
        <div class="menu-icon"><i class="fas fa-file-upload"></i></div>  <%-- icon baru lebih sesuai --%>
        <div class="menu-text">Submissions</div>
        <div class="menu-arrow">&#9662;</div>
    </div>
    <div class="submenu">
        <a href="ProposalReport.jsp" class="submenu-item">Proposal Report</a>
        <a href="FinalReport.jsp" class="submenu-item">Final Report</a>
    </div>
</div>

<!-- Past Report (menu sendiri, bukan dropdown) -->
<a href="PastReport.jsp" class="menu-item <%= currentURI.endsWith("/PastReport.jsp") ? "active" : "" %>">
    <div class="menu-icon"><i class="fas fa-archive"></i></div>
    <div class="menu-text">Past Reports</div>
</a>

<% } %>
    <%   if ("examiner".equals(userRole)) { %>
        <!-- Examiner Menu -->
        <a href="ProfileServlet" class="menu-item <%= currentURI.endsWith("/Profile.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user"></i></div>
            <div class="menu-text">Profile</div>
        </a>

        <a href="CSP600.jsp" class="menu-item <%= currentURI.endsWith("/ProposalIdea.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
            <div class="menu-text">Students</div>
        </a>

        <a href="Form.jsp" class="menu-item <%= currentURI.toLowerCase().endsWith("/Form.jsp") ? "active" : "" %>">
            <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
            <div class="menu-text">Forms</div>
        </a>

        <a href="PastReport.jsp" class="menu-item">
            <div class="menu-icon"><i class="fas fa-folder-open"></i></div>
            <div class="menu-text">Past Projects</div>
        </a>
    <% } %>


    <div class="divider"></div>

    <!-- Common Settings & Logout -->

    <div class="divider"></div>

    <a href="Login.jsp" class="menu-item" id="logoutBtn">
        <div class="menu-icon"><i class="fas fa-sign-out-alt"></i></div>
        <div class="menu-text">Logout</div>
    </a>
</div>
