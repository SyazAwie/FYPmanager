package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Supervisor;
import DBconnection.DatabaseConnection;

public class SupervisorDB {

    // Insert supervisor
    public void insertSupervisor(Supervisor supervisor) {
        String sql = "INSERT INTO supervisor (supervisor_id, quota, roleOfInterest, pastProject, admin_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisor.getSupervisor_id());
            stmt.setInt(2, supervisor.getQuota());
            stmt.setString(3, supervisor.getRoleOfInterest());
            stmt.setString(4, supervisor.getPastProject());
            stmt.setInt(5, supervisor.getAdmin_id());
            
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all supervisors
    public List<Supervisor> getAllSupervisors() {
        List<Supervisor> supervisors = new ArrayList<>();
        String sql = "SELECT * FROM supervisor";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Supervisor supervisor = new Supervisor(
                    rs.getInt("supervisor_id"),
                    rs.getInt("quota"),
                    rs.getString("roleOfInterest"),
                    rs.getString("pastProject"),
                    rs.getInt("admin_id")
                );
                supervisors.add(supervisor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return supervisors;
    }

    // Update supervisor
    public void updateSupervisor(Supervisor supervisor) {
        String sql = "UPDATE supervisor SET quota = ?, roleOfInterest = ?, pastProject = ?, admin_id = ? WHERE supervisor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisor.getQuota());
            stmt.setString(2, supervisor.getRoleOfInterest());
            stmt.setString(3, supervisor.getPastProject());
            stmt.setInt(4, supervisor.getAdmin_id());
            stmt.setInt(5, supervisor.getSupervisor_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete supervisor
    public void deleteSupervisor(int supervisorId) {
        String sql = "DELETE FROM supervisor WHERE supervisor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisorId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Get supervisor by ID
    public static Supervisor getSupervisorById(String id) {
        Supervisor supervisor = null;

        String sql = "SELECT * FROM supervisor WHERE supervisor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    supervisor = new Supervisor();
                    supervisor.setSupervisor_id(rs.getInt("supervisor_id"));
                    supervisor.setQuota(rs.getInt("quota"));
                    supervisor.setRoleOfInterest(rs.getString("roleOfInterest"));
                    supervisor.setPastProject(rs.getString("pastProject"));
                    supervisor.setAdmin_id(rs.getInt("admin_id"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return supervisor;
    }
    
    // Get supervisors by admin ID
    public List<Supervisor> getSupervisorsByAdminId(int adminId) {
        List<Supervisor> supervisors = new ArrayList<>();
        String sql = "SELECT * FROM supervisor WHERE admin_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, adminId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Supervisor supervisor = new Supervisor(
                    rs.getInt("supervisor_id"),
                    rs.getInt("quota"),
                    rs.getString("roleOfInterest"),
                    rs.getString("pastProject"),
                    rs.getInt("admin_id")
                );
                supervisors.add(supervisor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return supervisors;
    }
    
    // Reduce supervisor quota by 1
    public void reduceQuota(int supervisorId) {
        String sql = "UPDATE supervisor SET quota = quota - 1 WHERE supervisor_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisorId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Increase supervisor quota by 1
    public void increaseQuota(int supervisorId) {
        String sql = "UPDATE supervisor SET quota = quota + 1 WHERE supervisor_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisorId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}