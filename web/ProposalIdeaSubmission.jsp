<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Dashboard (Proposal)</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
   body {
  margin: 0;
  font-family: Arial, sans-serif;
  background-color: #ffffff; /* White background */
  display: flex;
}


    /* Sidebar */
    .sidebar {
      width: 220px;
      background-color: #6c4978;
      color: white;
      height: 100vh;
      padding: 20px;
      position: fixed;
    }

    .sidebar img {
      width: 100%;
      margin-bottom: 30px;
    }

    .sidebar ul {
      list-style: none;
      padding: 0;
    }

    .sidebar ul li {
      margin: 10px 0;
    }

    .sidebar ul li a {
      color: white;
      text-decoration: none;
      display: flex;
      align-items: center;
      padding: 10px;
      border-radius: 8px;
      transition: 0.3s;
    }

    .sidebar ul li a i {
      margin-right: 10px;
    }

    .sidebar ul li a:hover,
    .sidebar ul li a.active {
      background-color: #8e6aa6;
    }

    /* Main Content */
    .main-content {
      margin-left: 220px;
      padding: 40px;
      width: 100%;
    }

    .card {
      background-color: #f9f9f9;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      max-width: 800px;
      margin: auto;
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
      margin-top: 30px;
    }

    button {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
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
  background-color: #1d4ed8; /* Darker blue when clicked */
}

.btn-back:active {
  background-color: #1e3a8a; /* Darker navy when clicked */
}

.btn-update:active {
  background-color: #15803d; /* Darker green when clicked */
}

.btn-delete:active {
  background-color: #b91c1c; /* Darker red when clicked */
}


    input[type="file"] {
      margin-top: 10px;
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
    <div class="card">
      <h2>Write your proposal here:</h2>
      <form action="#" method="post" enctype="multipart/form-data">
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" name="fullname" required>

        <label for="studentid">Student ID:</label>
        <input type="text" id="studentid" name="studentid" required>

        <label for="semester">Semester:</label>
        <input type="text" id="semester" name="semester" required>

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
          <button type="button" class="btn-back">Back</button>
          <div>
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
