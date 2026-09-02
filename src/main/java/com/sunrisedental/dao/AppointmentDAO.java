package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean addAppointment(Appointment app) {
        boolean status = false;
        String query = "INSERT INTO appointments (appointment_number, patient_name, nic, contact_number, appointment_date, treatment_type) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, app.getAppointmentNumber());
            ps.setString(2, app.getPatientName());
            ps.setString(3, app.getNic());
            ps.setString(4, app.getContactNumber());
            ps.setString(5, app.getAppointmentDate());
            ps.setString(6, app.getTreatmentType());
            
            status = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setAppointmentNumber(rs.getString("appointment_number"));
                app.setPatientName(rs.getString("patient_name"));
                app.setNic(rs.getString("nic"));
                app.setContactNumber(rs.getString("contact_number"));
                app.setAppointmentDate(rs.getString("appointment_date"));
                app.setTreatmentType(rs.getString("treatment_type"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}