package fyp.model;

public class Project {
    private int project_id;
    private String projectTitle;
    private String project_type;
    private String submission_date;
    private int projectIdea_id;
    private int supervisor_id;
    private int student_id;

    public Project(int project_id, String projectTitle, String project_type, String submission_date, int projectIdea_id, int supervisor_id, int student_id) {
        this.project_id = project_id;
        this.projectTitle = projectTitle;
        this.project_type = project_type;
        this.submission_date = submission_date;
        this.projectIdea_id = projectIdea_id;
        this.supervisor_id = supervisor_id;
        this.student_id = student_id;
    }

    public int getProject_id() {
        return project_id;
    }

    public void setProject_id(int project_id) {
        this.project_id = project_id;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getProject_type() {
        return project_type;
    }

    public void setProject_type(String project_type) {
        this.project_type = project_type;
    }

    public String getSubmission_date() {
        return submission_date;
    }

    public void setSubmission_date(String submission_date) {
        this.submission_date = submission_date;
    }

    public int getProjectIdea_id() {
        return projectIdea_id;
    }

    public void setProjectIdea_id(int projectIdea_id) {
        this.projectIdea_id = projectIdea_id;
    }

    public int getSupervisor_id() {
        return supervisor_id;
    }

    public void setSupervisor_id(int supervisor_id) {
        this.supervisor_id = supervisor_id;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }
}
