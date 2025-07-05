package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Student;
import DBconnection.DatabaseConnection;

public class StudentDB {

    // INSERT
    public void insertStudent(Student student) {
        String sql = "INSERT INTO student (student_id, semester, intake, admin_id, course_id, name, lecturer_id, supervisor_id, examiner_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, student.getStudent_id());
            stmt.setInt(2, student.getSemester());
            stmt.setString(3, student.getIntake());
            stmt.setInt(4, student.getAdmin_id());
            stmt.setInt(5, student.getCourse_id());
            stmt.setString(6, student.getName());
            stmt.setInt(7, student.getLecturer_id());
            stmt.setInt(8, student.getSupervisor_id());
            stmt.setInt(9, student.getExaminer_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    public void updateStudent(Student student) {
        String sql = "UPDATE student SET semester = ?, intake = ?, admin_id = ?, course_id = ?, name = ?, lecturer_id = ?, supervisor_id = ?, examiner_id = ? WHERE student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, student.getSemester());
            stmt.setString(2, student.getIntake());
            stmt.setInt(3, student.getAdmin_id());
            stmt.setInt(4, student.getCourse_id());
            stmt.setString(5, student.getName());
            stmt.setInt(6, student.getLecturer_id());
            stmt.setInt(7, student.getSupervisor_id());
            stmt.setInt(8, student.getExaminer_id());
            stmt.setInt(9, student.getStudent_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public void deleteStudent(int studentId) {
        String sql = "DELETE FROM student WHERE student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // GET BY ID
    public static Student getStudentById(String id) {
        Student student = null;
        String sql = "SELECT * FROM student WHERE student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    student = new Student();
                    student.setStudent_id(rs.getInt("student_id"));
                    student.setSemester(rs.getInt("semester"));
                    student.setIntake(rs.getString("intake"));
                    student.setAdmin_id(rs.getInt("admin_id"));
                    student.setCourse_id(rs.getInt("course_id"));
                    student.setName(rs.getString("name"));
                    student.setLecturer_id(rs.getInt("lecturer_id"));
                    student.setSupervisor_id(rs.getInt("supervisor_id"));
                    student.setExaminer_id(rs.getInt("examiner_id"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return student;
    }

    // GET ALL
    public static List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM student";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setStudent_id(rs.getInt("student_id"));
                student.setSemester(rs.getInt("semester"));
                student.setIntake(rs.getString("intake"));
                student.setAdmin_id(rs.getInt("admin_id"));
                student.setCourse_id(rs.getInt("course_id"));
                student.setName(rs.getString("name"));
                student.setLecturer_id(rs.getInt("lecturer_id"));
                student.setSupervisor_id(rs.getInt("supervisor_id"));
                student.setExaminer_id(rs.getInt("examiner_id"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // GET BY SUPERVISOR ID
    public static List<Student> getStudentsBySupervisorId(int supervisorId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE supervisor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisorId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Student student = new Student();
                student.setStudent_id(rs.getInt("student_id"));
                student.setSemester(rs.getInt("semester"));
                student.setIntake(rs.getString("intake"));
                student.setAdmin_id(rs.getInt("admin_id"));
                student.setCourse_id(rs.getInt("course_id"));
                student.setName(rs.getString("name"));
                student.setLecturer_id(rs.getInt("lecturer_id"));
                student.setSupervisor_id(rs.getInt("supervisor_id"));
                student.setExaminer_id(rs.getInt("examiner_id"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // GET BY LECTURER ID
    public static List<Student> getStudentsByLecturerId(int lecturerId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE lecturer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lecturerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Student student = new Student();
                student.setStudent_id(rs.getInt("student_id"));
                student.setSemester(rs.getInt("semester"));
                student.setIntake(rs.getString("intake"));
                student.setAdmin_id(rs.getInt("admin_id"));
                student.setCourse_id(rs.getInt("course_id"));
                student.setName(rs.getString("name"));
                student.setLecturer_id(rs.getInt("lecturer_id"));
                student.setSupervisor_id(rs.getInt("supervisor_id"));
                student.setExaminer_id(rs.getInt("examiner_id"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // GET BY EXAMINER ID
    public static List<Student> getStudentsByExaminerId(int examinerId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE examiner_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, examinerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Student student = new Student();
                student.setStudent_id(rs.getInt("student_id"));
                student.setSemester(rs.getInt("semester"));
                student.setIntake(rs.getString("intake"));
                student.setAdmin_id(rs.getInt("admin_id"));
                student.setCourse_id(rs.getInt("course_id"));
                student.setName(rs.getString("name"));
                student.setLecturer_id(rs.getInt("lecturer_id"));
                student.setSupervisor_id(rs.getInt("supervisor_id"));
                student.setExaminer_id(rs.getInt("examiner_id"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }
}
