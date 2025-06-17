<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    .submenu {
      display: none; /* 🔽 Hide submenus by default */
      list-style: none;
      padding-left: 20px;
    }

    .submenu li {
      margin: 5px 0;
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
    <li><a href="LecturerDashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
    <li><a href="LecturerProfile.jsp"><i class="fas fa-user"></i> Profile</a></li>

    <li>
      <a href="javascript:void(0);" onclick="toggleMenu('students-submenu')">
        <i class="fas fa-user-graduate"></i> Students 
        <i class="fas fa-chevron-down" style="margin-left:auto;"></i>
      </a>
      <ul class="submenu" id="students-submenu">
        <li><a href="CSP600.jsp">CSP600</a></li>
        <li><a href="CSP650.jsp">CSP650</a></li>
      </ul>
    </li>

    <li>
      <a href="javascript:void(0);" onclick="toggleMenu('supervisors-submenu')">
        <i class="fas fa-chalkboard-teacher"></i> Supervisors 
        <i class="fas fa-chevron-down" style="margin-left:auto;"></i>
      </a>
      <ul class="submenu" id="supervisors-submenu">
        <li><a href="LecturerSupervisors.jsp">Supervisors</a></li>
        <li><a href="LecturerExaminers.jsp">Examiners</a></li>
      </ul>
    </li>

    <li><a href="LecturerForms.jsp"><i class="fas fa-file-alt"></i> Form</a></li>
    <li><a href="LecturerReports.jsp"><i class="fas fa-chart-bar"></i> Report</a></li>
    <li><a href="LecturerLogout.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
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
    <div class="profile-photo">
      <img id="profileImg" src="https://via.placeholder.com/100" alt="Profile Photo">
      <div>
        <input type="file" id="photoInput" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
        <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
        <button type="button" class="delete-photo" onclick="deletePhoto()">Delete</button>
      </div>
    </div>

    <form action="#" method="POST" class="profile-form">
      <div class="form-group">
        <label for="full-name">Full Name</label>
        <input type="text" id="full-name" name="full-name" placeholder="Enter full name">
      </div>

      <div class="form-group">
        <label for="student-id">Staff ID</label>
        <input type="text" id="staff-id" name="staff-id" placeholder="Enter student id">
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

<!-- ✅ JavaScript at the end -->
<script>
  function previewPhoto(event) {
    const reader = new FileReader();
    reader.onload = function () {
      document.getElementById('profileImg').src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
  }

  function deletePhoto() {
    document.getElementById('profileImg').src = "https://via.placeholder.com/100";
  }

  function toggleMenu(id) {
    const submenu = document.getElementById(id);
    submenu.style.display = submenu.style.display === 'block' ? 'none' : 'block';
  }
</script>

</body>
</html>
