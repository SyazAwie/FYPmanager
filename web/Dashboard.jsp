<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    
    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">

   
</head>
<body>
    
    <jsp:include page="sidebar.jsp" />
    
    <!-- Admin Dashboard -->
    <% if ("admin".equals(userRole)) { %>
        <div class="main-content">
            <div class="welcome-info">
                    <h2>Welcome, <%= userName %></h2>
                    <p><%= displayRole %></p>
                </div>
            <!-- Summary Cards -->
            <div class="cards">
                <div class="card purple"><h3>Students</h3><span>100</span></div>
                <div class="card blue"><h3>Supervisors</h3><span>100</span></div>
                <div class="card yellow"><h3>Active FYP Projects</h3><span>100</span></div>
                <div class="card cyan"><h3>Scheduled Presentations</h3><span>100</span></div>
                <div class="card grey"><h3>Submitted Reports</h3><span>100</span></div>
            </div>

            <!-- Widgets -->
            <div class="widgets">
                <div class="widget-box">
                    <h4>Deadline</h4>
                    <p>☑️ Submissions</p>
                    <p>☑️ Presentations</p>
                    <p>🔘 ...</p>
                </div>

                <div class="widget-box">
                    <h4>Recent Activity</h4>
                    <p>🔹 New student registrations</p>
                    <p>🔹 Supervisor feedback</p>
                    <p>🔹 Recent submissions</p>
                </div>
            </div>
             <footer>
            FYP Management System &copy; <%= java.time.Year.now() %> UiTM. All rights reserved.
        </footer>
        </div>
        
    <!-- Announcement Box -->
    <div class="announcement">
        <strong>📢 New Announcement</strong><br>
        <input type="text" placeholder="Type...">
        <button>Publish</button>
    </div>

    <% } %>
    

    
   <!-- Student Dashboard -->
