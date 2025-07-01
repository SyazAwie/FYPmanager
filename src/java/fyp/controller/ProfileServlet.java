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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet", "/UpdateProfile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileServlet extends HttpServlet {

    private static final String AVATAR_UPLOAD_DIR = "C:\\uploads_FYPavatar";
    private static final String[] ALLOWED_IMAGE_TYPES = {"jpg", "jpeg", "png", "gif"};
    private static final long MAX_AVATAR_SIZE = 5 * 1024 * 1024; // 5MB

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
        String currentRole = (String) session.getAttribute("role");

        try {
            int id = Integer.parseInt(userId);
            User user = UserDB.getUserById(id);
            
            if (user == null) {
                response.sendRedirect("error.jsp?error=userNotFound");
                return;
            }

            // Get all roles for this user
            List<String> userRoles = UserDB.getUserRoles(userId);
            if (userRoles == null || userRoles.isEmpty()) {
                response.sendRedirect("error.jsp?error=noRolesAssigned");
                return;
            }

            // Set request attributes
            request.setAttribute("user", user);
            request.setAttribute("userRoles", userRoles);
            request.setAttribute("currentRole", currentRole);

            // Load all relevant profiles
            Map<String, Object> profiles = loadAllProfiles(userId, userRoles);
            request.setAttribute("profiles", profiles);

            // Set current profile based on active role
            Object currentProfile = determineCurrentProfile(profiles, currentRole, session);
            request.setAttribute("profile", currentProfile);

            RequestDispatcher dispatcher = request.getRequestDispatcher("Profile.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?error=invalidUserId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=serverError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            // Handle role switching
            if ("switchRole".equals(request.getParameter("action"))) {
                handleRoleSwitch(request, response, session);
                return;
            }

            // Validate user ID
            String userIdStr = request.getParameter("user_id");
            if (userIdStr == null || userIdStr.isEmpty()) {
                response.sendRedirect("error.jsp?error=invalidRequest");
                return;
            }

            int userId = Integer.parseInt(userIdStr);
            UserDB userDB = new UserDB();

            // Process avatar upload/delete
            handleAvatarUpload(request, userId, userDB, session);

            // Update profile information
            updateProfileInfo(request, userId, userDB);

            response.sendRedirect("ProfileServlet?update=success");

        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?error=invalidUserId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=serverError");
        }
    }

    // ========== HELPER METHODS ========== //

    private Map<String, Object> loadAllProfiles(String userId, List<String> userRoles) {
        Map<String, Object> profiles = new HashMap<>();
        
        for (String role : userRoles) {
            switch (role.toLowerCase()) {
                case "student":
                    profiles.put("student", StudentDB.getStudentById(userId));
                    break;
                case "lecturer":
                    profiles.put("lecturer", LecturerDB.getLecturerById(userId));
                    break;
                case "supervisor":
                    profiles.put("supervisor", SupervisorDB.getSupervisorById(userId));
                    break;
                case "examiner":
                    profiles.put("examiner", ExaminerDB.getExaminerById(userId));
                    break;
                case "admin":
                    profiles.put("admin", AdminDB.getAdminById(userId));
                    break;
            }
        }
        return profiles;
    }

    private Object determineCurrentProfile(Map<String, Object> profiles, String currentRole, HttpSession session) {
        Object currentProfile = profiles.get(currentRole.toLowerCase());
        
        // Fallback to first available role if current role isn't valid
        if (currentProfile == null && !profiles.isEmpty()) {
            String firstRole = profiles.keySet().iterator().next();
            session.setAttribute("role", firstRole);
            return profiles.get(firstRole);
        }
        return currentProfile;
    }

    private void handleRoleSwitch(HttpServletRequest request, HttpServletResponse response, 
                                HttpSession session) throws IOException {
        String newRole = request.getParameter("newRole");
        String userId = (String) session.getAttribute("userId");

        if (newRole != null && !newRole.isEmpty()) {
            List<String> userRoles = UserDB.getUserRoles(userId);
            if (userRoles.contains(newRole)) {
                session.setAttribute("role", newRole);
            }
        }
        response.sendRedirect("ProfileServlet");
    }

    private void handleAvatarUpload(HttpServletRequest request, int userId, 
                                  UserDB userDB, HttpSession session) 
            throws IOException, ServletException {
        
        String deleteAvatar = request.getParameter("delete_avatar");
        Part avatarPart = request.getPart("avatar");

        // Handle avatar deletion
        if ("true".equals(deleteAvatar)) {
            deleteUserAvatar(userId, userDB, session);
        } 
        // Handle new avatar upload
        else if (avatarPart != null && avatarPart.getSize() > 0) {
            uploadNewAvatar(avatarPart, userId, userDB, session, request);
        }
    }

    private void deleteUserAvatar(int userId, UserDB userDB, HttpSession session) {
        String currentAvatar = userDB.getUserAvatar(userId);
        if (currentAvatar != null && !currentAvatar.isEmpty()) {
            File file = new File(AVATAR_UPLOAD_DIR, currentAvatar);
            if (file.exists()) {
                file.delete();
            }
            userDB.updateUserAvatar(userId, null);
            session.setAttribute("avatar", null);
        }
    }

    private void uploadNewAvatar(Part avatarPart, int userId, UserDB userDB,
                               HttpSession session, HttpServletRequest request) 
            throws IOException {
        // Validate file size
        if (avatarPart.getSize() > MAX_AVATAR_SIZE) {
            request.setAttribute("error", "Avatar size exceeds maximum limit (5MB)");
            return;
        }

        // Validate file type
        String fileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
        String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        
        if (!Arrays.asList(ALLOWED_IMAGE_TYPES).contains(fileExt)) {
            request.setAttribute("error", "Invalid image type. Allowed types: JPG, JPEG, PNG, GIF");
            return;
        }

        // Create upload directory if needed
        File uploadDir = new File(AVATAR_UPLOAD_DIR);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            request.setAttribute("error", "Cannot create upload directory");
            return;
        }

        // Generate unique filename
        String newAvatarFilename = userId + "_" + System.currentTimeMillis() + "." + fileExt;
        File file = new File(uploadDir, newAvatarFilename);

        // Save the file
        try (InputStream input = avatarPart.getInputStream();
             OutputStream output = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }

            // Update database and session
            userDB.updateUserAvatar(userId, newAvatarFilename);
            session.setAttribute("avatar", newAvatarFilename);

        } catch (IOException e) {
            // Clean up if upload failed
            if (file.exists()) {
                file.delete();
            }
            throw e;
        }
    }

    private void updateProfileInfo(HttpServletRequest request, int userId, UserDB userDB) {
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String currentPass = request.getParameter("current-password");
        String newPass = request.getParameter("new-password");
        String confirmPass = request.getParameter("confirm-password");

        // Update basic contact info
        userDB.updateUserContact(userId, phone, email);

        // Handle password change if requested
        if (newPass != null && !newPass.isEmpty() && newPass.equals(confirmPass)) {
            if (userDB.verifyPassword(userId, currentPass)) {
                userDB.updateUserPassword(userId, newPass);
                request.setAttribute("success", "Password updated successfully");
            } else {
                request.setAttribute("error", "Current password is incorrect");
            }
        }
    }
}