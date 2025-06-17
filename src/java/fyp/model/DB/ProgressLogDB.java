package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.ProgressLog;
import DBconnection.DatabaseConnection;

public class ProgressLogDB {

    // Insert progress log
    public void insertProgressLog(ProgressLog log) {
        String sql = "INSERT INTO PROGRESSLOG (progress_id, update_date, description, next_meeting, project_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, log.getProgress_id());
            stmt.setString(2, log.getUpdate_date());
            stmt.setString(3, log.getDescription());
            stmt.setString(4, log.getNext_meeting());
            stmt.setInt(5, log.getProject_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all progress logs
    public List<ProgressLog> getAllProgressLogs() {
        List<ProgressLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM PROGRESSLOG";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                ProgressLog log = new ProgressLog(
                    rs.getInt("progress_id"),
                    rs.getString("update_date"),
                    rs.getString("description"),
                    rs.getString("next_meeting"),
                    rs.getInt("project_id")
                );
                logs.add(log);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return logs;
    }

    // Update progress log
    public void updateProgressLog(ProgressLog log) {
        String sql = "UPDATE PROGRESSLOG SET update_date = ?, description = ?, next_meeting = ?, project_id = ? WHERE progress_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, log.getUpdate_date());
            stmt.setString(2, log.getDescription());
            stmt.setString(3, log.getNext_meeting());
            stmt.setInt(4, log.getProject_id());
            stmt.setInt(5, log.getProgress_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete progress log
    public void deleteProgressLog(int progressId) {
        String sql = "DELETE FROM PROGRESSLOG WHERE progress_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, progressId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
