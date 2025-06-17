<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>FYP Management System - Login</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f7eeee;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .login-box {
      background-color: #f2f2f2;
      padding: 40px;
      border-radius: 12px;
      width: 400px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      text-align: center;
      position: relative;
      height: 500px;
    }

    .login-box img {
      width: 180px;
      margin-bottom: 10px;
    }

    .login-box h2 {
      margin: 10px 0 20px;
      color: #333;
    }

    .role-select {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-bottom: 20px;
      flex-wrap: wrap;
    }

    .role-select label {
      font-size: 14px;
    }

    input[type="radio"] {
      margin-right: 5px;
    }

    input[type="text"],
    input[type="password"] {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border-radius: 8px;
      border: 1px solid #ccc;
    }

    label {
      text-align: left;
      display: block;
      font-size: 14px;
      color: #333;
    }

    .login-btn {
      background-color: #6e5a8c;
      color: white;
      padding: 10px;
      width: 100%;
      border: none;
      border-radius: 25px;
      font-size: 16px;
      cursor: pointer;
      margin-top: 20px;
    }

    .login-btn:hover {
      background-color: #8e6aa6;
    }

    .bottom-row {
      position: absolute;
      bottom: 20px;
      left: 40px;
      right: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
    }

    .admin-link a {
      color: #5b3b74;
      text-decoration: none;
      font-weight: bold;
    }

    .admin-link a:hover {
      text-decoration: underline;
    }

    .remember label {
      margin: 0;
    }
  </style>

  <script>
    function setFormAction() {
      const role = document.querySelector('input[name="role"]:checked').value;
      const form = document.getElementById('login-form');

      if (role === 'student') {
        form.action = 'StudentDashboard.jsp';
      } else if (role === 'lecturer') {
        form.action = 'LecturerDashboard.jsp';
      } else if (role === 'supervisor') {
        form.action = 'SupervisorDashboard.jsp';
      }
    }
  </script>
</head>
<body>

  <div class="login-box">
    <img src="images/UiTM-Logo.png" alt="UiTM Logo" class="brand-logo">
    <h2>FYP Management System</h2>

    <div class="role-select">
      <label><input type="radio" name="role" value="student" checked> Student</label>
      <label><input type="radio" name="role" value="lecturer"> Lecturer</label>
      <label><input type="radio" name="role" value="supervisor"> Supervisor</label>
    </div>

    <form id="login-form" method="get" onsubmit="setFormAction()">
      <label for="id">User ID</label>
      <input type="text" id="id" name="id" placeholder="Enter your ID" required>

      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="Enter your password" required>

      <button type="submit" class="login-btn">Log in</button>

      <div class="bottom-row">
        <div class="remember">
          <input type="checkbox" id="remember">
          <label for="remember">Remember me</label>
        </div>
        <div class="admin-link">
          Admin? <a href="AdminLogin.jsp">Log in Here</a>
        </div>
      </div>
    </form>
  </div>

</body>
</html>
