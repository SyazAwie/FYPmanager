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

    boolean isEditable = "lecturer".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>F3 - Literature Review Evaluation</title>
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
            transition: background 0.3s;
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
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
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
            color: var(--dark);
            margin-bottom: 5px;
        }

        .form-group input, .form-group textarea {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input[readonly], textarea[readonly] {
            background: #f0f0f0;
        }

        .next-btn, .submit-btn {
        background: var(--primary);
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-weight: bold;
        cursor: pointer;
        }

        .next-btn:hover, .submit-btn:hover {
        background: var(--secondary);
        }

        .form-title {
            padding: 20px;
            font-size: 20px;
            font-weight: 600;
            color: var(--dark);
        }

        .criteria-row {
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }

        .criteria-row textarea {
            flex: 1;
            height: 80px;
        }

        .criteria-row input[type="number"] {
            width: 80px;
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
    <h2 class="form-title">F3 - Literature Review Evaluation</h2>

    <div class="tabs">
        <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
        <button class="tab-button" onclick="showTab(event, 'criteriaTab')">Evaluation Criteria</button>
        <button class="tab-button" onclick="showTab(event, 'reviewerTab')">Reviewer Info</button>
    </div>

    <form action="SubmitF3Servlet" method="post">
        <!-- Student Info -->
        <div class="tab-content active" id="studentTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Student Name</label>
                    <input type="text" name="studentName" <%= isEditable ? "" : "readonly" %> required>
                </div>
                <div class="form-group">
                    <label>Student ID</label>
                    <input type="text" name="studentId" <%= isEditable ? "" : "readonly" %> required>
                </div>
                <div class="form-group">
                    <label>Project Title</label>
                    <input type="text" name="projectTitle" <%= isEditable ? "" : "readonly" %> required>
                </div>
                <div class="submit-area">
                <button type="button" class="next-btn" onclick="showTabById('criteriaTab')">Next</button>
                </div>
                </div>
        </div>

        <!-- Evaluation Criteria -->
        <div class="tab-content" id="criteriaTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Literature Reviewed (Relevance & Quality) - 40%</label>
                    <div class="criteria-row">
                        <textarea name="literatureComment" <%= isEditable ? "" : "readonly" %>></textarea>
                        <input type="number" id="score1" min="0" max="10" <%= isEditable ? "" : "readonly" %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>Critical Analysis - 40%</label>
                    <div class="criteria-row">
                        <textarea name="analysisComment" <%= isEditable ? "" : "readonly" %>></textarea>
                        <input type="number" id="score2" min="0" max="10" <%= isEditable ? "" : "readonly" %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>Clarity of Review - 20%</label>
                    <div class="criteria-row">
                        <textarea name="clarityComment" <%= isEditable ? "" : "readonly" %>></textarea>
                        <input type="number" id="score3" min="0" max="5" <%= isEditable ? "" : "readonly" %>>
                    </div>
                </div>
                <div class="form-group">
                    <label>Total Marks (%)</label>
                    <input type="text" id="totalScore" name="totalScore" readonly>
                </div>
                    <div class="submit-area">
                <button type="button" class="next-btn" onclick="showTabById('reviewerTab')">Next</button>
                    </div>
                    </div>
        </div>

        <!-- Reviewer Info -->
        <div class="tab-content" id="reviewerTab">
            <div class="form-section">
                <div class="form-group">
                    <label>Lecturer Name</label>
                    <input type="text" name="lecturerName" value="<%= userName %>" readonly>
                </div>
                <div class="form-group">
                    <label>Remarks</label>
                    <textarea name="remarks" rows="4" <%= isEditable ? "" : "readonly" %>></textarea>
                </div>
                <% if (isEditable) { %>
                <div class="submit-area">
                <button type="submit" class="submit-btn">Submit</button>
                </div>
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
        const weighted = (s1 * 4 + s2 * 4 + s3 * 4) / 10;
        document.getElementById('totalScore').value = weighted.toFixed(2);
    });
</script>
</body>
</html>
