package fyp.model;

public class Project_Idea {
    private int projectIdea_id;
    private String title;
    private String scope;
    private String description;
    private String status;
    private int student_id;
    private Integer supervisor_id;

    // Parameterized constructor
    public Project_Idea(int projectIdea_id, String title, String scope, String description, 
                      String status, int student_id, int supervisor_id) {
        this.projectIdea_id = projectIdea_id;
        this.title = title;
        this.scope = scope;
        this.description = description;
        this.status = status;
        this.student_id = student_id;
        this.supervisor_id = supervisor_id;
    }

    // Default constructor
    public Project_Idea() {
        this.projectIdea_id = 0;
        this.title = "";
        this.description = "";
        this.status = "Pending"; // Default status
        this.student_id = 0;
        this.supervisor_id = 0;
    }

    // Getters and setters
    public int getProjectIdea_id() {
        return projectIdea_id;
    }

    public void setProjectIdea_id(int projectIdea_id) {
        this.projectIdea_id = projectIdea_id;
    }

    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public Integer getSupervisor_id() {
        return supervisor_id;
    }

    public void setSupervisor_id(Integer supervisor_id) {
        this.supervisor_id = supervisor_id;
    }
}