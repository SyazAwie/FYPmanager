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

    // ===================== Insert Form =====================
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

    // ===================== Get All Forms =====================
    public List<Forms> getAllForms() {
        List<Forms> formList = new ArrayList<>();
        String sql = "SELECT * FROM FORMS";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
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
    // ===================== Get Generic Form Data by Code =====================
    public Map<String, String> getFormDataByCode(int studentId, String formCode) throws SQLException {
    String sql = "SELECT * FROM forms WHERE student_id = ? AND form_code = ?";
    Map<String, String> data = new HashMap<>();

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, studentId);
        ps.setString(2, formCode);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                ResultSetMetaData meta = rs.getMetaData();
                int columnCount = meta.getColumnCount();

                for (int i = 1; i <= columnCount; i++) {
                    String columnName = meta.getColumnName(i);
                    String value = rs.getString(i);
                    data.put(columnName, value != null ? value : "");
                }
            }
        }
    }

    return data;
    }
    // ===================== Save or Update Generic Form =====================
    public void saveOrUpdateForm(Forms form) throws SQLException {
    // Check if the form already exists
    String checkSql = "SELECT form_id FROM forms WHERE form_code = ? AND student_id = ?";
    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setString(1, form.getForm_code());
        checkStmt.setInt(2, form.getStudent_id());
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Update existing form
            form.setForm_id(rs.getInt("form_id"));
            updateForm(form);
        } else {
            // Insert new form
            insertForm(form);
        }
    }
    }
    public int getFormIdByStudentAndCode(int studentId, String formCode) throws SQLException {
    String sql = "SELECT form_id FROM forms WHERE student_id = ? AND form_code = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, studentId);
        stmt.setString(2, formCode);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getInt("form_id");
        }
    }
    return 0;
    }

    // ===================== Update Form =====================
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

    // ===================== Delete Form =====================
    public void deleteForm(int formId) {
        String sql = "DELETE FROM FORMS WHERE form_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, formId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // ===================== Save or Update F1 Form =====================
    public void saveFormF1(int studentId, String studentSignature) throws SQLException {
    String formCode = "F1";

    String checkSql = "SELECT form_id FROM forms WHERE form_code = ? AND student_id = ?";
    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setString(1, formCode);
        checkStmt.setInt(2, studentId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Form exists - update
            int formId = rs.getInt("form_id");
            String updateSql = "UPDATE forms SET remarks = ?, submit = 'yes', submitted_date = CURRENT_DATE WHERE form_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, studentSignature);
                updateStmt.setInt(2, formId);
                updateStmt.executeUpdate();
                System.out.println("DEBUG: F1 form updated.");
            }
        } else {
            // Form doesn't exist - insert
            String insertSql = "INSERT INTO forms (form_code, form_name, remarks, submit, submitted_date, student_id) VALUES (?, ?, ?, 'yes', CURRENT_DATE, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, formCode);
                insertStmt.setString(2, "Mutual Acceptance Form");
                insertStmt.setString(3, studentSignature);
                insertStmt.setInt(4, studentId);
                insertStmt.executeUpdate();
                System.out.println("DEBUG: F1 form inserted.");
            }
        }
    }
}

      // ===================== Prefill F2 Data =====================
    public Map<String, String> getFormF2Data(int studentId) throws SQLException {
    String sql = "SELECT pi.title AS project_title, u.name AS student_name, s.student_id, u2.name AS supervisor_name " +
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
                data.put("studentId", rs.getString("student_id"));
                data.put("projectTitle", rs.getString("project_title"));
                data.put("supervisorName", rs.getString("supervisor_name"));
            }
        }
    }
    return data;
    }
    
    // ===================== Insert F5 Logs =====================
    public void insertF5Logs(int formId, String[] dates, String[] completed, String[] next, String[] signatures) throws SQLException {
    // Optional: clear old logs if re-submitted
    String deleteSql = "DELETE FROM f5_logs WHERE form_id = ?";
    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
        deleteStmt.setInt(1, formId);
        deleteStmt.executeUpdate();
    }

    String sql = "INSERT INTO f5_logs (form_id, meeting_date, completed, next_task, supervisor_signature) VALUES (?, ?, ?, ?, ?)";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        for (int i = 0; i < dates.length; i++) {
            stmt.setInt(1, formId);
            stmt.setString(2, dates[i]);
            stmt.setString(3, completed[i]);
            stmt.setString(4, next[i]);
            stmt.setString(5, signatures[i]);
            stmt.addBatch();
        }
        stmt.executeBatch();
    }
}

        // ===================== Get F5 Logs =====================
       public List<Map<String, String>> getF5Logs(int formId) throws SQLException {
    List<Map<String, String>> logs = new ArrayList<>();
    String sql = "SELECT * FROM f5_logs WHERE form_id = ? ORDER BY meeting_date ASC";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, formId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Map<String, String> log = new HashMap<>();
            log.put("date", rs.getString("meeting_date"));
            log.put("completed", rs.getString("completed"));
            log.put("next", rs.getString("next_task"));
            log.put("signature", rs.getString("supervisor_signature"));
            logs.add(log);
        }
    }
    return logs;
    }
       public int getStudentIdBySupervisor(int supervisorId) throws SQLException {
    String sql = "SELECT student_id FROM project_idea WHERE supervisor_id = ? AND status = 'ACCEPTED' LIMIT 1";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, supervisorId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getInt("student_id");
        }
    }
    return 0;
    }
       // ===================== Save F6a Form =====================
       public void saveFormF6a(int studentId, int supervisorId, double similarityIndex, boolean confirm) throws SQLException {
    String formCode = "F6a";

    // Check if form exists
    String checkSql = "SELECT form_id FROM forms WHERE form_code = ? AND student_id = ?";
    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setString(1, formCode);
        checkStmt.setInt(2, studentId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Update
            int formId = rs.getInt("form_id");
            String updateSql = "UPDATE forms SET similarity_index = ?, plagiarism_confirm = ?, submitted_date = CURRENT_DATE, status = 'Submitted' WHERE form_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setDouble(1, similarityIndex);
                updateStmt.setString(2, confirm ? "yes" : "no");
                updateStmt.setInt(3, formId);
                updateStmt.executeUpdate();
            }
        } else {
            // Insert
            String insertSql = "INSERT INTO forms (form_code, form_name, student_id, supervisor_id, similarity_index, plagiarism_confirm, submitted_date, status) VALUES (?, ?, ?, ?, ?, ?, CURRENT_DATE, 'Submitted')";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, formCode);
                insertStmt.setString(2, "Report Submission (F6a)");
                insertStmt.setInt(3, studentId);
                insertStmt.setInt(4, supervisorId);
                insertStmt.setDouble(5, similarityIndex);
                insertStmt.setString(6, confirm ? "yes" : "no");
                insertStmt.executeUpdate();
            }
             }
            }
        }
        


    // ===================== Prefill F7 Data =====================
    public Map<String, String> getFormF7Data(int studentId) throws SQLException {
        String sql = "SELECT pi.title, pi.description, u.name AS student_name, s.intake AS programme, " +
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
                    data.put("programme", rs.getString("programme"));
                    data.put("supervisorName", rs.getString("supervisor_name"));
                    data.put("supervisorEmail", rs.getString("supervisor_email"));
                    data.put("projectTitle", rs.getString("title"));
                    data.put("projectDescription", rs.getString("description"));
                }
            }
        }
        return data;
    }

    // ===================== Save or Update F7 Form =====================
    public void saveFormF7(int studentId, String role, double score, String scoringDate) throws SQLException {
        int supervisorId = getSupervisorIdByStudent(studentId);

        boolean isSupervisor = "supervisor".equalsIgnoreCase(role);
        boolean isExaminer = "examiner".equalsIgnoreCase(role);

        String checkSql = "SELECT * FROM forms WHERE form_code = 'F7' AND student_id = ? AND " +
                (isSupervisor ? "supervisor_id = ?" : "examinerId = ?");
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, studentId);
            checkStmt.setInt(2, supervisorId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE forms SET score = ?, submitted_date = ?, status = 'Submitted' " +
                        "WHERE form_code = 'F7' AND student_id = ? AND " +
                        (isSupervisor ? "supervisor_id = ?" : "examinerId = ?");
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setDouble(1, score);
                    updateStmt.setString(2, scoringDate);
                    updateStmt.setInt(3, studentId);
                    updateStmt.setInt(4, supervisorId);
                    updateStmt.executeUpdate();
                }
            } else {
                Forms form = new Forms(
                        0,
                        "F7",
                        "Project Formulation Evaluation",
                        null,
                        role,
                        scoringDate,
                        String.valueOf(studentId),
                        String.valueOf(supervisorId),
                        scoringDate,
                        "Submitted",
                        score,
                        null,
                        studentId,
                        0,
                        isSupervisor ? supervisorId : 0,
                        0,
                        isExaminer ? supervisorId : 0
                );
                insertForm(form);
            }
        }
    }
      

    // ===================== Get Score by Role (F7 only) =====================
    public Double getF7ScoreByRole(int studentId, String role) throws SQLException {
        String sql;
        if ("supervisor".equalsIgnoreCase(role)) {
            sql = "SELECT score FROM forms WHERE form_code = 'F7' AND student_id = ? AND supervisor_id > 0";
        } else if ("examiner".equalsIgnoreCase(role)) {
            sql = "SELECT score FROM forms WHERE form_code = 'F7' AND student_id = ? AND examinerId > 0";
        } else {
            return null;
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("score");
            }
        }
        return null;
    }
    // ===================== Prefill F8 Data =====================
