package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Admin;
import DBconnection.DatabaseConnection;

public class AdminDB {

    // Insert admin
    public void insertAdmin(Admin admin) {
        String sql = "INSERT INTO admin (user_id, email) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, admin.getUserId());
            stmt.setString(2, admin.getEmail());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all admins
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admin";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Admin admin = new Admin(
                    rs.getString("user_id"),
                    rs.getString("email")
                );
                admins.add(admin);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return admins;
    }

    // Update admin
    public void updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET email = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, admin.getEmail());
            stmt.setString(2, admin.getUserId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete admin
    public void deleteAdmin(String userId) {
        String sql = "DELETE FROM admin WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get admin by ID
    public static Admin getAdminById(String userId) {
        Admin admin = null;
        String sql = "SELECT * FROM admin WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setUserId(rs.getString("user_id"));
                    admin.setEmail(rs.getString("email"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return admin;
    }
}
