<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="template.jsp" />
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");

    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole) || !"student".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=unauthorizedAccess");
        return;
    }
%>

<style>
    .progress-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
        background-color: #fff;
        border-radius: 16px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    .progress-container h2 {
        text-align: center;
        margin-bottom: 30px;
    }

    .progress-container label {
        font-weight: 500;
        display: block;
        margin-top: 15px;
    }

    .progress-container input[type="text"],
    .progress-container select {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 8px;
    }

    .upload-section {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
        margin-top: 20px;
    }

    .upload-box {
        flex: 1;
        border: 2px dashed #ccc;
        border-radius: 10px;
        height: 120px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 16px;
        color: #888;
        background-color: #f9f9f9;
    }

    .upload-box input[type="file"] {
        margin-top: 10px;
    }

    .dropdown-box {
        flex: 0.5;
    }

    .top-submit-btn {
        float: right;
        margin-top: -40px;
        margin-right: 10px;
        padding: 10px 20px;
        background-color: #007bff;
        border: none;
        border-radius: 10px;
        color: white;
        font-weight: bold;
        cursor: pointer;
    }

    .top-submit-btn:hover {
        background-color: #0069d9;
    }

    .button-row {
        display: flex;
        justify-content: space-between;
        margin-top: 30px;
    }

    .button-row button {
        padding: 10px 20px;
        border: none;
        border-radius: 10px;
        color: white;
        font-weight: bold;
        cursor: pointer;
    }

    .btn-blue {
        background-color: #007bff;
    }

    .btn-blue:hover {
        background-color: #0069d9;
    }

    .btn-green {
        background-color: #28a745;
    }

    .btn-green:hover {
        background-color: #218838;
    }

    .btn-red {
        background-color: #dc3545;
    }

    .btn-red:hover {
        background-color: #c82333;
    }
</style>

<div class="main-content">
    <div class="progress-container">
        <h2>Write Your Progress Here</h2>

        <!-- Butang Submit Atas -->
        <form action="SubmitProgressServlet" method="post" enctype="multipart/form-data">
            <button type="submit" class="top-submit-btn">Submit</button>

            <label>Full Name:</label>
            <input type="text" name="fullName" required>

            <label>Student ID:</label>
            <input type="text" name="studentId" required>

            <label>Semester:</label>
            <input type="text" name="semester" required>

            <label>Topic:</label>
            <input type="text" name="topic" required>

            <label>Scope:</label>
            <input type="text" name="scope" required>

            <div class="upload-section">
                <div class="upload-box">
                    <div>
                        Drop your files here<br>
                        <input type="file" name="progressFile" />
                    </div>
                </div>

                <div class="dropdown-box">
                    <label>Progress Status:</label>
                    <select name="status" required>
                        <option value="">Select</option>
                        <option value="half">Half</option>
                        <option value="done">Done</option>
                    </select>
                </div>
            </div>

            <hr style="margin-top: 30px; margin-bottom: 20px;">

            <div class="button-row">
                <button type="button" class="btn-blue" onclick="window.history.back()">Back</button>
                <div>
                    <button type="submit" class="btn-blue">Submit</button>
                    <button type="submit" formaction="UpdateProgressServlet" class="btn-green">Update</button>
                    <button type="submit" formaction="DeleteProgressServlet" class="btn-red">Delete</button>
                </div>
            </div>
        </form>
    </div>
</div>
