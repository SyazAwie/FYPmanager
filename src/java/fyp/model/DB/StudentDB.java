package fyp.model.DB;

import java.sql.*;
import java.util.*;
import java.util.List;
import fyp.model.Student;
import DBconnection.DatabaseConnection;

public class StudentDB {

    // Insert student
    public void insertStudent(Student student) {
        String sql = "INSERT INTO student (student_id, semester, intake, admin_id, course_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, student.getStudent_id());
            stmt.setInt(2, student.getSemester());
            stmt.setString(3, student.getIntake());
            stmt.setInt(4, student.getAdmin_id());
            stmt.setInt(5, student.getCourse_id());
            
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all students
    public static List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM student";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student(
                    rs.getInt("student_id"),
                    rs.getInt("semester"),
                    rs.getString("intake"),
                    rs.getInt("admin_id"),
                    rs.getInt("course_id")
                );
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // Update student
    public void updateStudent(Student student) {
        String sql = "UPDATE student SET semester = ?, intake = ?, admin_id = ?, course_id = ? WHERE student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, student.getSemester());
            stmt.setString(2, student.getIntake());
            stmt.setInt(3, student.getAdmin_id());
            stmt.setInt(4, student.getCourse_id());
            stmt.setInt(6, student.getStudent_id());
            

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete student
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
    
    // Get student by ID
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
            }
        }


        } catch (SQLException e) {
            e.printStackTrace();
        }

        return student;
    }
}
