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
    boolean isLecturer = "lecturer".equals(userRole);
    boolean isExaminer = "examiner".equals(userRole);

    if (isExaminer) {
        response.sendRedirect("dashboard.jsp?error=unauthorized");
        return;
    }

    String readOnly = isSupervisor ? "" : "readonly";
%>
<!DOCTYPE html>
<html>
<head>
    <title>F4 - Methodology Evaluation</title>
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
        body {
            font-family: 'Poppins', sans-serif;
        }
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
            float: right;
        }
        .next-btn:hover, .submit-btn:hover { background: var(--secondary); }
        .inline-input { display: flex; gap: 10px; align-items: center; }
        .inline-input textarea { flex: 1; height: 80px; }
        .inline-input input[type="number"] { width: 100px; }
        .form-title {
            padding: 20px; font-size: 20px; font-weight: 600; color: var(--dark);
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
    <h2 class="form-title">F4 - Methodology Evaluation Form</h2>

    <div class="tabs">
        <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
        <button class="tab-button" onclick="showTab(event, 'criteriaTab')">Evaluation Criteria</button>
        <button class="tab-button" onclick="showTab(event, 'reviewerTab')">Supervisor Info</button>
    </div>

    <form action="SubmitF4Servlet" method="post">
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
                <div class="form-group">
                    <label>1. Design of Methodology (Weight: 3)</label>
                    <div class="inline-input">
                        <textarea name="designComment" <%= readOnly %>></textarea>
                        <input type="number" id="score1" min="1" max="10" <%= readOnly %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>2. Tools/Techniques Used (Weight: 3)</label>
                    <div class="inline-input">
                        <textarea name="toolsComment" <%= readOnly %>></textarea>
                        <input type="number" id="score2" min="1" max="10" <%= readOnly %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>3. Implementation Feasibility (Weight: 4)</label>
                    <div class="inline-input">
                        <textarea name="feasibilityComment" <%= readOnly %>></textarea>
                        <input type="number" id="score3" min="1" max="10" <%= readOnly %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>Total Marks (out of 100)</label>
                    <input type="number" id="totalScore" name="totalScore" readonly>
                </div>
                <button type="button" class="next-btn" onclick="showTabById('reviewerTab')">Next</button>
            </div>
        </div>

        <!-- Supervisor Info -->
        <div class="tab-content" id="reviewerTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Supervisor Name</label>
                    <input type="text" name="supervisorName" value="<%= userName %>" readonly>
                </div>
                <div class="form-group">
                    <label>Date Scored</label>
                    <input type="date" name="dateScored" <%= readOnly %> required>
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
        const tabs = document.querySelectorAll('.tab-button');
        const contents = document.querySelectorAll('.tab-content');
        tabs.forEach(t => t.classList.remove('active'));
        contents.forEach(c => c.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        evt.currentTarget.classList.add('active');
    }

    function showTabById(tabId) {
        const tabs = document.querySelectorAll('.tab-button');
        const contents = document.querySelectorAll('.tab-content');
        tabs.forEach(t => t.classList.remove('active'));
        contents.forEach(c => c.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        const btn = Array.from(tabs).find(b => b.textContent.replace(/\s/g, '').toLowerCase().includes(tabId.replace('Tab', '').toLowerCase()));
        if (btn) btn.classList.add('active');
    }

    document.addEventListener("input", function () {
        const s1 = parseFloat(document.getElementById('score1').value) || 0;
        const s2 = parseFloat(document.getElementById('score2').value) || 0;
        const s3 = parseFloat(document.getElementById('score3').value) || 0;
        const total = (s1 * 3) + (s2 * 3) + (s3 * 4);
        document.getElementById('totalScore').value = total;
    });
</script>
</body>
</html>
