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
        
        try {
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

        request.getRequestDispatcher("ProposalIdea.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        String userRole = (String) session.getAttribute("role");
        request.setAttribute("userRole", userRole);
        
        try {
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String searchQuery = request.getParameter("search");
            
        // Fallback untuk elak null
        if (statusFilter == null) statusFilter = "";
        if (searchQuery == null) searchQuery = "";

        // SET ke JSP
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchQuery", searchQuery);

            
            // Get all proposals with filters
            List<Project_Idea> proposals = Project_IdeaDB.getAllProposals(statusFilter, searchQuery);
            
            // Get additional student and user info for display
            Map<Integer, Student> studentMap = new HashMap<>();
            Map<Integer, User> userMap = new HashMap<>();
            
            for (Project_Idea proposal : proposals) {
                int studentId = proposal.getStudent_id();
                if (!studentMap.containsKey(studentId)) {
                    Student student = StudentDB.getStudentById(String.valueOf(studentId));
                    User user = UserDB.getUserById(studentId);
                    if (student != null) studentMap.put(studentId, student);
                    if (user != null) userMap.put(studentId, user);
                }
            }
            
            request.setAttribute("proposals", proposals);
            request.setAttribute("studentMap", studentMap);
            request.setAttribute("userMap", userMap);
            
            request.getRequestDispatcher("SupervisorProposals.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
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
}