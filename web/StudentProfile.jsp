<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    %>
    
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Profile</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    * {
      box-sizing: border-box;
    }

    body {
  display: flex;
  margin: 0;
  font-family: Arial, sans-serif;
}

 
   /* Sidebar */
    .sidebar {
      width: 250px;
      background-color: #6c4978;
      color: white;
      height: 100vh;
      padding: 20px;
      box-sizing: border-box;
      position: fixed;
    }

    .sidebar img {
      width: 80%;
      margin-bottom: 20px;
    }

    .sidebar ul {
      list-style: none;
      padding: 0;
    }

    .sidebar ul li {
      margin: 15px 0;
    }

    .sidebar ul li a {
      color: white;
      text-decoration: none;
      display: block;
      padding: 8px;
      border-radius: 8px;
    }

    .sidebar ul li a:hover {
      background-color: #8e6aa6;
    }
    .main-content {
      margin-left: 300px;
      padding: 20px;
      flex-grow: 1;
      width: calc(100% - 250px);
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #ccc;
      padding: 10px 20px;
      border-radius: 5px;
    }

    .header input[type="search"] {
      padding: 10px;
      width: 300px;
      border-radius: 5px;
      border: 1px solid #aaa;
    }

    .profile-notifications span {
      margin-left: 15px;
      font-size: 20px;
      cursor: pointer;
    }

    .profile {
      margin-top: 20px;
    }

    .profile h2 {
      margin-bottom: 20px;
    }

    .profile-photo {
      text-align: center;
      margin-bottom: 20px;
    }

    .profile-photo img {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      background-color: #ddd;
      object-fit: cover;
    }

    .upload-photo,
    .delete-photo {
      margin-top: 10px;
      margin-right: 5px;
      padding: 8px 12px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      color: white;
    }

    .upload-photo {
      background-color: #28a745;
    }

    .delete-photo {
      background-color: #dc3545;
    }

    .profile-form {
      max-width: 600px;
      margin: auto;
    }

    .form-group {
      margin-bottom: 15px;
    }

    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }

    input, select {
      width: 100%;
      padding: 10px;
      border: 1px solid #aaa;
      border-radius: 5px;
    }

    .save-changes {
      background-color: #007bff;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 5px;
      float: right;
      cursor: pointer;
    }

    .save-changes:hover {
      background-color: #0056b3;
    }

    @media (max-width: 768px) {
      .sidebar {
        width: 100%;
        height: auto;
        position: relative;
      }

      .main-content {
        margin-left: 0;
        width: 100%;
      }
    }
  </style>
</head>
<body>

<div class="sidebar">
   <img src="images/UiTM-Logo.png" alt="UiTM Logo" class="brand-logo">
 <ul>
  <li><a href="StudentDashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
  <li><a href="StudentProfile.jsp"><i class="fas fa-user"></i> Profile</a></li>
  <li><a href="StudentProposalIdea.jsp"><i class="fas fa-file-alt"></i> Proposal Idea</a></li>
  <li><a href="StudentProgressReport.jsp"><i class="fas fa-folder-open"></i> Progress Report</a></li>
  <li><a href="StudentFinalReports.jsp"><i class="fas fa-clipboard"></i> Final Reports</a></li>
  <li><a href="StudentEvaluation.jsp"><i class="fas fa-check-circle"></i> Evaluation</a></li>
  <li><a href="StudentGuideline.jsp"><i class="fas fa-book"></i> Guideline</a></li>
  <li><a href="StudentConsultationLog.jsp"><i class="fas fa-comments"></i> Consultation Log</a></li>
  <li><a href="StudentLogout.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
</ul>

</div>

  <div class="main-content">
    <div class="header">
      <input type="search" placeholder="Search...">
      <div class="profile-notifications">
        <span><i class="fas fa-bell"></i></span>
        <span><i class="fas fa-user"></i></span>
      </div>
    </div>

    <div class="profile">
      <h2>Welcome</h2>
        <form action="UploadAvatar" method="post" enctype="multipart/form-data">
            <div class="profile-photo">
                <!-- Avatar Image Preview -->
                <img id="profileImg"
                     src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>"
                     alt="User Avatar"
                     style="width:100px; height:100px; border-radius:50%; object-fit:cover;">

                <!-- Upload + Save + Delete -->
                <div style="margin-top:10px;">
                    <!-- Hidden File Input -->
                    <input type="file" id="photoInput" name="avatar" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
                    <input type="hidden" name="user_id" value="<%= userId %>">

                    <!-- Buttons -->
                    <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
                    <button type="submit" class="upload-photo">Save</button>

                    <!-- Delete Button in the Same Line -->
        </form>
        <form action="DeleteAvatar" method="post" style="display:inline;">
            <input type="hidden" name="user_id" value="<%= userId %>">
            <button type="submit" class="delete-photo">Delete</button>
        </form>
                </div>
            </div>          
          
      <form action="#" method="POST" class="profile-form">
        <div class="form-group">
          <label for="full-name">Full Name</label>
          <input type="text" id="full-name" name="full-name" placeholder="Enter full name">
        </div>

        <div class="form-group">
          <label for="student-id">Student ID</label>
          <input type="text" id="student-id" name="student-id" placeholder="Enter Student ID">
        </div>

        <div class="form-group">
          <label for="course">Course</label>
          <select id="course" name="course">
            <option value="CSP600">CSP600</option>
            <option value="CSP650">CSP650</option>
          </select>
        </div>

        <div class="form-group">
          <label for="phone">Phone Number</label>
          <input type="tel" id="phone" name="phone" placeholder="Enter phone number">
        </div>

        <div class="form-group">
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" placeholder="Enter email address">
        </div>

        <div class="form-group">
          <label for="current-password">Current Password</label>
          <input type="password" id="current-password" name="current-password" placeholder="Enter current password">
        </div>

        <div class="form-group">
          <label for="new-password">New Password</label>
          <input type="password" id="new-password" name="new-password" placeholder="Enter new password">
        </div>

        <div class="form-group">
          <label for="confirm-password">Confirm Password</label>
          <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password">
        </div>

        <button type="submit" class="save-changes">Save Changes</button>
      </form>
    </div>
  </div>

  <script>
function previewPhoto(event) {
    const reader = new FileReader();
    reader.onload = function () {
        const output = document.getElementById('profileImg');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
}
</script>

</body>
</html>
