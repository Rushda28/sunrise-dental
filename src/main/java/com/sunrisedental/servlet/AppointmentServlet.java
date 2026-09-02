package com.sunrisedental.servlet;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.CodeGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientName = request.getParameter("patientName");
        String nic = request.getParameter("nic");
        String contactNumber = request.getParameter("contactNumber");
        String appointmentDate = request.getParameter("appointmentDate");
        String treatmentType = request.getParameter("treatmentType");

        String appointmentNumber = CodeGenerator.generateAppointmentNumber();

        Appointment appointment = new Appointment(appointmentNumber, patientName, nic, contactNumber, appointmentDate, treatmentType);
        boolean isSuccess = appointmentDAO.addAppointment(appointment);

        if (isSuccess) {
            response.sendRedirect("dashboard.jsp?status=success");
        } else {
            response.sendRedirect("register-appointment.jsp?status=error");
        }
    }
}