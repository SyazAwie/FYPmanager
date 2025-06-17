package fyp.model;

public class Document {
    private int document_id;
    private String doc_type;
    private String file_path;
    private String version;
    private String uploaded_at;
    private double plagiarism_score;
    private int project_id;

    public Document(int document_id, String doc_type, String file_path, String version, String uploaded_at, double plagiarism_score, int project_id) {
        this.document_id = document_id;
        this.doc_type = doc_type;
        this.file_path = file_path;
        this.version = version;
        this.uploaded_at = uploaded_at;
        this.plagiarism_score = plagiarism_score;
        this.project_id = project_id;
    }

    // Getters
    public int getDocument_id() {
        return document_id;
    }

    public String getDoc_type() {
        return doc_type;
    }

    public String getFile_path() {
        return file_path;
    }

    public String getVersion() {
        return version;
    }

    public String getUploaded_at() {
        return uploaded_at;
    }

    public double getPlagiarism_score() {
        return plagiarism_score;
    }

    public int getProject_id() {
        return project_id;
    }

    // Setters
    public void setDocument_id(int document_id) {
        this.document_id = document_id;
    }

    public void setDoc_type(String doc_type) {
        this.doc_type = doc_type;
    }

    public void setFile_path(String file_path) {
        this.file_path = file_path;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public void setUploaded_at(String uploaded_at) {
        this.uploaded_at = uploaded_at;
    }

    public void setPlagiarism_score(double plagiarism_score) {
        this.plagiarism_score = plagiarism_score;
    }

    public void setProject_id(int project_id) {
        this.project_id = project_id;
    }
}
