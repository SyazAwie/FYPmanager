package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Forms;
import DBconnection.DatabaseConnection;

public class FormsDB {
    
    Connection conn = DatabaseConnection.getConnection();
    
    public FormsDB(Connection conn) {
        this.conn = conn;
    }


    public void insertForm(Forms form) {
        String sql = "INSERT INTO FORMS (form_id, form_code, form_name, description, access_role, formDate, submitted_by, submitted_to, submitted_date, status, score, remarks, student_id, lecturer_id, supervisor_id, admin_id, examinerId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Statement stmt = conn.createStatement();
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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, formId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Map<String, String> getFormF1Data(int studentId) throws SQLException {
        String sql = "SELECT pi.projectIdea_id, pi.title, pi.description, " +
                "u.name AS student_name, u.email AS student_email, s.semester, s.intake, " +
                "sup.supervisor_id, sup.roleOfInterest, sup.pastProject, " +
                "u2.name AS supervisor_name, u2.email AS supervisor_email " +
                "FROM project_idea pi " +
                "JOIN student s ON pi.student_id = s.student_id " +
                "JOIN users u ON s.student_id = u.user_id " +
                "JOIN supervisor sup ON pi.supervisor_id = sup.supervisor_id " +
                "JOIN users u2 ON sup.supervisor_id = u2.user_id " +
                "WHERE pi.student_id = ? AND pi.status = 'ACCEPTED'";

        Map<String, String> data = new HashMap<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    data.put("studentName", rs.getString("student_name"));
                    data.put("studentId", String.valueOf(studentId));
                    data.put("programme", rs.getString("intake"));

                    data.put("supervisorName", rs.getString("supervisor_name"));
                    data.put("supervisorEmail", rs.getString("supervisor_email"));

                    data.put("projectTitle", rs.getString("title"));
                    data.put("projectDescription", rs.getString("description"));
                }
            }
        }
        return data;
    }

    // Simpan Form F1
    public void saveFormF1(int studentId, String studentSignature) throws SQLException {
        int supervisorId = getSupervisorIdByStudent(studentId);

        String sql = "INSERT INTO forms (form_code, form_name, student_id, supervisor_id, submitted_by, submitted_date, status, description) " +
                     "VALUES (?, ?, ?, ?, ?, NOW(), ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "F1");
            ps.setString(2, "Form Agreement");
            ps.setInt(3, studentId);
            ps.setInt(4, supervisorId);
            ps.setString(5, String.valueOf(studentId));
            ps.setString(6, "Submitted");
            ps.setString(7, studentSignature);
            ps.executeUpdate();
        }
    }

    private int getSupervisorIdByStudent(int studentId) throws SQLException {
        String sql = "SELECT supervisor_id FROM project_idea WHERE student_id = ? AND status = 'ACCEPTED'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("supervisor_id");
                }
            }
        }
        return 0;
    }
}
