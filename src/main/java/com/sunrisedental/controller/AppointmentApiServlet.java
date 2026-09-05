package com.sunrisedental.controller;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/appointments")
public class AppointmentApiServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

    try (java.sql.Connection testConn =
            com.sunrisedental.util.DBConnection.getConnection()) {

        System.out.println("API DATABASE = " + testConn.getCatalog());
        System.out.println("API DATABASE URL = "
                + testConn.getMetaData().getURL());
    }

    List<Appointment> appointmentList =
            appointmentDAO.getAllAppointments();


            PrintWriter out = response.getWriter();
            StringBuilder jsonBuilder = new StringBuilder();

            jsonBuilder.append("{\"status\":\"success\",\"count\":")
                    .append(appointmentList.size())
                    .append(",\"data\":[");

            for (int i = 0; i < appointmentList.size(); i++) {

                Appointment a = appointmentList.get(i);

                jsonBuilder.append("{")
                        .append("\"appointmentNumber\":\"")
                        .append(a.getAppointmentNumber()).append("\",")
                        .append("\"patientName\":\"")
                        .append(a.getPatientName()).append("\",")
                        .append("\"dentistName\":\"")
                        .append(a.getDentistName()).append("\",")
                        .append("\"treatment\":\"")
                        .append(a.getTreatmentType()).append("\",")
                        .append("\"date\":\"")
                        .append(a.getAppointmentDate()).append("\"")
                        .append("}");

                if (i < appointmentList.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]}");

            out.print(jsonBuilder.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().print(
                    "{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}