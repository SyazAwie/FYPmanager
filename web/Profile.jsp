<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fyp.model.User" %>
<%@ page import="fyp.model.Student" %>
<%@ page import="fyp.model.Lecturer" %>
<%@ page import="fyp.model.Supervisor" %>
<%@ page import="fyp.model.Admin" %>
<%@ page import="fyp.model.Examiner" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    // Get attributes from request
    User user = (User) request.getAttribute("user");
    Map<String, Object> profiles = (Map<String, Object>) request.getAttribute("profiles");
    List<String> userRoles = (List<String>) request.getAttribute("userRoles");
    String currentRole = (String) request.getAttribute("currentRole");
    Object profile = request.getAttribute("profile");

    // Initialize user data variables with empty defaults
    String userAvatar = "";
    String userName = "";
    String email = "";
    String phone = "";
    String userId = "";

    // Handle user data
    if (user != null) {
        userAvatar = user.getAvatar() != null ? user.getAvatar() : "";
        userName = user.getName() != null ? user.getName() : "";
        email = user.getEmail() != null ? user.getEmail() : "";
        phone = user.getPhoneNum() != null ? user.getPhoneNum() : "";
        userId = String.valueOf(user.getUser_id());
    } else {
        response.sendRedirect("error.jsp?error=userNotFound");
        return;
    }

    // Initialize role-specific objects
    Student student = null;
    Lecturer lecturer = null;
    Supervisor supervisor = null;
    Admin admin = null;
    Examiner examiner = null;

    // Get the profile object based on current role
    if (currentRole != null && profile != null) {
        switch (currentRole.toLowerCase()) {
            case "student":
                student = (Student) profile;
                break;
            case "lecturer":
                lecturer = (Lecturer) profile;
                break;
            case "supervisor":
                supervisor = (Supervisor) profile;
                break;
            case "admin":
                admin = (Admin) profile;
                break;
            case "examiner":
                examiner = (Examiner) profile;
                break;
        }
    } else {
        response.sendRedirect("error.jsp?error=roleNotFound");
        return;
    }
%>


