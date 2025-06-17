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
        <title>UiTM FYP System</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <!--SIDEBAR-->
        <jsp:include page="sidebar.jsp" />
        
        <!-- Admin Part -->
        <% if ("admin".equals(userRole)) { %>
            <!-- content -->
        <% } %>
        
        <!-- Student Part -->
        <% if ("student".equals(userRole)) { %>
            <!-- content -->
        <% } %>
        
        <!-- Lecturer Part -->
        <% if ("lecturer".equals(userRole)) { %>
            <!-- content -->
        <% } %>
        
        <!-- Supervisor Part -->
        <% if ("supervisor".equals(userRole)) { %>
            <!-- content -->
        <% } %>
            
    </body>
</html>
