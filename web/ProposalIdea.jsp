<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%@ page import="fyp.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page isELIgnored="false" %>

<%
// ========== DEBUG INITIALIZATION ==========
System.out.println("[DEBUG] ========= PROPOSAL_IDEA.JSP STARTED =========");
System.out.println("[DEBUG] Request URI: " + request.getRequestURI());
System.out.println("[DEBUG] Session ID: " + session.getId());

// ========== SESSION VALIDATION ==========
String userRole = (String) session.getAttribute("role");
String userId = (String) session.getAttribute("userId");

if (userId == null || userRole == null) {
    System.out.println("[ERROR] Invalid session - redirecting to login");
    response.sendRedirect("Login.jsp?error=sessionExpired");
    return;
}

if (!"supervisor".equals(userRole)) {
    System.out.println("[ERROR] Unauthorized access attempt by role: " + userRole);
    response.sendRedirect("Login.jsp?error=unauthorized");
    return;
}

System.out.println("[DEBUG] Valid supervisor session - UserID: " + userId + ", Role: " + userRole);

// ========== DATA RETRIEVAL ==========
List<Project_Idea> proposals = (List<Project_Idea>) request.getAttribute("proposals");
Map<Integer, Student> studentMap = (Map<Integer, Student>) request.getAttribute("studentMap");
Map<Integer, User> userMap = (Map<Integer, User>) request.getAttribute("userMap");
String statusFilter = request.getParameter("status") != null ? request.getParameter("status") : "";
String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";

// Debug logs for data validation
System.out.println("[DEBUG] Data counts - Proposals: " + (proposals != null ? proposals.size() : "null") + 
                 ", StudentMap: " + (studentMap != null ? studentMap.size() : "null") + 
                 ", UserMap: " + (userMap != null ? userMap.size() : "null"));
System.out.println("[DEBUG] Filters - Status: '" + statusFilter + "', Search: '" + searchQuery + "'");

// Get supervisor profile
User supervisor = (User) request.getAttribute("user");
Supervisor supervisorProfile = (Supervisor) request.getAttribute("profile");
String userAvatar = (String) session.getAttribute("avatar");

if (supervisor == null) {
    System.out.println("[WARN] Supervisor user object is null");
}

