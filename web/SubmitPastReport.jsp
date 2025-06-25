<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
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
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
    <style>
        
        
      .main-content {
      margin-left: 220px;
      padding: 20px;
      width: calc(100% - 220px);
      box-sizing: border-box;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      background-color: #f9f9f9;
      border-radius: 15px;
      padding: 40px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      width: 90vw;
      max-width: none;
      box-sizing: border-box;
    }

    h2 {
      text-align: center;
      margin-bottom: 20px;
    }

    label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }

    input[type="text"], input[type="file"] {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 6px;
      border: 1px solid #ccc;
      box-sizing: border-box;
    }

    .row {
      display: flex;
      gap: 20px;
    }

    .row .input-group {
      flex: 1;
    }

    .upload-section {
      border: 2px dashed #aaa;
      padding: 20px;
      text-align: center;
      margin-top: 15px;
      border-radius: 10px;
      background-color: #f7f7f7;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    .upload-section i {
      font-size: 30px;
      margin-bottom: 10px;
      color: #666;
    }

    .upload-section input[type="file"] {
      margin-top: 15px;
      display: block;
      max-width: 300px;
    }

    .buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 25px;
      flex-wrap: wrap;
    }

    button {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 10px;
    }

    .btn-submit { background-color: #3b82f6; color: white; }
    .btn-back { background-color: #3b3bb4; color: white; }
    .btn-update { background-color: #22c55e; color: white; }
    .btn-delete { background-color: #ef4444; color: white; }

    .btn-submit:active { background-color: #1d4ed8; }
    .btn-back:active { background-color: #1e3a8a; }
    .btn-update:active { background-color: #15803d; }
    .btn-delete:active { background-color: #b91c1c; }
  </style>
</head>
<body>

  <!-- Sidebar Include -->
  <jsp:include page="sidebar.jsp" />

  <!-- Main Content -->
  <div class="main-content">
    <div class="card">
      <h2>Write your final report here:</h2>
      <form action="UploadFinalReportServlet" method="post" enctype="multipart/form-data">

        <!-- Full Name -->
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" name="fullname" required>

        <!-- Student ID & Semester -->
        <div class="row">
          <div class="input-group">
            <label for="studentid">Student ID:</label>
            <input type="text" id="studentid" name="studentid" required>
          </div>
          <div class="input-group">
            <label for="semester">Semester:</label>
            <input type="text" id="semester" name="semester" required>
          </div>
        </div>

        <!-- Topic -->
        <label for="topic">Topic:</label>
        <input type="text" id="topic" name="topic" required>

        <!-- Scope -->
        <label for="scope">Scope:</label>
        <input type="text" id="scope" name="scope" required>

        <!-- Upload -->
        <label for="upload">Upload File:</label>
        <div class="upload-section">
          <i class="fas fa-file-upload"></i>
          <p>Drop your file here</p>
          <input type="file" name="finalReportFile" id="upload" required>
        </div>

        <!-- Buttons -->
        <div class="buttons">
          <button type="button" class="btn-back" onclick="goBackToProgress()">Back</button>
          <div>
            <button type="submit" class="btn-update" formaction="UpdateFinalReportServlet">Update</button>
            <button type="submit" class="btn-delete" formaction="DeleteFinalReportServlet">Delete</button>
          </div>
          <button type="submit" class="btn-submit">Submit</button>
        </div>

      </form>
    </div>
  </div>

  <script>
    function goBackToProgress() {
      window.location.href = "StudentFinalReport.jsp#submission-section";
    }
  </script>
</body>
</html>