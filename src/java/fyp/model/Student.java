package fyp.model;

public class Student {
    private int student_id;
    private int semester;
    private String intake;
    private int admin_id;
    private int course_id;
    private String name;
    private int lecturer_id;
    private int supervisor_id;
    private int examiner_id;

    public Student() {
        this.student_id = 0;
        this.semester = 0;
        this.intake = "";
        this.admin_id = 0;
        this.course_id = 0;
        this.name = "";
        this.lecturer_id = 0;
        this.supervisor_id = 0;
        this.examiner_id = 0;
    }

    public Student(int student_id, int semester, String intake, int admin_id, int course_id, String name, int lecturer_id, int supervisor_id, int examiner_id) {
        this.student_id = student_id;
        this.semester = semester;
        this.intake = intake;
        this.admin_id = admin_id;
        this.course_id = course_id;
        this.name = name;
        this.lecturer_id = lecturer_id;
        this.supervisor_id = supervisor_id;
        this.examiner_id = examiner_id;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public String getIntake() {
        return intake;
    }

    public void setIntake(String intake) {
        this.intake = intake;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }

    public int getCourse_id() {
        return course_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLecturer_id() {
        return lecturer_id;
    }

    public void setLecturer_id(int lecturer_id) {
        this.lecturer_id = lecturer_id;
    }

    public int getSupervisor_id() {
        return supervisor_id;
    }

    public void setSupervisor_id(int supervisor_id) {
        this.supervisor_id = supervisor_id;
    }

    public int getExaminer_id() {
        return examiner_id;
    }

    public void setExaminer_id(int examiner_id) {
        this.examiner_id = examiner_id;
    }
}
