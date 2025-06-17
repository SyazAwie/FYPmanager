<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="../css/style.css" />
  <style>
    body {
      display: flex;
      margin: 0;
      font-family: Arial, sans-serif;
    }

    .sidebar {
      width: 220px;
      background-color: #6c4978;
      color: white;
      padding: 20px;
      height: 100vh;
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
      display: flex;
      align-items: center;
      gap: 10px;
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
      flex-grow: 1;
      background: #f7eeee;
      padding: 20px;
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

    .cards {
      display: flex;
      gap: 20px;
      margin: 40px 0 30px 0;
    }

    .card {
      flex: 1;
      padding: 25px;
      border-radius: 15px;
      text-align: center;
      font-size: 18px;
      font-weight: bold;
      color: #333;
      background: linear-gradient(to bottom right, #f0f0f0, #e0e0e0);
    }

    .card i {
      display: block;
      font-size: 24px;
      margin-bottom: 10px;
    }

    .card:nth-child(1) {
      background: linear-gradient(to bottom right, #fbd3e9, #bb7fd6);
    }

    .card:nth-child(2) {
      background: linear-gradient(to bottom right, #fdfb8c, #f9e79f);
    }

    .card:nth-child(3) {
      background: linear-gradient(to bottom right, #dcd6f7, #b6b4e0);
    }

    .card:nth-child(4) {
      background: linear-gradient(to bottom right, #c2f0c2, #a3e4d7);
    }

    .box {
      background: white;
      padding: 20px;
      border-radius: 15px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      margin-bottom: 30px;
    }

    .timetable-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 14px;
    }

    .timetable-table th,
    .timetable-table td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
      vertical-align: middle;
    }

    .timetable-table th {
      background-color: #5b3b74;
      color: white;
    }

    .timetable-table td {
      background-color: #f9f9f9;
    }

    .timetable-table tr:hover td {
      background-color: #f0e6ff;
    }

    .create-btn {
      display: inline-block;
      margin-top: 15px;
      background-color: #5b3b74;
      color: white;
      padding: 10px 15px;
      text-decoration: none;
      border-radius: 8px;
      font-weight: bold;
    }

    .create-btn i {
      margin-right: 6px;
    }

    .create-btn:hover {
      background-color: #7a5a99;
    }

    .reminders {
      background: white;
      padding: 15px;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      margin-top: 20px;
      margin-bottom: 30px;
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

    <div class="cards">
      <div class="card"><i class="fas fa-user"></i>20<br>Total Students</div>
      <div class="card"><i class="fas fa-chart-line"></i>20<br>Ongoing Reports</div>
      <div class="card"><i class="fas fa-file"></i>8<br>Total Forms</div>
      <div class="card"><i class="fas fa-tasks"></i>10<br>Ongoing Tasks</div>
    </div>

    <div class="box timetable">
      <h4><i class="fas fa-calendar-alt"></i> Lecturer Timetable</h4>
      <a href="edit-timetable.html" class="create-btn"><i class="fas fa-pen"></i> Edit Timetable</a>
      <table class="timetable-table">
        <thead>
          <tr>
            <th>Day</th>
            <th>Time</th>
            <th>Subject</th>
            <th>Group</th>
            <th>Location</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Monday</td>
            <td>9:00 AM - 11:00 AM</td>
            <td>CSC650</td>
            <td>Group A</td>
            <td>DK1</td>
          </tr>
          <tr>
            <td>Wednesday</td>
            <td>2:00 PM - 4:00 PM</td>
            <td>CSC650</td>
            <td>Group B</td>
            <td>Lab 2</td>
          </tr>
          <tr>
            <td>Friday</td>
            <td>10:00 AM - 12:00 PM</td>
            <td>CSC650</td>
            <td>Group C</td>
            <td>DK2</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="reminders">
      <h4><i class="fas fa-bell"></i> Reminders:</h4>
      <p>-</p>
    </div>
  </div>
 <script>
   
function toggleMenu(id) {
    const submenu = document.getElementById(id);
    submenu.style.display = submenu.style.display === 'block' ? 'none' : 'block';
  }
</script>
</body>
</html>
