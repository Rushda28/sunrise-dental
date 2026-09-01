package com.sunrisedental.servlet;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/api/appointments")
public class AppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    // Handles Search / Lookup
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String appNumber = request.getParameter("appNumber");

        if (appNumber == null || appNumber.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Appointment number is required.\"}");
            return;
        }

        try {
            Appointment app = appointmentDAO.getAppointmentByNumber(appNumber);
            if (app != null) {
                String json = String.format(
                    "{\"appointmentNumber\":\"%s\",\"patientId\":%d,\"dentistId\":%d,\"treatmentType\":\"%s\",\"dateTime\":\"%s\",\"status\":\"%s\"}",
                    app.getAppointmentNumber(),
                    app.getPatientId(),
                    app.getDentistId(),
                    app.getTreatmentType(),
                    app.getAppointmentDateTime(),
                    app.getStatus()
                );
                out.print(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Appointment not found.\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Server error: " + e.getMessage() + "\"}");
        }
    }

    // Handles Book Appointment (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            StringBuilder buffer = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
            String jsonBody = buffer.toString();

            // Extract Patient fields
            String name = extractJsonValue(jsonBody, "name");
            String address = extractJsonValue(jsonBody, "address");
            String contact = extractJsonValue(jsonBody, "contact");

            // Extract Appointment fields as raw Strings
            String dentistIdStr = extractJsonValue(jsonBody, "dentistId");
            String treatmentType = extractJsonValue(jsonBody, "treatmentType");
            String dateTimeStr = extractJsonValue(jsonBody, "dateTime");

            // 1. Validate empty inputs before converting types
            if (name.isEmpty() || address.isEmpty() || contact.isEmpty() || 
                dentistIdStr.isEmpty() || treatmentType.isEmpty() || dateTimeStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"All fields (Name, Address, Contact, Dentist, Treatment, Date/Time) are required.\"}");
                return;
            }

            // 2. Safely parse Dentist ID
            int dentistId;
            try {
                dentistId = Integer.parseInt(dentistIdStr);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Please select a valid dentist from the dropdown menu.\"}");
                return;
            }

            // 3. Register Patient in DB to get generated patientId
            Patient patient = new Patient();
            patient.setName(name);
            patient.setAddress(address);
            patient.setContact(contact);

            int patientId = patientDAO.registerPatient(patient);

            if (patientId <= 0) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to register patient details in database.\"}");
                return;
            }

            // 4. Validate Dentist Exists in Database
            if (!appointmentDAO.dentistExists(dentistId)) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Dentist ID " + dentistId + " does not exist in the system.\"}");
                return;
            }

            // 5. Validate Date is Not in the Past
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm[:ss]");
            LocalDateTime appointmentTime = LocalDateTime.parse(dateTimeStr.replace("T", " "), formatter);
            
            if (appointmentTime.isBefore(LocalDateTime.now())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Cannot book appointments for past dates and times.\"}");
                return;
            }

            // 6. Check for Double Booking
            if (appointmentDAO.isDoubleBooked(dentistId, dateTimeStr)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print("{\"error\":\"This dentist is already booked for the selected date and time.\"}");
                return;
            }

            // 7. Save Appointment
            Appointment app = new Appointment("", patientId, dentistId, treatmentType, dateTimeStr, "SCHEDULED");
            boolean created = appointmentDAO.createAppointment(app);

            if (created) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"message\":\"Appointment created successfully!\",\"appointmentNumber\":\"" + app.getAppointmentNumber() + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to save appointment to database.\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Failed to register appointment: " + e.getMessage() + "\"}");
        }
    }

    // Helper method to parse simple JSON key-values safely
    private String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\":";
        int start = json.indexOf(searchKey);
        if (start == -1) return "";
        
        start += searchKey.length();
        
        while (start < json.length() && (json.charAt(start) == '"' || json.charAt(start) == ' ')) {
            start++;
        }

        int end = start;
        while (end < json.length()) {
            char c = json.charAt(end);
            if (c == '"' || c == ',' || c == '}' || c == ']' || c == '\r' || c == '\n') {
                break;
            }
            end++;
        }

        return json.substring(start, end).replace("\"", "").replace("}", "").trim();
    }
}