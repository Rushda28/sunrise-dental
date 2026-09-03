package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class AppointmentDAO {

    /**
     * Inserts a new appointment record into the database.
     * Generates a unique appointment number if not already present.
     */
    public boolean createAppointment(Appointment app) {
        if (app.getAppointmentNumber() == null || app.getAppointmentNumber().trim().isEmpty()) {
            String appNumber = "SUN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            app.setAppointmentNumber(appNumber);
        }

        String sql = "INSERT INTO appointments (appointment_number, patient_id, dentist_id, treatment_type, appointment_date_time, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, app.getAppointmentNumber());
            pstmt.setInt(2, app.getPatientId());
            pstmt.setInt(3, app.getDentistId());
            pstmt.setString(4, app.getTreatmentType());
            pstmt.setString(5, app.getAppointmentDateTime());
            pstmt.setString(6, app.getStatus() != null ? app.getStatus() : "SCHEDULED");

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in createAppointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a dentist already has an appointment scheduled at the given date and time.
     */
    public boolean isDoubleBooked(int dentistId, String dateTime) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE dentist_id = ? AND appointment_date_time = ? AND status != 'CANCELLED'";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, dentistId);
            pstmt.setString(2, dateTime);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in isDoubleBooked: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Verifies if a given patient ID exists in the database.
     */
    public boolean patientExists(int patientId) {
        String sql = "SELECT COUNT(*) FROM patients WHERE id = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in patientExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Verifies if a given dentist ID exists in the database.
     */
    public boolean dentistExists(int dentistId) {
        String sql = "SELECT COUNT(*) FROM dentists WHERE id = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, dentistId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in dentistExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves appointment details by matching either the Appointment Number (e.g. SUN-679B33FE)
     * or the Database ID (e.g. 1).
     */
    public Appointment findByNumberOrId(String identifier) {
        String sql = "SELECT id, appointment_number, patient_id, dentist_id, treatment_type, appointment_date_time, status "
                   + "FROM appointments WHERE appointment_number = ? OR id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, identifier);

            int idVal = -1;
            try {
                idVal = Integer.parseInt(identifier);
            } catch (NumberFormatException ignored) {}

            pstmt.setInt(2, idVal);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Appointment app = new Appointment();
                    app.setId(rs.getInt("id"));
                    app.setAppointmentNumber(rs.getString("appointment_number"));
                    app.setPatientId(rs.getInt("patient_id"));
                    app.setDentistId(rs.getInt("dentist_id"));
                    app.setTreatmentType(rs.getString("treatment_type"));
                    app.setAppointmentDateTime(rs.getString("appointment_date_time"));
                    app.setStatus(rs.getString("status"));
                    return app;
                }
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in findByNumberOrId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Legacy wrapper method for backward compatibility with existing code calling getAppointmentByNumber.
     */
    public Appointment getAppointmentByNumber(String appNumber) {
        return findByNumberOrId(appNumber);
    }
}