package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean addAppointment(Appointment app) {
        boolean isSuccess = false;
        String sql = "INSERT INTO appointments (appointment_number, patient_name, address, contact_number, dentist_name, treatment_type, appointment_date, appointment_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, app.getAppointmentNumber());
            stmt.setString(2, app.getPatientName());
            stmt.setString(3, app.getAddress());
            stmt.setString(4, app.getContactNumber());
            stmt.setString(5, app.getDentistName());
            stmt.setString(6, app.getTreatmentType());
            stmt.setString(7, app.getAppointmentDate());
            stmt.setString(8, app.getAppointmentTime());
            stmt.setString(9, app.getStatus());

            int rowsAffected = stmt.executeUpdate();
            isSuccess = rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Appointment app = new Appointment();
               // app.setId(rs.getInt("id"));
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setAddress(rs.getString("address"));
                app.setContactNumber(rs.getString("contact_number"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentType(rs.getString("treatment_type"));
                app.setAppointmentDate(rs.getString("appointment_date"));
                app.setAppointmentTime(rs.getString("appointment_time"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDate(String dateStr) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE appointment_date = ? ORDER BY  DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, dateStr);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment app = new Appointment();
                    //app.setId(rs.getInt("id"));
                    app.setAppointmentNumber(rs.getString("appointment_number"));
                    app.setPatientName(rs.getString("patient_name"));
                    app.setAddress(rs.getString("address"));
                    app.setContactNumber(rs.getString("contact_number"));
                    app.setDentistName(rs.getString("dentist_name"));
                    app.setTreatmentType(rs.getString("treatment_type"));
                    app.setAppointmentDate(rs.getString("appointment_date"));
                    app.setAppointmentTime(rs.getString("appointment_time"));
                    app.setStatus(rs.getString("status"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}