<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if (userName == null || "null".equals(userName)) {
        userName = "User";
    }
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userAvatar == null || "null".equals(userAvatar) || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    String mode = request.getParameter("mode");
    boolean canEdit = ("student".equals(userRole) || "supervisor".equals(userRole)) && "edit".equals(mode);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>F1 - Mutual Acceptance Form</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<jsp:include page="sidebar.jsp" />

<div class="main-content" style="padding: 20px;">
    <h2>F1 – Mutual Acceptance Form</h2>

    <form action="SubmitF1Servlet" method="post">
        <!-- Student Section -->
        <fieldset>
            <legend>Student Information</legend>
            <label>Name:</label>
            <input type="text" name="studentName" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Student ID:</label>
            <input type="text" name="studentId" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Program:</label>
            <input type="text" name="program" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Email:</label>
            <input type="email" name="studentEmail" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Contact:</label>
            <input type="text" name="studentPhone" <%= canEdit ? "" : "readonly='readonly'" %> />
        </fieldset>

        <!-- Supervisor Section -->
        <fieldset>
            <legend>Supervisor Information</legend>
            <label>Name:</label>
            <input type="text" name="supervisorName" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Faculty:</label>
            <input type="text" name="supervisorFaculty" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Email:</label>
            <input type="email" name="supervisorEmail" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Contact:</label>
            <input type="text" name="supervisorPhone" <%= canEdit ? "" : "readonly='readonly'" %> />
        </fieldset>

        <!-- Project Info -->
        <fieldset>
            <legend>Project Information</legend>
            <label>Project Area:</label>
            <input type="text" name="projectArea" <%= canEdit ? "" : "readonly='readonly'" %> /><br><br>
            <label>Project Title:</label>
            <input type="text" name="projectTitle" <%= canEdit ? "" : "readonly='readonly'" %> />
        </fieldset>

        <!-- Agreement Signatures -->
        <fieldset>
            <legend>Agreement</legend>
            <p>I hereby understand the Terms and Conditions of supervision.</p>
            <label>Student Signature:</label> ______________________ Date: __________<br><br>
            <label>Supervisor Signature:</label> ___________________ Date: __________
        </fieldset>

        <% if (canEdit) { %>
            <br><input type="submit" value="Submit Form" />
        <% } %>
    </form>
</div>

</body>
</html>
