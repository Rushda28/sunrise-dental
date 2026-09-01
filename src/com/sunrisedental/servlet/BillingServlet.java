package com.sunrisedental.servlet;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/api/billing")
public class BillingServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String appParam = request.getParameter("appointmentNumber");
        if (appParam == null || appParam.trim().isEmpty()) {
            appParam = request.getParameter("appointmentId");
        }

        if (appParam == null || appParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Appointment Number parameter is required.\"}");
            return;
        }

        Appointment app = appointmentDAO.findByNumberOrId(appParam.trim());

        if (app == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"error\":\"Appointment record not found for: " + escapeJson(appParam) + "\"}");
            return;
        }

        double consultationFee = 1500.00;
        double treatmentCost = getTreatmentCost(app.getTreatmentType());
        double totalAmount = consultationFee + treatmentCost;

        String currentTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        // Build standard JSON manually without Gson dependency
        String json = String.format(
            "{\"appointmentNumber\":\"%s\",\"treatmentType\":\"%s\",\"consultationFee\":%.2f,\"treatmentCost\":%.2f,\"totalAmount\":%.2f,\"issuedAt\":\"%s\"}",
            escapeJson(app.getAppointmentNumber()),
            escapeJson(app.getTreatmentType() != null ? app.getTreatmentType() : "N/A"),
            consultationFee,
            treatmentCost,
            totalAmount,
            currentTime
        );

        response.setStatus(HttpServletResponse.SC_OK);
        out.print(json);
    }

    private double getTreatmentCost(String treatment) {
        if (treatment == null) return 2000.00;
        switch (treatment) {
            case "General Checkup": return 1000.00;
            case "Teeth Cleaning": return 3000.00;
            case "Root Canal": return 15000.00;
            case "Tooth Extraction": return 4000.00;
            case "Teeth Whitening": return 10000.00;
            default: return 2500.00;
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}