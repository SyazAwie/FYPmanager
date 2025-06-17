package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Forms;
import DBconnection.DatabaseConnection;

public class FormsDB {

    public void insertForm(Forms form) {
        String sql = "INSERT INTO FORMS (form_id, form_code, form_name, description, access_role, formDate, submitted_by, submitted_to, submitted_date, status, score, remarks, student_id, lecturer_id, supervisor_id, admin_id, examinerId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, form.getForm_id());
            stmt.setString(2, form.getForm_code());
            stmt.setString(3, form.getForm_name());
            stmt.setString(4, form.getDescription());
            stmt.setString(5, form.getAccess_role());
            stmt.setString(6, form.getFormDate());
            stmt.setString(7, form.getSubmitted_by());
            stmt.setString(8, form.getSubmitted_to());
            stmt.setString(9, form.getSubmitted_date());
            stmt.setString(10, form.getStatus());
            stmt.setDouble(11, form.getScore());
            stmt.setString(12, form.getRemarks());
            stmt.setInt(13, form.getStudent_id());
            stmt.setInt(14, form.getLecturer_id());
            stmt.setInt(15, form.getSupervisor_id());
            stmt.setInt(16, form.getAdmin_id());
            stmt.setInt(17, form.getExaminerId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Forms> getAllForms() {
        List<Forms> formList = new ArrayList<>();
        String sql = "SELECT * FROM FORMS";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Forms form = new Forms(
                    rs.getInt("form_id"),
                    rs.getString("form_code"),
                    rs.getString("form_name"),
                    rs.getString("description"),
                    rs.getString("access_role"),
                    rs.getString("formDate"),
                    rs.getString("submitted_by"),
                    rs.getString("submitted_to"),
                    rs.getString("submitted_date"),
                    rs.getString("status"),
                    rs.getDouble("score"),
                    rs.getString("remarks"),
                    rs.getInt("student_id"),
                    rs.getInt("lecturer_id"),
                    rs.getInt("supervisor_id"),
                    rs.getInt("admin_id"),
                    rs.getInt("examinerId")
                );
                formList.add(form);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return formList;
    }

    public void updateForm(Forms form) {
        String sql = "UPDATE FORMS SET form_code = ?, form_name = ?, description = ?, access_role = ?, formDate = ?, submitted_by = ?, submitted_to = ?, submitted_date = ?, status = ?, score = ?, remarks = ?, student_id = ?, lecturer_id = ?, supervisor_id = ?, admin_id = ?, examinerId = ? WHERE form_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, form.getForm_code());
            stmt.setString(2, form.getForm_name());
            stmt.setString(3, form.getDescription());
            stmt.setString(4, form.getAccess_role());
            stmt.setString(5, form.getFormDate());
            stmt.setString(6, form.getSubmitted_by());
            stmt.setString(7, form.getSubmitted_to());
            stmt.setString(8, form.getSubmitted_date());
            stmt.setString(9, form.getStatus());
            stmt.setDouble(10, form.getScore());
            stmt.setString(11, form.getRemarks());
            stmt.setInt(12, form.getStudent_id());
            stmt.setInt(13, form.getLecturer_id());
            stmt.setInt(14, form.getSupervisor_id());
            stmt.setInt(15, form.getAdmin_id());
            stmt.setInt(16, form.getExaminerId());
            stmt.setInt(17, form.getForm_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteForm(int formId) {
        String sql = "DELETE FROM FORMS WHERE form_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, formId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
