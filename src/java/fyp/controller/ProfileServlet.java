package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import java.nio.file.Paths;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet", "/UpdateProfile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                        maxFileSize = 1024 * 1024 * 10,
                        maxRequestSize = 1024 * 1024 * 50)
public class ProfileServlet extends HttpServlet {

    private static final String AVATAR_UPLOAD_DIR = "C:\\uploads_FYPavatar";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        int id = Integer.parseInt(userId);

        try {
            // Common user info (from User table)
            User user = UserDB.getUserById(id);
            request.setAttribute("user", user);

            switch (role) {
                case "student":
                    Student student = StudentDB.getStudentById(userId);
                    request.setAttribute("profile", student);
                    break;
                case "lecturer":
                    Lecturer lecturer = LecturerDB.getLecturerById(userId);
                    request.setAttribute("profile", lecturer);
                    break;
                case "supervisor":
                    Supervisor supervisor = SupervisorDB.getSupervisorById(userId);
                    request.setAttribute("profile", supervisor);
                    break;
                case "examiner":
                    Examiner examiner = ExaminerDB.getExaminerById(userId);
                    request.setAttribute("profile", examiner);
                    break;
                case "admin":
                    Admin admin = AdminDB.getAdminById(userId);
                    request.setAttribute("profile", admin);
                    break;
                default:
                    response.sendRedirect("Login.jsp?error=invalidRole");
                    return;
            }
            

            RequestDispatcher dispatcher = request.getRequestDispatcher("Profile.jsp");
            dispatcher.forward(request, response);

        } catch (IOException | NumberFormatException | ServletException e) {
            response.sendRedirect("error.jsp?error=internalServer");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession();
        System.out.println("✅ doPost() triggered");

        String userIdStr = request.getParameter("user_id");
        int userId = Integer.parseInt(userIdStr);
        UserDB userDB = new UserDB();

        // 1. Avatar Upload
        Part avatarPart = request.getPart("avatar");
        String deleteAvatar = request.getParameter("delete_avatar");
        String newAvatarFilename = null;
        final String AVATAR_UPLOAD_DIR = "C:\\uploads_FYPavatar";

        if ("true".equals(deleteAvatar)) {
            String currentAvatar = userDB.getUserAvatar(userId);
            if (currentAvatar != null && !currentAvatar.isEmpty()) {
                File file = new File(AVATAR_UPLOAD_DIR, currentAvatar);
                if (file.exists()) {
                    try {
                        file.delete();
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Failed to delete avatar.");
                    }
                }
                userDB.updateUserAvatar(userId, null);
                session.setAttribute("avatar", null);
            }

        } else if (avatarPart != null && avatarPart.getSize() > 0) {
            String originalFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            newAvatarFilename = userId + "_" + originalFileName;

            File uploadDir = new File(AVATAR_UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            File file = new File(uploadDir, newAvatarFilename);
            try (InputStream input = avatarPart.getInputStream(); OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }

                // Only update DB after successful file write
                userDB.updateUserAvatar(userId, newAvatarFilename);
                session.setAttribute("avatar", newAvatarFilename);

            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("error", "Failed to upload avatar.");
            }
        }


        // 2. Update Profile Info
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String currentPass = request.getParameter("current-password");
        String newPass = request.getParameter("new-password");
        String confirmPass = request.getParameter("confirm-password");
        
        System.out.println("DEBUG: CurrentPass=" + currentPass);
        System.out.println("DEBUG: NewPass=" + newPass);
        System.out.println("DEBUG: ConfirmPass=" + confirmPass);


        userDB.updateUserContact(userId, phone, email);

        if (newPass != null && !newPass.isEmpty() && newPass.equals(confirmPass)) {
            System.out.println("DEBUG: New password and confirm password match");

            boolean isCurrentValid = userDB.verifyPassword(userId, currentPass);
            System.out.println("DEBUG: isCurrentValid = " + isCurrentValid);

            if (isCurrentValid) {
                userDB.updateUserPassword(userId, newPass);
                System.out.println("DEBUG: Password updated for user ID: " + userId);
            } else {
                System.out.println("DEBUG: Current password is incorrect.");
                request.setAttribute("error", "Current password is incorrect.");
            }
        } else {
            System.out.println("DEBUG: Passwords don't match or new password is empty");
        }

        response.sendRedirect("ProfileServlet?update=success");

    }
}
