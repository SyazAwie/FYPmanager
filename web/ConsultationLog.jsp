<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    boolean designMode = true;
    String userId = designMode ? "123" : String.valueOf(session.getAttribute("userId"));
    String userRole = designMode ? "student" : (String) session.getAttribute("role");
    String userName = designMode ? "Test User" : (String) session.getAttribute("userName");
    String userAvatar = designMode ? "default.png" : (String) session.getAttribute("avatar");

    if (!designMode && (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole))) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userName == null || "null".equals(userName)) userName = "User";
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) userAvatar = "default.png";

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
  <title>UiTM FYP System</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="styles.css">
  <link rel="stylesheet" href="sidebarStyle.css">
  <style>
    .main-content .content {
      padding: 30px;
      background: var(--light);
      min-height: calc(100vh - 70px);
    }

    h2 {
      margin-top: 0;
      color: var(--primary);
      text-align: center;
    }

    .btn-new {
      background-color: #4CAF50; /* Changed to green */
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: bold;
      margin-bottom: 15px;
      transition: background-color 0.3s;
    }

    .btn-new:hover {
      background-color: #45a049; /* Darker green on hover */
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    th, td {
      border: 1px solid var(--gray-medium);
      padding: 12px;
      text-align: center;
    }

    thead tr {
      background-color: var(--primary);
    }

    th {
      background-color: var(--primary);
      color: var(--white);
      font-weight: 600;
      text-transform: uppercase;
      font-size: 14px;
      letter-spacing: 0.5px;
    }

    tbody tr:hover {
      background-color: var(--gray-light);
    }

    td.actions i {
      cursor: pointer;
      margin: 0 5px;
      color: var(--primary);
    }

    td.actions i:hover {
      color: var(--secondary);
    }

    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0; top: 0; width: 100%; height: 100%;
      background: rgba(0,0,0,0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background: white;
      padding: 20px 30px;
      border-radius: 8px;
      width: 400px;
      max-width: 90%;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }

    .modal-content h3 {
      margin-top: 0;
      color: var(--primary);
      text-align: center;
    }

    .modal-content label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }

    .modal-content input, .modal-content textarea {
      width: 100%;
      padding: 8px 10px;
      margin-top: 5px;
      border: 1px solid var(--gray-medium);
      border-radius: 6px;
      resize: vertical;
    }

    .modal-content button {
      margin-top: 20px;
      padding: 10px 20px;
      background-color: var(--primary);
      border: none;
      color: white;
      border-radius: 6px;
      cursor: pointer;
      font-weight: bold;
    }

    .modal-content button:hover {
      background-color: var(--secondary);
    }

    .modal-close {
      float: right;
      font-size: 1.2em;
      font-weight: bold;
      cursor: pointer;
      color: var(--gray-dark);
    }

    .modal-close:hover {
      color: var(--primary);
    }
  </style>
</head>
<body>
  <header id="topbar">
    <jsp:include page="topbar.jsp" />
  </header>

  <aside id="sidebar">
    <jsp:include page="navbar.jsp" />
  </aside>

  <div id="sidebarOverlay"></div>

  <div class="main-content">
    <div class="content">
      <h2><i class="fas fa-calendar-plus"></i> Consultation Request</h2>
      <button class="btn-new" onclick="openModal()">
        <i class="fas fa-plus"></i> New Request
      </button>

      <table>
        <thead>
          <tr>
            <th>No</th>
            <th>Requested Date</th>
            <th>Requested Time</th>
            <th>Note</th>
            <th>Status</th>
            <th>Supervisor Comment</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <!-- Dummy data for presentation -->
          <tr>
            <td>1</td>
            <td>2025-06-20</td>
            <td>09:00 AM</td>
            <td>Request for supervisor meeting</td>
            <td><span style="color: orange;">Pending</span></td>
            <td>-</td>
            <td class="actions">
              <i class="fas fa-trash" title="Cancel Request" onclick="cancelRequest(1)"></i>
            </td>
          </tr>
          <tr>
            <td>2</td>
            <td>2025-06-22</td>
            <td>11:00 AM</td>
            <td>Progress discussion for FYP</td>
            <td><span style="color: green;">Approved</span></td>
            <td>See you on time</td>
            <td class="actions">
              <i class="fas fa-trash" title="Cancel Request" onclick="cancelRequest(2)"></i>
            </td>
          </tr>

          <!-- Existing loop from database -->
          <c:forEach var="log" items="${consultations}" varStatus="i">
            <tr>
              <td>${i.index + 1}</td>
              <td>${log.date}</td>
              <td>${log.time}</td>
              <td>${log.note}</td>
              <td><span style="color: ${log.statusColor}">${log.status}</span></td>
              <td>${log.comment}</td>
              <td class="actions">
                <i class="fas fa-trash" title="Cancel Request" onclick="cancelRequest(${log.id})"></i>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

  <div class="modal" id="requestModal">
    <div class="modal-content">
      <span class="modal-close" onclick="closeModal()">&times;</span>
      <h3><i class="fas fa-calendar-plus"></i> New Consultation Request</h3>
      <form action="SubmitConsultationRequestServlet" method="post" onsubmit="return validateForm()">
        <label for="requestDate">Date</label>
        <input type="date" id="requestDate" name="requestDate" required>

        <label for="requestTime">Time</label>
        <input type="time" id="requestTime" name="requestTime" required>

        <label for="note">Note</label>
        <textarea id="note" name="note" rows="3" required></textarea>

        <button type="submit">Submit Request</button>
      </form>
    </div>
  </div>

  <jsp:include page="sidebarScript.jsp" />
  <script>
    function openModal() {
      document.getElementById('requestModal').style.display = 'flex';
    }
    function closeModal() {
      document.getElementById('requestModal').style.display = 'none';
    }
    function cancelRequest(id) {
      if (confirm("Are you sure you want to cancel this consultation request?")) {
        alert("Request ID " + id + " cancelled.");
      }
    }
    function validateForm() {
      const date = document.getElementById('requestDate').value;
      const time = document.getElementById('requestTime').value;
      const note = document.getElementById('note').value.trim();
      if (!date || !time || !note) {
        alert('Please fill in all fields');
        return false;
      }
      return true;
    }
  </script>
</body>
</html>