if (supervisorProfile == null) {
    System.out.println("[WARN] Supervisor profile object is null");
}
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
        .dashboard-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e1e4e8;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
        }

        /* Alert Messages */
        .alert-message {
            padding: 0.75rem 1rem;
            margin-bottom: 1.5rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }

        .alert-success {
            background-color: #f0fff4;
            color: #2f855a;
            border-left: 4px solid #38a169;
        }

        .alert-error {
            background-color: #fff5f5;
            color: #c53030;
            border-left: 4px solid #e53e3e;
        }

        .alert-message i {
            margin-right: 0.5rem;
        }

        /* Filter Section */
        .filter-container {
            background-color: white;
            padding: 1.25rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            min-width: 200px;
        }

        .filter-label {
            font-size: 0.85rem;
            color: #4a5568;
            margin-bottom: 0.35rem;
            font-weight: 500;
        }

        .filter-select, .filter-input {
            padding: 0.5rem 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.95rem;
            transition: border-color 0.2s;
        }

        .filter-select:focus, .filter-input:focus {
            outline: none;
            border-color: #3182ce;
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .filter-button {
            background-color: #4299e1;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }

        .filter-button:hover {
            background-color: #3182ce;
        }

        /* Proposals Grid */
        .proposals-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }

        .proposal-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .proposal-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .proposal-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .proposal-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
            flex: 1;
        }

        .proposal-status {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 0.5rem;
        }

        .status-pending {
            background-color: #fffaf0;
            color: #dd6b20;
        }

        .status-accepted {
            background-color: #f0fff4;
            color: #38a169;
        }

        .status-rejected {
            background-color: #fff5f5;
            color: #e53e3e;
        }

        .proposal-meta {
            margin-bottom: 1.25rem;
        }

        .meta-item {
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .meta-label {
            font-weight: 500;
            color: #718096;
        }

        .meta-value {
            color: #4a5568;
        }

        .proposal-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 0.5rem 0.75rem;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.2s;
        }

        .btn-view {
            background-color: #edf2f7;
            color: #2d3748;
        }

        .btn-view:hover {
            background-color: #e2e8f0;
        }

        .btn-accept {
            background-color: #c6f6d5;
            color: #22543d;
        }

        .btn-accept:hover {
            background-color: #9ae6b4;
        }

        .btn-reject {
            background-color: #fed7d7;
            color: #822727;
        }

        .btn-reject:hover {
            background-color: #feb2b2;
        }

        /* Empty State */
        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem 1rem;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .empty-icon {
            font-size: 2.5rem;
            color: #a0aec0;
            margin-bottom: 1rem;
        }

        .empty-title {
            font-size: 1.25rem;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #718096;
            margin-bottom: 0;
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
        <div class="dashboard-header">
            <h1 class="page-title">Student Proposals</h1>
        </div>

        <!-- Success/Error Messages will be handled by SweetAlert -->
        <% if (request.getAttribute("success") != null) { %>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: '<%= request.getAttribute("success") %>',
                        confirmButtonColor: '#4b2e83',
                        timer: 3000,
                        timerProgressBar: true
                    });
                });
            </script>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: '<%= request.getAttribute("error") %>',
                        confirmButtonColor: '#e67777'
                    });
                });
            </script>
        <% } %>

        <!-- Filter Section -->
        <div class="filter-container">
            <form method="get" action="ProposalServlet" class="filter-form">
                <input type="hidden" name="action" value="supervisorView">

                <div class="filter-group">
                    <label for="status" class="filter-label">Status</label>
                    <select id="status" name="status" class="filter-select" onchange="this.form.submit()">
                        <option value="">All Statuses</option>
                        <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= "Accepted".equals(statusFilter) ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="search" class="filter-label">Search</label>
                    <input type="text" id="search" name="search" class="filter-input" 
                           placeholder="Search by title or student..." value="<%= searchQuery %>">
                </div>

                <button type="submit" class="filter-button">
                    <i class="fas fa-search"></i> Apply Filters
                </button>
            </form>
        </div>

        <!-- Proposals Grid -->
        <div class="proposals-grid">
            <% if (proposals == null || proposals.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <h3 class="empty-title">No Proposals Found</h3>
                    <p>There are currently no student proposals matching your criteria.</p>
                    <% if (!statusFilter.isEmpty() || !searchQuery.isEmpty()) { %>
                        <a href="ProposalServlet?action=supervisorView" class="filter-button" style="margin-top: 1rem;">
                            <i class="fas fa-times"></i> Clear Filters
                        </a>
                    <% } %>
                </div>
            <% } else { 
                for (Project_Idea proposal : proposals) { 
                    User studentUser = userMap != null ? userMap.get(proposal.getStudent_id()) : null;
                    String statusClass = "status-" + proposal.getStatus().toLowerCase();
            %>
                <div class="proposal-card">
                    <div class="proposal-header">
                        <h3 class="proposal-title"><%= proposal.getTitle() %></h3>
                        <span class="proposal-status <%= statusClass %>">
                            <%= proposal.getStatus() %>
                        </span>
                    </div>

                    <div class="proposal-meta">
                        <div class="meta-item">
                            <span class="meta-label">Student:</span>
                            <span class="meta-value">
                                <%= studentUser != null ? studentUser.getName() : "Unknown" %>
                                (<%= proposal.getStudent_id() %>)
                            </span>
                        </div>

                        <div class="meta-item">
                            <span class="meta-label">Scope:</span>
                            <span class="meta-value"><%= proposal.getScope() %></span>
                        </div>

                    </div>

                    <div class="proposal-actions">
                        <button class="action-btn btn-view" onclick="viewProposal(<%= proposal.getProjectIdea_id() %>)">
                            <i class="fas fa-eye"></i> View
                        </button>
                            
                        <% if ("Pending".equals(proposal.getStatus())) { %>
                            <button class="action-btn btn-accept" 
                                    onclick="confirmAction(
                                        <%= proposal.getProjectIdea_id() %>, 
                                        'Accepted', 
                                        <%= userId %>, 
                                        '<%= proposal.getTitle() %>',
                                        <%= proposal.getStudent_id() %>
                                    )">
                                <i class="fas fa-check"></i> Accept
                            </button>
                        <% } %>
                    </div>
                </div>
            <% } 
           } %>
        </div>
    </div>

    <script>
        // View proposal function
        function viewProposal(proposalId) {
            window.location.href = 'ProposalServlet?action=view&id=' + proposalId;
        }

        function confirmAction(proposalId, action, supervisorId, proposalTitle, studentId) {
            const actionText = action.toLowerCase();

            Swal.fire({
                title: `Confirm ${action}`,
                html: `Are you sure you want to <strong>${actionText}</strong> the proposal:<br><br>
                      <strong>"${proposalTitle}"</strong>?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: action === 'Accepted' ? '#4b2e83' : '#e67777',
                cancelButtonColor: '#7a7d9a',
                confirmButtonText: `Yes, ${actionText} it!`,
                cancelButtonText: 'Cancel',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    updateProposalStatus(proposalId, action, supervisorId, proposalTitle, studentId);
                }
            });
        }

        function updateProposalStatus(proposalId, status, supervisorId, proposalTitle, studentId) {
            Swal.fire({
                title: 'Processing...',
                html: `Please wait while we ${status.toLowerCase()} the proposal`,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();

                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'ProposalServlet';

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = status === 'Accepted' ? 'accept' : 'reject';
                    form.appendChild(actionInput);

                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'proposalId';
                    idInput.value = proposalId;
                    form.appendChild(idInput);

                    const supervisorInput = document.createElement('input');
                    supervisorInput.type = 'hidden';
                    supervisorInput.name = 'supervisorId';
                    supervisorInput.value = supervisorId;
                    form.appendChild(supervisorInput);

                    const studentInput = document.createElement('input');
                    studentInput.type = 'hidden';
                    studentInput.name = 'studentId';
                    studentInput.value = studentId;
                    form.appendChild(studentInput);

                    const titleInput = document.createElement('input');
                    titleInput.type = 'hidden';
                    titleInput.name = 'proposalTitle';
                    titleInput.value = proposalTitle;
                    form.appendChild(titleInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
    
    <script>
        // View proposal function - updated to handle PDF viewing
        function viewProposal(proposalId) {
            // Show loading indicator
            Swal.fire({
                title: 'Opening Proposal',
                html: 'Please wait while we load the proposal...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();

                    // Fetch the proposal details first
                    fetch('ProposalServlet?action=getProposalDetails&id=' + proposalId)
                        .then(response => response.json())
                        .then(data => {
                            Swal.close();
                            if (data.fileName) {
                                // Open the PDF in a new tab
                                window.open('ProposalServlet?action=viewFile&id=' + proposalId, '_blank');
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'File Not Found',
                                    text: 'The proposal file could not be found',
                                    confirmButtonColor: '#e67777'
                                });
                            }
                        })
                        .catch(error => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to load proposal details',
                                confirmButtonColor: '#e67777'
                            });
                        });
                }
            });
        }
    </script>
    
    <jsp:include page="sidebarScript.jsp" />
</body>
</html>