<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    if (userName == null || "null".equals(userName)) {
        userName = "User";
    }

    if (userAvatar == null || "null".equals(userAvatar) || userAvatar.trim().isEmpty()) {
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
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>FYP Student Guideline</title>
  <link rel="stylesheet" href="../css/style.css" />
  <style>
    .guideline-container {
      background-color: #ffffff;
      border-radius: 12px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      padding: 40px;
      max-width: 900px;
      margin: auto;
    }

    h2 {
      text-align: center;
      font-size: 28px;
      color: #2c3e50;
      margin-bottom: 25px;
      font-weight: bold;
    }

    .line {
      width: 80px;
      height: 4px;
      background-color: #3498db;
      margin: 0 auto 30px auto;
      border-radius: 10px;
    }

    ol {
      padding-left: 20px;
      font-size: 16px;
      color: #333;
    }

    li {
      margin-bottom: 18px;
      line-height: 1.8;
    }

    li b {
      color: #2980b9;
    }

    @media (max-width: 768px) {
      .main-content {
        margin-left: 0;
        padding: 20px;
      }

      .guideline-container {
        padding: 25px;
      }

      h2 {
        font-size: 22px;
      }
    }
  </style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

<div class="main-content">
  <div class="guideline-container">
    <h2>Final Year Project (FYP) Student Guideline</h2>
    <div class="line"></div>
    <ol>
      <li><b>Register Your Project Early:</b> Pick a suitable topic and get approval through the FYP system.</li>
      <li><b>Communicate With Supervisor:</b> Meet regularly and document your discussions using the logbook.</li>
      <li><b>Prepare Your Proposal:</b> Include problem statement, objectives, scope, background, and a timeline.</li>
      <li><b>Progress Reports:</b> Submit mid-semester updates and make sure your supervisor signs off on them.</li>
      <li><b>System Development:</b> Build your system gradually. Focus on functionality and user interface.</li>
      <li><b>Final Report:</b> Write a structured, clear, and formatted report (Chapters 1–5) with references.</li>
      <li><b>Presentation & Demo:</b> Be confident, keep slides simple, and showcase working system features.</li>
      <li><b>Final Submission:</b> Submit your system files, final report, and required forms before the deadline.</li>
      <li><b>Ask for Help:</b> If you're unsure about anything, reach out to your supervisor or FYP coordinator early.</li>
    </ol>
  </div>
</div>

</body>
</html>
