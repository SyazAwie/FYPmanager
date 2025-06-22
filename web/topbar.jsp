<%@ page import="java.util.*" %>
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
        userAvatar = "default.png";
    }
    
    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
    
    // Split name for display
    String[] nameParts = userName != null ? userName.split("\\s+") : new String[0];
    String firstLine = nameParts.length > 0 ? nameParts[0] : "User";
%>

<div class="topbar-container">
    <div class="toggle-btn" id="toggleSidebar">
        <i class="fas fa-bars"></i>
    </div>

    <div class="topbar-left">
        <div class="mobile-toggle" id="mobileToggle">
            <i class="fas fa-bars"></i>
        </div>
        
        <div class="search-container">
            <i class="fas fa-search search-icon"></i>
            <input type="text" placeholder="Search...">
        </div>
    </div>
    
    <div class="topbar-right">
        <div class="notification-btn" id="notificationBtn">
            <i class="fas fa-bell"></i>
            <span class="notification-count">3</span>
            
            <div class="notification-dropdown" id="notificationDropdown">
                <div class="notification-header">
                    <div class="notification-title">Notifications</div>
                    <div class="mark-read">Mark all as read</div>
                </div>
                <div class="notification-list">
                    <div class="notification-item unread">
                        <div class="notification-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="notification-content">
                            <div class="notification-text">Your project proposal has been approved</div>
                            <div class="notification-time">2 hours ago</div>
                        </div>
                    </div>
                    <div class="notification-item unread">
                        <div class="notification-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div class="notification-content">
                            <div class="notification-text">Deadline approaching: Progress Report due</div>
                            <div class="notification-time">5 hours ago</div>
                        </div>
                    </div>
                    <div class="notification-item">
                        <div class="notification-icon">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="notification-content">
                            <div class="notification-text">Dr. Johnson commented on your document</div>
                            <div class="notification-time">Yesterday</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <a href="ProfileServlet" class="topbar-profile">
            <div class="topbar-img">
                <img src="DownloadAvatar?filename=<%= userAvatar %>" 
                    alt="Profile" style="width:35px; height:35px; border-radius:50%; object-fit:cover;">
            </div>
            <div class="topbar-name"><%= firstLine %></div>
            <span class="profile-tooltip">View Profile</span>
        </a>
    </div>
</div>