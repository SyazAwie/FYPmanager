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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
    <style><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Dashboard (Proposal)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="sidebarStyle.css">
  <style>
    .main-content {
      margin-left: 220px;
      padding: 40px;
      width: calc(100% - 220px);
      box-sizing: border-box;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }

    .card {
      background-color: #f9f9f9;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      width: 100%;
      max-width: 1200px;
      min-height: 600px; 
      box-sizing: border-box;
    }

    h2 {
      text-align: center;
      margin-bottom: 30px;
    }

    label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }

  
    .form-row {
      display: flex;
      gap: 20px;
      margin-top: 15px;
    }

    .form-group {
      flex: 1;
    }

      input[type="text"] {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 6px;
      border: 1px solid #ccc;
    }

    .upload-section {
      border: 2px dashed #aaa;
      padding: 30px;
      text-align: center;
      margin-top: 15px;
      border-radius: 10px;
      background-color: #f7f7f7;
    }

    .upload-section i {
      font-size: 40px;
      margin-bottom: 10px;
      color: #666;
    }
    .buttons {
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      margin-top: 30px;
      gap: 10px;
    }

    .btn-group-middle {
      display: flex;
      gap: 10px;
      justify-content: center;
      flex: 1;
    }

    a.btn-back,
    button {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
    }

    .btn-submit {
      background-color: #3b82f6;
      color: white;
    }

    .btn-back {
      background-color: #3b3bb4;
      color: white;
    }

    .btn-update {
      background-color: #22c55e;
      color: white;
    }

    .btn-delete {
      background-color: #ef4444;
      color: white;
    }

    .btn-submit:active {
      background-color: #1d4ed8;
    }

    .btn-back:active {
      background-color: #1e3a8a;
    }

    .btn-update:active {
      background-color: #15803d;
    }

    .btn-delete:active {
      background-color: #b91c1c;
    }
  </style>
</head>
<body>

  <div class="main-content">
    <div class="card">
      <h2>Write your proposal here:</h2>
      <form action="#" method="post" enctype="multipart/form-data">
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" name="fullname" required>

        <div class="form-row">
          <div class="form-group">
            <label for="studentid">Student ID:</label>
            <input type="text" id="studentid" name="studentid" required>
          </div>
          <div class="form-group">
            <label for="semester">Semester:</label>
            <input type="text" id="semester" name="semester" required>
          </div>
        </div>

        <label for="topic">Topic:</label>
        <input type="text" id="topic" name="topic" required>

        <label for="scope">Scope:</label>
        <input type="text" id="scope" name="scope" required>

        <label for="upload">Upload File:</label>
        <div class="upload-section">
          <i class="fas fa-file-upload"></i>
          <p>Drop your files here</p>
          <input type="file" name="proposalFile" id="upload">
        </div>

        <div class="buttons">
          <a href="ProposalIdea.jsp" class="btn-back">Back</a>
          <div class="btn-group-middle">
            <button type="submit" class="btn-update">Update</button>
            <button type="submit" class="btn-delete">Delete</button>
          </div>
          <button type="submit" class="btn-submit">Submit</button>
        </div>

      </form>
    </div>
  </div>

</body>
</html>
