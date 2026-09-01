<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.LocalTime, java.time.Duration" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Register Appointment</title>
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
            min-height: 100vh;
            padding: 30px 20px; 
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow-x: hidden;
        }

        /* Glowing accents matching login & dashboard */
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
            border: 1px solid rgba(52, 211, 153, 0.25);
            border-radius: 24px;
            padding: 40px 35px; 
            box-shadow: 0 25px 50px -12px rgba(14, 165, 233, 0.2);
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
            font-size: 24px;
            font-weight: 700;
            letter-spacing: -0.2px;
            margin-bottom: 4px;
        }

        .header-box p {
            color: #94a3b8;
            font-size: 13px;
        }

        .form-group { 
            margin-bottom: 18px; 
        }

        label { 
            display: block; 
            margin-bottom: 6px; 
            color: #cbd5e1; 
            font-weight: 500; 
            font-size: 13px;
        }

        input[type="text"], input[type="tel"], input[type="date"], input[type="time"], select { 
            width: 100%; 
            padding: 12px 14px; 
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 10px; 
            font-size: 14px;
            font-family: inherit;
            color: #ffffff;
            transition: all 0.2s ease;
            outline: none;
        }

        input[type="text"]::placeholder, input[type="tel"]::placeholder {
            color: #64748b;
        }

        input[type="text"]:focus, input[type="tel"]:focus, input[type="date"]:focus, input[type="time"]:focus, select:focus {
            border-color: #34d399;
            background: rgba(30, 41, 59, 0.9);
            box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.2);
        }

        select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 16px;
            padding-right: 40px;
        }

        select option {
            background-color: #0f172a;
            color: #ffffff;
        }

        button { 
            width: 100%; 
            background: linear-gradient(135deg, #34d399 0%, #0ea5e9 100%);
            color: #0f172a;
            border: none; 
            padding: 12px; 
            border-radius: 10px; 
            font-size: 15px; 
            font-weight: 700;
            cursor: pointer; 
            transition: all 0.2s ease;
            margin-top: 8px;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
        }

        button:hover { 
            opacity: 0.95;
            transform: translateY(-1px);
        }

        button:active {
            transform: translateY(0);
        }

        .success { 
            background: rgba(52, 211, 153, 0.12); 
            color: #34d399; 
            padding: 12px; 
            border-radius: 10px; 
            margin-bottom: 20px; 
            text-align: center; 
            font-size: 13px;
            border: 1px solid rgba(52, 211, 153, 0.25);
            line-height: 1.5;
        }

        .error { 
            background: rgba(239, 68, 68, 0.1); 
            color: #f87171; 
            padding: 12px; 
            border-radius: 10px; 
            margin-bottom: 20px; 
            text-align: center; 
            font-size: 13px;
            border: 1px solid rgba(239, 68, 68, 0.25);
            line-height: 1.5;
        }

        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 22px; 
            text-decoration: none; 
            color: #94a3b8; 
            font-weight: 600;
            font-size: 13px;
            transition: color 0.2s ease;
        }

        .back-link:hover { 
            color: #34d399;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-box">
            <div class="brand-tag">🌿 Sunrise Dental</div>
            <h2>Register Appointment</h2>
            <p>Schedule a new patient consultation or treatment</p>
        </div>

        <% 
            String pName = request.getParameter("patientName");
            if (pName != null && !pName.trim().isEmpty()) {
                String contact = request.getParameter("contact");
                String apptDateStr = request.getParameter("appointmentDate");
                String apptTimeStr = request.getParameter("appointmentTime");
                String treatment = request.getParameter("treatment");
                String dentist = request.getParameter("dentist");

                LocalDate apptDate = null;
                LocalTime apptTime = null;
                try {
                    apptDate = LocalDate.parse(apptDateStr);
                    apptTime = LocalTime.parse(apptTimeStr);
                } catch(Exception e) {}

                int durationMinutes = 30; 
                if ("Filling".equals(treatment) || "Extraction".equals(treatment)) {
                    durationMinutes = 45;
                } else if ("RootCanal".equals(treatment)) {
                    durationMinutes = 60;
                }

                if (!pName.matches("^[a-zA-Z\\s\\.]+$")) {
                    out.println("<div class='error'>Validation Error: Patient name must contain only letters and spaces.</div>");
                } else if (contact == null || !contact.matches("^07\\d{8}$")) {
                    out.println("<div class='error'>Validation Error: Contact number must be 10 digits and start with 07 (e.g., 0712345678).</div>");
                } else if (apptDate == null || apptDate.isBefore(LocalDate.now())) {
                    out.println("<div class='error'>Validation Error: Past dates are not permitted.</div>");
                } else if (apptDate.getYear() != LocalDate.now().getYear()) {
                    out.println("<div class='error'>Validation Error: Please enter a valid year for the appointment.</div>");
                } else if (apptDate.isEqual(LocalDate.now()) && apptTime != null && apptTime.isBefore(LocalTime.now())) {
                    out.println("<div class='error'>Validation Error: Cannot schedule an appointment in the past for today.</div>");
                } else {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");

                        LocalTime newEndTime = apptTime.plusMinutes(durationMinutes);

                        PreparedStatement checkPs = conn.prepareStatement(
                            "SELECT appointment_time, treatment_type FROM appointments WHERE dentist_name = ? AND appointment_date = ?"
                        );
                        checkPs.setString(1, dentist.trim());
                        checkPs.setString(2, apptDateStr.trim());
                        ResultSet rs = checkPs.executeQuery();

                        boolean hasOverlap = false;
                        while(rs.next()) {
                            LocalTime existingStart = rs.getTime("appointment_time").toLocalTime();
                            String existingTreatment = rs.getString("treatment_type");
                            
                            int existingDuration = 30;
                            if ("Filling".equals(existingTreatment) || "Extraction".equals(existingTreatment)) {
                                existingDuration = 45;
                            } else if ("RootCanal".equals(existingTreatment)) {
                                existingDuration = 60;
                            }
                            LocalTime existingEnd = existingStart.plusMinutes(existingDuration);

                            if (apptTime.isBefore(existingEnd) && existingStart.isBefore(newEndTime)) {
                                hasOverlap = true;
                                break;
                            }
                        }

                        if (hasOverlap) {
                            out.println("<div class='error'>Conflict Error: This time slot overlaps with another appointment for Dr. " + dentist + ". Please choose a different time.</div>");
                        } else {
                            int randomNum = (int)(Math.random() * 9000) + 1000;
                            String appointmentNumber = "SUN-" + randomNum;

                            PreparedStatement ps = conn.prepareStatement(
                                "INSERT INTO appointments (appointment_number, patient_name, address, contact_number, dentist_name, treatment_type, appointment_date, appointment_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                            );
                            ps.setString(1, appointmentNumber);
                            ps.setString(2, pName.trim());
                            ps.setString(3, request.getParameter("address").trim());
                            ps.setString(4, contact.trim());
                            ps.setString(5, dentist.trim());
                            ps.setString(6, treatment.trim());
                            ps.setString(7, apptDateStr.trim());
                            ps.setString(8, apptTimeStr.trim());
                            ps.executeUpdate();

                            out.println("<div class='success'>Appointment Saved!<br>Assigned Appointment Number: <strong>" + appointmentNumber + "</strong></div>");
                        }
                        conn.close();
                    } catch(Exception e) {
                        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                    }
                }
            }
        %>

        <form action="register-appointment.jsp" method="post">
            <div class="form-group">
                <label>Patient Name</label>
                <input type="text" name="patientName" pattern="[a-zA-Z\s\.]+" required placeholder="Enter full name" title="Patient name should contain only letters and spaces">
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" required placeholder="Enter residential address">
            </div>
            <div class="form-group">
                <label>Contact Number</label>
                <input type="tel" name="contact" pattern="07[0-9]{8}" required placeholder="0712345678 (10 digits starting with 07)" title="Must start with 07 and contain 10 digits">
            </div>
            
            <div class="form-group">
                <label>Dentist Name</label>
                <select name="dentist" required>
                    <option value="">-- Select Registered Dentist --</option>
                    <% 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                            Statement st = conn.createStatement();
                            ResultSet rs = st.executeQuery("SELECT dentist_name, speciality FROM dentists");
                            while(rs.next()) {
                                String dName = rs.getString("dentist_name");
                                String dSpec = rs.getString("speciality");
                    %>
                                <option value="<%= dName %>"><%= dName %> (<%= dSpec %>)</option>
                    <% 
                            }
                            conn.close();
                        } catch(Exception e) {} 
                    %>
                </select>
            </div>

            <div class="form-group">
                <label>Treatment Type</label>
                <select name="treatment" required>
                    <option value="">-- Select Treatment --</option>
                    <option value="Cleaning">Teeth Cleaning (30 mins)</option>
                    <option value="Filling">Tooth Filling (45 mins)</option>
                    <option value="RootCanal">Root Canal (60 mins)</option>
                    <option value="Extraction">Tooth Extraction (45 mins)</option>
                </select>
            </div>

            <div class="form-group">
                <label>Appointment Date</label>
                <input type="date" name="appointmentDate" min="<%= java.time.LocalDate.now() %>" required>
            </div>
            <div class="form-group">
                <label>Appointment Time</label>
                <input type="time" name="appointmentTime" required>
            </div>
            <button type="submit">Save Appointment</button>
        </form>
        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
    </div>
</body>
</html>