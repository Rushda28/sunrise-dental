package com.sunrisedental.model;

public class Bill {
    private int id;
    private String billNumber;
    private String appointmentNumber;
    private double treatmentFee;
    private double medicationFee;
    private double totalAmount;

    public Bill() {}

    public Bill(String billNumber, String appointmentNumber, double treatmentFee, double medicationFee, double totalAmount) {
        this.billNumber = billNumber;
        this.appointmentNumber = appointmentNumber;
        this.treatmentFee = treatmentFee;
        this.medicationFee = medicationFee;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBillNumber() { return billNumber; }
    public void setBillNumber(String billNumber) { this.billNumber = billNumber; }
    public String getAppointmentNumber() { return appointmentNumber; }
    public void setAppointmentNumber(String appointmentNumber) { this.appointmentNumber = appointmentNumber; }
    public double getTreatmentFee() { return treatmentFee; }
    public void setTreatmentFee(double treatmentFee) { this.treatmentFee = treatmentFee; }
    public double getMedicationFee() { return medicationFee; }
    public void setMedicationFee(double medicationFee) { this.medicationFee = medicationFee; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}