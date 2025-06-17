package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Lecturer;
import DBconnection.DatabaseConnection;

public class LecturerDB {

    // Insert lecturer
    public void insertLecturer(Lecturer lecturer) {
        String sql = "INSERT INTO lecturer (lecturer_id, admin_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lecturer.getLecturer_id());
            stmt.setInt(2, lecturer.getAdmin_id());
            
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all lecturers
    public List<Lecturer> getAllLecturers() {
        List<Lecturer> lecturers = new ArrayList<>();
        String sql = "SELECT * FROM lecturer";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Lecturer lecturer = new Lecturer(
                    rs.getInt("lecturer_id"),
                    rs.getInt("admin_id")
                );
                lecturers.add(lecturer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lecturers;
    }

    // Update lecturer
    public void updateLecturer(Lecturer lecturer) {
        String sql = "UPDATE lecturer SET admin_id = ? WHERE lecturer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lecturer.getAdmin_id());
            stmt.setInt(2, lecturer.getLecturer_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete lecturer
    public void deleteLecturer(int lecturerId) {
        String sql = "DELETE FROM lecturer WHERE lecturer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lecturerId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Get lecturer by ID
    public static Lecturer getLecturerById(String id) {
        Lecturer lecturer = null;

        String sql = "SELECT * FROM Lecturer WHERE lecturer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    lecturer = new Lecturer();
                    lecturer.setLecturer_id(rs.getInt("lecturer_id"));
                    lecturer.setAdmin_id(rs.getInt("admin_id"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lecturer;
    }
}