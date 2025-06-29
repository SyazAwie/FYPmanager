<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%@ page import="fyp.model.User" %>
<%@ page import="fyp.model.Student" %>
<%@ page import="fyp.model.Supervisor" %>
<%@ page import="fyp.model.Project_Idea" %>
<%@ page import="java.util.*" %>
<%@ page isELIgnored="false" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    User user = (User) request.getAttribute("user");
    Student student = (Student) request.getAttribute("profile");
    List<Supervisor> matchingSupervisors = (List<Supervisor>) session.getAttribute("matchingSupervisors");
    Project_Idea existingProposal = (Project_Idea) request.getAttribute("existingProposal");

    // Initialize default values
    String userName = "User";
    String userId = "";
    int semester = 0;
    String userRole = (String) session.getAttribute("role");
    String userAvatar = (String) session.getAttribute("avatar");

    // Safely handle user data
    if (user != null) {
        userName = user.getName() != null ? user.getName() : userName;
        userId = String.valueOf(user.getUser_id());
    }
    
    if (student != null) {
        semester = student.getSemester();
    }

    // Session validation
    if (userId.isEmpty() || userRole == null) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
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
    
    .alert {
        padding: 1rem;
        margin-bottom: 1.5rem;
        border-radius: var(--border-radius);
        font-weight: 500;
        box-shadow: var(--shadow-sm);
    }
    
    .alert.success {
        background-color: rgba(133, 119, 230, 0.1);
        color: var(--success);
        border: 1px solid rgba(133, 119, 230, 0.3);
    }
    
    .alert.error {
        background-color: rgba(230, 119, 119, 0.1);
        color: var(--danger);
        border: 1px solid rgba(230, 119, 119, 0.3);
    }

    
    .current-proposal {
    font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
    max-width: 100%;
    margin: 1.5rem 0;
    background: var(--light);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow-lg);
    overflow: hidden;
    border: 1px solid var(--accent);
    transition: var(--transition);
}

.current-proposal:hover {
    box-shadow: 0 15px 30px rgba(26, 13, 63, 0.15);
    transform: translateY(-3px);
}

.proposal-details {
    padding: 1.5rem 2rem;
}

.detail-row {
    display: flex;
    padding: 1rem 0;
    border-bottom: 1px solid rgba(179, 153, 212, 0.3);
    align-items: center;
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    flex: 0 0 180px;
    font-weight: 600;
    color: var(--gray);
    font-size: 0.9rem;
    letter-spacing: 0.3px;
}

.detail-value {
    flex: 1;
    color: var(--dark);
    font-size: 1rem;
    line-height: 1.5;
    display: flex;
    align-items: center;
    gap: 10px;
}

.detail-value .fas {
    color: var(--danger);
    font-size: 1.2rem;
}

.file-info {
    font-size: 0.85rem;
    color: var(--gray);
    margin-left: 8px;
    font-style: italic;
}

/* Status colors using your variables */
.detail-value.draft {
    color: var(--warning);
    font-weight: 500;
}

.detail-value.submitted {
    color: var(--secondary);
    font-weight: 500;
}

.detail-value.approved {
    color: var(--success);
    font-weight: 500;
}

.detail-value.rejected {
    color: var(--danger);
    font-weight: 500;
}

.detail-value.review {
    color: var(--primary);
    font-weight: 500;
}

/* Hover effects */
.detail-row:hover {
    background-color: rgba(179, 153, 212, 0.05);
}

/* Responsive design */
@media (max-width: 768px) {
    .detail-row {
        flex-direction: column;
        align-items: flex-start;
        gap: 0.5rem;
        padding: 1.2rem 0;
    }
    
    .detail-label {
        flex: none;
        width: 100%;
        font-size: 0.8rem;
    }
    
    .detail-value {
        flex: none;
        width: 100%;
    }
    
    .proposal-details {
        padding: 1.25rem;
    }
}

