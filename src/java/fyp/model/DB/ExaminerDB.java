package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Examiner;
import DBconnection.DatabaseConnection;

public class ExaminerDB {

    // Insert examiner
    public void insertExaminer(Examiner examiner) {
        String sql = "INSERT INTO examiner (examiner_id, assigned_project, admin_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, examiner.getExaminer_id());
            stmt.setInt(2, examiner.getAssigned_project());
            stmt.setInt(3, examiner.getAdmin_id());
            
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all examiners
    public List<Examiner> getAllExaminers() {
        List<Examiner> examiners = new ArrayList<>();
        String sql = "SELECT * FROM examiner";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Examiner examiner = new Examiner(
                    rs.getInt("examiner_id"),
                    rs.getInt("assigned_project"),
                    rs.getInt("admin_id")
                );
                examiners.add(examiner);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return examiners;
    }

    // Update examiner
    public void updateExaminer(Examiner examiner) {
        String sql = "UPDATE examiner SET assigned_project = ?, admin_id = ? WHERE examiner_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, examiner.getAssigned_project());
            stmt.setInt(2, examiner.getAdmin_id());
            stmt.setInt(3, examiner.getExaminer_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete examiner
    public void deleteExaminer(int examinerId) {
        String sql = "DELETE FROM examiner WHERE examiner_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, examinerId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Get examiner by ID
    public static Examiner getExaminerById(String id) {
        Examiner examiner = null;
        String sql = "SELECT * FROM examiner WHERE examiner_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    examiner = new Examiner();
                    examiner.setExaminer_id(rs.getInt("examiner_id"));
                    examiner.setAssigned_project(rs.getInt("assigned_project"));
                    examiner.setAdmin_id(rs.getInt("admin_id"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return examiner;
    }
}