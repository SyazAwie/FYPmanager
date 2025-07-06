package fyp.model;

public class Supervisor {
    private int supervisor_id;
    private int quota;
    private String roleOfInterest;
    private String pastProject;
    private int admin_id;

    // NEW FIELDS
    private String name;
    private String email;
    private String phone;
    private String photo;

    // Constructor with all parameters
    public Supervisor(int supervisor_id, int quota, String roleOfInterest, String pastProject, int admin_id,
                      String name, String email, String phone, String photo) {
        this.supervisor_id = supervisor_id;
        this.quota = quota;
        this.roleOfInterest = roleOfInterest;
        this.pastProject = pastProject;
        this.admin_id = admin_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.photo = photo;
    }

    // Default constructor
    public Supervisor() {
        this.supervisor_id = 0;
        this.quota = 0;
        this.roleOfInterest = "";
        this.pastProject = "";
        this.admin_id = 0;
        this.name = "";
        this.email = "";
        this.phone = "";
        this.photo = "";
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
}
