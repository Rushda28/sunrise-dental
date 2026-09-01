<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Calculate & Print Bill</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body { 
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif; 
            background: linear-gradient(135deg, #064e3b 0%, #0f172a 50%, #0369a1 100%);
            color: #f8fafc;
            margin: 0; 
            padding: 40px 20px; 
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Glowing accents matching app theme */
        body::before {
            content: '';
            position: absolute;
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, rgba(52, 211, 153, 0.15) 0%, transparent 70%);
            top: -120px;
            left: -120px;
            border-radius: 50%;
            z-index: 0;
        }
        body::after {
            content: '';
            position: absolute;
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.15) 0%, transparent 70%);
            bottom: -120px;
            right: -120px;
            border-radius: 50%;
            z-index: 0;
        }

        .container { 
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 520px; 
            background: rgba(15, 23, 42, 0.78); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            padding: 40px 35px; 
            border-radius: 24px; 
            box-shadow: 0 25px 50px -12px rgba(14, 165, 233, 0.2); 
            border: 1px solid rgba(52, 211, 153, 0.25);
        }

        .brand-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(52, 211, 153, 0.12);
            color: #34d399;
            font-size: 11px;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: 20px;
            margin-bottom: 10px;
            border: 1px solid rgba(52, 211, 153, 0.25);
        }

        .header-box {
            text-align: center;
            margin-bottom: 25px;
        }

        h2 { 
            color: #ffffff; 
            margin-top: 0;
            margin-bottom: 4px; 
            font-size: 24px;
            font-weight: 700;
        }

        .bill-card { 
            background: rgba(30, 41, 59, 0.65); 
            border: 1px solid rgba(56, 189, 248, 0.25); 
            padding: 24px; 
            border-radius: 16px; 
            backdrop-filter: blur(8px);
        }

        .bill-card hr {
            border: none;
            border-top: 1px solid rgba(56, 189, 248, 0.15);
            margin: 16px 0;
        }

        .bill-card p {
            margin: 10px 0;
            font-size: 13px;
            color: #f8fafc;
            display: flex;
            justify-content: space-between;
        }

        .bill-card p strong {
            color: #94a3b8;
            font-weight: 500;
        }

        .bill-total {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid rgba(52, 211, 153, 0.25);
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #34d399;
            font-size: 16px;
            font-weight: 700;
        }

        .error { 
            background: rgba(239, 68, 68, 0.12); 
            color: #f87171; 
            padding: 14px; 
            border-radius: 14px; 
            text-align: center; 
            font-weight: 600; 
            font-size: 13px;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .btn-print { 
            width: 100%; 
            background: linear-gradient(135deg, #34d399 0%, #059669 100%); 
            color: #064e3b; 
            border: none; 
            padding: 14px; 
            border-radius: 14px; 
            font-size: 15px; 
            font-weight: 700;
            cursor: pointer; 
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(52, 211, 153, 0.25);
            margin-top: 20px; 
        }

        .btn-print:hover { 
            opacity: 0.95;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(52, 211, 153, 0.35);
        }

        .container > a {
            display: block; 
            text-align: center; 
            margin-top: 25px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: color 0.2s ease;
        }

        .container > a:hover {
            color: #34d399;
        }

        @media print {
            body { 
                background: white !important; 
                padding: 0;
            }
            body::before, body::after {
                display: none;
            }
            .container { 
                box-shadow: none; 
                width: 100%; 
                max-width: 100%;
                margin: 0; 
                padding: 20px; 
                background: white !important;
                border: none;
            }
            .no-print { display: none !important; }
            .bill-card {
                background: white !important;
                border: 2px dashed #cbd5e0 !important;
                color: #0f172a !important;
                box-shadow: none;
            }
            .bill-card p, .bill-card p strong, .bill-card h3 {
                color: #0f172a !important;
            }
            .bill-card hr {
                border-top-color: #cbd5e0 !important;
            }
            .bill-total {
                border-top-color: #cbd5e0 !important;
                color: #059669 !important;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-box no-print">
            <div class="brand-tag">🧾 Billing & Receipt</div>
            <h2>Patient Billing & Receipt</h2>
        </div>

        <% 
            String apptNo = request.getParameter("apptNo");
            if (apptNo != null && !apptNo.trim().isEmpty()) {
                Connection conn = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                    
                    // 1. Get appointment details
                    PreparedStatement psAppt = conn.prepareStatement("SELECT * FROM appointments WHERE appointment_number = ?");
                    psAppt.setString(1, apptNo.trim());
                    ResultSet rs = psAppt.executeQuery();

                    if (rs.next()) {
                        String treatment = rs.getString("treatment_type");
                        String currentApptNo = rs.getString("appointment_number");
                        String patientName = rs.getString("patient_name");
                        String contactNumber = rs.getString("contact_number");
                        String dentistName = rs.getString("dentist_name");

                        // 2. Fetch treatment cost dynamically from the database
                        double treatmentCost = 0.00;
                        PreparedStatement psCost = conn.prepareStatement("SELECT price FROM treatments WHERE treatment_name = ?");
                        psCost.setString(1, treatment);
                        ResultSet rsCost = psCost.executeQuery();
                        if (rsCost.next()) {
                            treatmentCost = rsCost.getDouble("price");
                        }

                        // 3. Fetch standard consultation fee dynamically
                        double consultationFee = 1500.00; // Fallback default
                        PreparedStatement psCons = conn.prepareStatement("SELECT price FROM treatments WHERE treatment_name = 'Consultation'");
                        ResultSet rsCons = psCons.executeQuery();
                        if (rsCons.next()) {
                            consultationFee = rsCons.getDouble("price");
                        }

                        double totalAmount = consultationFee + treatmentCost;

                        // 4. Check if bill already exists to prevent duplicate inserts on reload
                        PreparedStatement psCheck = conn.prepareStatement("SELECT * FROM bills WHERE appointment_number = ?");
                        psCheck.setString(1, currentApptNo);
                        ResultSet rsCheck = psCheck.executeQuery();

                        if (!rsCheck.next()) {
                            PreparedStatement psInsert = conn.prepareStatement("INSERT INTO bills (appointment_number, consultation_fee, treatment_cost, total_amount, payment_status) VALUES (?, ?, ?, ?, 'PAID')");
                            psInsert.setString(1, currentApptNo);
                            psInsert.setDouble(2, consultationFee);
                            psInsert.setDouble(3, treatmentCost);
                            psInsert.setDouble(4, totalAmount);
                            psInsert.executeUpdate();
                        }
        %>
                        <div class="bill-card">
                            <h3 style="text-align:center; margin-top:0; color:#34d399; font-size:18px;">Sunrise Dental Clinic</h3>
                            <p style="text-align:center; font-size:12px; color:#94a3b8; display:block; margin-bottom:15px;">Official Patient Invoice</p>
                            <hr>
                            <p><strong>Appointment No:</strong> <span>#<%= currentApptNo %></span></p>
                            <p><strong>Patient Name:</strong> <span><%= patientName %></span></p>
                            <p><strong>Contact:</strong> <span><%= contactNumber %></span></p>
                            <p><strong>Dentist:</strong> <span><%= dentistName %></span></p>
                            <p><strong>Treatment:</strong> <span><%= treatment %></span></p>
                            <hr>
                            <p><strong>Consultation Fee:</strong> <span>LKR <%= String.format("%.2f", consultationFee) %></span></p>
                            <p><strong>Treatment Cost:</strong> <span>LKR <%= String.format("%.2f", treatmentCost) %></span></p>
                            <div class="bill-total">
                                <span>Total Payable</span>
                                <span>LKR <%= String.format("%.2f", totalAmount) %></span>
                            </div>
                        </div>

                        <button onclick="window.print();" class="btn-print no-print">Print Receipt</button>
        <% 
                    } else {
                        out.println("<div class='error'>Appointment not found for billing.</div>");
                    }
                    if(conn != null) conn.close();
                } catch(Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }
            } else {
                out.println("<div class='error'>No Appointment Number provided.</div>");
            }
        %>

        <a href="search-appointment.jsp" class="no-print">&larr; Back to Search</a>
    </div>
</body>
</html>