package com.sunrisedental.model;

public class Appointment {
    private String appointmentNumber;
    private int patientId;
    private int dentistId;
    private String treatmentType;
    private String appointmentDateTime;
    private String status;
    private int id;

    // Default constructor
    public Appointment() {
    }

    // 5-parameter constructor (default status to 'SCHEDULED')
    public Appointment(String appointmentNumber, int patientId, int dentistId, String treatmentType, String appointmentDateTime) {
        this(appointmentNumber, patientId, dentistId, treatmentType, appointmentDateTime, "SCHEDULED");
    }

    // 6-parameter constructor
    public Appointment(String appointmentNumber, int patientId, int dentistId, String treatmentType, String appointmentDateTime, String status) {
        this.appointmentNumber = appointmentNumber;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.treatmentType = treatmentType;
        this.appointmentDateTime = appointmentDateTime;
        this.status = status;
    }

    // Getters and Setters
    public String getAppointmentNumber() { return appointmentNumber; }
    public void setAppointmentNumber(String appointmentNumber) { this.appointmentNumber = appointmentNumber; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDentistId() { return dentistId; }
    public void setDentistId(int dentistId) { this.dentistId = dentistId; }

    public String getTreatmentType() { return treatmentType; }
    public void setTreatmentType(String treatmentType) { this.treatmentType = treatmentType; }

    public String getAppointmentDateTime() { return appointmentDateTime; }
    public void setAppointmentDateTime(String appointmentDateTime) { this.appointmentDateTime = appointmentDateTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
}