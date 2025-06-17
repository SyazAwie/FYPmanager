<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Form F3 - Literature Review Evaluation</title>
  <link rel="stylesheet" type="text/css" href="styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .inline-input {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .inline-input input[type="number"] {
      width: 100px;
    }
    .wide-textarea {
      width: 100%;
      padding: 12px;
      border-radius: 8px;
      font-size: 14px;
      border: 1px solid #bbb;
      resize: vertical;
    }
  </style>
</head>
<body>
  <!-- Mobile Toggle Button -->
  <div class="mobile-toggle" onclick="showSidebar()">
    <i class="fas fa-bars"></i>
  </div>

  <!-- Sidebar -->
  <div class="sidebar">
    <div class="close-sidebar" onclick="hideSidebar()">
      <i class="fas fa-times"></i>
    </div>

    <div class="logo">
      <img src="images/UiTM-Logo.png" alt="UiTM Logo">
      <p>UNIVERSITI TEKNOLOGI MARA</p>
      <div class="role-badge">Lecturer Dashboard</div>
    </div>

    <nav>
      <ul>
        <li><a href="#" class="nav-link active"><i class="fas fa-home"></i><span>Dashboard</span></a></li>
        <li><a href="#" class="nav-link"><i class="fas fa-user"></i><span>Profile</span></a></li>

        <li class="dropdown">
          <div class="nav-link parent-link">
            <div>
              <i class="fas fa-user-graduate"></i>
              <span>Students</span>
            </div>
            <span class="arrow">&#9662;</span>
          </div>
          <div class="submenu">
            <a href="#" class="nav-link">CSP600</a>
            <a href="#" class="nav-link">CSP650</a>
          </div>
        </li>

        <li class="dropdown">
          <div class="nav-link parent-link">
            <div>
              <i class="fas fa-chalkboard-teacher"></i>
              <span>Supervisors</span>
            </div>
            <span class="arrow">&#9662;</span>
          </div>
          <div class="submenu">
            <a href="#" class="nav-link">Supervisors</a>
            <a href="#" class="nav-link">Examiners</a>
          </div>
        </li>

        <li><a href="#" class="nav-link"><i class="fas fa-file-alt"></i><span>Form</span></a></li>
        <li><a href="#" class="nav-link"><i class="fas fa-chart-bar"></i><span>Report</span></a></li>
        <li><a href="#" class="nav-link"><i class="fas fa-cog"></i><span>Settings</span></a></li>
        <li><a href="#" class="nav-link"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
      </ul>
    </nav>
  </div>

  <div class="main-content">
    <div class="header">
      <div class="search-bar">
        <input type="text" placeholder="Search">
      </div>
      <div class="icons">
        <span class="icon">?</span>
        <span class="user-avatar">
          <img src="images/default.png" alt="Avatar"
            style="width:35px; height:35px; border-radius:50%; object-fit:cover;" />
        </span>
      </div>
    </div>

    <!-- FORM F3 CONTENT -->
    <div class="dashboard-body">
      <div class="box">
        <h2>Form F3 - Literature Review Evaluation</h2>
        <form oninput="
          let total = 
            (parseFloat(document.getElementById('score1').value) || 0) +
            (parseFloat(document.getElementById('score2').value) || 0) +
            (parseFloat(document.getElementById('score3').value) || 0);
          document.getElementById('totalScore').value = total;
        ">
          <div class="form-group">
            <label>Student Name:</label>
            <input type="text" name="studentName" required />
          </div>

          <div class="form-group">
            <label>Student ID:</label>
            <input type="text" name="studentId" required />
          </div>

          <div class="form-group">
            <label>Project Title:</label>
            <input type="text" name="projectTitle" required />
          </div>

          <div class="form-group">
            <label>Literature Reviewed (Relevance & Quality):</label>
            <div class="inline-input">
              <textarea name="literature" rows="3" required class="wide-textarea"></textarea>
              <input type="number" id="score1" min="0" max="10" placeholder="/10" required />
            </div>
          </div>

          <div class="form-group">
            <label>Critical Analysis:</label>
            <div class="inline-input">
              <textarea name="analysis" rows="3" required class="wide-textarea"></textarea>
              <input type="number" id="score2" min="0" max="10" placeholder="/10" required />
            </div>
          </div>

          <div class="form-group">
            <label>Clarity of Review:</label>
            <div class="inline-input">
              <textarea name="clarity" rows="3" required class="wide-textarea"></textarea>
              <input type="number" id="score3" min="0" max="5" placeholder="/5" required />
            </div>
          </div>

          <div class="form-group">
            <label>Overall Comment:</label>
            <textarea name="comment" rows="4" class="wide-textarea"></textarea>
          </div>

          <div class="form-group">
            <label>Total Marks (%):</label>
            <input type="number" id="totalScore" name="marks" readonly />
          </div>

          <div class="button-group">
            <button type="submit" class="save-changes">Submit</button>
            <button type="reset" class="btn">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function showSidebar() {
      document.querySelector('.sidebar').classList.add('active');
    }
    function hideSidebar() {
      document.querySelector('.sidebar').classList.remove('active');
    }
    document.querySelectorAll('.dropdown').forEach(dropdown => {
      dropdown.addEventListener('click', function () {
        this.classList.toggle('active');
      });
    });
    document.addEventListener('click', function (event) {
      const sidebar = document.querySelector('.sidebar');
      const mobileToggle = document.querySelector('.mobile-toggle');
      if (window.innerWidth <= 992 && sidebar.classList.contains('active') &&
        !sidebar.contains(event.target) &&
        event.target !== mobileToggle &&
        !mobileToggle.contains(event.target)) {
        hideSidebar();
      }
    });
  </script>
</body>
</html>
