<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Dashboard</title>
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
      margin-left: 250px;
      padding: 20px;
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

    /* Dashboard Cards */
    .cards {
      display: flex;
      gap: 20px;
      margin: 30px 0;
      flex-wrap: wrap;
    }

    .card {
      flex: 1 1 200px;
      padding: 20px;
      border-radius: 15px;
      text-align: center;
      font-size: 16px;
      font-weight: bold;
      color: #333;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 200px;
    }

    .card i {
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

    .card.supervisor-info {
      background: linear-gradient(to bottom right, #c2f0c2, #a3e4d7);
      padding: 12px;
      font-size: 13px;
      line-height: 1.4;
    }

    .card.supervisor-info p {
      margin: 3px 0;
      font-weight: normal;
      font-size: 12px;
    }

    /* Topics */
    .topics-container {
      display: flex;
      gap: 20px;
      margin-top: 20px;
      flex-wrap: wrap;
    }

    .topic-box {
      background: #f7f1fa;
      border: 1px solid #ccc;
      border-radius: 15px;
      width: 380px;
      height: 400px;
      padding: 20px;
      text-align: center;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      color: #6c4978;
    }

    .topic-box img {
      width: 115px;
      margin-bottom: 20px;
    }

    .topic-box h3 {
      margin-bottom: 15px;
      font-size: 18px;
    }

    .btn-group {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 120px;
      filex-wrap: wrap;
    }

    .btn {
      background-color: #6c4978;
      border: none;
      color: white;
      padding: 8px 12px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: background-color 0.3s ease;
    }

    .btn:hover {
      background-color: #8e6aa6;
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

      .cards, .topics-container {
        flex-direction: column;
        align-items: center;
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
      <li><a href="Login.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
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
    <div class="card"><i class="fas fa-user-graduate"></i> 20 Students</div>
    <div class="card"><i class="fas fa-book-open"></i> 20 Topics</div>
    <div class="card"><i class="fas fa-folder-open"></i> 100 Past Reports</div>
    <div class="card supervisor-info">
      <i class="fas fa-chalkboard-teacher"></i> Supervisor Info
      <p><strong>Prof. Muhammad Ali</strong></p>
      <p>muhdali79@gmail.com</p>
      <p>📞 +60 123456789</p>
    </div>
  </div>

  <div class="topics-container">
    <div class="topic-box">
      <img src="images/Logo_Topic.jpg" alt="Topic Logo" class="brand-logo">
      <h3>Topic 1</h3>
      <div class="btn-group">
        <button class="btn"><i class="fas fa-download"></i> Download</button>
        <button class="btn"><i class="fas fa-eye"></i> View</button>
      </div>
    </div>

    <div class="topic-box">
      <img src="images/Logo_Topic.jpg" alt="Topic Logo" class="brand-logo">
      <h3>Topic 2</h3>
      <div class="btn-group">
        <button class="btn"><i class="fas fa-download"></i> Download</button>
        <button class="btn"><i class="fas fa-eye"></i> View</button>
      </div>
    </div>

    <div class="topic-box">
      <img src="images/Logo_Topic.jpg" alt="Topic Logo" class="brand-logo">
      <h3>Topic 3</h3>
      <div class="btn-group">
        <button class="btn"><i class="fas fa-download"></i> Download</button>
        <button class="btn"><i class="fas fa-eye"></i> View</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>
