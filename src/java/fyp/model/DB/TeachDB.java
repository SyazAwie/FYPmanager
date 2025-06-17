package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Teach;
import DBconnection.DatabaseConnection;

public class TeachDB {

    // Insert teach
    public void insertTeach(Teach teach) {
        String sql = "INSERT INTO TEACH (teach_id, course_id, lect_id) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teach.getTeach_id());
            stmt.setInt(2, teach.getCourse_id());
            stmt.setInt(3, teach.getLect_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all teach records
    public List<Teach> getAllTeach() {
        List<Teach> teachList = new ArrayList<>();
        String sql = "SELECT * FROM TEACH";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Teach teach = new Teach(
                    rs.getInt("teach_id"),
                    rs.getInt("course_id"),
                    rs.getInt("lect_id")
                );
                teachList.add(teach);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return teachList;
    }

    // Update teach record
    public void updateTeach(Teach teach) {
        String sql = "UPDATE TEACH SET course_id = ?, lect_id = ? WHERE teach_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teach.getCourse_id());
            stmt.setInt(2, teach.getLect_id());
            stmt.setInt(3, teach.getTeach_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete teach record
    public void deleteTeach(int teachId) {
        String sql = "DELETE FROM TEACH WHERE teach_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teachId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
