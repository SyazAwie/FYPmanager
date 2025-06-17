package fyp.model;

public class Supervisor {
    private int supervisor_id;
    private int quota;
    private String roleOfInterest;
    private String pastProject;
    private int admin_id;

    // Constructor with all parameters
    public Supervisor(int supervisor_id, int quota, String roleOfInterest, String pastProject, int admin_id) {
        this.supervisor_id = supervisor_id;
        this.quota = quota;
        this.roleOfInterest = roleOfInterest;
        this.pastProject = pastProject;
        this.admin_id = admin_id;
    }

    // Default constructor
    public Supervisor() {
        this.supervisor_id = 0;
        this.quota = 0;
        this.roleOfInterest = "";
        this.pastProject = "";
        this.admin_id = 0;
    }

    // Getters and setters
    public int getSupervisor_id() {
        return supervisor_id;
    }

    public void setSupervisor_id(int supervisor_id) {
        this.supervisor_id = supervisor_id;
    }

    public int getQuota() {
        return quota;
    }

    public void setQuota(int quota) {
        this.quota = quota;
    }

    public String getRoleOfInterest() {
        return roleOfInterest;
    }

    public void setRoleOfInterest(String roleOfInterest) {
        this.roleOfInterest = roleOfInterest;
    }

    public String getPastProject() {
        return pastProject;
    }

    public void setPastProject(String pastProject) {
        this.pastProject = pastProject;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }
}