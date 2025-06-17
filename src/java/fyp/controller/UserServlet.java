package fyp.controller;

import fyp.model.DB.UserDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet(name = "UserServlet", urlPatterns = {"/UploadAvatar", "/DeleteAvatar"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class UserServlet extends HttpServlet {

    // Use a fixed, permanent location for uploaded avatars
    private static final String AVATAR_UPLOAD_DIR = "C:\\uploads_FYPavatar";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET not supported for this action.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String userIdStr = request.getParameter("user_id");

        if (userIdStr == null || userIdStr.isEmpty()) {
            throw new ServletException("Missing or empty user_id");
        }

        int userId = Integer.parseInt(userIdStr);
        UserDB userDB = new UserDB();

        if ("/UploadAvatar".equals(path)) {
            Part filePart = request.getPart("avatar");
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileName = userId + "_" + originalFileName;

            // Create upload folder if it doesn't exist
            File uploadDir = new File(AVATAR_UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Delete old avatar if exists
            String oldAvatar = userDB.getUserAvatar(userId);
            if (oldAvatar != null && !oldAvatar.equals(fileName)) {
                File oldFile = new File(AVATAR_UPLOAD_DIR, oldAvatar);
                if (oldFile.exists()) oldFile.delete();
            }

            // Save the new file
            File file = new File(uploadDir, fileName);
            try (InputStream input = filePart.getInputStream();
                 OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // Update database
            userDB.updateUserAvatar(userId, fileName);
            System.out.println("User ID Param: " + userId);
            System.out.println(">>> UploadAvatar triggered <<<");

            response.sendRedirect("Profile.jsp?upload=success");

        } else if ("/DeleteAvatar".equals(path)) {
            String currentAvatar = userDB.getUserAvatar(userId);

            if (currentAvatar != null && !currentAvatar.trim().isEmpty()) {
                File file = new File(AVATAR_UPLOAD_DIR, currentAvatar);
                if (file.exists()) file.delete();
            }

            userDB.updateUserAvatar(userId, null);
            response.sendRedirect("Profile.jsp?delete=success");
        }
    }
}
