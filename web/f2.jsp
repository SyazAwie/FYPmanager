<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");

    if (userName == null || "null".equals(userName)) userName = "User";
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    boolean canEdit = "lecturer".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>F2 - Project Motivation Form</title>
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

        .form-group input,
        .form-group textarea {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input[readonly],
        .form-group textarea[readonly] {
            background-color: #f0f0f0;
        }

        .submit-area {
            text-align: right;
            margin-top: 20px;
        }

        .submit-btn, .btn-next {
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-btn:hover, .btn-next:hover {
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
        <h2 style="padding: 20px; color: var(--dark); font-weight: bold;">F2 - Project Motivation Form</h2>

        <!-- Tabs -->
        <div class="tabs">
            <button class="tab-button active" onclick="showTab(event, 'studentTab')">Student Info</button>
            <button class="tab-button" onclick="showTab(event, 'projectTab')">Project Info</button>
            <button class="tab-button" onclick="showTab(event, 'assessmentTab')">Assessment</button>
            <button class="tab-button" onclick="showTab(event, 'lecturerTab')">Lecturer Remarks</button>
        </div>

        <form action="SubmitF2Servlet" method="post">
            <!-- Student Info -->
            <div class="tab-content active" id="studentTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Student Name</label>
                        <input type="text" name="studentName" value="Ali Bin Ahmad" readonly>
                    </div>
                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="text" name="studentId" value="2021123456" readonly>
                    </div>
                    <div class="submit-area">
                        <button type="button" class="btn-next" onclick="goToTab('projectTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Project Info -->
            <div class="tab-content" id="projectTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Project Title</label>
                        <input type="text" name="projectTitle" value="Smart Farming with IoT" readonly>
                    </div>
                    <div class="submit-area">
                        <button type="button" class="btn-next" onclick="goToTab('assessmentTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Assessment -->
            <div class="tab-content" id="assessmentTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Originality (weight 0.4)</label>
                        <input type="number" id="score1" onchange="calculateMark(1, 0.4)" <%= canEdit ? "" : "readonly" %>>
                        <input type="text" id="mark1" class="total-field" readonly>
                    </div>
                    <div class="form-group">
                        <label>Relevance (weight 0.3)</label>
                        <input type="number" id="score2" onchange="calculateMark(2, 0.3)" <%= canEdit ? "" : "readonly" %>>
                        <input type="text" id="mark2" class="total-field" readonly>
                    </div>
                    <div class="form-group">
                        <label>Feasibility (weight 0.3)</label>
                        <input type="number" id="score3" onchange="calculateMark(3, 0.3)" <%= canEdit ? "" : "readonly" %>>
                        <input type="text" id="mark3" class="total-field" readonly>
                    </div>
                    <div class="form-group">
                        <label>Total Marks</label>
                        <input type="text" id="totalMarks" class="total-field" readonly>
                    </div>
                    <div class="submit-area">
                        <button type="button" class="btn-next" onclick="goToTab('lecturerTab')">Next</button>
                    </div>
                </div>
            </div>

            <!-- Lecturer Remarks -->
            <div class="tab-content" id="lecturerTab">
                <div class="form-section">
                    <div class="form-group">
                        <label>Lecturer Name</label>
                        <input type="text" name="lecturerName" value="<%= userName %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Remarks</label>
                        <textarea name="remarks" rows="4" <%= canEdit ? "" : "readonly" %>></textarea>
                    </div>
                </div>
                <% if (canEdit) { %>
                <div class="submit-area">
                    <button type="submit" class="submit-btn">Submit Form</button>
                </div>
                <% } %>
            </div>
        </form>
    </div>

    <jsp:include page="sidebarScript.jsp" />

    <script>
        function showTab(evt, tabId) {
            const tabs = document.querySelectorAll('.tab-button');
            const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(btn => btn.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            evt.currentTarget.classList.add('active');
        }

        function goToTab(tabId) {
            const tabs = document.querySelectorAll('.tab-button');
            const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(btn => {
                if (btn.getAttribute('onclick').includes(tabId)) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });

            contents.forEach(c => c.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
        }

        function calculateMark(num, weight) {
            const score = parseInt(document.getElementById('score' + num).value);
            const markField = document.getElementById('mark' + num);
            if (!isNaN(score)) {
                markField.value = (score * weight).toFixed(2);
            } else {
                markField.value = '';
            }
            calculateTotal();
        }

        function calculateTotal() {
            const m1 = parseFloat(document.getElementById('mark1').value) || 0;
            const m2 = parseFloat(document.getElementById('mark2').value) || 0;
            const m3 = parseFloat(document.getElementById('mark3').value) || 0;
            document.getElementById('totalMarks').value = (m1 + m2 + m3).toFixed(2);
        }
    </script>
</body>
</html>
