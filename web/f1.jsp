<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if (userName == null || "null".equals(userName)) userName = "User";
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userAvatar == null || "null".equals(userAvatar) || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    boolean isEditable = "student".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>F1 - Mutual Acceptance Form</title>
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
            --accent: #b399d4;
            --light: #f9f7fd;
            --dark: #1a0d3f;
            --white: #ffffff;
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
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group input:disabled, .form-group textarea:disabled {
            background: #f0f0f0;
            color: #555;
            cursor: not-allowed;
        }
        .action-area {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .action-btn {
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }
        .action-btn:hover {
            background: var(--secondary);
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

    <div class="main-content">
        <h2 style="padding: 20px; color: var(--dark); font-weight: bold;">F1 - Mutual Acceptance Form</h2>

        <!-- Tabs -->
        <div class="tabs">
            <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
            <button class="tab-button" onclick="showTab(event, 'supervisorTab')">Supervisor Info</button>
            <button class="tab-button" onclick="showTab(event, 'projectTab')">Project Info</button>
            <button class="tab-button" onclick="showTab(event, 'agreementTab')">Agreement</button>
        </div>

        <!-- Tab Contents -->
        <form action="F1Servlet" method="post">
            <!-- Student Tab -->
            <div class="tab-content active" id="studentTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Student Name</label>
                        <input type="text" value="${studentName}"  name="studentName" <%= isEditable ? "" : "disabled" %> >
                    </div>
                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="text" value="${studentId}" name="studentId" <%= isEditable ? "" : "disabled" %> >
                    </div>
                    <div class="form-group">
                        <label>Programme</label>
                        <input type="text" value="${programme}" name="programme" <%= isEditable ? "" : "disabled" %>>
                    </div>
                    <div class="action-area">
                        <button type="button" class="action-btn" onclick="showTabById('supervisorTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Supervisor Tab -->
            <div class="tab-content" id="supervisorTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Supervisor Name</label>
                        <input type="text" value="${supervisorName}" name="supervisorName" <%= isEditable ? "" : "disabled" %>>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="${supervisorEmail}" name="supervisorEmail" <%= isEditable ? "" : "disabled" %>>
                    </div>
                    <div class="action-area">
                        <button type="button" class="action-btn" onclick="showTabById('projectTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Project Tab -->
            <div class="tab-content" id="projectTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Project Title</label>
                        <input type="text" value="${projectTitle}"  name="projectTitle" <%= isEditable ? "" : "disabled" %>>
                    </div>
                    <div class="form-group">
                        <label>Project Description</label>
                        <textarea name="projectDescription" rows="4" <%= isEditable ? "" : "disabled" %>>${projectDescription}</textarea>
                    </div>
                    <div class="action-area">
                        <button type="button" class="action-btn" onclick="showTabById('agreementTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Agreement Tab -->
            <div class="tab-content" id="agreementTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Agreement Statement</label>
                        <textarea rows="1" disabled>
                I hereby confirm that I agree to the responsibilities and expectations outlined above for this Final Year Project.
                        </textarea>
                    </div>
                    <% if (isEditable) { %>
                    <div class="form-group">
                        <label>Student Signature</label>
                        <input type="text" name="studentSignature" required>
                    </div>
                    <div class="action-area">
                        <button type="submit" class="action-btn">Submit Form</button>
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

            tabs.forEach(btn => btn.classList.remove('active'));
            contents.forEach(content => content.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            evt.currentTarget.classList.add('active');
        }

        function showTabById(tabId) {
            const tabs = document.querySelectorAll('.tab-button');
            const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(btn => btn.classList.remove('active'));
            contents.forEach(content => content.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            const btn = Array.from(tabs).find(b => b.textContent.includes(tabId.replace('Tab', '')));
            if (btn) btn.classList.add('active');
        }
    </script>
</body>
</html>
