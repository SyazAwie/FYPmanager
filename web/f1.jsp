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
    <style>
        
        /* Fieldset Styling */
        fieldset {
          border: 1px solid #e0e6ed;
          border-radius: 10px;
          padding: 25px;
          margin-bottom: 25px;
          background: #f9fbfd;
          position: relative;
          transition: all 0.3s ease;
        }

        fieldset:hover {
          border-color: #3498db;
          box-shadow: 0 5px 15px rgba(52, 152, 219, 0.1);
        }

        legend {
          font-weight: 600;
          color: #2c3e50;
          background: #e9f7fe;
          padding: 10px 20px;
          border-radius: 30px;
          border: 1px solid #bde0fe;
        }

        /* Form Layout */
        form {
          display: grid;
          grid-template-columns: 1fr;
          gap: 20px;
        }

        @media (min-width: 768px) {
          form {
            grid-template-columns: repeat(2, 1fr);
          }

          fieldset {
            grid-column: span 2;
          }

          fieldset:last-child {
            grid-column: span 2;
          }
        }

        /* Label Styles */
        label {
          display: block;
          margin-bottom: 8px;
          font-weight: 500;
          color: #2c3e50;
        }

        /* Input Styles */
        input[type="text"],
        input[type="email"] {
          width: 100%;
          padding: 12px 15px;
          border: 1px solid #d1d8e0;
          border-radius: 8px;
          font-size: 16px;
          transition: all 0.3s ease;
          background: #ffffff;
        }

        input[type="text"]:focus,
        input[type="email"]:focus {
          border-color: #3498db;
          box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
          outline: none;
        }

        input[readonly] {
          background-color: #f5f7fa;
          color: #6c757d;
          cursor: not-allowed;
        }

        /* Agreement Section */
        fieldset:last-child p {
          margin-bottom: 20px;
          color: #495057;
          line-height: 1.6;
        }

        fieldset:last-child label {
          display: inline-block;
          margin-right: 10px;
          font-weight: 600;
        }

        /* Submit Button */
        input[type="submit"] {
          background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
          color: white;
          border: none;
          padding: 14px 28px;
          font-size: 18px;
          font-weight: 600;
          border-radius: 8px;
          cursor: pointer;
          transition: all 0.3s ease;
          display: block;
          margin: 20px auto 0;
          width: 100%;
          max-width: 250px;
        }

        input[type="submit"]:hover {
          transform: translateY(-3px);
          box-shadow: 0 7px 15px rgba(52, 152, 219, 0.4);
        }

        /* Form Group */
        .form-group {
          margin-bottom: 20px;
        }
    </style>
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
