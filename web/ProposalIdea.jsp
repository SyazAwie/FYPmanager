<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");
    
    // Set default values if null
    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    // Check login/session
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
      --success: #8577e6;
      --warning: #e6c177;
      --danger: #e67777;
      --gray: #7a7d9a;
      --border-radius: 8px;
      --transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.12);
      --shadow-md: 0 4px 6px rgba(26, 13, 63, 0.1);
      --shadow-lg: 0 10px 15px rgba(26, 13, 63, 0.1);
    }

    .card {
      background-color: #fff;
      border-radius: var(--border-radius);
      box-shadow: var(--shadow-lg);
      padding: 2rem;
      border: 1px solid rgba(0, 0, 0, 0.05);
      transition: var(--transition);
      background-color: var(--light);
    }

    .card:hover {
      box-shadow: 0 15px 30px rgba(26, 13, 63, 0.15);
    }

    h1 {
      color: var(--dark);
      font-size: 1.75rem;
      margin-bottom: 1.5rem;
      font-weight: 700;
      position: relative;
      display: inline-block;
    }

    h1:after {
      content: '';
      position: absolute;
      bottom: -8px;
      left: 0;
      width: 50px;
      height: 4px;
      background: var(--primary);
      border-radius: 2px;
    }

    /* Profile Section */
    .profile-info {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 2rem;
      padding: 1rem;
      background-color: white;
      border-radius: var(--border-radius);
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--accent);
    }

    .avatar {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      object-fit: cover;
      border: 3px solid white;
      box-shadow: var(--shadow-sm);
    }

    .student-name {
      font-size: 1.1rem;
      font-weight: 600;
      color: var(--dark);
      margin-bottom: 0.25rem;
    }

    .student-role {
      font-size: 0.85rem;
      color: var(--gray);
      text-transform: capitalize;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .student-role:before {
      content: '';
      display: block;
      width: 6px;
      height: 6px;
      background: var(--accent);
      border-radius: 50%;
      opacity: 0.8;
    }

    /* Form Layout */
    .form-row {
      display: flex;
      gap: 1.5rem;
      margin-bottom: 1.25rem;
    }

    .form-group {
      flex: 1;
      margin-bottom: 0;
      position: relative;
    }

    .half-width {
      flex: 0 0 calc(50% - 0.75rem);
    }

    .full-width {
      width: 100%;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      color: var(--dark);
      font-weight: 500;
      font-size: 0.9rem;
    }

    .form-group input[type="text"] {
      width: 100%;
      padding: 0.75rem 1rem;
      border: 1px solid var(--accent);
      border-radius: var(--border-radius);
      font-size: 0.95rem;
      box-sizing: border-box;
      transition: var(--transition);
      background-color: white;
    }

    .form-group input[type="text"]:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(107, 77, 188, 0.15);
      outline: none;
    }

    .form-group input[readonly] {
      background-color: rgba(179, 153, 212, 0.1);
      border-color: var(--accent);
      color: var(--dark);
      cursor: not-allowed;
    }

    /* Upload Section */
    .upload-section {
      position: relative;
      border: 2px dashed var(--accent);
      border-radius: var(--border-radius);
      padding: 2rem;
      text-align: center;
      transition: var(--transition);
      background-color: white;
      margin-bottom: 1.5rem;
    }

    .upload-section.active {
      border-color: var(--primary);
      background-color: rgba(179, 153, 212, 0.05);
    }

    .upload-section:hover {
      border-color: var(--primary);
      transform: translateY(-2px);
    }

    .upload-content {
      pointer-events: none;
    }

    .upload-icon {
      font-size: 2.5rem;
      color: var(--primary);
      margin-bottom: 1rem;
      display: inline-flex;
      padding: 1rem;
      background-color: var(--light);
      border-radius: 50%;
      box-shadow: var(--shadow-sm);
    }

    .upload-section h3 {
      font-size: 1.1rem;
      margin: 0.5rem 0;
      color: var(--dark);
      font-weight: 600;
    }

    .upload-section p {
      color: var(--gray);
      font-size: 0.85rem;
      margin: 0.5rem 0;
      max-width: 300px;
      margin-left: auto;
      margin-right: auto;
    }

    .upload-section input[type="file"] {
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      opacity: 0;
      cursor: pointer;
    }

    .file-info {
      display: none;
      margin-top: 1rem;
      padding: 0.75rem 1rem;
      background-color: white;
      border-radius: var(--border-radius);
      text-align: left;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--accent);
      animation: fadeIn 0.3s ease-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .file-name {
      color: var(--dark);
      margin-bottom: 0.25rem;
      font-weight: 500;
      font-size: 0.9rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .file-name i {
      color: var(--danger);
    }

    .file-size {
      font-size: 0.75rem;
      color: var(--gray);
    }

    /* Buttons */
    .buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 2.5rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
    }

    .btn {
        padding: 1rem 2rem;
        border: none;
        border-radius: var(--border-radius);
        cursor: pointer;
        font-weight: 600;
        transition: var(--transition);
        font-size: 1rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.75rem;
        min-width: 120px;
    }

    .btn-lg {
        padding: 1.25rem 2.5rem;
        font-size: 1.1rem;
    }

    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(26, 13, 63, 0.15);
    }

    .btn:active {
        transform: translateY(1px);
    }

    .btn-back {
        background-color: white;
        color: var(--gray);
        border: 2px solid var(--accent);
        font-weight: 500;
    }

    .btn-back:hover {
        background-color: var(--light);
        border-color: var(--secondary);
    }

    .btn-update {
        background-color: var(--warning);
        color: var(--dark);
        box-shadow: 0 4px 0 rgba(180, 130, 40, 0.3);
    }

    .btn-update:hover {
        background-color: #e0b05e;
        box-shadow: 0 6px 0 rgba(180, 130, 40, 0.3);
    }

    .btn-delete {
        background-color: var(--danger);
        color: white;
        box-shadow: 0 4px 0 rgba(180, 60, 60, 0.3);
    }

    .btn-delete:hover {
        background-color: #d45e5e;
        box-shadow: 0 6px 0 rgba(180, 60, 60, 0.3);
    }

    .btn-submit {
        background-color: var(--primary);
        color: white;
        box-shadow: 0 4px 0 rgba(55, 30, 110, 0.3);
    }

    .btn-submit:hover {
        background-color: var(--secondary);
        box-shadow: 0 6px 0 rgba(55, 30, 110, 0.3);
    }

    /* Loading animation */
    .btn-submit.loading .spinner {
        display: inline-block;
        width: 1.25rem;
        height: 1.25rem;
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: white;
        animation: spin 1s ease-in-out infinite;
    }

    /* Button icons */
    .btn i {
        font-size: 1.1em;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .form-row {
        flex-direction: column;
        gap: 1rem;
      }

      .half-width {
        flex: 1 1 100%;
      }

      .buttons {
        flex-direction: column;
      }

      .action-buttons {
        order: 1;
        justify-content: space-between;
        width: 100%;
      }

      .btn-back {
        order: 2;
        width: 100%;
        margin-top: 0.5rem;
      }

      .btn-submit {
        order: 3;
        width: 100%;
        margin-top: 0.5rem;
        justify-content: center;
      }
    }

    @media (max-width: 480px) {
      .card {
        padding: 1.5rem;
      }

      h1 {
        font-size: 1.5rem;
      }

      .upload-section {
        padding: 1.5rem;
      }

      .btn {
        padding: 0.65rem 1.25rem;
      }
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
    
    
    <% if ("student".equals(userRole)) { %>
    <div class="main-content">
        <div class="card">
          <h1>Write your proposal here:</h1>

          <div class="profile-info">
            <img src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>" 
                 alt="Avatar" class="avatar">
            <div class="profile-text">
              <div class="student-name"><%= userName %></div>
              <div class="student-role"><%= userRole %></div>
            </div>
          </div>

          <form action="#" method="post" enctype="multipart/form-data">
            <div class="form-row">
              <div class="form-group half-width">
                <label>Full Name:</label>
                <input type="text" value="<%= userName %>" readonly>
              </div>
              <div class="form-group half-width">
                <label>Student ID:</label>
                <input type="text" value="<%= userId %>" readonly>
              </div>
            </div>

            <div class="form-row">
              <div class="form-group half-width">
                <label>Semester:</label>
                <input type="text" readonly>
              </div>
              <div class="form-group half-width">
                <label>Topic:</label>
                <input type="text" required>
              </div>
            </div>

            <div class="form-group full-width">
              <label>Scope:</label>
              <input type="text" required>
            </div>

            <div class="form-group full-width">
              <label>Upload File:</label>
              <div class="upload-section">
                <input type="file" id="upload" name="proposalFile" accept=".pdf" required>
                <div class="upload-content">
                  <i class="fas fa-cloud-upload-alt"></i>
                  <h3>Upload Proposal PDF</h3>
                  <p>Max file size: 10MB</p>
                </div>
                <div class="file-info" id="fileInfo">
                  <div class="file-name"><i class="fas fa-file-pdf"></i> <span id="fileName"></span></div>
                  <div class="file-size">Size: <span id="fileSize"></span></div>
                </div>
              </div>
            </div>

            <div class="buttons">
                <div class="action-buttons">
                    <button class="btn btn-back" onclick="showBackAlert()">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <button class="btn btn-update" onclick="showUpdateAlert()">
                        <i class="fas fa-sync-alt"></i> Update
                    </button>
                    <button class="btn btn-delete" onclick="showDeleteAlert()">
                        <i class="fas fa-trash-alt"></i> Delete
                    </button>
                </div>
                <button class="btn btn-submit btn-lg" onclick="showSuccessAlert()">
                    <i class="fas fa-check-circle"></i> Submit
                </button>
            </div>

          </form>
        </div>
    </div>
    <% } %>
    
    
    
    <jsp:include page="sidebarScript.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function() {
    // Get all necessary elements
    const backBtn = document.querySelector('.main-content .btn-back');
    const updateBtn = document.querySelector('.main-content .btn-update');
    const deleteBtn = document.querySelector('.main-content .btn-delete');
    const submitBtn = document.querySelector('.main-content .btn-submit');
    const fileInput = document.querySelector('.main-content #upload');
    const fileInfo = document.querySelector('.main-content #fileInfo');
    const fileName = document.querySelector('.main-content #fileName');
    const fileSize = document.querySelector('.main-content #fileSize');
    const form = document.querySelector('.main-content form');

    // Back button functionality
    if (backBtn) {
      backBtn.addEventListener('click', function() {
        // You can modify this to match your navigation needs
        window.history.back();
        // Or redirect to a specific page:
        // window.location.href = '/previous-page';
      });
    }

    // Update button functionality
    if (updateBtn) {
      updateBtn.addEventListener('click', function(e) {
        e.preventDefault();
        // Here you would typically validate the form first
        if (validateForm()) {
          // Submit the form with an "update" action
          form.setAttribute('action', '/update-proposal');
          form.submit();
        }
      });
    }

    // Delete button functionality
    if (deleteBtn) {
      deleteBtn.addEventListener('click', function(e) {
        e.preventDefault();
        // Confirm before deleting
        if (confirm('Are you sure you want to delete this proposal?')) {
          // Submit the form with a "delete" action
          form.setAttribute('action', '/delete-proposal');
          form.submit();
        }
      });
    }

    // Submit button functionality
    if (submitBtn) {
      submitBtn.addEventListener('click', function(e) {
        e.preventDefault();
        // Validate form before submission
        if (validateForm()) {
          // Submit the form with the default action
          form.submit();
        }
      });
    }

    // File upload display functionality
    if (fileInput) {
      fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
          const file = this.files[0];

          // Check file type (PDF only)
          if (file.type !== 'application/pdf') {
            alert('Please upload a PDF file only.');
            this.value = '';
            return;
          }

          // Check file size (10MB max)
          if (file.size > 10 * 1024 * 1024) {
            alert('File size exceeds 10MB limit.');
            this.value = '';
            return;
          }

          // Display file info
          fileName.textContent = file.name;
          fileSize.textContent = formatFileSize(file.size);
          fileInfo.style.display = 'block';
        }
      });
    }

    // Form validation function
    function validateForm() {
      let isValid = true;
      const requiredFields = document.querySelectorAll('.main-content input[required]');

      requiredFields.forEach(field => {
        if (!field.value.trim()) {
          isValid = false;
          field.style.borderColor = 'red';

          // Remove error style after user starts typing
          field.addEventListener('input', function() {
            this.style.borderColor = '#ddd';
          });
        }
      });

      // Check if file is uploaded (if required)
      const fileUpload = document.querySelector('.main-content #upload');
      if (fileUpload && fileUpload.required && !fileUpload.files[0]) {
        isValid = false;
        alert('Please upload your proposal file.');
      }

      return isValid;
    }

    // Helper function to format file size
    function formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes';
      const k = 1024;
      const sizes = ['Bytes', 'KB', 'MB', 'GB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }
  });
