<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    // Ambil dari session
    String userIdString = String.valueOf(session.getAttribute("userId"));
    int userId = Integer.parseInt(userIdString);
    
    String userRole = (String) session.getAttribute("role");
    if (userRole == null || !userRole.equals("admin")) {
        response.sendRedirect("Login.jsp?error=unauthorized");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    
    String userAvatar = (String) session.getAttribute("avatar");
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png"; // fallback kalau tak ada gambar
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
        <title>UiTM FYP System</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="styles.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="stylesheet" href="sidebarStyle.css">
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
            --warning: #FFC107;
            --danger: #F44336;
            --info: #2196F3;
            --sidebar-width: 250px;
            --sidebar-collapsed: 80px;
            --topbar-height: 70px;
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light);
        }

        #sidebar {
            width: var(--sidebar-width);
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            background: var(--primary);
            color: #fff;
            overflow-y: auto;
            transition: width 0.3s;
            z-index: 998;
        }
        #sidebar.collapsed {
            width: var(--sidebar-collapsed);
        }

        #topbar {
            position: fixed;
            top: 0;
            left: var(--sidebar-width);
            width: calc(100% - var(--sidebar-width));
            height: var(--topbar-height);
            background: #fff;
            display: flex;
            align-items: center;
            border-bottom: 1px solid var(--gray-medium);
            z-index: 999;
            transition: left 0.3s, width 0.3s;
        }
        #topbar.collapsed {
            left: var(--sidebar-collapsed);
            width: calc(100% - var(--sidebar-collapsed));
        }

        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--topbar-height);
            padding: 40px;
        }


        .main-content.collapsed {
            margin-left: var(--sidebar-collapsed);
        }


        h1 {
            color: var(--primary);
            border-bottom: 2px solid var(--secondary);
            padding-bottom: 10px;
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            background-color: var(--white);
            border-radius: 15px;
            overflow: hidden;
            border: 1px solid var(--gray-medium);
        }
        th, td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid var(--gray-light);
        }
        th {
            background: var(--primary);
            color: var(--white);
            font-weight: 600;
        }
        tr:nth-child(even) { background-color: var(--gray-light); }
        tr:hover { background-color: var(--accent); opacity: 0.9; }
        .action-buttons { display: flex; gap: 8px; white-space: nowrap; }
        .action-btn { padding: 8px 12px; border-radius: 6px; text-decoration: none; color: var(--white); font-size: 14px; font-weight: 500; display: inline-flex; align-items: center; gap: 5px; transition: var(--transition); }
        .action-btn i { font-size: 14px; }
        .edit-btn { background-color: var(--info); }
        .delete-btn { background-color: var(--danger); }
        .action-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); opacity: 0.9; }
        .add-btn { display: inline-block; width: fit-content; padding: 8px 14px; background-color: var(--success); color: var(--white); text-decoration: none; border-radius: 6px; font-weight: 500; margin-bottom: 20px; transition: var(--transition); }
        .add-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
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

    <div class="main-content" style="display: flex; gap: 20px;">
        <h1>LIST OF STUDENT CSP600</h1>

        <button type="button" class="add-btn" onclick="showAddStudentForm()">
            <i class="fas fa-plus"></i> Add New Student
        </button>


        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Student ID</th>
                    <th>Programme</th>
                    <th>Supervisor</th>
                    <th>Action</th>
                </tr>
            </thead>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<tbody>
    <c:forEach var="student" items="${studentList}">
        <tr>
            <td>${student.name}</td>
            <td>${student.studentId}</td>
            <td>${student.programme}</td>
            <td>${student.supervisorName}</td>
            <td>
                <div class="action-buttons">
                    <a href="#" class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</a>
                    <a href="#" class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</a>
                </div>
            </td>
        </tr>
    </c:forEach>
</tbody>
        </table>
    </div>
   
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const sidebar = document.getElementById("sidebar");
            const topbar = document.getElementById("topbar");
            const container = document.querySelector(".main-content");
            const toggleBtn = document.getElementById("sidebarToggle");

        if (toggleBtn && sidebar && topbar && container) {
            toggleBtn.addEventListener("click", function () {
                sidebar.classList.toggle("collapsed");
                topbar.classList.toggle("collapsed");
                container.classList.toggle("collapsed");
            });
        }
        });
        

function showAddStudentForm() {
    Swal.fire({
        title: 'Add New Student',
        html:
            '<form id="studentForm" action="StudentListServlet" method="post">' +
                '<input name="student_id" class="swal2-input" placeholder="Student ID" required>' +
                '<input name="name" class="swal2-input" placeholder="Full Name" required>' +
                '<input name="email" class="swal2-input" placeholder="Email" type="email" required>' +
                '<input name="phoneNum" class="swal2-input" placeholder="Phone Number" required>' +
                '<input name="semester" class="swal2-input" placeholder="Semester" required>' +
                '<input name="intake" class="swal2-input" placeholder="Intake" required>' +
                '<input name="course_id" class="swal2-input" value="1" readonly>' +
                '<button type="submit" class="swal2-confirm swal2-styled" style="display:inline-block; margin-top:10px;">Submit</button>' +
            '</form>',
        showConfirmButton: false, // disable default OK button
        focusConfirm: false,
        didOpen: () => {
            const form = document.getElementById('studentForm');
            form.addEventListener('submit', () => {
                Swal.showLoading(); // optional loading state
            });
        }
    });
}



    </script>
        <jsp:include page="sidebarScript.jsp" />

</body>
</html>