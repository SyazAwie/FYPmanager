package fyp.model;

public class Course {
    private int course_id;
    private String course_code;
    private String courseName;

    public Course(int course_id, String course_code, String courseName) {
        this.course_id = course_id;
        this.course_code = course_code;
        this.courseName = courseName;
    }

    // Getters
    public int getCourse_id() {
        return course_id;
    }

    public String getCourse_code() {
        return course_code;
    }

    public String getCourseName() {
        return courseName;
    }

    // Setters
    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public void setCourse_code(String course_code) {
        this.course_code = course_code;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
}
