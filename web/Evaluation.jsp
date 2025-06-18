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
  <meta charset="UTF-8">
  <title>FYP Project Evaluation Form</title>
  <link rel="stylesheet" href="styles.css" />
  <style>
    h2 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 10px;
    }
    .subtitle {
      text-align: center;
      color: #7f8c8d;
      font-size: 14px;
      margin-bottom: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      border-radius: 6px;
      overflow: hidden;
    }
    th, td {
      padding: 12px;
      border-bottom: 1px solid #ddd;
      vertical-align: top;
    }
    th {
      background-color: #2980b9;
      color: white;
      text-align: center;
    }
    input[type="text"], input[type="number"], textarea, select {
      width: 100%;
      padding: 8px;
      margin-top: 4px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
    }
    input[readonly] {
      background-color: #ecf0f1;
      font-weight: bold;
    }
    textarea {
      resize: vertical;
      height: 60px;
    }
    .submit-btn {
      background-color: #27ae60;
      color: white;
      padding: 10px 20px;
      font-weight: bold;
      border: none;
      border-radius: 5px;
      margin-top: 20px;
      cursor: pointer;
    }
    .submit-btn:hover {
      background-color: #1e8449;
    }
    .info-section {
      margin-bottom: 30px;
      padding: 15px;
      background: #fff;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      border-radius: 6px;
    }
    .info-section label {
      font-weight: bold;
      display: inline-block;
      width: 150px;
    }
    .info-section input, .info-section select {
      margin-bottom: 10px;
    }
    .label {
      font-weight: bold;
      font-size: 13px;
      text-align: center;
      color: #2c3e50;
    }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="sidebar.jsp" />

<% if ("student".equals(userRole)) { %>
  <h2>Final Year Project Evaluation</h2>
  <div class="subtitle">FYP Management System</div>

  <div class="info-section">
    <label>Student Name:</label>
    <input type="text" name="studentName" placeholder="e.g. Nurin Danisa Suhaimi"><br>
    <label>Student ID:</label>
    <input type="text" name="studentID" placeholder="e.g. 0111678972"><br>
    <label>Evaluator Name:</label>
    <input type="text" name="evaluatorName" value="Dr. Ahmad Zaki"><br>
    <label>Evaluator Role:</label>
    <select name="evaluatorRole">
      <option value="Supervisor">Supervisor</option>
      <option value="Second Examiner">Second Examiner</option>
      <option value="Panel">Panel</option>
    </select>
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
<% } %>

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
</script>

</body>
</html>
