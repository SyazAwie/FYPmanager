package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "ProposalServlet", urlPatterns = {"/ProposalServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize = 1024 * 1024 * 10,
                 maxRequestSize = 1024 * 1024 * 50)
public class ProposalServlet extends HttpServlet {

    private static final String PROPOSAL_UPLOAD_DIR = "C:\\uploads_FYPproposals";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        System.out.println("========== ENTERING doGet() ==========");
        
        HttpSession session = request.getSession(false);
        System.out.println("Session object: " + session);
        
        // Session validation
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            System.out.println("Session validation failed - session: " + session);
            if (session != null) {
                System.out.println("Session attributes - userId: " + session.getAttribute("userId") + 
                                 ", role: " + session.getAttribute("role"));
            }
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        System.out.println("Current user - ID: " + userId + ", Role: " + role);

        // Role validation
        if (!"student".equals(role)) {
            System.out.println("Role validation failed - expected student, got: " + role);
            response.sendRedirect("Dashboard.jsp?error=unauthorized");
            return;
        }

        try {
            System.out.println("Attempting to get user and student info...");
            // Get user and student info
            int userIdInt = Integer.parseInt(userId);
            System.out.println("Parsed user ID: " + userIdInt);
            
            User user = UserDB.getUserById(userIdInt);
            System.out.println("Retrieved User object: " + user);
            
            Student student = StudentDB.getStudentById(userId);
            System.out.println("Retrieved Student object: " + student);
            
            if (user == null || student == null) {
                System.out.println("User or Student not found - User: " + user + ", Student: " + student);
                response.sendRedirect("error.jsp?error=profileNotFound");
                return;
            }

            // Check for existing proposal
            Project_Idea existingProposal = Project_IdeaDB.getProposalByStudentId(userIdInt);
            if (existingProposal != null) {
                System.out.println("Found existing proposal: " + existingProposal);
                request.setAttribute("existingProposal", existingProposal);
                
                // Get file info
                File proposalFile = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
                if (proposalFile.exists()) {
                    request.setAttribute("fileSize", proposalFile.length() / 1024 + " KB");
                    request.setAttribute("fileName", existingProposal.getDescription());
                }
            }

            // Set attributes
            request.setAttribute("user", user);
            request.setAttribute("profile", student);
            System.out.println("Set request attributes - user: " + user + ", profile: " + student);
            
            // Clear previous matches if any
            session.removeAttribute("matchingSupervisors");
            System.out.println("Cleared any existing matchingSupervisors from session");

            RequestDispatcher dispatcher = request.getRequestDispatcher("ProposalIdea.jsp");
            System.out.println("Forwarding to ProposalIdea.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("NumberFormatException in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Login.jsp?error=invalidSession");
        } catch (Exception e) {
            System.err.println("General Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=serverError");
        } finally {
            System.out.println("========== EXITING doGet() ==========");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        System.out.println("========== ENTERING doPost() ==========");
        
        HttpSession session = request.getSession(false);
        System.out.println("Session object: " + session);
        
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Session validation failed in doPost");
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");
        System.out.println("User ID from session: " + userId + ", Action: " + action);
        
        try {
            int studentId = Integer.parseInt(userId);
            System.out.println("Parsed student ID: " + studentId);

            // Check for existing proposal
            Project_Idea existingProposal = Project_IdeaDB.getProposalByStudentId(studentId);
            
            // Handle delete action
            if ("delete".equals(action)) {
                System.out.println("Processing delete request");
                if (existingProposal != null) {
                    // Delete the file first
                    File file = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
                    if (file.exists()) {
                        boolean deleted = file.delete();
                        System.out.println("File deletion " + (deleted ? "successful" : "failed"));
                    }
                    
                    // Then delete from database
                    boolean dbDelete = Project_IdeaDB.deleteProposal(existingProposal.getProjectIdea_id());
                    System.out.println("Database deletion " + (dbDelete ? "successful" : "failed"));
                    
                    if (dbDelete) {
                        request.setAttribute("success", "Proposal deleted successfully");
                    } else {
                        request.setAttribute("error", "Failed to delete proposal");
                    }
                }
                doGet(request, response);
                return;
            }

            // Get form data
            String title = request.getParameter("title");
            String scope = request.getParameter("scope");
            Part filePart = request.getPart("proposalFile");
            System.out.println("Form parameters - title: " + title + ", scope: " + scope);
            
            if (title == null || scope == null || title.trim().isEmpty() || scope.trim().isEmpty()) {
                System.out.println("Missing required form fields");
                request.setAttribute("error", "Please fill all required fields");
                doGet(request, response);
                return;
            }

            // Handle update without file change
            if (existingProposal != null && (filePart == null || filePart.getSize() == 0)) {
                System.out.println("Updating proposal without file change");
                existingProposal.setTitle(title);
                existingProposal.setScope(scope);
                boolean updateSuccess = Project_IdeaDB.updateProposal(existingProposal);
                
                if (updateSuccess) {
                    request.setAttribute("success", "Proposal updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update proposal");
                }
                doGet(request, response);
                return;
            }

            // Handle file upload for new or updated proposal
            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("No file uploaded or empty file");
                request.setAttribute("error", "Please select a file for new submission");
                doGet(request, response);
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileName = studentId + "_" + originalFileName;
            System.out.println("Generated filename: " + fileName);

            // Create upload directory if needed
            File uploadDir = new File(PROPOSAL_UPLOAD_DIR);
            if (!uploadDir.exists()) {
                System.out.println("Upload directory doesn't exist, attempting to create");
                if (!uploadDir.mkdirs()) {
                    System.err.println("Failed to create upload directory");
                    throw new ServletException("Cannot create upload directory");
                }
                System.out.println("Created upload directory successfully");
            }

            // Save the file
            File file = new File(uploadDir, fileName);
            System.out.println("Saving file to: " + file.getAbsolutePath());
            
            try (InputStream input = filePart.getInputStream();
                 OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
                System.out.println("File saved successfully");
            }

            if (existingProposal != null) {
                // Update existing proposal with new file
                System.out.println("Updating existing proposal with new file");
                
                // Delete old file first
                File oldFile = new File(PROPOSAL_UPLOAD_DIR, existingProposal.getDescription());
                if (oldFile.exists()) {
                    boolean deleted = oldFile.delete();
                    System.out.println("Old file deletion " + (deleted ? "successful" : "failed"));
                }
                
                existingProposal.setTitle(title);
                existingProposal.setDescription(fileName);
                existingProposal.setScope(scope);
                boolean updateSuccess = Project_IdeaDB.updateProposal(existingProposal);
                
                if (updateSuccess) {
                    request.setAttribute("success", "Proposal updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update proposal");
                    // Clean up the new file if update failed
                    if (file.exists()) {
                        file.delete();
                    }
                }
            } else {
                // Create new proposal
                System.out.println("Creating new proposal");
                Project_Idea newProposal = new Project_Idea();
                newProposal.setTitle(title);
                newProposal.setDescription(fileName);
                newProposal.setStatus("Pending");
                newProposal.setStudent_id(studentId);
                newProposal.setSupervisor_id(null);
                newProposal.setScope(scope);
                
                boolean insertSuccess = Project_IdeaDB.insertProjectIdea(newProposal, fileName);
                
                if (insertSuccess) {
                    // Get matching supervisors
                    System.out.println("Getting matching supervisors for scope: " + scope);
                    List<Supervisor> matchingSupervisors = SupervisorDB.getSupervisorsByScope(scope);
                    System.out.println("Found " + (matchingSupervisors != null ? matchingSupervisors.size() : 0) + " matching supervisors");
                    
                    session.setAttribute("matchingSupervisors", matchingSupervisors);
                    request.setAttribute("success", "Proposal submitted successfully");
                } else {
                    request.setAttribute("error", "Failed to submit proposal");
                    // Clean up the file if insert failed
                    if (file.exists()) {
                        file.delete();
                    }
                }
            }
            
            doGet(request, response); // Refresh to show updated data
            
        } catch (NumberFormatException e) {
            System.err.println("NumberFormatException in doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Login.jsp?error=invalidSession");
        } catch (Exception e) {
            System.err.println("General Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        } finally {
            System.out.println("========== EXITING doPost() ==========");
        }
    }
}