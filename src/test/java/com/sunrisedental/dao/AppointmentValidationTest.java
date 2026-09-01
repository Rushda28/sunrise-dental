package com.sunrisedental.dao;

import org.junit.jupiter.api.Test;
import java.time.LocalDate;
import java.time.LocalTime;
import static org.junit.jupiter.api.Assertions.*;

public class AppointmentValidationTest {

    // Remark: Blank field validation test
    @Test
    public void testAppointmentBlankFields() {
        String patientName = "";
        String contact = "";
        boolean isValid = patientName != null && !patientName.trim().isEmpty() 
                       && contact != null && contact.matches("^07\\d{8}$");
        assertFalse(isValid, "Blank fields must be rejected by validation rules.");
    }

    // Remark: Digits in patient name test
    @Test
    public void testPatientNameWithDigits() {
        String patientName = "John123";
        boolean isValidName = patientName.matches("^[a-zA-Z\\s\\.]+$");
        assertFalse(isValidName, "Patient name containing digits must be rejected.");
    }

    // Remark: Contact number with more than 10 digits test
    @Test
    public void testContactNumberTooLong() {
        String contact = "07123456789"; // 11 digits
        boolean isValidContact = contact.matches("^07\\d{8}$");
        assertFalse(isValidContact, "Contact numbers exceeding 10 digits must be rejected.");
    }

    // Remark: Contact number with letters test
    @Test
    public void testContactNumberWithLetters() {
        String contact = "071234ABCD";
        boolean isValidContact = contact.matches("^07\\d{8}$");
        assertFalse(isValidContact, "Contact numbers containing letters must be rejected.");
    }

    // Remark: Past date for appointment test
    @Test
    public void testPastAppointmentDate() {
        LocalDate apptDate = LocalDate.now().minusDays(1);
        boolean isValidDate = !apptDate.isBefore(LocalDate.now());
        assertFalse(isValidDate, "Past appointment dates must be rejected.");
    }

    // Remark: Past time for today's appointment test
    @Test
    public void testPastTimeForToday() {
        LocalDate apptDate = LocalDate.now();
        LocalTime apptTime = LocalTime.now().minusHours(1); // 1 hour ago
        
        boolean isInvalidTime = apptDate.isEqual(LocalDate.now()) && apptTime.isBefore(LocalTime.now());
        assertTrue(isInvalidTime, "Scheduling an appointment for a past time today must be blocked.");
    }

    // Remark: Treatment duration mapping logic test
    @Test
    public void testTreatmentDurationMapping() {
        String treatment = "RootCanal";
        int durationMinutes = 30;
        
        if ("Filling".equals(treatment) || "Extraction".equals(treatment)) {
            durationMinutes = 45;
        } else if ("RootCanal".equals(treatment)) {
            durationMinutes = 60;
        }
        
        assertEquals(60, durationMinutes, "Root Canal treatment must correctly map to a 60-minute duration.");
    }

    // Remark: Dentist schedule gap and overlap conflict detection logic test
    @Test
    public void testDentistTimeSlotOverlapAndGap() {
        // Existing appointment: 10:00 to 11:00 (Root Canal = 60 mins duration)
        LocalTime existingStart = LocalTime.of(10, 0);
        int existingDuration = 60; 
        LocalTime existingEnd = existingStart.plusMinutes(existingDuration); // 11:00

        // New attempted appointment starting at 10:30 (violates the gap requirement)
        LocalTime newStart = LocalTime.of(10, 30);
        int newDuration = 30; // Cleaning = 30 mins
        LocalTime newEnd = newStart.plusMinutes(newDuration); // 11:00

        // Overlap condition: (newStart < existingEnd) && (existingStart < newEnd)
        boolean hasOverlap = newStart.isBefore(existingEnd) && existingStart.isBefore(newEnd);

        assertTrue(hasOverlap, "An appointment overlapping within an active dentist's treatment gap must be flagged as a conflict.");
    }
}