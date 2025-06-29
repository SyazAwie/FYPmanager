<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");

    if (userName == null || "null".equals(userName)) userName = "User";
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    boolean isSupervisor = "supervisor".equals(userRole);
    boolean isExaminer = "examiner".equals(userRole);
    boolean isAuthorized = isSupervisor || isExaminer;

    if (!isAuthorized) {
        response.sendRedirect("dashboard.jsp?error=unauthorized");
        return;
    }

    String readOnly = isAuthorized ? "" : "readonly";
%>
<!DOCTYPE html>
<html>
<head>
    <title>F12 - Confirmation of Report Correction</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <link rel="stylesheet" href="sidebarStyle.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #4b2e83;
            --secondary: #6d4ac0;
            --light: #f9f7fd;
            --dark: #1a0d3f;
        }
        body {
            font-family: 'Poppins', sans-serif;
        }
        .tabs {
            display: flex;
            border-bottom: 3px solid var(--primary);
            margin: 0 20px;
        }
        .tab-button {
            padding: 12px 25px;
            cursor: pointer;
            border: none;
            background: var(--light);
            color: var(--dark);
            font-weight: bold;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .tab-button.active {
            background: var(--primary);
            color: white;
        }
        .tab-content {
            display: none;
            padding: 25px 30px;
            background: white;
            border-radius: 0 0 12px 12px;
            margin: 0 20px 30px;
        }
        .tab-content.active {
            display: block;
        }
        .form-section {
            display: grid;
            gap: 20px;
            margin-top: 10px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-weight: 600;
            margin-bottom: 5px;
            color: var(--dark);
        }
        .form-group input, .form-group textarea {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group input[readonly] {
            background: #f0f0f0;
        }
        .form-title {
            padding: 20px;
            font-size: 20px;
            font-weight: 600;
            color: var(--dark);
        }
        .submit-btn {
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            float: right;
        }
        .submit-btn:hover {
            background: var(--secondary);
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
    <h2 class="form-title">F12 - Confirmation of Report Correction</h2>

    <div class="tabs">
        <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
        <button class="tab-button" onclick="showTab(event, 'confirmationTab')">Confirmation</button>
    </div>

    <form action="SubmitF12Servlet" method="post">
        <!-- Student Info -->
        <div class="tab-content active" id="studentTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Student Name</label>
                    <input type="text" name="studentName" <%= readOnly %> required>
                </div>
                <div class="form-group">
                    <label>Student ID</label>
                    <input type="text" name="studentId" <%= readOnly %> required>
                </div>
                <div class="form-group">
                    <label>Project Title</label>
                    <input type="text" name="projectTitle" <%= readOnly %> required>
                </div>
            </div>
        </div>

        <!-- Confirmation Tab -->
        <div class="tab-content" id="confirmationTab">
            <div class="form-section">
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="confirmation" value="confirmed" <%= readOnly %> required>
                        I hereby confirm this student has made the necessary amendments to his/her Final Year Project report.
                        The report complies with the requirements for the Computing Sciences Bachelor Degree programme
                        conducted by the Faculty of Computer & Mathematical Sciences. This student may submit his/her final report.
                    </label>
                </div>
                <div class="form-group">
                    <label>Name of Supervisor / Examiner</label>
                    <input type="text" name="supervisorName" value="<%= userName %>" readonly>
                </div>
                <div class="form-group">
                    <label>Date</label>
                    <input type="date" name="dateConfirmed" <%= readOnly %> required>
                </div>
                <% if (isAuthorized) { %>
                <button type="submit" class="submit-btn">Submit</button>
                <% } %>
            </div>
        </div>
    </form>
</div>

<jsp:include page="sidebarScript.jsp" />

<script>
    function showTab(evt, tabId) {
        document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
        evt.currentTarget.classList.add('active');
        document.getElementById(tabId).classList.add('active');
    }

    function showTabById(tabId) {
        document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        const tabBtn = Array.from(document.querySelectorAll('.tab-button'))
            .find(btn => btn.textContent.replace(/\s/g, '').toLowerCase().includes(tabId.replace('Tab', '').toLowerCase()));
        if (tabBtn) tabBtn.classList.add('active');
    }
</script>

</body>
</html>
