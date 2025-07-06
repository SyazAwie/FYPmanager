<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
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
      .card {
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
        padding: 2.5rem;
        border: 1px solid rgba(0, 0, 0, 0.05);
      }

      h2 {
        color: var(--dark);
        font-size: 1.8rem;
        margin-bottom: 2rem;
        font-weight: 700;
        position: relative;
        padding-bottom: 0.5rem;
      }

      h2:after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 60px;
        height: 4px;
        background: var(--primary);
        border-radius: 2px;
      }

      .form-row {
        display: flex;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
      }

      .form-group {
        margin-bottom: 1.75rem;
        flex: 1;
      }

      .form-group label {
        display: block;
        margin-bottom: 0.75rem;
        color: var(--dark);
        font-weight: 600;
        font-size: 1rem;
      }

      .form-group input[type="text"],
      .form-group select {
        width: 100%;
        padding: 1rem;
        border: 2px solid var(--accent);
        border-radius: 8px;
        font-size: 1rem;
        transition: var(--transition);
        background-color: white;
      }

      .form-group input[type="text"]:focus,
      .form-group select:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(75, 46, 131, 0.1);
        outline: none;
      }

      .form-group input[readonly] {
        background-color: rgba(179, 153, 212, 0.1);
        border-color: var(--accent);
        color: var(--dark);
        cursor: not-allowed;
      }

      .upload-section {
        border: 2px dashed var(--accent);
        border-radius: 12px;
        padding: 2.5rem;
        text-align: center;
        background-color: var(--light);
        transition: var(--transition);
        margin-top: 0.5rem;
      }

      .upload-section:hover {
        border-color: var(--primary);
        background-color: rgba(179, 153, 212, 0.1);
      }

      .upload-icon {
        font-size: 2.5rem;
        color: var(--primary);
        margin-bottom: 1rem;
      }

      .upload-section h3 {
        font-size: 1.2rem;
        margin-bottom: 0.5rem;
        color: var(--dark);
      }

      .upload-section p {
        color: var(--gray);
        font-size: 0.9rem;
      }

      .file-info {
        margin-top: 1rem;
        padding: 1rem;
        background-color: white;
        border-radius: 8px;
        border: 1px solid var(--accent);
        display: none;
      }

      .buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 2.5rem;
        gap: 1rem;
      }

      .action-buttons {
        display: flex;
        gap: 1rem;
      }

      .readonly-field {
        display: flex;
        align-items: center;
        padding: 1rem;
        background-color: var(--light);
        border: 2px solid var(--accent);
        border-radius: 8px;
        color: var(--dark);
        font-weight: 500;
        min-height: 52px;
      }

      .readonly-field i {
        margin-right: 12px;
        color: var(--primary);
        font-size: 1.1rem;
      }

      .readonly-field span {
        flex: 1;
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
    <div class="card">
      <h2>Write your progress report here:</h2>
      <form action="#" method="post" enctype="multipart/form-data">
        <!-- Name & ID -->
        <div class="form-row">
          <div class="form-group">
            <label>Full Name:</label>
            <div class="readonly-field">
              <i class="fas fa-user"></i>
              <input type="text" value="<%= userName %>" readonly>
            </div>
          </div>
          <div class="form-group">
            <label>Student ID:</label>
            <div class="readonly-field">
              <i class="fas fa-id-card"></i>
              <input type="text" value="<%= userId %>" readonly>
            </div>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Semester:</label>
            <div class="readonly-field">
              <i class="fas fa-calendar-alt"></i>
              <input type="text" value="" readonly>
            </div>
          </div>
          <div class="form-group">
            <label>Topic:</label>
            <div class="readonly-field">
              <i class="fas fa-book"></i>
              <input type="text" value="" readonly>
            </div>
          </div>
        </div>

        <!-- Scope dropdown -->
        <div class="form-group">
          <label for="scope">Scope:</label>
          <select id="scope" name="scope" required>
            <option value="">-- Select Chapter --</option>
            <option value="Chapter 1">Chapter 1</option>
            <option value="Chapter 2">Chapter 2</option>
            <option value="Chapter 3">Chapter 3</option>
          </select>
        </div>

        <!-- File Upload -->
        <div class="form-group">
          <label for="upload">Upload File:</label>
          <div class="upload-section">
            <div class="upload-content">
              <i class="fas fa-cloud-upload-alt upload-icon"></i>
              <h3>Drag & Drop Files Here</h3>
              <p>or click to browse (PDF, DOCX, PPTX)</p>
            </div>
            <input type="file" name="proposalFile" id="upload">
          </div>
          <div class="file-info">
            <div class="file-name">
              <i class="fas fa-file-alt"></i>
              <span>No file selected</span>
            </div>
          </div>
        </div>

        <!-- Buttons -->
        <div class="buttons">
          <button type="button" class="btn btn-back" onclick="showBackAlert()">
            <i class="fas fa-arrow-left"></i> Back
          </button>
          <div class="action-buttons">
            <button type="button" class="btn btn-update" onclick="showUpdateAlert()">
              <i class="fas fa-sync-alt"></i> Update
            </button>
            <button type="button" class="btn btn-delete" onclick="showDeleteAlert()">
              <i class="fas fa-trash-alt"></i> Delete
            </button>
          </div>
          <button type="submit" class="btn btn-submit btn-lg">
            <i class="fas fa-check-circle"></i> Submit
          </button>
        </div>
      </form>
    </div>
  </div>

  <jsp:include page="sidebarScript.jsp" />

  <script>
    document.getElementById('upload').addEventListener('change', function(e) {
      const fileInfo = document.querySelector('.file-info');
      const fileName = document.querySelector('.file-name span');
      const file = e.target.files[0];
      
      if (file) {
        fileInfo.style.display = 'block';
        fileName.textContent = file.name;
      } else {
        fileInfo.style.display = 'none';
      }
    });
  </script>

</body>
</html>
