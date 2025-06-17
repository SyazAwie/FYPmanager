package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Document;
import DBconnection.DatabaseConnection;

public class DocumentDB {

    // Insert document
    public void insertDocument(Document doc) {
        String sql = "INSERT INTO DOCUMENT (document_id, doc_type, file_path, version, uploaded_at, plagiarism_score, project_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doc.getDocument_id());
            stmt.setString(2, doc.getDoc_type());
            stmt.setString(3, doc.getFile_path());
            stmt.setString(4, doc.getVersion());
            stmt.setString(5, doc.getUploaded_at());
            stmt.setDouble(6, doc.getPlagiarism_score());
            stmt.setInt(7, doc.getProject_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all documents
    public List<Document> getAllDocuments() {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM DOCUMENT";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Document doc = new Document(
                    rs.getInt("document_id"),
                    rs.getString("doc_type"),
                    rs.getString("file_path"),
                    rs.getString("version"),
                    rs.getString("uploaded_at"),
                    rs.getDouble("plagiarism_score"),
                    rs.getInt("project_id")
                );
                documents.add(doc);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return documents;
    }

    // Update document
    public void updateDocument(Document doc) {
        String sql = "UPDATE DOCUMENT SET doc_type = ?, file_path = ?, version = ?, uploaded_at = ?, plagiarism_score = ?, project_id = ? WHERE document_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, doc.getDoc_type());
            stmt.setString(2, doc.getFile_path());
            stmt.setString(3, doc.getVersion());
            stmt.setString(4, doc.getUploaded_at());
            stmt.setDouble(5, doc.getPlagiarism_score());
            stmt.setInt(6, doc.getProject_id());
            stmt.setInt(7, doc.getDocument_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete document
    public void deleteDocument(int documentId) {
        String sql = "DELETE FROM DOCUMENT WHERE document_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, documentId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
