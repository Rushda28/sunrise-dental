package com.sunrisedental.dao;

import com.sunrisedental.model.Bill;
import com.sunrisedental.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BillingDAO {

    public boolean saveBill(Bill bill) {
        boolean status = false;
        String query = "INSERT INTO bills (bill_number, appointment_number, treatment_fee, medication_fee, total_amount) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, bill.getBillNumber());
            ps.setString(2, bill.getAppointmentNumber());
            ps.setDouble(3, bill.getTreatmentFee());
            ps.setDouble(4, bill.getMedicationFee());
            ps.setDouble(5, bill.getTotalAmount());
            
            status = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}