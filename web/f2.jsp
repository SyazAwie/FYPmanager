<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Lecturer Forms</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="../css/style.css" />
  <style>
    * { box-sizing: border-box; }
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
      position: fixed;
    }
    .sidebar img {
      width: 90%;
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
    .sidebar ul li a:hover,
    .sidebar ul li a.active {
      background-color: #8e6aa6;
      font-weight: bold;
    }
    .main-content {
      margin-left: 250px;
      width: calc(100% - 250px);
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      background: #f7eeee;
      padding: 20px;
    }
    .header {
      background-color: #b0b0b0;
      height: 60px;
      padding: 10px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .search-bar {
      flex-grow: 1;
      margin-right: 20px;
      display: flex;
      align-items: center;
    }
    .search-bar input {
      padding: 8px 12px;
      border-radius: 8px;
      border: none;
      width: 300px;
      outline: none;
    }
    .search-bar button {
      background: none;
      border: none;
      cursor: pointer;
      margin-left: -35px;
      color: #555;
    }
    .icons {
      display: flex;
      gap: 20px;
      align-items: center;
      position: relative;
    }
    .icon {
      font-size: 1.5em;
      color: #555;
      cursor: pointer;
      position: relative;
    }
    .notif-popup {
      position: absolute;
      top: 50px;
      right: 0;
      background: #fff;
      color: #000;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      width: 180px;
      font-size: 11px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
      display: none;
      z-index: 999;
    }
    .user-avatar {
      background-color: #ccc;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      overflow: hidden;
    }
    .user-avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    table, th, td {
      border: 1px solid black;
    }
    th, td {
      padding: 8px;
      text-align: left;
      vertical-align: top;
    }
    .center {
      text-align: center;
    }
    .button {
      padding: 10px 15px;
      margin: 5px;
      border: none;
      border-radius: 5px;
      color: white;
      cursor: pointer;
    }
    .btn-purple { background-color: #6a0dad; }
    .btn-blue { background-color: blue; }
    .btn-green { background-color: green; }
    .signature-section td {
      border: none;
    }
    select, input[type="text"], input[type="date"] {
      width: 100%;
      padding: 5px;
      box-sizing: border-box;
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
    <li><a href="LecturerForms.jsp" class="active"><i class="fas fa-file-alt"></i> Form</a></li>
    <li><a href="LecturerReports.jsp"><i class="fas fa-chart-bar"></i> Report</a></li>
    <li><a href="LecturerLogout.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
  </ul>
</div>

<div class="main-content">
  <div class="header">
    <div class="search-bar">
      <form action="search.jsp" method="get">
        <input type="search" name="query" placeholder="Search..." required />
        <button type="submit"><i class="fas fa-search"></i></button>
      </form>
    </div>
    <div class="icons">
      <div class="icon" id="notifBell">
        <i class="fas fa-bell"></i>
        <div id="notifPopup" class="notif-popup">
          <p>You have no new notifications.</p>
        </div>
      </div>
      <div class="user-avatar">
        <img id="headerProfileImg" src="${sessionScope.userProfileImageURL != null ? sessionScope.userProfileImageURL : 'images/LecturerProfile.png'}" alt="Profile" />
      </div>
    </div>
  </div>

  <h3>F2 - PROJECT MOTIVATION EVALUATION FORM</h3>
  <table>
    <tr>
      <td>STUDENT NAME</td>
      <td><input type="text" name="studentName"></td>
      <td>STUDENT ID</td>
      <td><input type="text" name="studentId"></td>
    </tr>
    <tr>
      <td>PROGRAM</td>
      <td colspan="3"><input type="text" name="program"></td>
    </tr>
    <tr>
      <td>SUPERVISOR</td>
      <td colspan="3"><input type="text" name="supervisor"></td>
    </tr>
    <tr>
      <td>PROJECT TITLE</td>
      <td colspan="3"><input type="text" name="projectTitle"></td>
    </tr>
  </table>

  <table>
    <tr>
      <th>Assessment Criteria</th>
      <th>Weight (W)</th>
      <th>Score (S)<br>[1?10]</th>
      <th>Marks (W*S)</th>
    </tr>
    <tr>
      <td><strong>1. Problem identification</strong><br><small>(Identify problems/issues/opportunities)</small></td>
      <td class="center">3</td>
      <td>
        <select id="score1" onchange="calculateMark(1, 3)">
          <option value="">--</option>
          <%
            for (int i = 1; i <= 10; i++) {
              out.println("<option value='" + i + "'>" + i + "</option>");
            }
          %>
        </select>
      </td>
      <td><input type="text" id="mark1" readonly></td>
    </tr>
    <tr>
      <td><strong>2. Evidences</strong><br><small>(To support problems/issues/opportunities identified)</small></td>
      <td class="center">5</td>
      <td>
        <select id="score2" onchange="calculateMark(2, 5)">
          <option value="">--</option>
          <%
            for (int i = 1; i <= 10; i++) {
              out.println("<option value='" + i + "'>" + i + "</option>");
            }
          %>
        </select>
      </td>
      <td><input type="text" id="mark2" readonly></td>
    </tr>
    <tr>
      <td><strong>3. Solutions</strong><br><small>(Propose solutions)</small></td>
      <td class="center">2</td>
      <td>
        <select id="score3" onchange="calculateMark(3, 2)">
          <option value="">--</option>
          <%
            for (int i = 1; i <= 10; i++) {
              out.println("<option value='" + i + "'>" + i + "</option>");
            }
          %>
        </select>
      </td>
      <td><input type="text" id="mark3" readonly></td>
    </tr>
    <tr>
      <td colspan="3" class="center"><strong>Total</strong></td>
      <td><input type="text" id="totalMarks" readonly></td>
    </tr>
  </table>

  <table class="signature-section">
    <tr>
      <td>Lecturer?s Name</td>
      <td>Signature</td>
      <td>Date</td>
    </tr>
    <tr>
      <td><input type="text" /></td>
      <td><input type="text" /></td>
      <td><input type="date" /></td>
    </tr>
    <tr>
      <td colspan="3" style="text-align: right;">
        <button class="button btn-green">Add</button>
      </td>
    </tr>
  </table>
</div>

<script>
  function calculateMark(num, weight) {
    const score = parseInt(document.getElementById('score' + num).value);
    const markField = document.getElementById('mark' + num);
    if (!isNaN(score)) {
      markField.value = score * weight;
    } else {
      markField.value = '';
    }
    calculateTotal();
  }

  function calculateTotal() {
    const mark1 = parseFloat(document.getElementById('mark1').value) || 0;
    const mark2 = parseFloat(document.getElementById('mark2').value) || 0;
    const mark3 = parseFloat(document.getElementById('mark3').value) || 0;
    document.getElementById('totalMarks').value = mark1 + mark2 + mark3;
  }

  function toggleMenu(id) {
    const submenu = document.getElementById(id);
    submenu.style.display = submenu.style.display === "block" ? "none" : "block";
  }

  document.getElementById('notifBell').addEventListener('click', function () {
    const popup = document.getElementById('notifPopup');
    popup.style.display = popup.style.display === 'block' ? 'none' : 'block';
  });
</script>

</body>
</html>
