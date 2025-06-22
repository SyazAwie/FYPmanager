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
        /* Add this container to wrap your proposal card */
        .proposal-card-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
        }
        
        .proposal-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 30px;
            position: relative;
            overflow: hidden;
            margin: 0 auto; /* Center horizontally */
            position: relative;
            top: 50%; /* Position for vertical centering */
            transform: translateY(-50%); /* Complete vertical centering */
        }
        
        /* Keep all your existing styles below */
        .proposal-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            position: relative;
        }
        
        .proposal-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            border-radius: 2px;
        }
        
        .profile-info {
            display: flex;
            align-items: center;
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .profile-info:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            border-color: #3498db;
        }
        
        .avatar-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #3498db;
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.2);
        }
        
        .profile-text {
            margin-left: 20px;
        }
        
        .student-name {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .student-name i {
            color: #3498db;
            margin-right: 8px;
        }
        
        .student-role {
            font-size: 16px;
            color: #7f8c8d;
            background: #e9f7fe;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-weight: 500;
        }
        
        .upload-section {
            margin-bottom: 25px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 1px dashed #3498db;
        }
        
        .upload-label {
            display: block;
            text-align: center;
            padding: 15px;
            background: #e9f7fe;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .upload-label:hover {
            background: #d1edfb;
        }
        
        .upload-label i {
            font-size: 32px;
            color: #3498db;
            margin-bottom: 10px;
        }
        
        .upload-text {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .upload-subtext {
            font-size: 14px;
            color: #7f8c8d;
        }
        
        #fileInput {
            display: none;
        }
        
        .file-info {
            display: none;
            margin-top: 15px;
            padding: 15px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        
        .file-info.active {
            display: block;
        }
        
        .file-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .file-size {
            font-size: 14px;
            color: #7f8c8d;
        }
        
        .btn-group {
            display: flex;
            justify-content: space-between;
            gap: 15px;
        }
        
        .btn {
            flex: 1;
            padding: 16px 20px;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            border: none;
            outline: none;
        }
        
        .btn-view {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
        }
        
        .btn-view:hover {
            background: linear-gradient(135deg, #2980b9 0%, #3498db 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.3);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
        }
        
        .btn-submit:hover {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.3);
        }
        
        .decoration {
            position: absolute;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            z-index: -1;
            opacity: 0.1;
        }
        
        .dec-1 {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            top: -60px;
            right: -60px;
        }
        
        .dec-2 {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            bottom: -80px;
            left: -80px;
        }
        
        @media (max-width: 576px) {
            .proposal-card {
                padding: 25px 20px;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .profile-info {
                flex-direction: column;
                text-align: center;
            }
            
            .profile-text {
                margin-left: 0;
                margin-top: 15px;
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
    <div class="proposal-card-container">
    <div class="proposal-card">
        <div class="decoration dec-1"></div>
        <div class="decoration dec-2"></div>
        
        <div class="proposal-title">My Proposal</div>
        
        <div class="profile-info">
            <img src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>" 
                        alt="Avatar" style="width:35px; height:35px; border-radius:50%; object-fit:cover;" />
            <div class="profile-text">
                <div class="student-name"><i class="fas fa-user"></i> <strong><%= userName %></strong></div>
                <div class="student-role"><%= userRole %>"</div>
            </div>
        </div>
        
        <div class="upload-section">
            <label for="fileInput" class="upload-label">
                <i class="fas fa-cloud-upload-alt"></i>
                <div class="upload-text">Upload Proposal PDF</div>
                <div class="upload-subtext">Max file size: 10MB</div>
            </label>
            <input type="file" id="fileInput" accept=".pdf">
            
            <div class="file-info" id="fileInfo">
                <div class="file-name"><i class="fas fa-file-pdf"></i> <span id="fileName"></span></div>
                <div class="file-size">Size: <span id="fileSize"></span></div>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="#" class="btn btn-view" id="viewBtn">
                <i class="fas fa-eye"></i> View
            </a>
            <a href="#" class="btn btn-submit" id="submitBtn">
                <i class="fas fa-paper-plane"></i> Submit
            </a>
        </div>
    </div>
    </div>
    </div>
    <% } %>
    <jsp:include page="sidebarScript.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // File upload functionality
        document.getElementById('fileInput').addEventListener('change', function(e) {
            if (this.files.length > 0) {
                const file = this.files[0];
                
                // Validate file type
                if (file.type !== 'application/pdf') {
                    Swal.fire({
                        title: 'Invalid File Type',
                        text: 'Please upload a PDF file only',
                        icon: 'error',
                        confirmButtonColor: '#e74c3c'
                    });
                    this.value = '';
                    return;
                }
                
                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    Swal.fire({
                        title: 'File Too Large',
                        text: 'Maximum file size is 10MB',
                        icon: 'error',
                        confirmButtonColor: '#e74c3c'
                    });
                    this.value = '';
                    return;
                }
                
                // Show confirmation dialog
                Swal.fire({
                    title: 'Confirm Upload',
                    html: `
                        <p>Are you sure you want to upload this file?</p>
                        <div style="text-align: left; margin-top: 15px; background: #f8f9fa; padding: 12px; border-radius: 8px;">
                            <p><i class="fas fa-file-pdf"></i> <strong>${file.name}</strong></p>
                            <p>Size: ${formatFileSize(file.size)}</p>
                        </div>
                    `,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3498db',
                    cancelButtonColor: '#7f8c8d',
                    confirmButtonText: 'Yes, upload it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Simulate upload process
                        Swal.fire({
                            title: 'Uploading...',
                            text: 'Please wait while we upload your file',
                            timer: 2000,
                            timerProgressBar: true,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        }).then(() => {
                            // Show success message
                            Swal.fire({
                                title: 'Upload Successful!',
                                text: 'Your proposal has been uploaded',
                                icon: 'success',
                                confirmButtonColor: '#2ecc71'
                            });
                            
                            // Update file info display
                            document.getElementById('fileInfo').classList.add('active');
                            document.getElementById('fileName').textContent = file.name;
                            document.getElementById('fileSize').textContent = formatFileSize(file.size);
                            
                            // Enable view button
                            document.getElementById('viewBtn').href = URL.createObjectURL(file);
                        });
                    } else {
                        // Clear file input if cancelled
                        this.value = '';
                    }
                });
            }
        });
        
        // View button functionality
        document.getElementById('viewBtn').addEventListener('click', function(e) {
            if (!this.href || this.href === '#') {
                e.preventDefault();
                Swal.fire({
                    title: 'No File Available',
                    text: 'Please upload a proposal first',
                    icon: 'info',
                    confirmButtonColor: '#3498db'
                });
            }
        });
        
        // Submit button functionality
        document.getElementById('submitBtn').addEventListener('click', function(e) {
            e.preventDefault();
            
            if (!document.getElementById('viewBtn').href || document.getElementById('viewBtn').href === '#') {
                Swal.fire({
                    title: 'No Proposal Uploaded',
                    text: 'Please upload your proposal before submitting',
                    icon: 'warning',
                    confirmButtonColor: '#3498db'
                });
                return;
            }
            
            Swal.fire({
                title: 'Submit Proposal',
                html: `
                    <p>Are you sure you want to submit your proposal?</p>
                    <div style="text-align: left; margin-top: 15px; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <p><i class="fas fa-check-circle" style="color:#2ecc71;"></i> Please ensure all information is correct</p>
                        <p><i class="fas fa-check-circle" style="color:#2ecc71;"></i> Verify the document is complete</p>
                    </div>
                `,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#2ecc71',
                cancelButtonColor: '#e74c3c',
                confirmButtonText: 'Yes, submit now!',
                cancelButtonText: 'Review again',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading state
                    Swal.fire({
                        title: 'Submitting...',
                        text: 'Please wait while we process your proposal',
                        timer: 2000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    }).then(() => {
                        // Submit success
                        Swal.fire({
                            title: 'Submitted!',
                            text: 'Your proposal has been submitted for review',
                            icon: 'success',
                            confirmButtonColor: '#2ecc71',
                            confirmButtonText: 'Continue'
                        });
                    });
                }
            });
        });
        
        // Helper function to format file size
        function formatFileSize(bytes) {
            if (bytes < 1024) return bytes + ' bytes';
            else if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
            else return (bytes / 1048576).toFixed(1) + ' MB';
        }
    </script>
</body>
</html>
