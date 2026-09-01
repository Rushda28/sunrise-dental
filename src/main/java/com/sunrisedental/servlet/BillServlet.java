package com.sunrisedental.servlet;

import com.sunrisedental.model.Bill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.UUID;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private Object billDAO;

    @Override
    public void init() throws ServletException {
        try {
            Class<?> billDaoClass = Class.forName("com.sunrisedental.dao.BillDAO");
            billDAO = billDaoClass.getDeclaredConstructor().newInstance();
        } catch (ReflectiveOperationException e) {
            throw new ServletException("Unable to initialize BillDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appointmentNumber = request.getParameter("appointmentNumber");
        double treatmentFee = Double.parseDouble(request.getParameter("treatmentFee"));
        double medicationFee = Double.parseDouble(request.getParameter("medicationFee"));
        double totalAmount = treatmentFee + medicationFee;

        String billNumber = "BILL-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        Bill bill = new Bill(billNumber, appointmentNumber, treatmentFee, medicationFee, totalAmount);
        boolean isSaved;
        try {
            isSaved = (Boolean) billDAO.getClass()
                    .getMethod("saveBill", Bill.class)
                    .invoke(billDAO, bill);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            throw new ServletException("Unable to save bill", e);
        }

        if (isSaved) {
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("view-bill.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard.jsp?status=bill_error");
        }
    }
}