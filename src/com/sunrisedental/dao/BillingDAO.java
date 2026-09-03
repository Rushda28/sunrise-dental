package com.sunrisedental.dao;

import com.sunrisedental.model.Bill;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class BillingDAO {

    private static final double STANDARD_CONSULTATION_FEE = 1500.00;
    private static final Map<String, Double> TREATMENT_PRICING = new HashMap<>();

    static {
        TREATMENT_PRICING.put("Cleaning / Scaling", 3500.00);
        TREATMENT_PRICING.put("Tooth Extraction", 2500.00);
        TREATMENT_PRICING.put("Root Canal", 15000.00);
        TREATMENT_PRICING.put("Dental Filling", 4000.00);
        TREATMENT_PRICING.put("Orthodontic Consultation", 5000.00);
    }

    public double getTreatmentCost(String treatmentType) {
        return TREATMENT_PRICING.getOrDefault(treatmentType, 3000.00);
    }

    public Bill generateBill(int appointmentId, String treatmentType) {
        double treatmentCost = getTreatmentCost(treatmentType);
        double total = STANDARD_CONSULTATION_FEE + treatmentCost;

        Bill bill = new Bill(appointmentId, STANDARD_CONSULTATION_FEE, treatmentCost, total);

        String sql = "INSERT INTO bills (appointment_id, consultation_fee, treatment_cost, total_amount) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bill.getAppointmentId());
            pstmt.setDouble(2, bill.getConsultationFee());
            pstmt.setDouble(3, bill.getTreatmentCost());
            pstmt.setDouble(4, bill.getTotalAmount());

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                return getBillByAppointmentId(appointmentId);
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in generateBill: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Bill getBillByAppointmentId(int appointmentId) {
        String sql = "SELECT id, appointment_id, consultation_fee, treatment_cost, total_amount, issued_at FROM bills WHERE appointment_id = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, appointmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Bill(
                        rs.getInt("id"),
                        rs.getInt("appointment_id"),
                        rs.getDouble("consultation_fee"),
                        rs.getDouble("treatment_cost"),
                        rs.getDouble("total_amount"),
                        rs.getString("issued_at")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("DATABASE ERROR in getBillByAppointmentId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
