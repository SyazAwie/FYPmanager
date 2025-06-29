<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

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
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
  <style>
    .close-modal {
        cursor: pointer;
        font-size: 1.2rem;
        color: #757575;
        user-select: none;
    }
    .modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }
    .modal-footer .btn {
        min-width: 120px;
    }
    .presentation-container {
        padding: 20px;
        background-color: #f9f7fd;
        min-height: calc(100vh - 120px);
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 20px;
    }
    .presentation-column {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    .presentation-card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        padding: 20px;
    }
    .presentation-title {
        color: #4b2e83;
        font-size: 1.3rem;
        margin-bottom: 15px;
        padding-bottom: 8px;
        border-bottom: 2px solid #b399d4;
    }
    .filter-section {
        display: flex;
        gap: 10px;
        margin-bottom: 15px;
        flex-wrap: wrap;
    }
    .filter-group {
        flex: 1;
        min-width: 100%;
    }
    .filter-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: 500;
        color: #4b2e83;
        font-size: 0.9rem;
    }
    .filter-control {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        font-family: 'Poppins', sans-serif;
        font-size: 0.9rem;
    }
    .presentation-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
        font-size: 0.9rem;
    }
    .presentation-table th, 
    .presentation-table td {
        padding: 8px 10px;
        text-align: left;
        border-bottom: 1px solid #e0e0e0;
    }
    .presentation-table th {
        background-color: #f9f7fd;
        color: #4b2e83;
        font-weight: 600;
    }
    .btn {
        padding: 8px 15px;
        border-radius: 6px;
        border: none;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        font-size: 0.9rem;
    }
    .attendance-checkbox {
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: #4b2e83;
    }
    .presentation-table th:nth-child(3),
    .presentation-table td:nth-child(3) {
        text-align: center;
        width: 70px;
    }
    .btn-primary {
        background: #4b2e83;
        color: white;
    }
    .btn-primary:hover {
        background: #6d4ac0;
    }
    .btn-outline {
        background: transparent;
        border: 1px solid #4b2e83;
        color: #4b2e83;
        padding: 7px 12px;
    }
    .status-badge {
        padding: 3px 8px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 500;
    }
    .status-pending {
        background: rgba(255, 193, 7, 0.2);
        color: #FFC107;
    }
    .status-approved {
        background: rgba(76, 175, 80, 0.2);
        color: #4CAF50;
    }
    .file-upload {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .file-input {
        display: none;
    }
    .file-label {
        display: inline-block;
        padding: 8px 15px;
        background: #b399d4;
        color: #1a0d3f;
        border-radius: 6px;
        cursor: pointer;
        text-align: center;
        font-size: 0.9rem;
    }
    .file-name {
        font-size: 0.8rem;
        color: #757575;
        margin-top: 5px;
    }
    @media (max-width: 1200px) {
        .presentation-container {
            grid-template-columns: 1fr 1fr;
        }
    }
    @media (max-width: 768px) {
        .presentation-container {
            grid-template-columns: 1fr;
        }
        .filter-section {
            flex-direction: column;
        }
    }
</style>
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
        <div class="presentation-container">
            <div class="presentation-column">
                <div class="presentation-card">
                    <h3 class="presentation-title">Session Schedule</h3>
                    <div class="filter-section">
                        <div class="filter-group">
                            <label for="filter-date">Filter by Date</label>
                            <input type="date" id="filter-date" class="filter-control">
                        </div>
                        <div class="filter-group">
                            <label for="filter-type">Filter by Type</label>
                            <select id="filter-type" class="filter-control">
                                <option value="">All Types</option>
                                <option value="proposal">Proposal</option>
                                <option value="report">Report</option>
                            </select>
                        </div>
                        <button class="btn btn-primary" style="width: 100%; margin-top: 5px;">
                            <i class="fas fa-file-download"></i> Download Timetable
                        </button>
                    </div>
                    <table class="presentation-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Student</th>
                                <th>Venue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>20 May</td><td>08:00 AM</td><td>Muhammad Amirul</td><td>Seminar</td></tr>
                            <tr><td>20 May</td><td>10:00 AM</td><td>Nurul Huda</td><td>Seminar</td></tr>
                            <tr><td>20 May</td><td>08:00 AM</td><td>Ahmad Daniel</td><td>MK-E2</td></tr>
                            <tr><td>20 May</td><td>10:00 AM</td><td>Mohd Azian</td><td>MK-E2</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="presentation-column">
                <div class="presentation-card">
                    <h3 class="presentation-title">Assign Examiner</h3>
                    <div class="filter-group" style="margin-bottom: 15px;">
                        <label for="session-select">Select Session</label>
                        <select id="session-select" class="filter-control">
                            <option value="">Select session</option>
                            <option value="1">[2023118937] Muhammad Amirul - Proposal</option>
                            <option value="2">[2023230569] Nurul Huda - Proposal</option>
                        </select>
                    </div>
                    <button id="assignExaminerBtn" class="btn btn-primary" style="width: 100%; margin-top: 10px;">
                        <i class="fas fa-user-plus"></i> Assign Examiner
                    </button>
                    <div id="examinerModal" class="modal" style="display: none;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4>Select Examiner</h4>
                                <span class="close-modal">&times;</span>
                            </div>
                            <div class="modal-body">
                                <select name="examiner" id="examiner-select">
                                    <option value="">-- Select an examiner --</option>
                                    <optgroup label="Computer Science"><option value="dr_ali">Dr. Ali</option></optgroup>
                                    <optgroup label="Artificial Intelligence"><option value="dr_siti">Dr. Siti</option></optgroup>
                                    <optgroup label="Data Science"><option value="dr_ahmad">Dr. Ahmad</option></optgroup>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button id="cancelExaminers" class="btn btn-outline">Cancel</button>
                                <button id="confirmExaminers" class="btn btn-primary">Confirm</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="presentation-card">
                    <h3 class="presentation-title">Attendance</h3>
                    <table class="presentation-table">
                        <thead>
                            <tr><th>Student ID</th><th>Name</th><th>Present</th></tr>
                        </thead>
                        <tbody>
                            <tr><td>2023118937</td><td>Muhammad Amirul</td><td><input type="checkbox" class="attendance-checkbox"></td></tr>
                            <tr><td>2023230569</td><td>Nurul Huda</td><td><input type="checkbox" class="attendance-checkbox"></td></tr>
                            <tr><td>2023227845</td><td>Ahmad Daniel</td><td><input type="checkbox" class="attendance-checkbox"></td></tr>
                            <tr><td>2023439172</td><td>Mohd Azian</td><td><input type="checkbox" class="attendance-checkbox"></td></tr>
                        </tbody>
                    </table>
                    <button class="btn btn-primary" style="width: 100%; margin-top: 15px;">
                        <i class="fas fa-save"></i> Save Attendance
                    </button>
                </div>
            </div>

            <div class="presentation-column">
                <div class="presentation-card">
                    <h3 class="presentation-title">Upload Slides</h3>
                    <div class="filter-group" style="margin-bottom: 15px;">
                        <label for="upload-session">Select Session</label>
                        <select id="upload-session" class="filter-control">
                            <option value="">Select session</option>
                            <option value="1">[2023118937] Muhammad Amirul</option>
                            <option value="2">[2023230569] Nurul Huda</option>
                        </select>
                    </div>
                    <div class="file-upload">
                        <input type="file" id="file-upload" class="file-input" accept=".ppt,.pptx,.pdf">
                        <label for="file-upload" class="file-label">
                            <i class="fas fa-file-powerpoint"></i> Choose File
                        </label>
                        <span id="file-name" class="file-name">No file chosen</span>
                    </div>
                    <button class="btn btn-primary" style="width: 100%; margin-top: 10px;">
                        <i class="fas fa-upload"></i> Upload
                    </button>
                </div>

                <div class="presentation-card">
                    <h3 class="presentation-title">Evaluation Tracking</h3>
                    <table class="presentation-table">
                        <thead><tr><th>Student</th><th>Type</th><th>Action</th></tr></thead>
                        <tbody>
                            <tr><td>Muhammad Amirul</td><td>Proposal</td><td><button class="btn btn-outline">Edit</button></td></tr>
                            <tr><td>Nurul Huda</td><td>Proposal</td><td><button class="btn btn-outline">Edit</button></td></tr>
                            <tr><td>Ahmad Daniel</td><td>Proposal</td><td><button class="btn btn-outline">Edit</button></td></tr>
                            <tr><td>Mohd Azian</td><td>Project</td><td><button class="btn btn-outline">Edit</button></td></tr>
                        </tbody>
                    </table>
                    <div id="evaluationModal" class="modal" style="display: none;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4>Edit Evaluation</h4>
                                <span class="close-eval-modal close-modal">&times;</span>
                            </div>
                            <div class="modal-body">
                                <label>Student Name</label>
                                <input type="text" id="eval-student" class="filter-control" readonly>
                                <label>Type</label>
                                <input type="text" id="eval-type" class="filter-control" readonly>
                                <label>Mark</label>
                                <input type="number" id="eval-mark" class="filter-control" placeholder="Enter mark...">
                            </div>
                            <div class="modal-footer">
                                <button id="cancelEval" class="btn btn-outline">Cancel</button>
                                <button id="saveEval" class="btn btn-primary">Save</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
    document.getElementById('file-upload').addEventListener('change', function(e) {
        const fileName = e.target.files[0] ? e.target.files[0].name : 'No file chosen';
        document.getElementById('file-name').textContent = fileName;
    });

    document.querySelector('.btn-primary').addEventListener('click', function() {
        const date = document.getElementById('filter-date').value;
        const type = document.getElementById('filter-type').value;
        console.log('Filtering by:', date, type);
    });

    document.getElementById('assignExaminerBtn').addEventListener('click', function() {
        const sessionSelect = document.getElementById('session-select');
        if (sessionSelect.value === '') {
            alert('Please select a session first');
            return;
        }
        document.getElementById('examinerModal').style.display = 'block';
    });

    document.querySelector('.close-modal').addEventListener('click', function() {
        document.getElementById('examinerModal').style.display = 'none';
    });

    document.getElementById('cancelExaminers').addEventListener('click', function() {
        document.getElementById('examinerModal').style.display = 'none';
    });

    document.getElementById('confirmExaminers').addEventListener('click', function() {
        const selectedExaminer = document.getElementById('examiner-select').value;
        if (!selectedExaminer) {
            alert('Please select an examiner');
            return;
        }
        const examinerSelect = document.getElementById('examiner-select');
        const selectedText = examinerSelect.options[examinerSelect.selectedIndex].text;
        alert(`Examiner "${selectedText}" assigned successfully!`);
    });

    window.addEventListener('click', function(event) {
        if (event.target === document.getElementById('examinerModal')) {
            document.getElementById('examinerModal').style.display = 'none';
        }
    });
</script>
</body>
</html>