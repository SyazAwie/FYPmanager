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

    if (!isSupervisor && !isExaminer) {
        response.sendRedirect("dashboard.jsp?error=unauthorized");
        return;
    }

    String readOnly = isSupervisor ? "" : "readonly";
%>
<!DOCTYPE html>
<html>
<head>
    <title>F9 - Project Progress Presentation</title>
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
            --white: #ffffff;
        }
        body { font-family: 'Poppins', sans-serif; }
        .tabs { display: flex; border-bottom: 3px solid var(--primary); margin: 0 20px; }
        .tab-button {
            padding: 12px 25px; cursor: pointer; border: none;
            background: var(--light); color: var(--dark); font-weight: bold;
            border-top-left-radius: 10px; border-top-right-radius: 10px;
        }
        .tab-button.active { background: var(--primary); color: white; }
        .tab-content {
            display: none; padding: 25px 30px; background: white;
            border-radius: 0 0 12px 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin: 0 20px 30px;
        }
        .tab-content.active { display: block; }
        .form-section { display: grid; gap: 20px; margin-top: 10px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-weight: 600; color: var(--dark); margin-bottom: 5px; }
        .form-group input, .form-group textarea {
            padding: 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px;
        }
        .form-group input[readonly], textarea[readonly] { background: #f0f0f0; }
        .next-btn, .submit-btn {
            background: var(--primary); color: white; padding: 10px 20px;
            border: none; border-radius: 6px; font-weight: bold; cursor: pointer;
            float: right; margin-top: 15px;
        }
        .next-btn:hover, .submit-btn:hover { background: var(--secondary); }
        .form-title {
            padding: 20px; font-size: 20px; font-weight: 600; color: var(--dark);
        }
        table.criteria-table {
            width: 100%; border-collapse: collapse; margin-top: 15px;
        }
        .criteria-table th, .criteria-table td {
            border: 1px solid #ccc; padding: 10px; text-align: center;
        }
        .criteria-table th {
            background-color: var(--primary); color: white;
        }
        .criteria-table input[type="number"] {
            width: 80px; padding: 6px; font-size: 14px;
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
    <h2 class="form-title">F9 - Project Progress Presentation</h2>

    <div class="tabs">
        <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
        <button class="tab-button" onclick="showTab(event, 'criteriaTab')">Evaluation Criteria</button>
        <button class="tab-button" onclick="showTab(event, 'reviewerTab')">Supervisor Info</button>
    </div>

    <form action="SubmitF9Servlet" method="post">
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
                <button type="button" class="next-btn" onclick="showTabById('criteriaTab')">Next</button>
            </div>
        </div>

        <!-- Evaluation Criteria -->
        <div class="tab-content" id="criteriaTab">
            <div class="form-section">
                <table class="criteria-table">
                    <thead>
                        <tr>
                            <th>Assessment Criteria</th>
                            <th>Weight</th>
                            <th>Score (1-10)</th>
                            <th>Marks (W × S)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>Depth of Knowledge</td><td>3</td><td><input type="number" id="score1" min="1" max="10" <%= readOnly %>></td><td><input type="number" id="mark1" readonly></td></tr>
                        <tr><td>Overall Organization of Project Presentation</td><td>1</td><td><input type="number" id="score2" min="1" max="10" <%= readOnly %>></td><td><input type="number" id="mark2" readonly></td></tr>
                        <tr><td>Progress</td><td>4</td><td><input type="number" id="score3" min="1" max="10" <%= readOnly %>></td><td><input type="number" id="mark3" readonly></td></tr>
                        <tr><td>Delivery Skills</td><td>2</td><td><input type="number" id="score4" min="1" max="10" <%= readOnly %>></td><td><input type="number" id="mark4" readonly></td></tr>
                        <tr><th colspan="3">Total Marks</th><td><input type="number" id="totalMarks" name="totalMarks" readonly></td></tr>
                    </tbody>
                </table>
                <button type="button" class="next-btn" onclick="showTabById('reviewerTab')">Next</button>
            </div>
        </div>

        <!-- Reviewer Info -->
        <div class="tab-content" id="reviewerTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Supervisor Name</label>
                    <input type="text" name="supervisorName" value="<%= userName %>" readonly>
                </div>
                <div class="form-group">
                    <label>Evaluation Date</label>
                    <input type="date" name="evaluationDate" <%= readOnly %> required>
                </div>
                <% if (isSupervisor) { %>
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

    // Auto calculate marks (F9 version - 4 criteria only)
    document.addEventListener("input", () => {
        const s1 = parseFloat(document.getElementById('score1').value) || 0;
        const s2 = parseFloat(document.getElementById('score2').value) || 0;
        const s3 = parseFloat(document.getElementById('score3').value) || 0;
        const s4 = parseFloat(document.getElementById('score4').value) || 0;

        const m1 = s1 * 3;
        const m2 = s2 * 1;
        const m3 = s3 * 4;
        const m4 = s4 * 2;

        document.getElementById('mark1').value = m1.toFixed(2);
        document.getElementById('mark2').value = m2.toFixed(2);
        document.getElementById('mark3').value = m3.toFixed(2);
        document.getElementById('mark4').value = m4.toFixed(2);

        const total = m1 + m2 + m3 + m4;
        document.getElementById('totalMarks').value = total.toFixed(2);
    });
</script>

</body>
</html>
