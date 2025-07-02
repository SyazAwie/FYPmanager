<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");
    //test laptop khaleda
    //laptop danisa
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
    
    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("examiner", "Examiner");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
%>
<!DOCTYPE html>
<html>
<head>
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
    <style>
     
/* UNIVERSAL WRAPPER (JIKA MAHU ROLE BASED) */
.dashboard-wrapper {
  display: flex;
  flex-direction: row;
  gap: 30px;
  padding: 80px 40px 40px;
  box-sizing: border-box;
  min-height: 100vh;
  width: 100%;
  
}

/* LEFT/RIGHT PANELS - Flexible */
.left-panel,
.right-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* WELCOME INFO */
.welcome-info h2 {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 5px;
  color: #2d2d2d;
}
.welcome-info p {
  font-size: 16px;
  color: #555;
  margin-bottom: 20px;
}

/* CARDS AREA */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}
.card {
  padding: 20px;
  border-radius: 12px;
  background-color: #ffffff;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
  font-size: 16px;
  color: #333;
  transition: all 0.3s ease;
}

/* SUPERVISOR CARD */
.supervisor-card {
  display: flex;
  align-items: center;
  gap: 20px;
  background: #f0f4ff;
  border-radius: 15px;
  padding: 25px 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  margin-bottom: 40px;
  width: 100%;
  min-height: 180px;
  box-sizing: border-box;
  flex-wrap: wrap; /* penting untuk responsive */
}
.supervisor-img {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 50%;
  border: 2px solid #4b8cf5;
}
.supervisor-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 200px;
}

