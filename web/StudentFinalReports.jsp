<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Final Reports</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    body {
      display: flex;
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
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

    /* Main Content */
    .main-content {
      margin-left: 250px;
      padding: 20px;
      flex-grow: 1;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #ccc;
      padding: 10px 20px;
      border-radius: 5px;
      margin-bottom: 30px;
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

    /* Proposal Card */
    .proposal-card {
      background-color: #fff5ba; /* light pastel yellow */
      border-radius: 25px;
      padding: 35px;
      max-width: 650px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }

    .proposal-title {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 15px;
    }

    .profile-info {
      display: flex;
      align-items: center;
      font-size: 18px;
      color: #333;
    }

    .profile-info i {
      font-size: 22px;
      margin-right: 10px;
    }

    .btn-group {
      position: absolute;
      bottom: 20px;
      right: 25px;
      display: flex;
      gap: 10px;
    }

    .btn {
      padding: 8px 16px;
      font-size: 14px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      font-weight: bold;
      color: white;
      transition: background-color 0.3s ease;
    }

    .btn-view {
      background-color: #28a745; /* Green */
    }

    .btn-view:hover {
      background-color: #218838;
    }

    .btn-submit {
      background-color: #007bff; /* Blue */
    }

    .btn-submit:hover {
      background-color: #0069d9;
    }
  </style>
</head>
<body>

  <!-- Sidebar -->
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

  <!-- Main Content -->
  <div class="main-content">
    <div class="header">
      <input type="search" placeholder="Search...">
      <div class="profile-notifications">
        <span><i class="fas fa-bell"></i></span>
        <span><i class="fas fa-user"></i></span>
      </div>
    </div>

    <div class="proposal-card">
      <div class="proposal-title">My Final Report</div>
      <div class="profile-info">
        <i class="fas fa-user"></i>
        Muhammad Amirul Bin Iskandar
      </div>

       <div class="btn-group">
         <a href="uploads/proposal.pdf" target="_blank" class="btn btn-view">View</a>
         <a href="FinalReportSubmission.jsp" class="btn btn-submit">Submit</a>
    </div>

</body>
</html>
