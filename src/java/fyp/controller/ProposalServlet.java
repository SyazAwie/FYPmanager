package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.nio.file.Paths;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ProposalServlet", urlPatterns = {"/ProposalServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProposalServlet extends HttpServlet {

    private static final String PROPOSAL_UPLOAD_DIR = "C:\\uploads_FYPproposals";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Session validation
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");

        try {
            // Handle proposal file viewing
            if ("viewFile".equalsIgnoreCase(action)) {
                int proposalId = Integer.parseInt(request.getParameter("id"));
                handleViewFile(request, response, proposalId);
                return;
            }

            // Handle proposal details request
            if ("getProposalDetails".equalsIgnoreCase(action)) {
                int proposalId = Integer.parseInt(request.getParameter("id"));
                handleGetProposalDetails(request, response, proposalId);
                return;
            }

            // Handle supervisor view
            if ("supervisor".equalsIgnoreCase(role)) {
                handleSupervisorView(request, response);
                return;
            }

            // Handle student view
            if ("student".equalsIgnoreCase(role)) {
                handleStudentView(request, response, userId);
                return;
            }

            // Unauthorized access
            response.sendRedirect("Dashboard.jsp?error=unauthorized");

        } catch (NumberFormatException e) {
            response.sendRedirect("Login.jsp?error=invalidSession");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=serverError");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        
        try {
            // Handle supervisor actions
            if ("supervisor".equalsIgnoreCase(role)) {
                if ("accept".equalsIgnoreCase(action)) {
                    handleAcceptProposal(request, response, userId);
                    return;
                } else if ("reject".equalsIgnoreCase(action)) {
                    handleRejectProposal(request, response);
                    return;
                }
            }
            
            // Handle student actions
            if ("student".equalsIgnoreCase(role)) {
                handleStudentSubmission(request, response, userId);
                return;
            }
            
            // Unauthorized access
            response.sendRedirect("Dashboard.jsp?error=unauthorized");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }

    // ========== STUDENT METHODS ========== //
    
    private void handleStudentView(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, NumberFormatException {
        
        int userIdInt = Integer.parseInt(userId);
        User user = UserDB.getUserById(userIdInt);
        Student student = StudentDB.getStudentById(userId);
        
        if (user == null || student == null) {
            response.sendRedirect("error.jsp?error=profileNotFound");
            return;
        }

        // Check for existing proposal
        Project_Idea existingProposal = Project_IdeaDB.getProposalByStudentId(userIdInt);
        if (existingProposal != null) {
            request.setAttribute("existingProposal", existingProposal);
            
            // Get file info
            File proposalFile = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
            if (proposalFile.exists()) {
                request.setAttribute("fileSize", proposalFile.length() / 1024 + " KB");
                request.setAttribute("fileName", existingProposal.getDescription());
            }
        }
        HttpSession session = request.getSession();
        request.setAttribute("user", user);
        request.setAttribute("profile", student);
        session.removeAttribute("matchingSupervisors");
        
        if (existingProposal != null && existingProposal.getSupervisor_id() != null) {
            User supervisor = UserDB.getUserById(existingProposal.getSupervisor_id());
            request.setAttribute("supervisorName", supervisor != null ? supervisor.getName() : "Not assigned");
        }

        request.getRequestDispatcher("ProposalIdeaSubmission.jsp").forward(request, response);
    }
    
    private void handleStudentSubmission(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, NumberFormatException {
        
        int studentId = Integer.parseInt(userId);
        String action = request.getParameter("action");
        Project_Idea existingProposal = Project_IdeaDB.getProposalByStudentId(studentId);
        
        // Handle delete action
        if ("delete".equalsIgnoreCase(action)) {
            if (existingProposal != null) {
                // Delete the file first
                File file = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
                if (file.exists()) {
                    file.delete();
                }
                
                // Then delete from database
                Project_IdeaDB.deleteProposal(existingProposal.getProjectIdea_id());
                request.setAttribute("success", "Proposal deleted successfully");
            }
            doGet(request, response);
            return;
        }

        // Get form data
        String title = request.getParameter("title");
        String scope = request.getParameter("scope");
        Part filePart = request.getPart("proposalFile");
        
        if (title == null || scope == null || title.trim().isEmpty() || scope.trim().isEmpty()) {
            request.setAttribute("error", "Please fill all required fields");
            doGet(request, response);
            return;
        }

        // Handle update without file change
        if (existingProposal != null && (filePart == null || filePart.getSize() == 0)) {
            existingProposal.setTitle(title);
            existingProposal.setScope(scope);
            boolean updateSuccess = Project_IdeaDB.updateProposal(existingProposal);
            
            request.setAttribute(updateSuccess ? "success" : "error", 
                updateSuccess ? "Proposal updated successfully" : "Failed to update proposal");
            doGet(request, response);
            return;
        }

        // Handle file upload for new or updated proposal
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select a file for new submission");
            doGet(request, response);
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileName = studentId + "_" + System.currentTimeMillis() + "_" + originalFileName;

        // Create upload directory if needed
        File uploadDir = new File(PROPOSAL_UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Save the file
        File file = new File(uploadDir, fileName);
        try (InputStream input = filePart.getInputStream();
             OutputStream output = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }

        if (existingProposal != null) {
            // Update existing proposal with new file
            File oldFile = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
            if (oldFile.exists()) {
                oldFile.delete();
            }
            
            existingProposal.setTitle(title);
            existingProposal.setDescription(fileName);
            existingProposal.setScope(scope);
            boolean updateSuccess = Project_IdeaDB.updateProposal(existingProposal);
            
            if (!updateSuccess && file.exists()) {
                file.delete();
            }
            request.setAttribute(updateSuccess ? "success" : "error", 
                updateSuccess ? "Proposal updated successfully" : "Failed to update proposal");
        } else {
            // Create new proposal
            Project_Idea newProposal = new Project_Idea();
            newProposal.setTitle(title);
            newProposal.setDescription(fileName);
            newProposal.setStatus("Pending");
            newProposal.setStudent_id(studentId);
            newProposal.setSupervisor_id(null);
            newProposal.setScope(scope);
            
            boolean insertSuccess = Project_IdeaDB.insertProjectIdea(newProposal, fileName);
            
            if (insertSuccess) {
                List<Supervisor> matchingSupervisors = SupervisorDB.getSupervisorsByScope(scope);
                request.getSession().setAttribute("matchingSupervisors", matchingSupervisors);
                request.setAttribute("success", "Proposal submitted successfully");
            } else {
                if (file.exists()) {
                    file.delete();
                }
                request.setAttribute("error", "Failed to submit proposal");
            }
        }
        
        doGet(request, response);
    }

    // ========== SUPERVISOR METHODS ========== //
    
    private void handleSupervisorView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session handling
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("[ERROR] No active session found - redirecting to login");
            response.sendRedirect("Login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("role");
        System.out.printf("[DEBUG] Session attributes - Role: %s, Session ID: %s%n", 
                userRole, session.getId());
        request.setAttribute("userRole", userRole);
        // Supervisor ID dari session
        String userId = (String) session.getAttribute("userId");
        User supervisor = UserDB.getUserById(Integer.parseInt(userId));

        try {
            // Parameter processing
            String statusFilter = request.getParameter("status");
            String searchQuery = request.getParameter("search");
            System.out.printf("[DEBUG] Request parameters - status: '%s', search: '%s'%n", 
                    statusFilter, searchQuery);

            // Null handling
            statusFilter = (statusFilter == null) ? "" : statusFilter.trim();
            searchQuery = (searchQuery == null) ? "" : searchQuery.trim();
            System.out.printf("[DEBUG] Sanitized parameters - status: '%s', search: '%s'%n", 
                    statusFilter, searchQuery);

            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);

            // Database query
            System.out.println("[DEBUG] Querying proposals from database...");
            long queryStart = System.currentTimeMillis();
            List<Project_Idea> proposals = Project_IdeaDB.getAllProposals(statusFilter, searchQuery);
            long queryTime = System.currentTimeMillis() - queryStart;
            System.out.printf("[DEBUG] Retrieved %d proposals in %d ms%n", 
                    proposals.size(), queryTime);

            // Student and user data collection
            System.out.println("[DEBUG] Building supplementary data maps...");
            Map<Integer, Student> studentMap = new HashMap<>();
            Map<Integer, User> userMap = new HashMap<>();
            int studentLookups = 0;
            int userLookups = 0;

            for (Project_Idea proposal : proposals) {
                int studentId = proposal.getStudent_id();

                if (!studentMap.containsKey(studentId)) {
                    System.out.printf("[TRACE] Processing new student ID: %d%n", studentId);

                    // Student data
                    Student student = StudentDB.getStudentById(String.valueOf(studentId));
                    if (student != null) {
                        studentMap.put(studentId, student);
                        studentLookups++;
                    }

                    // User data
                    long userQueryStart = System.currentTimeMillis();
                    User user = UserDB.getUserById(studentId);
                    if (user != null) {
                        userMap.put(studentId, user);
                        userLookups++;
                        System.out.printf("[TRACE] Added user: %s (ID: %d) in %d ms%n",
                                user.getName(), studentId, System.currentTimeMillis() - userQueryStart);
                    }
                }
            }

            System.out.printf("[DEBUG] Data collection complete - Students: %d/%d, Users: %d/%d%n",
                    studentMap.size(), proposals.size(), userMap.size(), proposals.size());

            // Prepare request attributes
            request.setAttribute("proposals", proposals);
            request.setAttribute("studentMap", studentMap);
            request.setAttribute("userMap", userMap);
            Supervisor supervisorProfile = SupervisorDB.getSupervisorById(userId);
            request.setAttribute("user", supervisor);  // Sama nama, supaya JSP dapat guna
            request.setAttribute("profile", supervisorProfile); // Kalau ada
            String userAvatar = (String) session.getAttribute("avatar");
            request.setAttribute("userAvatar", userAvatar);

            // Forward to JSP
            System.out.println("Forward path: " + getServletContext().getRealPath("/ProposalIdea.jsp"));
            System.out.println("[DEBUG] Forwarding to ProposalIdea.jsp");
            request.getRequestDispatcher("ProposalIdea.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.printf("[ERROR] Exception in handleSupervisorView: %s%n", e.getMessage());
            e.printStackTrace();
            System.out.println("[ERROR] Redirecting to error page");
            response.sendRedirect("error.jsp?error=serverError");
        }
    }
    
    private void handleAcceptProposal(HttpServletRequest request, HttpServletResponse response, String supervisorId)
            throws ServletException, IOException {
        
        try {
            int proposalId = Integer.parseInt(request.getParameter("proposalId"));
            int supervisorIdInt = Integer.parseInt(supervisorId);
            
            // Update proposal status to "Accepted" and assign supervisor
            boolean success = Project_IdeaDB.updateProposalStatus(
                proposalId, 
                "Accepted", 
                supervisorIdInt
            );
            
            request.setAttribute(success ? "success" : "error", 
                success ? "Proposal accepted successfully" : "Failed to accept proposal");
            
            request.setAttribute("statusFilter", request.getParameter("status"));
            request.setAttribute("searchQuery", request.getParameter("search"));

            
            // Refresh the supervisor view
            handleSupervisorView(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error accepting proposal: " + e.getMessage());
            handleSupervisorView(request, response);
        }
    }
    
    private void handleRejectProposal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int proposalId = Integer.parseInt(request.getParameter("proposalId"));
            String feedback = request.getParameter("feedback");
            
            // Update proposal status to "Rejected"
            boolean success = Project_IdeaDB.updateProposalStatus(
                proposalId, 
                "Rejected", 
                -1 // No supervisor assigned
            );
            
            request.setAttribute("statusFilter", request.getParameter("status"));
            request.setAttribute("searchQuery", request.getParameter("search"));

            request.setAttribute(success ? "success" : "error", 
                success ? "Proposal rejected successfully" : "Failed to reject proposal");
            
            // Refresh the supervisor view
            handleSupervisorView(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error rejecting proposal: " + e.getMessage());
            handleSupervisorView(request, response);
        }
    }

    private void handleGetProposalDetails(HttpServletRequest request, HttpServletResponse response, int proposalId) 
            throws ServletException, IOException {
        try {
            Project_Idea proposal = Project_IdeaDB.getProposalById(proposalId);
            if (proposal != null) {
                // Prepare JSON response
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"fileName\": \"" + proposal.getDescription() + "\"}");
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Proposal not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving proposal");
        }
    }

    private void handleViewFile(HttpServletRequest request, HttpServletResponse response, int proposalId) 
            throws ServletException, IOException {
        try {
            Project_Idea proposal = Project_IdeaDB.getProposalById(proposalId);
            if (proposal == null || proposal.getDescription() == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Proposal not found");
                return;
            }

            File file = new File(PROPOSAL_UPLOAD_DIR, proposal.getDescription());
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                return;
            }

            // Set response headers for PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
            response.setContentLength((int) file.length());

            // Stream the file to the response
            try (InputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving file");
        }
    }
}