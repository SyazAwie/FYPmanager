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
    /* === PROGRESS REPORT CARD === */
    .main-content .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        padding: 2.5rem;
        max-width: 800px;
        margin: 0 auto;
        transition: var(--transition);
        border: 1px solid rgba(75, 46, 131, 0.1);
    }

    .card h2 {
        color: var(--primary);
        margin-bottom: 1.8rem;
        font-size: 1.75rem;
        text-align: center;
        padding-bottom: 1rem;
        border-bottom: 1px solid rgba(75, 46, 131, 0.15);
        font-weight: 600;
    }

    .card form {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.5rem;
    }

    .card label {
        display: block;
        margin-bottom: 0.6rem;
        font-weight: 500;
        color: var(--dark);
        font-size: 0.95rem;
    }

    .card input[type="text"] {
        width: 100%;
        padding: 0.8rem 1rem;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        font-size: 1rem;
        transition: var(--transition);
        background-color: #f9f9f9;
    }

    .card input[type="text"]:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 3px rgba(179, 153, 212, 0.2);
        outline: none;
        background-color: white;
    }

    /* Full width form elements */
    .card label[for="topic"],
    .card label[for="scope"],
    .card label[for="upload"] {
        grid-column: span 2;
    }

    /* Upload Section Styling */
    .upload-section {
        border: 2px dashed var(--accent);
        border-radius: 10px;
        padding: 2.5rem 1rem;
        text-align: center;
        cursor: pointer;
        transition: var(--transition);
        background: rgba(179, 153, 212, 0.05);
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 150px;
        grid-column: span 2;
    }

    .upload-section:hover {
        background: rgba(179, 153, 212, 0.1);
        border-color: var(--secondary);
    }

    .upload-section i {
        font-size: 2.5rem;
        color: var(--secondary);
        margin-bottom: 1rem;
    }

    .upload-section p {
        color: var(--secondary);
        margin: 0 0 1rem;
        font-size: 1rem;
    }

    .upload-section input[type="file"] {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        cursor: pointer;
    }

    /* Button Styles */
    .buttons {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 1.5rem;
        grid-column: span 2;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .buttons > div {
        display: flex;
        gap: 1rem;
    }

    .btn-back, .btn-update, .btn-delete, .btn-submit {
        padding: 0.8rem 1.8rem;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: var(--transition);
        border: none;
        font-size: 1rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .btn-back {
        background: #f5f5f5;
        color: var(--dark);
        border: 1px solid #e0e0e0;
    }

    .btn-back:hover {
        background: #eaeaea;
        transform: translateY(-1px);
    }

    .btn-update {
        background: var(--accent);
        color: var(--primary);
        font-weight: 600;
    }

    .btn-update:hover {
        background: #a58ac9;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(179, 153, 212, 0.3);
    }

    .btn-delete {
        background: #ffebee;
        color: #d32f2f;
        font-weight: 600;
    }

    .btn-delete:hover {
        background: #ffcdd2;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(255, 205, 210, 0.3);
    }

    .btn-submit {
        background: var(--primary);
        color: white;
        font-weight: 600;
        box-shadow: 0 2px 10px rgba(75, 46, 131, 0.2);
    }

    .btn-submit:hover {
        background: var(--secondary);
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(75, 46, 131, 0.3);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .card form {
            grid-template-columns: 1fr;
        }

        .card label[for="topic"],
        .card label[for="scope"],
        .card label[for="upload"] {
            grid-column: span 1;
        }

        .buttons {
            flex-direction: column-reverse;
            gap: 1rem;
        }

        .buttons > div {
            width: 100%;
            justify-content: space-between;
        }

        .btn-back, .btn-submit {
            width: 100%;
        }
    }

    @media (max-width: 480px) {
        .main-content .card {
            padding: 1.5rem;
        }

        .card h2 {
            font-size: 1.5rem;
        }

        .buttons > div {
            flex-direction: column;
            gap: 0.75rem;
        }

        .btn-update, .btn-delete {
            width: 100%;
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

  <!-- Main Content -->
  <div class="main-content">
    <div class="card">
      <h2>Write your progress report here:</h2>
      <form action="#" method="post" enctype="multipart/form-data">
        <label for="fullname">Full Name:</label>
        <input type="text" id="fullname" name="fullname" required>

        <label for="studentid">Student ID:</label>
        <input type="text" id="studentid" name="studentid" required>

        <label for="semester">Semester:</label>
        <input type="text" id="semester" name="semester" required>

        <label for="topic">Topic:</label>
        <input type="text" id="topic" name="topic" required>

        <label for="scope">Scope:</label>
        <input type="text" id="scope" name="scope" required>

        <label for="upload">Upload File:</label>
        <div class="upload-section">
          <i class="fas fa-file-upload"></i>
          <p>Drop your files here</p>
          <input type="file" name="proposalFile" id="upload">
        </div>

        <div class="buttons">
          <button type="button" class="btn-back">Back</button>
          <div>
            <button type="submit" class="btn-update">Update</button>
            <button type="submit" class="btn-delete">Delete</button>
          </div>
          <button type="submit" class="btn-submit">Submit</button>
        </div>
      </form>
    </div>
  </div>
<jsp:include page="sidebarScript.jsp" />
</body>
</html>
