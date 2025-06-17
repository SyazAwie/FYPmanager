package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.SupervisorAssignment;
import DBconnection.DatabaseConnection;

public class SupervisorAssignmentDB {

    // Insert supervisor assignment
    public void insertAssignment(SupervisorAssignment assignment) {
        String sql = "INSERT INTO SUPERVISORASSIGNMENT (assignment_id, assigned_date, status, student_id, supervisor_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, assignment.getAssignment_id());
            stmt.setString(2, assignment.getAssigned_date());
            stmt.setString(3, assignment.getStatus());
            stmt.setInt(4, assignment.getStudent_id());
            stmt.setInt(5, assignment.getSupervisor_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all assignments
    public List<SupervisorAssignment> getAllAssignments() {
        List<SupervisorAssignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM SUPERVISORASSIGNMENT";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                SupervisorAssignment assignment = new SupervisorAssignment(
                    rs.getInt("assignment_id"),
                    rs.getString("assigned_date"),
                    rs.getString("status"),
                    rs.getInt("student_id"),
                    rs.getInt("supervisor_id")
                );
                assignments.add(assignment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assignments;
    }

    // Update assignment
    public void updateAssignment(SupervisorAssignment assignment) {
        String sql = "UPDATE SUPERVISORASSIGNMENT SET assigned_date = ?, status = ?, student_id = ?, supervisor_id = ? WHERE assignment_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, assignment.getAssigned_date());
            stmt.setString(2, assignment.getStatus());
            stmt.setInt(3, assignment.getStudent_id());
            stmt.setInt(4, assignment.getSupervisor_id());
            stmt.setInt(5, assignment.getAssignment_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete assignment
    public void deleteAssignment(int assignmentId) {
        String sql = "DELETE FROM SUPERVISORASSIGNMENT WHERE assignment_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, assignmentId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
