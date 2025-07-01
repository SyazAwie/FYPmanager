package fyp.model.DB;

import java.sql.*;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import fyp.model.User; 
import DBconnection.DatabaseConnection;


public class UserDB {

    // Insert user
    public void insertUser(User user) {
        String sql = "INSERT INTO USERS (user_id, name, email, phoneNum, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, user.getUser_id());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhoneNum());
            stmt.setString(5, user.getPassword());
            stmt.setString(6, user.getRole());
            stmt.setString(7, user.getAvatar());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM USERS";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phoneNum"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("avatar")
                );
                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    // Update user
    public void updateUser(User user) {
        String sql = "UPDATE USERS SET name = ?, email = ?, phoneNum = ?, password = ?, role = ?, avatar = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNum());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getAvatar());
            stmt.setInt(7, user.getUser_id());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete user
    public void deleteUser(int userId) {
        String sql = "DELETE FROM USERS WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public User getUserByIdAndPassword(int id, String password, String role) {
        String sql = "SELECT * FROM USERS WHERE user_id = ? AND TRIM(password) = TRIM(?) AND TRIM(role) = TRIM(?)";
        System.out.println("SQL TEST: id=" + id + ", password=" + password + ", role=" + role);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.setString(2, password);
            stmt.setString(3, role);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phoneNum"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("avatar")
                    );
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update avatar
    public void updateUserAvatar(int userId, String avatarFileName) {
        String sql = "UPDATE users SET avatar = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, avatarFileName);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get current avatar
    public String getUserAvatar(int userId) {
        String sql = "SELECT avatar FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("avatar");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public static User getUserById(int userId) {
        String sql = "SELECT * FROM USERS WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phoneNum"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("avatar")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    public void updateUserProfile(int userId, String phone, String email, String avatarFile, String password) {
        StringBuilder sql = new StringBuilder("UPDATE users SET phone = ?, email = ?");
        boolean hasAvatar = avatarFile != null && !avatarFile.trim().isEmpty();
        boolean hasPassword = password != null && !password.trim().isEmpty();

        if (hasAvatar) {
            sql.append(", avatar = ?");
        }

        if (hasPassword) {
            sql.append(", password = ?");
        }

        sql.append(" WHERE user_id = ?");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            stmt.setString(paramIndex++, phone);
            stmt.setString(paramIndex++, email);

            if (hasAvatar) {
                stmt.setString(paramIndex++, avatarFile);
            }

            if (hasPassword) {
                stmt.setString(paramIndex++, hashPassword(password));
            }

            stmt.setInt(paramIndex, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace(); // Replace with proper logging if needed
        }
    }
    
    public void updateUserContact(int userId, String phone, String email) {
        String sql = "UPDATE users SET phoneNum = ?, email = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, phone);
            stmt.setString(2, email);
            stmt.setInt(3, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ✅ Password hashing using SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    public boolean verifyPassword(int userId, String inputPassword) {
        String sql = "SELECT password FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("password").trim();
                String inputHashedPassword = hashPassword(inputPassword); // hash user input
                System.out.println("DEBUG: Fetching password for user ID = " + userId);
                System.out.println("DEBUG: Input Hashed = " + inputHashedPassword);
                System.out.println("DEBUG: Stored Hashed = " + storedHashedPassword);

                return storedHashedPassword.equals(inputHashedPassword); // compare hashes
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    
    public void updateUserPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String hashedPassword = hashPassword(newPassword); // use your hashing method
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        System.out.println("Password updated for user ID: " + userId);

    }

    public static List<String> getUserRoles(String userId) {
    List<String> roles = new ArrayList<>();
    String sql = "SELECT role FROM users WHERE user_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            roles.add(rs.getString("role"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return roles;
}



    
}
