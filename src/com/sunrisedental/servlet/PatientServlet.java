package com.sunrisedental.servlet;

import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/patients")
public class PatientServlet extends HttpServlet {

    private PatientDAO patientDAO = new PatientDAO();

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

            String name = extractJsonValue(jsonBody, "name");
            String address = extractJsonValue(jsonBody, "address");
            String contact = extractJsonValue(jsonBody, "contact");

            if (name.isEmpty() || contact.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Name and Contact Number are required.\"}");
                return;
            }

            Patient patient = new Patient(name, address, contact);
            int generatedId = patientDAO.registerPatient(patient);

            if (generatedId > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"message\":\"Patient registered successfully!\",\"patientId\":" + generatedId + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to save patient record to database.\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Failed to register patient: " + e.getMessage() + "\"}");
        }
    }

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