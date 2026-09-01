package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class AppointmentDAOTest {

    private AppointmentDAO appointmentDAO;
    private Appointment testAppointment;

    @BeforeEach
    public void setUp() {
        appointmentDAO = new AppointmentDAO();
        
        // Initialize a mock appointment matching database constraints
        testAppointment = new Appointment();
        int randomNum = (int)(Math.random() * 9000) + 1000;
        testAppointment.setAppointmentNumber("SUN-" + randomNum);
        testAppointment.setPatientName("John Doe");
        testAppointment.setAddress("123 Main Street, Colombo");
        testAppointment.setContactNumber("0712345678");
        testAppointment.setDentistName("Dr. Smith");
        testAppointment.setTreatmentType("Cleaning");
        testAppointment.setAppointmentDate("2026-10-15");
        testAppointment.setAppointmentTime("10:00:00");
    }

    @Test
    public void testAddAppointment() {
        // Test that the DAO successfully inserts the record into the database
        boolean isInserted = appointmentDAO.addAppointment(testAppointment);
        
        assertTrue(isInserted, "The appointment should be successfully saved to the database.");
    }
}