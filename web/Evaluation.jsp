<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    // Set default values if null
    if (userName == null || "null".equals(userName)) {
        userName = "User";
    }
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userAvatar == null || "null".equals(userAvatar) || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
  <style>
      .main-content h2 {
        color: var(--primary);
        font-size: 1.75rem;
        margin-bottom: 0.5rem;
        font-weight: 700;
        letter-spacing: -0.5px;
      }

      .main-content .subtitle {
        color: var(--gray);
        font-size: 1rem;
        margin-bottom: 2rem;
        font-weight: 500;
      }

      .info-section {
        background-color: var(--light);
        padding: 1.5rem;
        border-radius: var(--border-radius);
        margin-bottom: 2rem;
        border: 1px solid var(--gray-light);
      }

      .info-section label {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--dark);
        font-weight: 500;
        font-size: 0.95rem;
      }

      .info-section input[type="text"],
      .info-section select {
        width: 100%;
        padding: 0.75rem 1rem;
        margin-bottom: 1.25rem;
        border: 1px solid var(--gray-light);
        border-radius: var(--border-radius);
        font-size: 0.95rem;
        transition: var(--transition);
        background-color: white;
      }

      .info-section input[type="text"]:focus,
      .info-section select:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(107, 77, 188, 0.1);
        outline: none;
      }

      .info-section input[type="text"]::placeholder {
        color: var(--accent);
        opacity: 0.7;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        margin: 2rem 0;
        background-color: white;
        border-radius: var(--border-radius);
        overflow: hidden;
        box-shadow: var(--shadow-sm);
      }

      th {
        background-color: var(--primary);
        color: white;
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        font-size: 0.95rem;
      }

      td {
        padding: 1.25rem;
        border-bottom: 1px solid var(--gray-light);
        vertical-align: top;
      }

      td strong {
        color: var(--dark);
        font-weight: 600;
      }

      td small {
        color: var(--gray);
        font-size: 0.85rem;
        display: block;
        margin-top: 0.5rem;
        line-height: 1.4;
      }

      input[type="number"] {
        width: 60px;
        padding: 0.5rem 0.75rem;
        border: 1px solid var(--gray-light);
        border-radius: var(--border-radius);
        font-size: 0.95rem;
        transition: var(--transition);
      }

      input[type="number"]:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(107, 77, 188, 0.1);
        outline: none;
      }

      .label {
        font-weight: 500;
        font-size: 0.9rem;
        color: var(--dark);
        min-width: 80px;
      }

      textarea {
        width: 100%;
        min-height: 80px;
        padding: 0.75rem;
        border: 1px solid var(--gray-light);
        border-radius: var(--border-radius);
        font-family: inherit;
        font-size: 0.95rem;
        transition: var(--transition);
        resize: vertical;
      }

      textarea:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(107, 77, 188, 0.1);
        outline: none;
      }

      .submit-btn {
        background-color: var(--primary);
        color: white;
        border: none;
        padding: 0.875rem 1.75rem;
        border-radius: var(--border-radius);
        font-weight: 600;
        font-size: 1rem;
        cursor: pointer;
        transition: var(--transition);
        display: block;
        margin: 2rem auto 0;
        width: 100%;
        max-width: 300px;
      }

      .submit-btn:hover {
        background-color: var(--secondary);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(107, 77, 188, 0.2);
      }

      /* Score label colors */
      .label[data-score="10"],
      .label[data-score="9"] {
        color: #2e7d32; /* Excellent */
      }

      .label[data-score="8"],
      .label[data-score="7"] {
        color: #689f38; /* Good */
      }

      .label[data-score="6"],
      .label[data-score="5"] {
        color: #fbc02d; /* Average */
      }

      .label[data-score="4"],
      .label[data-score="3"] {
        color: #ff8f00; /* Weak */
      }

      .label[data-score="2"],
      .label[data-score="1"],
      .label[data-score="0"] {
        color: #d32f2f; /* Poor */
      }
      
      input[readonly], select[readonly] {
        background-color: #f5f5f5;
        color: #555;
        cursor: not-allowed;
        border-color: #e0e0e0;
      }

      /* Make readonly select look like a disabled field */
      select[readonly] {
        pointer-events: none;
        appearance: none;
      }

      /* Responsive adjustments */
      @media (max-width: 768px) {
        .main-content {
          padding: 1.5rem;
        }

        table {
          display: block;
          overflow-x: auto;
        }

        th, td {
          padding: 0.75rem;
          min-width: 150px;
        }

        .submit-btn {
          max-width: 100%;
        }
      }

      @media (max-width: 480px) {
        .main-content {
          padding: 1.25rem;
          margin: 1rem auto;
        }

        .main-content h2 {
          font-size: 1.5rem;
        }

        .info-section {
          padding: 1rem;
        }
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

<% if ("supervisor".equals(userRole)) { %>
<div class="main-content">
  <h2>Final Year Project Evaluation</h2>
  <div class="subtitle">FYP Management System</div>

  <div class="info-section">
  <label>Student Name:</label>
  <input type="text" name="studentName" value="" readonly>
  
  <label>Student ID:</label>
  <input type="text" name="studentID" value="" readonly>
  
  <label>Evaluator Name:</label>
  <input type="text" name="evaluatorName" value="<%= userName%>" readonly>
  
  <label>Evaluator Role:</label>
  <input type="text" name="evaluatorName" value="<%= displayRole %>" readonly>
</div>

  <table>
    <tr>
      <th>Section</th>
      <th>Marks ( /10 )</th>
      <th>Label</th>
      <th>Feedback</th>
    </tr>
    <tr>
      <td><strong>Proposal Evaluation</strong><br><small>Problem statement, objectives, scope & background study</small></td>
      <td><input type="number" min="0" max="10" oninput="setLabel(this.value, 'label1')"></td>
      <td class="label" id="label1"></td>
      <td><textarea placeholder="Comment on proposal quality..."></textarea></td>
    </tr>
    <tr>
      <td><strong>Progress Evaluation</strong><br><small>Tasks completed according to Gantt chart, consultation</small></td>
      <td><input type="number" min="0" max="10" oninput="setLabel(this.value, 'label2')"></td>
      <td class="label" id="label2"></td>
      <td><textarea placeholder="Comment on progress and effort..."></textarea></td>
    </tr>
    <tr>
      <td><strong>System Functionality</strong><br><small>Working modules, interface design, logic, usability</small></td>
      <td><input type="number" min="0" max="10" oninput="setLabel(this.value, 'label3')"></td>
      <td class="label" id="label3"></td>
      <td><textarea placeholder="Comment on system functions..."></textarea></td>
    </tr>
    <tr>
      <td><strong>Final Report</strong><br><small>Structure, content clarity, formatting, references</small></td>
      <td><input type="number" min="0" max="10" oninput="setLabel(this.value, 'label4')"></td>
      <td class="label" id="label4"></td>
      <td><textarea placeholder="Comment on report quality..."></textarea></td>
    </tr>
    <tr>
      <td><strong>Presentation & Delivery</strong><br><small>Confident, clear communication, visual aid</small></td>
      <td><input type="number" min="0" max="10" oninput="setLabel(this.value, 'label5')"></td>
      <td class="label" id="label5"></td>
      <td><textarea placeholder="Comment on presentation..."></textarea></td>
    </tr>
  </table>

  <button class="submit-btn">Submit Evaluation</button>
</div> 
<% } %>

<jsp:include page="sidebarScript.jsp" />
<script>
function setLabel(value, labelId) {
  let label = "";
  const score = parseInt(value);
  if (!isNaN(score)) {
    if (score >= 9) label = "Excellent";
    else if (score >= 7) label = "Very Good";
    else if (score >= 5) label = "Satisfactory";
    else if (score >= 3) label = "Weak";
    else label = "Poor";
  }
  document.getElementById(labelId).textContent = label;
}

// Sample function to set labels based on score (frontend)
function setLabel(score, elementId) {
  const label = document.getElementById(elementId);
  label.textContent = getScoreLabel(score);
  label.setAttribute('data-score', score);
}

function getScoreLabel(score) {
  if (score >= 9) return 'Excellent';
  if (score >= 7) return 'Good';
  if (score >= 5) return 'Average';
  if (score >= 3) return 'Weak';
  return 'Poor';
}
</script>

</body>
</html>
