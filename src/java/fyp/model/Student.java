package fyp.model;

/**
 *
 * @author syazw
 */
public class Student {
    private int student_id;
    private int semester;
    private String intake;
    private int admin_id;
    private int course_id;
    
    public Student(int student_id, int semester, String intake, int admin_id, int course_id){
        this.student_id = student_id;
        this.semester = semester;
        this.intake = intake;
        this.admin_id = admin_id;
        this.course_id = course_id;
    }
    
    public Student() {
        this.student_id = 0;
        this.semester = 0;
        this.intake = "";
        this.admin_id = 0;
        this.course_id = 0;
    }
    
    public int getStudent_id(){
        return student_id;
    }
    public void setStudent_id(int stdID){
        this.student_id = stdID;
    }
    
    public int getSemester(){
        return semester;
    }
    public void setSemester(int sem){
        this.semester = sem;
    }
    
    public String getIntake(){
        return intake;
    }
    public void setIntake(String intake){
        this.intake = intake;
    }
    
    public int getAdmin_id(){
        return admin_id;
    }
    public void setAdmin_id(int admID){
        this.admin_id = admID;
    }
    
    public int getCourse_id(){
        return course_id;
    }
    public void setCourse_id(int course){
        this.course_id = course;
    }
}
