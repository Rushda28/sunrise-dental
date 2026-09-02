package com.sunrisedental.model;

public class Appointment {
    private int id;
    private String appointmentNumber;
    private String patientName;
    private String nic;
    private String contactNumber;
    private String appointmentDate;
    private String treatmentType;

    public Appointment() {}

    public Appointment(String appointmentNumber, String patientName, String nic, String contactNumber, String appointmentDate, String treatmentType) {
        this.appointmentNumber = appointmentNumber;
        this.patientName = patientName;
        this.nic = nic;
        this.contactNumber = contactNumber;
        this.appointmentDate = appointmentDate;
        this.treatmentType = treatmentType;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getAppointmentNumber() { return appointmentNumber; }
    public void setAppointmentNumber(String appointmentNumber) { this.appointmentNumber = appointmentNumber; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }
    public String getTreatmentType() { return treatmentType; }
    public void setTreatmentType(String treatmentType) { this.treatmentType = treatmentType; }
}