@media (max-width: 480px) {
    .current-proposal {
        margin: 1rem 0;
    }
    
    .proposal-details {
        padding: 1rem;
    }
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
          <h1><%= existingProposal != null ? "Your Current Proposal" : "Write your proposal here" %></h1>

          <!-- Display success/error messages -->
          <% if (request.getAttribute("success") != null) { %>
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
          <% } %>
          
          <% if (request.getAttribute("error") != null) { %>
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
          <% } %>

          <!-- Display current proposal details if exists -->
          <% if (existingProposal != null) { %>
            <div class="current-proposal">
                <div class="proposal-details">
                    <div class="detail-row">
                        <span class="detail-label">Title</span>
                        <span class="detail-value"><%= existingProposal.getTitle() %></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Scope</span>
                        <span class="detail-value"><%= existingProposal.getScope() %></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Status</span>
                        <span class="detail-value <%= existingProposal.getStatus().toLowerCase() %>">
                            <%= existingProposal.getStatus() %>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Submitted File</span>
                        <span class="detail-value">
                            <i class="fas fa-file-pdf"></i> 
                            <%= existingProposal.getDescription() %>
                            <% if (request.getAttribute("fileSize") != null) { %>
                                <span class="file-info"><%= request.getAttribute("fileSize") %></span>
                            <% } %>
                        </span>
                    </div>
                </div>
            </div>
        <div class="divider"></div>
          <% } %>

          <div class="profile-info">
            <img src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>" 
                 alt="Avatar" class="avatar">
            <div class="profile-text">
              <div class="student-name"><%= userName %></div>
              <div class="student-role"><%= userRole %></div>
            </div>
          </div>

        <form action="ProposalServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= existingProposal != null ? "update" : "submit" %>">
            
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
                <input type="text" value="<%= semester %>" readonly>
              </div>
              <div class="form-group half-width">
                <label>Topic:</label>
                <input type="text" name="title" value="<%= existingProposal != null ? existingProposal.getTitle() : "" %>" required>
              </div>
            </div>

            <div class="form-group full-width">
                <label>Scope:</label>
                <select name="scope" required>
                  <option value="">-- Select Scope --</option>
                  <% 
                  String[] scopes = {
                    "Artificial Intelligence", "Data Science & Analytics", "Cybersecurity",
                    "Web Development", "Mobile App Development", "Internet of Things (IoT)",
                    "Cloud Computing", "Blockchain", "Game Development", "Robotics & Automation",
                    "Computer Vision", "Natural Language Processing", "Software Engineering",
                    "Networking", "Human-Computer Interaction", "Educational Technology"
                  };
                  
                  for (String scopeOption : scopes) {
                      boolean selected = existingProposal != null && scopeOption.equals(existingProposal.getScope());
                  %>
                    <option value="<%= scopeOption %>" <%= selected ? "selected" : "" %>>
                      <%= scopeOption %>
                    </option>
                  <% } %>
                </select>
            </div>

            <div class="form-group full-width">
              <label>Upload File:</label>
              <div class="upload-section">
                  <input type="hidden" name="studentId" value="<%= userId %>">
                <input type="file" id="upload" name="proposalFile" accept=".pdf" <%= existingProposal == null ? "required" : "" %>>
                <div class="upload-content">
                  <i class="fas fa-cloud-upload-alt"></i>
                  <h3><%= existingProposal != null ? "Upload New Version" : "Upload Proposal PDF" %></h3>
                  <p>Max file size: 10MB</p>
                </div>
                <div class="file-info" id="fileInfo" style="<%= existingProposal != null ? "display:block" : "display:none" %>">
                  <div class="file-name">
                    <i class="fas fa-file-pdf"></i> 
                    <span id="fileName"><%= existingProposal != null ? existingProposal.getDescription() : "" %></span>
                  </div>
                  <div class="file-size">
                    Size: <span id="fileSize"><%= request.getAttribute("fileSize") != null ? request.getAttribute("fileSize") : "" %></span>
                  </div>
                </div>
                <% if (existingProposal != null) { %>
                  <p class="file-note">Leave empty to keep current file</p>
                <% } %>
              </div>
            </div>

            <div class="buttons">
                <div class="action-buttons">
                    <% if (existingProposal != null) { %>
                      <button type="button" class="btn btn-delete" onclick="confirmDelete()">
                          <i class="fas fa-trash-alt"></i> Delete
                      </button>
                    <% } %>
                </div>
                <button type="submit" class="btn btn-submit btn-lg">
                    <i class="fas fa-check-circle"></i> <%= existingProposal != null ? "Update Proposal" : "Submit Proposal" %>
                </button>
            </div>
          </form>
        </div>
    </div>
    <% } %>
    
    <jsp:include page="sidebarScript.jsp" />
    
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // File upload display functionality
        const fileInput = document.getElementById('upload');
        const fileInfo = document.getElementById('fileInfo');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        
        if (fileInput) {
            fileInput.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    const file = this.files[0];

                    if (file.type !== 'application/pdf') {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid File Type',
                            text: 'Please upload a PDF file only.'
                        });
                        this.value = '';
                        return;
                    }

                    if (file.size > 10 * 1024 * 1024) {
                        Swal.fire({
                            icon: 'error',
                            title: 'File Too Large',
                            text: 'File size exceeds 10MB limit.'
                        });
                        this.value = '';
                        return;
                    }

                    fileName.textContent = file.name;
                    fileSize.textContent = formatFileSize(file.size);
                    fileInfo.style.display = 'block';
                }
            });
        }

        // Form validation
        const form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function(e) {
                const title = document.querySelector('input[name="title"]');
                const scope = document.querySelector('select[name="scope"]');
                
                if (!title.value.trim()) {
                    e.preventDefault();
                    title.style.borderColor = 'red';
                    Swal.fire({
                        icon: 'error',
                        title: 'Missing Field',
                        text: 'Please enter a topic title'
                    });
                }
                
                if (!scope.value) {
                    e.preventDefault();
                    scope.style.borderColor = 'red';
                    Swal.fire({
                        icon: 'error',
                        title: 'Missing Field',
                        text: 'Please select a scope'
                    });
                }
            });
        }
    });

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

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
                window.history.back();
            }
        });
    }

    function confirmDelete() {
        Swal.fire({
            title: 'Delete Proposal?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                // Create a hidden form for deletion
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'ProposalServlet';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'action';
                input.value = 'delete';
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }
</script>
</body>
</html>
