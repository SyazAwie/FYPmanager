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
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Final Report</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f4f4f4;
    }

    .proposal-card {
      background-color: #87CEEB; /* Sky blue */
      border-radius: 25px;
      padding: 35px;
      max-width: 650px;
      margin: auto;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }

    .proposal-title {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 15px;
      color: #fff;
    }

    .profile-info {
      display: flex;
      align-items: center;
      font-size: 18px;
      color: #fff;
    }

    .profile-info i {
      font-size: 22px;
      margin-right: 10px;
    }

    .btn-group {
      margin-top: 30px;
      display: flex;
      justify-content: flex-end;
      gap: 10px;
    }

    .btn {
      padding: 10px 20px;
      font-size: 14px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      font-weight: bold;
      color: white;
      text-decoration: none;
      transition: background-color 0.3s ease;
    }

    .btn-view {
      background-color: #28a745; /* Green */
    }

    .btn-view:hover {
      background-color: #218838;
    }

    .btn-submit {
      background-color: #007bff; /* Blue */
    }

    .btn-submit:hover {
      background-color: #0069d9;
    }
  </style>
</head>
<body>

  <jsp:include page="sidebar.jsp" />

  <div class="proposal-card">
  <div class="proposal-title">My Final Report</div>
  
  <% if ("student".equals(userRole)) { %>
  <div class="profile-info">
    <img src="images/<%= userAvatar %>" alt="Avatar" class="avatar-img">
    <div class="profile-text">
      <div class="student-name"><i class="fas fa-user"></i> <strong><%= userName %></strong></div>
      <div class="student-role"><%= displayRole %></div>
    </div>
  </div>
  <% } %>

  <div class="btn-group">
    <a href="uploads/proposal.pdf" target="_blank" class="btn btn-view">View</a>
    <a href="submitProjectReport.jsp" class="btn btn-submit">Submit</a>
  </div>
</div>
</body>
</html>
