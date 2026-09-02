package com.sunrisedental.servlet;

import com.sunrisedental.dao.BillingDAO;
import com.sunrisedental.model.Bill;
import com.sunrisedental.util.CodeGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private BillingDAO billingDAO;

    @Override
    public void init() {
        billingDAO = new BillingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appointmentNumber = request.getParameter("appointmentNumber");
        double treatmentFee = Double.parseDouble(request.getParameter("treatmentFee"));
        double medicationFee = Double.parseDouble(request.getParameter("medicationFee"));
        double totalAmount = treatmentFee + medicationFee;

        String billNumber = "BILL-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        Bill bill = new Bill(billNumber, appointmentNumber, treatmentFee, medicationFee, totalAmount);
        boolean isSaved = billingDAO.saveBill(bill);

        if (isSaved) {
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("view-bill.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard.jsp?status=bill_error");
        }
    }
}