/* PROGRESS BARS */
.horizontal-chart-box {
  background: #fff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
}
.horizontal-bar {
  margin-bottom: 15px;
}
.label {
  display: inline-block;
  width: 80px;
  font-weight: bold;
  color: #444;
}
.bar-wrapper {
  background-color: #e0e0e0;
  border-radius: 10px;
  height: 22px;
  overflow: hidden;
  width: 80%;
  display: inline-block;
  vertical-align: middle;
}
.bar {
  height: 100%;
  line-height: 22px;
  color: white;
  padding-left: 10px;
  font-size: 14px;
  font-weight: bold;
  animation: growBar 1.2s ease-out forwards;
}
@keyframes growBar {
  0% { width: 0; }
}
.bar-proposal { background: #4b8cf5; width: 85%; }
.bar-progress { background: #f5b342; width: 55%; }
.bar-final    { background: #f45b69; width: 20%; }

/* ANNOUNCEMENTS */
.announcement-container {
  background: #ffffff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 30px;
}

/* DEADLINE CARDS */
.deadline-grid {
  display: flex;
  flex-direction: column;
  gap: 15px;
}
.deadline-card {
  background-color: #f5f8ff;
  border-left: 5px solid #4b8cf5;
  padding: 12px 15px;
  border-radius: 10px;
}
.deadline-card h3 {
  margin: 0 0 6px;
  font-size: 16px;
  color: #333;
}
.deadline-card p,
.deadline-card button {
  font-size: 14px;
  margin: 3px 0;
}
.deadline-card button {
  background-color: #4b8cf5;
  color: white;
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
/* Table Style - Blue Theme */
.timetable-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
  background: #ffffff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}
.timetable-table thead {
  background-color: #4b8cf5;
  color: white;
}
.timetable-table th,
.timetable-table td {
  padding: 10px 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}
.timetable-table tbody tr:nth-child(odd) {
  background-color: #f0f4ff;
}
.timetable-table tbody tr:hover {
  background-color: #dceeff;
}

/* Make .card interactive (even without using <a>) */
.card {
  text-decoration: none;
  transition: transform 0.2s ease;
  cursor: pointer;
}

.card:hover {
  transform: scale(1.03);
  box-shadow: 0 5px 10px rgba(0,0,0,0.1);
}

/* Supervisor Dashboard Base Layout */
.dashboard-body {
  padding: 80px 40px 40px;
  box-sizing: border-box;
}
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 20px;
}

/* Card Colors */
.purple { background-color: #eae6f8; }
.yellow { background-color: #fff9e6; }
.red    { background-color: #fdecea; }
.green  { background-color: #e8f8f5; }
.blue   { background-color: #eef6ff; }
.cyan   { background-color: #e6faff; }

/* General Panel */
.panel {
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0,0,0,0.08);
  background-color: white;
}

/* Summary Box Style */
.summary-box {
  text-align: center;
}
.summary-box h3 {
  color: #2d2d2d;
  margin-bottom: 10px;
}
.summary-box p {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  margin: 5px 0;
}
.summary-box span {
  font-size: 14px;
  color: #666;
}

/* Table Style */
.panel table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}
.panel th {
  background-color: #4b8cf5;
  color: white;
  padding: 10px;
  text-align: left;
}
.panel td {
  padding: 10px;
  border-bottom: 1px solid #ddd;
}
.panel tbody tr:nth-child(odd) {
  background-color: #f4f9ff;
}
.panel tbody tr:hover {
  background-color: #e8f2ff;
}
.panel a {
  color: #2c3e50;
  text-decoration: underline;
}

    </style>
</head>
<body>
    
    <!-- Topbar -->
    <header id="topbar">
        <jsp:include page="topbar.jsp" />
    </header>
    
    <!-- Sidebar -->
    <aside id="sidebar">
        <jsp:include page="navbar.jsp" />
    </aside>
    
    <!-- Overlay -->
    <div id="sidebarOverlay"></div>
    
 <!-- Admin Dashboard -->
<% if ("admin".equals(userRole)) { %>
<div class="main-content" style="display: flex; gap: 20px;">

  <!-- LEFT PANEL -->
  <div class="left-panel" style="flex: 2;">
    <!-- Welcome Section -->
    <div class="welcome-info animate-fadeIn">
      <h2>Welcome, <%= userName %></h2>
      <p><%= displayRole %></p>
    </div>

    <!-- Summary Cards -->
    <div class="cards grid-cards animate-up" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px;">
      
      <!-- Students Card -->
      <div class="card purple" onclick="toggleLinks()" style="position: relative;">
        <i class="fas fa-users"></i>
        <h3>Students</h3>
        <span>100</span>
        <!-- Dropdown Link Option -->
        <div id="linkOptions" style="display: none; margin-top: 10px; position: absolute; background: #fff; color: #000; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); z-index: 10;">
          <div onclick="window.location.href='CSP600.jsp'" style="cursor: pointer; padding: 5px 0;">CSP600</div>
          <div onclick="window.location.href='CSP650.jsp'" style="cursor: pointer; padding: 5px 0;">CSP650</div>
        </div>
      </div>

      <!-- Other Cards -->
      <div class="card blue">
        <a href="SupervisorList.jsp">
          <i class="fas fa-chalkboard-teacher"></i>
          <h3>Supervisors</h3>
          <span>100</span>
        </a>
      </div>

      <div class="card yellow">
        <a href="PastReport.jsp">
          <i class="fas fa-tasks"></i>
          <h3>Past Report</h3>
          <span>100</span>
        </a>
      </div>

      <div class="card cyan">
        <a href="Presentation.jsp">
          <i class="fas fa-calendar-alt"></i>
          <h3>Presentations</h3>
          <span>100</span>
        </a>
      </div>
    </div>
  </div>

  <!-- RIGHT PANEL -->
  <div class="right-panel" style="flex: 1;">
    
    <!-- Deadlines -->
    <div class="announcement-container animate-fadeIn">
      <h3><i class="fas fa-hourglass-half"></i> Deadlines</h3>
      <ul class="deadline-grid">
        <li class="deadline-card">
          <h3>Proposal</h3>
          <p>20 June 2025</p>
        </li>
        <li class="deadline-card">
          <h3>Progress Report</h3>
          <p>5 July 2025</p>
        </li>
        <li class="deadline-card">
          <h3>Final Report</h3>
          <p>1 August 2025</p>
        </li>
      </ul>
    </div>

    <!-- Recent Activity -->
    <div class="announcement-container animate-fadeIn delay-2">
      <h3><i class="fas fa-bolt"></i> Recent Activity</h3>
      <p>🟢 5 New student registrations</p>
      <p>🟡 Supervisor updated FYP</p>
      <p>🔵 3 New submissions</p>
    </div>

    <!-- Announcement Publisher -->
    <div class="announcement-container animate-fadeIn delay-1">
      <h3><i class="fas fa-bullhorn"></i> Publish Announcement</h3>
      <form method="post" action="PostAnnouncementServlet">
        <input type="text" name="announcement" placeholder="Type announcement here..." required />
        <button type="submit"><i class="fas fa-paper-plane"></i> Publish</button>
      </form>
    </div>

  </div>
</div>

<script>
  function toggleLinks() {
    const links = document.getElementById("linkOptions");
    links.style.display = links.style.display === "block" ? "none" : "block";
  }

  // Sembunyi pilihan bila klik luar kad
  document.addEventListener("click", function(event) {
    const card = document.querySelector(".card.purple");
    const links = document.getElementById("linkOptions");
    if (!card.contains(event.target)) {
      links.style.display = "none";
    }
  });
</script>
<% } %>


    

    
   <!-- Student Dashboard -->
<% if ("student".equals(userRole)) { %>
<div class="main-content">
  
  <!-- LEFT PANEL -->
  <div class="left-panel">
    <!-- Welcome Info -->
    <div class="welcome-info">
      <h2>Welcome, <%= userName %></h2>
      <p><%= displayRole %></p>
    </div>

    <!-- Supervisor Card -->
    <div class="supervisor-card">
      <img src="images/default-supervisor.jpg" alt="Supervisor Photo" class="supervisor-img">
      <div class="supervisor-details">
        <h4><i class="fas fa-chalkboard-teacher"></i> Dr. Noraini Binti Ahmad</h4>
        <p><i class="fas fa-envelope"></i> <a href="mailto:noraini@uitm.edu.my">noraini@uitm.edu.my</a></p>
        <p><i class="fas fa-phone"></i> 012-3456789</p>
      </div>
    </div>


  <!-- RIGHT PANEL -->
  <div class="right-panel">

    <!-- Announcements -->
    <div class="announcement-container">
      <h2>📢 Announcements</h2>
      <ul>
        <li>📌 Submit proposal by <strong>20 June 2025</strong></li>
        <li>📌 Final report window opens <strong>1 August 2025</strong></li>
      </ul>
    </div>

    <!-- Upcoming Deadlines -->
    <div class="announcement-container">
      <h2>📅 Upcoming Deadlines</h2>
      <div class="deadline-grid">
        <div class="deadline-card">
          <h3>Proposal Submission</h3>
          <p>Due: 20 June 2025</p>
          <button onclick="goToSubmission('ProposalIdea.jsp')">
            <i class="fas fa-upload"></i> Submit
          </button>
        </div>
       
        <div class="deadline-card">
          <h3>Final Report</h3>
          <p>Due: 1 August 2025</p>
          <button onclick="goToSubmission('FinalReport.jsp')">
            <i class="fas fa-upload"></i> Submit
          </button>
        </div>
      </div>
    </div>

  </div> <!-- END RIGHT PANEL -->

</div> <!-- END DASHBOARD WRAPPER -->

<script>
  function goToSubmission(type) {
    let target = '';
    switch (type) {
      case 'Proposal': target = 'ProposalIdea.jsp'; break;
  
      case 'Final': target = 'FinalReport.jsp'; break;
      default: alert('Invalid submission type.'); return;
    }
    window.location.href = target;
  }
</script>
<% } %>

      <!-- Lecturer Dashboard -->
    <% if ("lecturer".equals(userRole)) { %>
<div class="main-content">

  <!-- Welcome -->
  <div class="welcome-info">
    <h2>Welcome, <%= userName %></h2>
    <p><%= displayRole %></p>
  </div>

  <!-- Summary Cards -->
    <div class="cards grid-cards animate-up" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px;">
      
      <!-- Students Card -->
      <div class="card purple" onclick="toggleLinks()" style="position: relative;">
        <i class="fas fa-users"></i>
        <h3>Students</h3>
        <span>100</span>
        <!-- Dropdown Link Option -->
        <div id="linkOptions" style="display: none; margin-top: 10px; position: absolute; background: #fff; color: #000; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); z-index: 10;">
          <div onclick="window.location.href='CSP600.jsp'" style="cursor: pointer; padding: 5px 0;">CSP600</div>
          <div onclick="window.location.href='CSP650.jsp'" style="cursor: pointer; padding: 5px 0;">CSP650</div>
        </div>
      </div>

      <!-- Other Cards -->
      <div class="card blue">
        <a href="SupervisorList.jsp">
          <i class="fas fa-chalkboard-teacher"></i>
          <h3>Supervisors</h3>
          <span>100</span>
        </a>
      </div>

      <div class="card yellow">
        <a href="PastReport.jsp">
          <i class="fas fa-tasks"></i>
          <h3>Past Report</h3>
          <span>100</span>
        </a>
      </div>

  </div>

  <!-- Timetable Box -->
  <div class="announcement-container">
    <h4><i class="fas fa-calendar-alt"></i> Lecturer Timetable</h4>
    <div class="table-wrapper">
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
          <tr><td>Monday</td><td>9:00 AM - 11:00 AM</td><td>CSC650</td><td>Group A</td><td>DK1</td></tr>
          <tr><td>Monday</td><td>11:30 AM - 1:30 PM</td><td>CSP500</td><td>5B2</td><td>Lab 3</td></tr>
          <tr><td>Tuesday</td><td>10:00 AM - 12:00 PM</td><td>CSP600</td><td>6B1</td><td>DK3</td></tr>
          <tr><td>Wednesday</td><td>2:00 PM - 4:00 PM</td><td>CSC650</td><td>Group B</td><td>Lab 2</td></tr>
          <tr><td>Thursday</td><td>9:00 AM - 11:00 AM</td><td>CSP500</td><td>5B1</td><td>Lab 4</td></tr>
          <tr><td>Friday</td><td>10:00 AM - 12:00 PM</td><td>CSC650</td><td>Group C</td><td>DK2</td></tr>
          <tr><td>Friday</td><td>2:00 PM - 4:00 PM</td><td>CSP600</td><td>6B1</td><td>Lab 1</td></tr>
        </tbody>
      </table>
    </div>
  </div>


<% } %>

   <% if ("supervisor".equals(userRole)) { %>
<div class="main-content">
  <!-- Welcome -->
  <div class="welcome-info">
    <h2>Welcome, <%= userName %></h2>
    <p><%= displayRole %></p>
  </div>

  <!-- Grid Panels -->
  <div class="dashboard-grid">

    <!-- Announcements Panel -->
    <div class="panel announcements-panel blue">
      <h3>Announcements Panel <span class="icon">&#128276;</span></h3>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Announcement Message</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>17 May</td><td>FYP Briefing Slides have been uploaded</td></tr>
          <tr><td>18 May</td><td>Reminder: FYP(a) submission closes in 2 days</td></tr>
          <tr><td>21 May</td><td>New plagiarism policy: reports over 30% must be flagged</td></tr>
          <tr><td>23 May</td><td>Final Year exhibition schedule released</td></tr>
        </tbody>
      </table>
    </div>
    
    <!-- Summary Cards -->
    <div class="cards grid-cards animate-up" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px;">
      
      <!-- Students Card -->
      <div class="card purple" onclick="toggleLinks()" style="position: relative;">
        <i class="fas fa-users"></i>
        <h3>My Students</h3>
        <span>4</span>
        <!-- Dropdown Link Option -->
        <div id="linkOptions" style="display: none; margin-top: 10px; position: absolute; background: #fff; color: #000; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); z-index: 10;">
          <div onclick="window.location.href='CSP600.jsp'" style="cursor: pointer; padding: 5px 0;">CSP600</div>
          <div onclick="window.location.href='CSP650.jsp'" style="cursor: pointer; padding: 5px 0;">CSP650</div>
        </div>
      </div>

      <!-- Other Cards -->
      <div class="card blue">
        <a href="SupervisorList.jsp">
          <i class="fas fa-chalkboard-teacher"></i>
          <h3>Pending</h3>
          <span>100</span>
        </a>
      </div>
      
           <!-- Other Cards -->
      <div class="card blue">
        <a href="ExaminerList.jsp">
          <i class="fas fa-chalkboard-teacher"></i>
          <h3>Pending</h3>
          <span>100</span>
        </a>
      </div>

  
    <!-- Upcoming Schedule -->
    <div class="panel upcoming-schedule-panel cyan">
      <h3>Upcoming Schedule <span class="icon">&#9200;</span></h3>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Event</th>
            <th>Type</th>
            <th>Student</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>20 May</td><td>FYP(a) Submission Due</td><td>Submission</td><td><a href="#">Nur Aisyah Binti Khalid</a></td></tr>
          <tr><td>21 May</td><td>Progress Review Checkpoint</td><td>Evaluation</td><td>Nurul Huda Binti Firdaus</td></tr>
          <tr><td>22 May</td><td>Proposal Review</td><td>Evaluation</td><td>Siti Nur Aila Binti Rahmah</td></tr>
          <tr><td>25 May</td><td>Plagiarism Verification</td><td>Plagiarism</td><td>Ahmad Faris Bin Zulkifli</td></tr>
        </tbody>
      </table>
    </div>

  </div>
</div>
<% } %>


<% if ("examiner".equals(userRole)) { %>
<div class="main-content">
  
  <!-- Welcome -->
  <div class="welcome-info">
    <h2>Welcome, <%= userName %></h2>
    <p><%= displayRole %></p>
  </div>

  <!-- Grid Panels -->
  <div class="dashboard-grid">

    <!-- Announcements Panel -->
    <div class="panel announcements-panel blue">
      <h3>Announcements Panel <span class="icon">&#128276;</span></h3>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Announcement Message</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>15 May</td><td>Examiner briefing will be held online</td></tr>
          <tr><td>18 May</td><td>Please review marking rubrics for FYP evaluation</td></tr>
          <tr><td>22 May</td><td>Reminder: Upload marks within 3 days after viva</td></tr>
          <tr><td>24 May</td><td>System updated with new evaluation form</td></tr>
        </tbody>
      </table>
    </div>

    <!-- Summary Cards -->
    <div class="cards grid-cards animate-up" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px;">
      
      <!-- Assigned Students -->
      <div class="card purple" onclick="toggleLinks()" style="position: relative;">
        <i class="fas fa-users"></i>
        <h3>Assigned Students</h3>
        <span>3</span>
        <!-- Dropdown Link Option -->
        <div id="linkOptions" style="display: none; margin-top: 10px; position: absolute; background: #fff; color: #000; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); z-index: 10;">
          <div onclick="window.location.href='CSP600.jsp'" style="cursor: pointer; padding: 5px 0;">CSP600</div>
          <div onclick="window.location.href='CSP650.jsp'" style="cursor: pointer; padding: 5px 0;">CSP650</div>
        </div>
      </div>

      <!-- Report History -->
      <div class="card cyan" onclick="window.location.href='PastReport.jsp'">
        <i class="fas fa-folder-open"></i>
        <h3>Past Report</h3>
        <span>6</span>
      </div>
    </div>

    <!-- Upcoming Evaluation Schedule -->
    <div class="panel upcoming-schedule-panel cyan">
      <h3>Upcoming Evaluations <span class="icon">&#9200;</span></h3>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Event</th>
            <th>Student</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>25 June</td><td>Proposal Evaluation</td><td>Ahmad Azim Bin Latif</td><td>Pending</td></tr>
          <tr><td>28 June</td><td>Progress Review</td><td>Fatin Syahirah Bt Mohd</td><td>Scheduled</td></tr>
          <tr><td>1 July</td><td>Final Report Review</td><td>Mohamad Iqbal Bin Isa</td><td>Pending</td></tr>
        </tbody>
      </table>
    </div>

  </div>
</div>

<script>
  function toggleLinks() {
    const links = document.getElementById("linkOptions");
    links.style.display = links.style.display === "block" ? "none" : "block";
  }

  document.addEventListener("click", function(event) {
    const card = document.querySelector(".card.purple");
    const links = document.getElementById("linkOptions");
    if (!card.contains(event.target)) {
      links.style.display = "none";
    }
  });
</script>
<% } %>





    <jsp:include page="sidebarScript.jsp" />
</body>

<script>
        document.addEventListener("DOMContentLoaded", function () {
            // Get the specific dropdown elements for "Review"
            const reviewParentLink = document.querySelector(".review-dropdown .parent-link");
            const reviewSubmenu = document.querySelector(".review-dropdown .submenu");
            const reviewArrow = document.querySelector(".review-dropdown .arrow");

            if (reviewParentLink && reviewSubmenu && reviewArrow) {
                reviewParentLink.addEventListener("click", function (event) {
                    // Prevent default link behavior if parent-link was an <a> tag
                    event.preventDefault();
                    
                    if (reviewSubmenu.style.display === "flex") {
                        reviewSubmenu.style.display = "none";
                        reviewArrow.innerHTML = "&#9662;"; // Down arrow
                    } else {
                        reviewSubmenu.style.display = "flex";
                        reviewArrow.innerHTML = "&#9652;"; // Up arrow
                    }
                });
            }
        });
    </script>
    
</html>