</script>

<script>
    function showBackAlert() {
        Swal.fire({
            title: 'Are you sure?',
            text: "You'll lose any unsaved changes!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4b2e83',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, go back',
            cancelButtonText: 'Cancel',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                // Add your back navigation logic here
                window.history.back();
            }
        });
    }

    function showUpdateAlert() {
        Swal.fire({
            title: 'Update Record',
            html: `
                <form id="updateForm">
                    <div class="form-group">
                        <label for="updateField">Update Field:</label>
                        <input type="text" id="updateField" class="swal2-input" placeholder="Enter new value">
                    </div>
                </form>
            `,
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#4b2e83',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Update',
            cancelButtonText: 'Cancel',
            preConfirm: () => {
                return {
                    value: document.getElementById('updateField').value
                }
            }
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire(
                    'Updated!',
                    'Your record has been updated.',
                    'success'
                );
                // Add your update logic here
            }
        });
    }

    function showDeleteAlert() {
        Swal.fire({
            title: 'Delete Record?',
            text: "You won't be able to revert this!",
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire(
                    'Deleted!',
                    'Your record has been deleted.',
                    'success'
                );
                // Add your delete logic here
            }
        });
    }

    function showSuccessAlert() {
        const submitBtn = document.querySelector('.btn-submit');
        submitBtn.classList.add('loading');
        submitBtn.innerHTML = '<span class="spinner"></span> Processing...';
        
        // Simulate async operation
        setTimeout(() => {
            Swal.fire({
                title: 'Success!',
                text: 'Your form has been submitted successfully.',
                icon: 'success',
                confirmButtonColor: '#4b2e83',
            }).then(() => {
                submitBtn.classList.remove('loading');
                submitBtn.innerHTML = '<i class="fas fa-check-circle"></i> Submit';
                // Add your submit logic here
            });
        }, 1500);
    }
</script>

</body>
</html>
