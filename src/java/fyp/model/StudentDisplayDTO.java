package fyp.model;

/**
 *
 * @author syazw
 */
public class StudentDisplayDTO {
    
    private String name;
    private String studentId;
    private String programme;
    private String supervisorName;

    // Constructor
    public StudentDisplayDTO() {
        // Default constructor
    }

    // Parameterized constructor
    public StudentDisplayDTO(String name, String studentId, String programme, String supervisorName) {
        this.name = name;
        this.studentId = studentId;
        this.programme = programme;
        this.supervisorName = supervisorName;
    }

    // Getters and setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getProgramme() {
        return programme;
    }

    public void setProgramme(String programme) {
        this.programme = programme;
    }

    public String getSupervisorName() {
        return supervisorName;
    }

    public void setSupervisorName(String supervisorName) {
        this.supervisorName = supervisorName;
    }
}