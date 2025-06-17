<%@ include file="template.jsp" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (!"admin".equals(userRole)) { response.sendRedirect("Login.jsp"); return; } %>

<div class="main-content">
    <div class="container" style="padding: 20px;">
        <h2>Presentation Management</h2>
        <div style="display: flex; gap: 20px;">

            <!-- Column 1: Session Schedule -->
            <div style="flex: 1; background: #f9f9f9; padding: 15px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                <h3>Session Schedule</h3>
                <form method="get" action="Presentation.jsp">
                    <label for="filterDate">Date:</label><br>
                    <input type="date" name="filterDate" id="filterDate" style="width: 100%; margin-bottom: 10px;"><br>

                    <label for="filterType">Type:</label><br>
                    <select name="filterType" id="filterType" style="width: 100%; margin-bottom: 10px;">
                        <option value="">-- Select --</option>
                        <option value="Proposal">Proposal</option>
                        <option value="Project">Project</option>
                    </select><br>

                    <button type="submit" class="btn">Filter</button>
                    <button type="submit" formaction="DownloadTimetableServlet" class="btn" style="margin-left: 10px;">Download Timetable</button>
                </form>

                <hr>
                <h4>Scheduled Students</h4>
                <div style="max-height: 300px; overflow-y: auto;">
                    <ul>
                        <li>Student A - 10 July - Proposal</li>
                        <li>Student B - 12 July - Project</li>
                        <!-- Replace with dynamic list -->
                    </ul>
                </div>
            </div>

            <!-- Column 2: Examiner Assignment and Attendance -->
            <div style="flex: 1; background: #f9f9f9; padding: 15px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                <h3>Examiner Assignment</h3>
                <form method="post" action="AssignExaminerServlet">
                    <label for="sessionId">Select Session:</label><br>
                    <select name="sessionId" id="sessionId" style="width: 100%; margin-bottom: 10px;">
                        <option value="1">10 July - Proposal</option>
                        <option value="2">12 July - Project</option>
                        <!-- Replace with dynamic session list -->
                    </select><br>

                    <button type="submit" formaction="Form.jsp" class="btn">Edit Form 7</button>
                </form>

                <hr>
                <h4>Student Attendance</h4>
                <form method="post" action="MarkAttendanceServlet">
                    <input type="checkbox" name="attend_1"> Student A<br>
                    <input type="checkbox" name="attend_2"> Student B<br>
                    <!-- Replace with dynamic student list -->
                    <br>
                    <button type="submit" class="btn">Submit Attendance</button>
                </form>
            </div>

            <!-- Column 3: Slide Upload and Evaluation -->
            <div style="flex: 1; background: #f9f9f9; padding: 15px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
                <h3>Slide Upload</h3>
                <form method="post" action="UploadSlideServlet" enctype="multipart/form-data">
                    <label for="sessionUpload">Select Session:</label><br>
                    <select name="sessionUpload" id="sessionUpload" style="width: 100%; margin-bottom: 10px;">
                        <option value="1">10 July - Proposal</option>
                        <option value="2">12 July - Project</option>
                        <!-- Replace with dynamic session list -->
                    </select><br>

                    <label for="slideFile">Upload PDF Slide:</label><br>
                    <input type="file" name="slideFile" accept="application/pdf" required style="margin-bottom: 10px;"><br>
                    <button type="submit" class="btn">Upload</button>
                </form>

                <hr>
                <h4>Evaluation Tracking</h4>
                <p>Coming soon...</p>
            </div>

        </div>
    </div>
</div>

<style>
    .btn {
        background-color: #4CAF50;
        color: white;
        padding: 8px 12px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn:hover {
        background-color: #45a049;
    }
</style>