<% if ("student".equals(userRole)) { %>
  <div class="main-content">
    <div class="welcome-info">
      <div class="left-panel">
        <div class="welcome">
          Welcome, <strong><%= userName %></strong>
        </div>

        <div class="cards">
          <div class="card purple"><i class="fas fa-user-graduate"></i> 20 Students</div>
          <div class="card blue"><i class="fas fa-book-open"></i> 20 Topics</div>
          <div class="card yellow"><i class="fas fa-folder-open"></i> 100 Past Reports</div>
          <div class="card supervisor-info">
            <i class="fas fa-chalkboard-teacher"></i> Supervisor Info
            <p><strong>Prof. Muhammad Ali</strong></p>
            <p><a href="mailto:muhdali79@gmail.com">muhdali79@gmail.com</a></p>
            <p><i class="fas fa-phone"></i>&nbsp;+60 123456789</p>
          </div>
        </div>

        <div class="horizontal-chart-box">
          <h2>Project Progress Overview</h2>
          <div class="horizontal-bar-container">
            <div class="horizontal-bar">
              <span class="label">Proposal</span>
              <div class="bar-wrapper"><div class="bar bar-proposal">100%</div></div>
            </div>
            <div class="horizontal-bar">
              <span class="label">Progress</span>
              <div class="bar-wrapper"><div class="bar bar-progress">50%</div></div>
            </div>
            <div class="horizontal-bar">
              <span class="label">Final</span>
              <div class="bar-wrapper"><div class="bar bar-final">10%</div></div>
            </div>
          </div>
        </div>
      </div>

      <div class="right-panel">
        <div class="announcement-container">
          <h2>Announcements</h2>
          <ul>
            <li>📌 Submit proposal by <strong>20 June 2025</strong></li>
            <li>📌 Progress report due <strong>5 July 2025</strong></li>
            <li>📌 Final report window opens <strong>1 August 2025</strong></li>
          </ul>
        </div>

        <div class="announcement-container">
          <h2>Upcoming Deadlines</h2>
          <div class="deadline-grid">
            <div class="deadline-card">
              <h3>Proposal Submission</h3>
              <p>Due: 20 June 2025</p>
              <button onclick="goToSubmission('Proposal')"><i class="fas fa-upload"></i> Submit</button>
            </div>
            <div class="deadline-card">
              <h3>Progress Report</h3>
              <p>Due: 5 July 2025</p>
              <button onclick="goToSubmission('Progress')"><i class="fas fa-upload"></i> Submit</button>
            </div>
            <div class="deadline-card">
              <h3>Final Report</h3>
              <p>Due: 1 August 2025</p>
              <button onclick="goToSubmission('Final')"><i class="fas fa-upload"></i> Submit</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer>
      FYP Management System &copy; <%= java.time.Year.now() %> UiTM. All rights reserved.
    </footer>
  </div>

  <script>
    function goToSubmission(type) {
      let target = '';
      switch (type) {
        case 'Proposal': target = 'submitProposalReport.jsp'; break;
        case 'Progress': target = 'progressReport.jsp'; break;
        case 'Final': target = 'finalReport.jsp'; break;
        default: alert('Invalid submission type.'); return;
      }
      window.location.href = target;
    }
  </script>
<% } %>

    
    <!-- Lecturer Dashboard -->
    <% if ("lecturer".equals(userRole)) { %>
<div class="main-content">
  <div class="welcome-info">
    <h2>Welcome, <%= userName %></h2>
    <p><%= displayRole %></p>
  </div>

  <div class="cards">
    <div class="card"><i class="fas fa-user"></i>20<br>Total Students</div>
    <div class="card"><i class="fas fa-chart-line"></i>20<br>Ongoing Reports</div>
    <div class="card"><i class="fas fa-file"></i>8<br>Total Forms</div>
    <div class="card"><i class="fas fa-tasks"></i>10<br>Ongoing Tasks</div>
  </div>

  <div class="box timetable">
    <h4><i class="fas fa-calendar-alt"></i> Lecturer Timetable</h4>
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
          <td>Monday</td>
          <td>11:30 AM - 1:30 PM</td>
          <td>CSP500</td>
          <td>5B2</td>
          <td>Lab 3</td>
        </tr>
        <tr>
          <td>Tuesday</td>
          <td>10:00 AM - 12:00 PM</td>
          <td>CSP600</td>
          <td>6B1</td>
          <td>DK3</td>
        </tr>
        <tr>
          <td>Wednesday</td>
          <td>2:00 PM - 4:00 PM</td>
          <td>CSC650</td>
          <td>Group B</td>
          <td>Lab 2</td>
        </tr>
        <tr>
          <td>Thursday</td>
          <td>9:00 AM - 11:00 AM</td>
          <td>CSP500</td>
          <td>5B1</td>
          <td>Lab 4</td>
        </tr>
        <tr>
          <td>Friday</td>
          <td>10:00 AM - 12:00 PM</td>
          <td>CSC650</td>
          <td>Group C</td>
          <td>DK2</td>
        </tr>
        <tr>
          <td>Friday</td>
          <td>2:00 PM - 4:00 PM</td>
          <td>CSP600</td>
          <td>6B1</td>
          <td>Lab 1</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="reminders">
    <h4><i class="fas fa-bell"></i> Reminders:</h4>
    <ul>
      <li>Submit FYP2 reports by <strong>20th June 2025</strong>.</li>
      <li>Review student consultation logs before Friday.</li>
      <li>Upload marks for CSP500 latest by next Monday.</li>
    </ul>
  </div>
</div>

<footer>
  FYP Management System &copy; <%= java.time.Year.now() %> UiTM. All rights reserved.
</footer>
<% } %>

    <!-- Supervisor Dashboard -->
   <% if ("supervisor".equals(userRole)) { %>
            <div class="dashboard-body">
                <div class="welcome-info">
                    <h2>Welcome, <%= userName %></h2>
                    <p><%= displayRole %></p>
                </div>

                <div class="dashboard-grid">
                    <div class="panel announcements-panel">
                        <h3>Announcements Panel <span class="icon">&#128276;</span></h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Announcement Message</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>17 May</td>
                                    <td>FYP Briefing Slides have been uploaded</td>
                                </tr>
                                <tr>
                                    <td>18 May</td>
                                    <td>Reminder: FYP (a) submission closes in 2 days</td>
                                </tr>
                                <tr>
                                    <td>21 May</td>
                                    <td>New plagiarism policy: reports over 30% must be flagged</td>
                                </tr>
                                <tr>
                                    <td>23 May</td>
                                    <td>Final Year exhibition schedule released</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="panel my-students-panel summary-box">
                        <h3>My Students</h3>
                        <p>4</p>
                        <span>assigned</span>
                    </div>

                    <div class="panel pending-reviews-panel summary-box">
                        <h3>Pending Reviews</h3>
                        <p>3</p>
                        <span>forms</span>
                    </div>

                    <div class="panel plagiarism-alerts-panel summary-box">
                        <h3>Plagiarism Alerts</h3>
                        <p>1</p>
                        <span>flagged report</span>
                    </div>

                    <div class="panel next-deadline-panel summary-box">
                        <h3>Next Deadline</h3>
                        <p>Proposal Review</p>
                        <span>by 20 May</span>
                    </div>

                    <div class="panel upcoming-schedule-panel">
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
                                <tr>
                                    <td>20 May</td>
                                    <td>FYP(a) Submission Due</td>
                                    <td>Submission</td>
                                    <td><a href="#">Nur Aisyah Binti Khalid</a></td>
                                </tr>
                                <tr>
                                    <td>21 May</td>
                                    <td>Progress Review Checkpoint</td>
                                    <td>Evaluation</td>
                                    <td>Nurul Huda Binti Firdaus</td>
                                </tr>
                                <tr>
                                    <td>22 May</td>
                                    <td>Proposal Review</td>
                                    <td>Evaluation</td>
                                    <td>Siti Nur Aila Binti Rahmah</td>
                                </tr>
                                <tr>
                                    <td>25 May</td>
                                    <td>Plagiarism Verification</td>
                                    <td>Plagiarism</td>
                                    <td>Ahmad Faris Bin Zulkifli</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <footer>
            FYP Management System &copy; <%= java.time.Year.now() %> UiTM. All rights reserved.
        </footer>
            </div>
            
    <% } %>

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