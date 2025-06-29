<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.Statement, java.sql.ResultSet" %>

<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    // Set default values if null
    if (userName == null || "null".equals(userName)) {
        userName = "User";
    }
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userAvatar == null || "null".equals(userAvatar) || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
  <style>
        :root {
            /* Primary Colors */
            --primary: #4b2e83;       /* Dark Purple (UiTM Brand) */
            --secondary: #6d4ac0;     /* Medium Purple */
            --accent: #b399d4;        /* Light Purple */
            
            /* Neutral Colors */
            --light: #f9f7fd;         /* Very Light Purple (Background) */
            --dark: #1a0d3f;          /* Very Dark Purple (Text) */
            --white: #ffffff;         /* Pure White */
            --gray-light: #f5f5f5;    /* Light Gray */
            --gray-medium: #e0e0e0;   /* Medium Gray */
            --gray-dark: #757575;     /* Dark Gray */
            
            /* Status Colors */
            --success: #4CAF50;       /* Green */
            --warning: #FFC107;       /* Amber */
            --danger: #F44336;        /* Red */
            --info: #2196F3;         /* Blue */
            
            /* Component Colors */
            --sidebar-width: 250px;
            --sidebar-collapsed: 70px;
            --topbar-height: 70px;
            --transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--light);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            color: var(--primary);
            border-bottom: 2px solid var(--secondary);
            padding-bottom: 10px;
            margin-top: 30px;
        }
        
        /* Table styling */
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
            padding: 15px 12px;
        }
        tr:nth-child(even) {
            background-color: var(--gray-light);
        }
        tr:hover {
            background-color: var(--accent);
            opacity: 0.9;
        }
        th:first-child {
            border-top-left-radius: 10px;
        }
        th:last-child {
            border-top-right-radius: 10px;
        }
        
        /* Action buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
            white-space: nowrap;
        }
        .action-btn {
            padding: 8px 12px;
            border-radius: 6px;
            text-decoration: none;
            color: var(--white);
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: var(--transition);
        }
        .action-btn i {
            font-size: 14px;
        }
        .edit-btn {
            background-color: var(--info);
        }
        .delete-btn {
            background-color: var(--danger);
        }
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            opacity: 0.9;
        }
        
        /* Add new student button */
        .add-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--success);
            color: var(--white);
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            margin-bottom: 20px;
            transition: var(--transition);
        }
        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
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

    <div class="container">
        <h1>LIST OF STUDENT CSP650</h1>
        
        <a href="addStudent.jsp?programme=CSP650" class="add-btn">
            <i class="fas fa-plus"></i> Add New Student
        </a>
        
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
            <tbody>
                <%
                    // Database connection parameters
                    String url = "jdbc:mysql://localhost:3306/fyp_system";
                    String username = "root";
                    String password = "";
                    
                    try {
                        // Load JDBC driver
                        Class.forName("com.mysql.jdbc.Driver");
                        
                        // Establish connection
                        Connection conn = DriverManager.getConnection(url, username, password);
                        
                        // Create statement
                        Statement stmt = conn.createStatement();
                        
                        // Execute query for CSP650 students
                        String query = "SELECT * FROM students WHERE programme = 'CDCS230' AND course = 'CSP650'";
                        ResultSet rs = stmt.executeQuery(query);
                        
                        // Display results
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("student_id") %></td>
                    <td><%= rs.getString("programme") %></td>
                    <td><%= rs.getString("supervisor") %></td>
                    <td>
                        <div class="action-buttons">
                            <a href="EditStudentServlet?id=<%= rs.getString("student_id") %>&course=CSP650" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStudentServlet?id=<%= rs.getString("student_id") %>&course=CSP650" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this student?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                        }
                        
                        // Close connections
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        // Fallback to dummy data if database connection fails
                %>
                <!-- Dummy Data (will be removed when database works) -->
                <tr>
                    <td>Muhammad Alman Hakim Bin Roslan</td>
                    <td>2023260248</td>
                    <td>CDCS230</td>
                    <td>Prof. Muhammad Ali</td>
                    <td>
                        <div class="action-buttons">
                            <a href="EditStudentServlet?id=2023260248&course=CSP650" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStudentServlet?id=2023260248&course=CSP650" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this student?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Siti Aisyah Binti Zulkifli</td>
                    <td>2023260357</td>
                    <td>CDCS230</td>
                    <td>Dr. Nurul Huda binti Kamaruddin</td>
                    <td>
                        <div class="action-buttons">
                            <a href="EditStudentServlet?id=2023260357&course=CSP650" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStudentServlet?id=2023260357&course=CSP650" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this student?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Muhammad Faris Bin Rahman</td>
                    <td>2023260412</td>
                    <td>CDCS230</td>
                    <td>Madam Tan Mei Ling</td>
                    <td>
                        <div class="action-buttons">
                            <a href="EditStudentServlet?id=2023260412&course=CSP650" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStudentServlet?id=2023260412&course=CSP650" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this student?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Nurul Izzati Binti Hassan</td>
                    <td>2023260521</td>
                    <td>CDCS230</td>
                    <td>Encik Ahmad Zaki bin Osman</td>
                    <td>
                        <div class="action-buttons">
                            <a href="EditStudentServlet?id=2023260521&course=CSP650" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStudentServlet?id=2023260521&course=CSP650" class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this student?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>