<!DOCTYPE html>
<html>
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
        .button-group button {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.3s ease;
        }

        /* Edit Profile button - Green */
        #editButton {
            background-color: #28a745; /* Bootstrap-style green */
            color: white;
        }

        #editButton:hover {
            background-color: #218838;
        }

        /* Save Changes button - Slightly different green */
        #saveButton {
            background-color: #20c997; /* Teal green */
            color: white;
        }

        #saveButton:hover {
            background-color: #17a2b8;
        }

        /* Cancel button - Red */
        #cancelButton {
            background-color: #dc3545; /* Bootstrap-style red */
            color: white;
        }

        #cancelButton:hover {
            background-color: #c82333;
        }

        /* New styles for compact form */
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 10px;
        }

        .form-group {
            flex: 1;
            min-width: 0;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
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

         
        <!-- Student Profile Section -->
        <% if ("student".equalsIgnoreCase(currentRole)) { %>
        <div class="main-content">
            <div class="profile-container">
                <div class="profile">
                    <h2>Welcome</h2>

                    <!-- Combined Form -->
                    <form id="profileForm" action="UpdateProfile" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="user_id" value="<%= userId %>">
                        <input type="hidden" id="delete_avatar_flag" name="delete_avatar" value="false">

                        <!-- Avatar Section -->
                        <div class="profile-photo">
                            <img id="profileImg"
                                 src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>"
                                 alt="User Avatar"
                                 style="width:100px; height:100px; border-radius:50%; object-fit:cover;">

                            <div id="uploadButtonGroup" style="display: none; margin-top: 10px; text-align:center;">
                                <input type="file" id="photoInput" name="avatar" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
                                <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
                                <button type="button" class="delete-photo" onclick="confirmDelete()">Delete Picture</button>
                            </div>
                        </div>

                        <!-- Profile Info -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="full-name">Full Name</label>
                                <input type="text" id="full-name" name="full-name" value="<%= userName %>" disabled>
                            </div>

                            <div class="form-group">
                                <label for="student-id">Student ID</label>
                                <input type="text" id="student-id" name="student-id" value="<%= student.getStudent_id() %>" disabled>
                            </div>
                        </div>

                        <div class="form-group">
                            <%  String selectedCourse = String.valueOf(student.getCourse_id());  %>
                            <label for="course">Course</label>
                            <select id="course" name="course" disabled>
                                <option value="600" <%= "1".equals(selectedCourse) ? "selected" : "" %>>CSP600</option>
                                <option value="650" <%= "2".equals(selectedCourse) ? "selected" : "" %>>CSP650</option>
                            </select>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="<%= email %>" disabled>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="<%= phone %>" disabled>
                            </div>
                        </div>

                        <!-- Password Fields -->
                        <div class="form-group password-field" style="display:none;">
                            <label for="current-password">Current Password</label>
                            <input type="password" id="current-password" name="current-password" placeholder="Enter current password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="new-password">New Password</label>
                            <input type="password" id="new-password" name="new-password" placeholder="Enter new password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="confirm-password">Confirm Password</label>
                            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password">
                        </div>

                        <!-- Action Buttons -->
                        <div class="button-group">
                            <button type="button" id="editButton">Edit Profile</button>
                            <button type="button" id="saveButton" style="display:none;">Save Changes</button>
                            <button type="button" id="cancelButton" style="display:none;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>                
             <!-- Lecturer Profile Section -->
        <% if ("lecturer".equalsIgnoreCase(currentRole)) { %>
        <div class="main-content">
            <div class="profile-container">
                <div class="profile">
                    <h2>Welcome</h2>

                    <!-- Combined Form -->
                    <form id="profileForm" action="UpdateProfile" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="user_id" value="<%= userId %>">
                        <input type="hidden" id="delete_avatar_flag" name="delete_avatar" value="false">

                        <!-- Avatar Section -->
                        <div class="profile-photo">
                            <img id="profileImg"
                                 src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>"
                                 alt="User Avatar"
                                 style="width:100px; height:100px; border-radius:50%; object-fit:cover;">

                            <div id="uploadButtonGroup" style="display: none; margin-top: 10px;">
                                <input type="file" id="photoInput" name="avatar" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
                                <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
                                <button type="button" class="delete-photo" onclick="confirmDelete()">Delete Picture</button>
                            </div>
                        </div>

                        <!-- Profile Info - Compact Layout -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="full-name">Full Name</label>
                                <input type="text" id="full-name" name="full-name" value="<%= userName %>" disabled>
                            </div>
                            <div class="form-group">
                                <label for="lecturer-id">Staff ID</label>
                                <input type="text" id="lecturer-id" name="lecturer-id" value="<%= lecturer.getLecturer_id() %>" disabled>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="<%= email %>" disabled>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="<%= phone %>" disabled>
                            </div>
                        </div>

                        <!-- Password Fields -->
                        <div class="form-group password-field" style="display:none;">
                            <label for="current-password">Current Password</label>
                            <input type="password" id="current-password" name="current-password" placeholder="Enter current password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="new-password">New Password</label>
                            <input type="password" id="new-password" name="new-password" placeholder="Enter new password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="confirm-password">Confirm Password</label>
                            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password">
                        </div>

                        <!-- Action Buttons -->
                        <div class="button-group">
                            <button type="button" id="editButton">Edit Profile</button>
                            <button type="button" id="saveButton" style="display:none;">Save Changes</button>
                            <button type="button" id="cancelButton" style="display:none;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
             <!-- Supervisor Profile Section -->
        <% if ("supervisor".equalsIgnoreCase(currentRole)) { %>
        <div class="main-content">
            <div class="profile-container">
                <div class="profile">
                    <h2>Welcome</h2>

                    <form id="profileForm" action="UpdateProfile" method="post" enctype="multipart/form-data" class="form-container">
                        <input type="hidden" name="user_id" value="<%= userId %>">
                        <input type="hidden" id="delete_avatar_flag" name="delete_avatar" value="false">

                        <!-- Avatar Section -->
                        <div class="profile-photo">
                            <img id="profileImg"
                                 src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>"
                                 alt="User Avatar"
                                 style="width:100px; height:100px; border-radius:50%; object-fit:cover;">

                            <div id="uploadButtonGroup" class="avatar-actions" style="display: none;">
                                <input type="file" id="photoInput" name="avatar" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
                                <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
                                <button type="button" class="delete-photo" onclick="confirmDelete()">Delete Picture</button>
                            </div>
                        </div>

                        <!-- Profile Info - Compact Layout -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="full-name">Full Name</label>
                                <input type="text" id="full-name" name="full-name" value="<%= userName %>" disabled>
                            </div>
                            <div class="form-group">
                                <label for="supervisor-id">Supervisor ID</label>
                                <input type="text" id="supervisor-id" name="supervisor-id" value="<%= supervisor.getSupervisor_id() %>" disabled>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="<%= email %>" disabled>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="<%= phone %>" disabled>
                            </div>
                        </div>

                        <!-- Password Fields -->
                        <div class="form-group password-field" style="display:none;">
                            <label for="current-password">Current Password</label>
                            <input type="password" id="current-password" name="current-password" placeholder="Enter current password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="new-password">New Password</label>
                            <input type="password" id="new-password" name="new-password" placeholder="Enter new password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="confirm-password">Confirm Password</label>
                            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password">
                        </div>

                        <!-- Action Buttons -->
                        <div class="button-group">
                            <button type="button" id="editButton">Edit Profile</button>
                            <button type="button" id="saveButton" style="display:none;">Save Changes</button>
                            <button type="button" id="cancelButton" style="display:none;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
        
        <% if ("examiner".equalsIgnoreCase(currentRole)) { %>
        <div class="main-content">
            <div class="profile-container">
                <div class="profile">
                    <h2>Welcome</h2>

                    <!-- Combined Form -->
                    <form id="profileForm" action="UpdateProfile" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="user_id" value="<%= userId %>">
                        <input type="hidden" id="delete_avatar_flag" name="delete_avatar" value="false">

                        <!-- Avatar Section -->
                        <div class="profile-photo">
                            <img id="profileImg"
                                 src="DownloadAvatar?filename=<%= userAvatar != null ? userAvatar : "default.png" %>"
                                 alt="User Avatar"
                                 style="width:100px; height:100px; border-radius:50%; object-fit:cover;">

                            <div id="uploadButtonGroup" style="display: none; margin-top: 10px; text-align:center;">
                                <input type="file" id="photoInput" name="avatar" style="display:none;" accept="image/*" onchange="previewPhoto(event)">
                                <button type="button" class="upload-photo" onclick="document.getElementById('photoInput').click()">Upload</button>
                                <button type="button" class="delete-photo" onclick="confirmDelete()">Delete Picture</button>
                            </div>
                        </div>

                        <!-- Profile Info -->
                        <div class="form-group">
                            <label for="full-name">Full Name</label>
                            <input type="text" id="full-name" name="full-name" value="<%= userName %>" disabled>
                        </div>

                        <div class="form-group">
                            <label for="student-id">Staff ID</label>
                            <input type="text" id="examiner-id" name="examiner-id" value="<%= examiner.getExaminer_id() %>" disabled>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<%= phone %>" disabled>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= email %>" disabled>
                        </div>

                        <!-- Password Fields -->
                        <div class="form-group password-field" style="display:none;">
                            <label for="current-password">Current Password</label>
                            <input type="password" id="current-password" name="current-password" placeholder="Enter current password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="new-password">New Password</label>
                            <input type="password" id="new-password" name="new-password" placeholder="Enter new password">
                        </div>

                        <div class="form-group password-field" style="display:none;">
                            <label for="confirm-password">Confirm Password</label>
                            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password">
                        </div>

                        <!-- Action Buttons -->
                        <div class="button-group">
                            <button type="button" id="editButton">Edit Profile</button>
                            <button type="button" id="saveButton" style="display:none;">Save Changes</button>
                            <button type="button" id="cancelButton" style="display:none;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
        
<jsp:include page="sidebarScript.jsp" />

<script>
document.getElementById('editButton').addEventListener('click', function () {
    // Existing edit functionality...
    document.getElementById('phone').disabled = false;
    document.getElementById('email').disabled = false;
    
    const passwordFields = document.querySelectorAll('.password-field');
    passwordFields.forEach(field => field.style.display = 'block');
    
    document.getElementById('uploadButtonGroup').style.display = 'block';
    
    this.style.display = 'none';
    document.getElementById('saveButton').style.display = 'inline-block';
    document.getElementById('cancelButton').style.display = 'inline-block';
});

document.getElementById('cancelButton').addEventListener('click', function () {
    // Existing cancel functionality...
    document.getElementById('phone').disabled = true;
    document.getElementById('email').disabled = true;
    
    const passwordFields = document.querySelectorAll('.password-field');
    passwordFields.forEach(field => field.style.display = 'none');
    
    document.getElementById('uploadButtonGroup').style.display = 'none';
    document.getElementById('profileForm').reset();
    
    document.getElementById('editButton').style.display = 'inline-block';
    document.getElementById('saveButton').style.display = 'none';
    this.style.display = 'none';
});

// Save with SweetAlert confirmation
document.getElementById('saveButton').addEventListener('click', function () {
    Swal.fire({
        title: "Save Changes?",
        text: "Do you want to save your profile changes?",
        icon: "question",
        showDenyButton: true,
        showCancelButton: true,
        confirmButtonText: "Save",
        denyButtonText: "Don't Save",
        cancelButtonText: "Cancel",
        confirmButtonColor: "#3085d6",
        denyButtonColor: "#d33",
        cancelButtonColor: "#7d7d7d"
    }).then((result) => {
        if (result.isConfirmed) {
            // User clicked "Save"
            Swal.fire({
                title: "Saving...",
                text: "Please wait while we save your changes",
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Simulate form saving delay (e.g., 1.5 seconds)
            setTimeout(() => {
                Swal.close(); // Close loading alert
                Swal.fire({
                    title: "Saved!",
                    text: "Your changes have been successfully saved.",
                    icon: "success",
                    confirmButtonText: "OK",
                    confirmButtonColor: "#3085d6"
                }).then(() => {
                    // Submit the form after confirmation
                    document.getElementById('profileForm').submit();
                });
            }, 1500);

        } else if (result.isDenied) {
            // User clicked "Don't Save"
            Swal.fire({
                title: "Changes Not Saved",
                text: "Your changes have been discarded",
                icon: "info",
                timer: 1500,
                showConfirmButton: false
            });

            // Reset the form and return to view mode
            document.getElementById('cancelButton').click();
        }
        // If "Cancel" is clicked, do nothing (stay in edit mode)
    });
});


// NEW: Delete with SweetAlert confirmation
function confirmDelete() {
    Swal.fire({
        title: "Delete Profile Picture?",
        text: "Are you sure you want to delete your profile picture?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, delete it!",
        cancelButtonText: "Cancel"
    }).then((result) => {
        if (result.isConfirmed) {
            // Set delete flag
            document.getElementById('delete_avatar_flag').value = "true";
            
            // Update image preview to default
            document.getElementById('profileImg').src = "DownloadAvatar?filename=default.png";
            
            Swal.fire({
                title: "Deleted!",
                text: "Your profile picture has been removed.",
                icon: "success",
                timer: 1500,
                showConfirmButton: false
            });
        }
    });
}

// Existing previewPhoto function
function previewPhoto(event) {
    if (event.target.files && event.target.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('profileImg').src = e.target.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
}
</script>
    </body>            
    
</html>
