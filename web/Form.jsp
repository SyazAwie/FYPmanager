<%@page import="fyp.model.DB.StudentDB"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.*"%>
<%@ page import="fyp.model.Student" %>
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
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    Map<String, String> roleNames = new HashMap<>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");
    roleNames.put("examiner", "Examiner");

    String displayRole = roleNames.getOrDefault(userRole, "User");

    // Full list of forms
    String[][] allForms = {
        {"F1", "Mutual Acceptance Form", null},
        {"F2", "Project Motivation Form", null},
        {"F3", "Literature Review Evaluation Form", null},
        {"F4", "Methodology Evaluation Form", null},
        {"F5", "Proposal/Project In-Progress Form", null},
        {"F6a", "Project Formulation Report Submission Form", null},
        {"F6b", "Project Report Submission Form", null},
        {"F7", "Project Formulation Presentation Form", null},
        {"F8", "Project Formulation Evaluation Form", null},
        {"F9", "Project Progress Presentation Form", null},
        {"F10", "Final Project Presentation Form", null},
        {"F11", "Final Report Evaluation Form", null},
        {"F12", "Confirmation of Correction Form", null},
        {"F13", "Business Model Evaluation Form", null}
    };
    Student student = StudentDB.getStudentById(userId);
    // Define accessible forms per role
    Set<String> accessibleForms = new HashSet<>();
    switch (userRole) {
        case "student":
            if (student.getCourse_id() == 1) {
             accessibleForms.addAll(Arrays.asList("F1", "F5", "F6a"));
            } else if (student.getCourse_id() == 2) {
             accessibleForms.addAll(Arrays.asList("F6b"));
            } else {
            // Optional fallback untuk testing
             accessibleForms.addAll(Arrays.asList("F1", "F5", "F6a", "F6b"));
              }

            break;
        case "lecturer":
            for (String[] f : allForms) {
                String formCode = f[0];
                if (!Arrays.asList("F7", "F8", "F11", "F12").contains(formCode)) {
                    accessibleForms.add(formCode);
                }
            }
            break;
        case "supervisor":
            accessibleForms.addAll(Arrays.asList("F1", "F5", "F6a", "F6b", "F7", "F8", "F10", "F11", "F12"));
            break;
        case "examiner":
            accessibleForms.addAll(Arrays.asList("F7", "F8", "F10", "F11", "F12"));
            break;
        default:
            accessibleForms.clear(); // no access if role not matched
    }

    // --- START: Get student list for dropdown (if not student) ---
    List<Student> studentList = new ArrayList<>();
    if (!"student".equals(userRole)) {
        switch (userRole) {
            case "lecturer":
                studentList = StudentDB.getStudentsByLecturerId(Integer.parseInt(userId));
                break;
            case "supervisor":
                studentList = StudentDB.getStudentsBySupervisorId(Integer.parseInt(userId));
                break;
            case "examiner":
                studentList = StudentDB.getStudentsByExaminerId(Integer.parseInt(userId));
                break;
            case "admin":
                studentList = StudentDB.getAllStudents();
                break;
        }
    }
    // --- END: Get student list ---
%>

<!DOCTYPE html>
<html>
<head>
    <title>UiTM FYP System</title>
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
            --gray-light: #f5f5f5;
            --gray-medium: #e0e0e0;
            --gray-dark: #757575;
            --success: #4CAF50;
            --info: #2196F3;
        }

        table.form-table {
            width: 90%; margin: 20px auto; border-collapse: collapse;
            background-color: var(--white); border-radius: 12px;
            overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            font-family: 'Segoe UI', sans-serif;
        }

        .form-table th, .form-table td {
            padding: 12px 20px; text-align: left;
        }

        .form-table th {
            background-color: var(--primary); color: var(--white); font-size: 16px;
        }

        .form-table td {
            font-size: 14px; border-bottom: 1px solid var(--gray-light);
        }

        .form-table tr:hover { background-color: var(--light); }
        .form-link { color: var(--dark); font-weight: bold; text-decoration: none; }
        .form-link:hover { text-decoration: underline; }

        .action-icons {
            display: flex; gap: 10px; align-items: center;
        }

        .icon-button {
            padding: 6px 10px; border-radius: 6px; font-size: 14px;
            display: flex; align-items: center; justify-content: center;
            color: white; text-decoration: none; transition: background-color 0.3s ease;
            width: 36px; height: 36px;
        }

        .edit-btn { background-color: var(--success); }
        .edit-btn:hover { background-color: #388e3c; }

        .download-btn { background-color: var(--info); }
        .download-btn:hover { background-color: #1976d2; }

        .automation-placeholder {
            margin: 30px auto; width: 90%;
            background-color: var(--gray-light);
            padding: 15px 20px; border-radius: 8px;
            color: var(--dark); font-weight: 500;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        /* Dropdown styling */
        #studentSelect {
            padding: 6px 12px;
            border-radius: 6px;
            margin-left: 10px;
            font-size: 14px;
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
    <h2 style="padding: 20px; color: var(--dark); font-weight: bold;">Forms and Due Date</h2>
    
    <% if (!"student".equals(userRole)) { %>
    <div style="padding: 0 40px 20px;">
        <label for="studentSelect" style="font-weight: 600;">Select Student:</label>
        
            <option disabled selected>Select a student</option>
            <% for (Student s : studentList) { %>

            <option value="<%= s.getStudent_id() %>"><%= s.getStudent_id() %> - <%= s.getName() %></option>
            <% } %>
        
    </div>
    <% } %>

    <table class="form-table">
        <thead>
            <tr>
                <th>Form ID</th>
                <th>Form Name</th>
                <th>Due Date</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (String[] form : allForms) {
                    String formId = form[0];
                    if (!accessibleForms.contains(formId)) continue;

                    String formName = form[1];
                    String dueDate = form[2];
                    String filename = formId + "Servlet";
            %>
            <tr>
                <td><%= formId %></td>
                <td><a class="form-link" href="<%= filename %>"><%= formName %></a></td>
                <td><%= (dueDate != null) ? dueDate : "<span style='color:#999;'>Pending</span>" %></td>
                <td>
                    <div class="action-icons">
                        <a class="icon-button edit-btn" href="<%= filename %>" title="Edit or Sign Form">
                            <i class="fas fa-pen"></i>
                        </a>
                        <a class="icon-button download-btn" href="DownloadFormServlet?form=<%= formId %>" title="Download PDF">
                            <i class="fas fa-download"></i>
                        </a>
                    </div>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<jsp:include page="sidebarScript.jsp" />
</body>
</html>