public Map<String, String> getFormF8Data(int studentId) throws SQLException {
    String sql = "SELECT pi.title, pi.description, u.name AS student_name, s.intake AS programme, " +
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
                data.put("programme", rs.getString("programme"));
                data.put("supervisorName", rs.getString("supervisor_name"));
                data.put("supervisorEmail", rs.getString("supervisor_email"));
                data.put("projectTitle", rs.getString("title"));
                data.put("projectDescription", rs.getString("description"));
            }
        }
    }
    return data;
}
    // ===================== Get Score by Role (F8 only) =====================
    public Double getF8ScoreByRole(int studentId, String role) throws SQLException {
    String sql;
    if ("supervisor".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F8' AND student_id = ? AND supervisor_id > 0";
    } else if ("examiner".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F8' AND student_id = ? AND examinerId > 0";
    } else {
        return null;
    }

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, studentId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getDouble("score");
        }
    }
    return null;
}
    // ===================== Save or Update F8 Form =====================
    public void saveFormF8(int studentId, String role, double score, String scoringDate) throws SQLException {
    int supervisorId = getSupervisorIdByStudent(studentId);
    boolean isSupervisor = "supervisor".equalsIgnoreCase(role);
    boolean isExaminer = "examiner".equalsIgnoreCase(role);

    String checkSql = "SELECT * FROM forms WHERE form_code = 'F8' AND student_id = ? AND " +
                      (isSupervisor ? "supervisor_id = ?" : "examinerId = ?");

    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setInt(1, studentId);
        checkStmt.setInt(2, supervisorId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Form exists - update score
            String updateSql = "UPDATE forms SET score = ?, submitted_date = ?, status = 'Submitted' " +
                               "WHERE form_code = 'F8' AND student_id = ? AND " +
                               (isSupervisor ? "supervisor_id = ?" : "examinerId = ?");
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setDouble(1, score);
                updateStmt.setString(2, scoringDate);
                updateStmt.setInt(3, studentId);
                updateStmt.setInt(4, supervisorId);
                updateStmt.executeUpdate();
            }
        } else {
            // Insert new
            Forms form = new Forms(
                    0,
                    "F8",
                    "Project Formulation Evaluation",
                    null,
                    role,
                    scoringDate,
                    String.valueOf(studentId),
                    String.valueOf(supervisorId),
                    scoringDate,
                    "Submitted",
                    score,
                    null,
                    studentId,
                    0,
                    isSupervisor ? supervisorId : 0,
                    0,
                    isExaminer ? supervisorId : 0
            );
            insertForm(form);
        }
    }
}
 public void saveFormF9(int studentId, String role, double score, String evaluationDate) throws SQLException {
    String sql = "INSERT INTO forms (form_code, student_id, role, score, submitted_date, status) VALUES (?, ?, ?, ?, ?, ?)";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, "F9");
        stmt.setInt(2, studentId);
        stmt.setString(3, role);
        stmt.setDouble(4, score);
        stmt.setString(5, evaluationDate);
        stmt.setString(6, "Submitted");
        stmt.executeUpdate();
    }
}
    public void saveFormF10(int studentId, String role, double score, String evaluationDate) throws SQLException {
    int supervisorId = getSupervisorIdByStudent(studentId);
    boolean isSupervisor = "supervisor".equalsIgnoreCase(role);
    boolean isExaminer = "examiner".equalsIgnoreCase(role);
    boolean isLecturer = "lecturer".equalsIgnoreCase(role); // optional, in case of multiple roles

    String checkSql = "SELECT * FROM forms WHERE form_code = 'F10' AND student_id = ? AND " +
                      (isSupervisor ? "supervisor_id = ?" : isExaminer ? "examinerId = ?" : "lecturer_id = ?");

    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
        checkStmt.setInt(1, studentId);
        checkStmt.setInt(2, supervisorId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // If exists, update
            String updateSql = "UPDATE forms SET score = ?, submitted_date = ?, status = 'Submitted' " +
                               "WHERE form_code = 'F10' AND student_id = ? AND " +
                               (isSupervisor ? "supervisor_id = ?" : isExaminer ? "examinerId = ?" : "lecturer_id = ?");
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setDouble(1, score);
                updateStmt.setString(2, evaluationDate);
                updateStmt.setInt(3, studentId);
                updateStmt.setInt(4, supervisorId);
                updateStmt.executeUpdate();
            }
        } else {
            // Insert new
            Forms form = new Forms(
                0,
                "F10",
                "Poster Presentation Evaluation",
                null,
                role,
                evaluationDate,
                String.valueOf(studentId),
                String.valueOf(supervisorId),
                evaluationDate,
                "Submitted",
                score,
                null,
                studentId,
                isLecturer ? supervisorId : 0,
                isSupervisor ? supervisorId : 0,
                0,
                isExaminer ? supervisorId : 0
            );
            insertForm(form);
        }
    }
}
    
            public Double getF10ScoreByRole(int studentId, String role) throws SQLException {
    String sql;
    if ("supervisor".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F10' AND student_id = ? AND supervisor_id > 0";
    } else if ("examiner".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F10' AND student_id = ? AND examinerId > 0";
    } else {
        return null;
    }

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, studentId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getDouble("score");
        }
    }
    return null;
}
    public Map<String, String> getFormF11Data(int studentId) throws SQLException {
    return getFormDataByCode(studentId, "F11");
}
    public Double getF11ScoreByRole(int studentId, String role) throws SQLException {
    String sql;
    if ("supervisor".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F11' AND student_id = ? AND supervisor_id > 0";
    } else if ("examiner".equalsIgnoreCase(role)) {
        sql = "SELECT score FROM forms WHERE form_code = 'F11' AND student_id = ? AND examinerId > 0";
    } else {
        return null;
    }

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, studentId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getDouble("score");
        }
    }
    return null;
}

    
    public static boolean saveF13Form(Forms form) {
    String sql = "INSERT INTO forms (form_code, form_name, description, access_role, formDate, submitted_by, submitted_to, submitted_date, status, score, student_id, lecturer_id, supervisor_id, admin_id, examinerId) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
        stmt.setDouble(10, form.getScore() != null ? form.getScore() : 0.0);
        stmt.setInt(11, form.getStudent_id());
        stmt.setInt(12, form.getLecturer_id());
        stmt.setInt(13, form.getSupervisor_id());
        stmt.setInt(14, form.getAdmin_id());
        stmt.setInt(15, form.getExaminerId());

        int rows = stmt.executeUpdate();
        return rows > 0;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    // ===================== Get Supervisor ID =====================
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