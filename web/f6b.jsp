<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    boolean isSupervisor = "supervisor".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>F6b - Final Report Submission</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <link rel="stylesheet" href="sidebarStyle.css">
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

        .main-content {
            padding: 30px;
        }

        h2 {
            color: var(--dark);
            margin-bottom: 20px;
        }

        .form-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.06);
            padding: 25px 30px;
            margin-bottom: 25px;
        }

        .form-section-title {
            font-weight: 600;
            color: var(--primary);
            font-size: 18px;
            margin-bottom: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: 500;
            margin-bottom: 6px;
            display: block;
            color: var(--dark);
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        input[readonly], textarea[readonly] {
            background-color: #f1f1f1;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 10px;
        }

        .submit-btn {
            background: var(--primary);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-btn:hover {
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

    <!-- Main Content -->
    <div class="main-content">
        <h2>F6b - Final Report Submission</h2>
        <form action="SubmitF6bServlet" method="post">

            <!-- Section: Student Info -->
            <div class="form-card">
                <div class="form-section-title">Student Information</div>
                <div class="form-group">
                    <label>Student Name</label>
                    <input type="text" name="studentName" value="Ali Bin Ahmad" readonly>
                </div>
                <div class="form-group">
                    <label>Student ID</label>
                    <input type="text" name="studentId" value="2022112345" readonly>
                </div>
            </div>

            <!-- Section: Project Info -->
            <div class="form-card">
                <div class="form-section-title">Project Information</div>
                <div class="form-group">
                    <label>Project Title</label>
                    <input type="text" name="projectTitle" value="IoT-Based Farming System" readonly>
                </div>
            </div>

            <!-- Section: Supervisor -->
            <div class="form-card">
                <div class="form-section-title">Supervisor Section</div>
                <div class="form-group">
                    <label>Supervisor Name</label>
                    <input type="text" name="supervisorName" value="<%= userName %>" readonly>
                </div>
                <div class="form-group">
                    <label>Similarity Index (%)</label>
                    <input type="number" name="similarityIndex" min="0" max="100" step="0.1" <%= isSupervisor ? "" : "readonly" %>>
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" name="plagiarismConfirm" value="yes" <%= isSupervisor ? "" : "disabled" %> required>
                    <label>I certify that this Final Year Project report has been screened for plagiarism and the original plagiarism report is enclosed.</label>
                </div>
            </div>

            <% if (isSupervisor) { %>
            <button type="submit" class="submit-btn">Submit Form</button>
            <% } %>
        </form>
    </div>

    <jsp:include page="sidebarScript.jsp" />
</body>
</html>
