package com.sunrisedental.model;

public class Appointment {
    private int id;
    private String appointmentNumber;
    private String patientName;
    private String contactNumber;
    private String address;
    private String dentistName;
    private String treatmentType;
    private String appointmentDate;
    private String appointmentTime;
    private String status;

    public Appointment() {}

    // 8-Argument Constructor
    public Appointment(String appointmentNumber, String patientName, String contactNumber, 
                       String appointmentDate, String treatmentType, String dentistName, 
                       String appointmentTime, String status) {
        this.appointmentNumber = appointmentNumber;
        this.patientName = patientName;
        this.contactNumber = contactNumber;
        this.appointmentDate = appointmentDate;
        this.treatmentType = treatmentType;
        this.dentistName = dentistName;
        this.appointmentTime = appointmentTime;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAppointmentNumber() { return appointmentNumber; }
    public void setAppointmentNumber(String appointmentNumber) { this.appointmentNumber = appointmentNumber; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDentistName() { return dentistName; }
    public void setDentistName(String dentistName) { this.dentistName = dentistName; }

    public String getTreatmentType() { return treatmentType; }
    public void setTreatmentType(String treatmentType) { this.treatmentType = treatmentType; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}