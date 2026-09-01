<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Search Appointment</title>
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
            max-width: 560px; 
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
            margin-bottom: 30px;
        }

        h2 { 
            color: #ffffff; 
            margin-top: 0;
            margin-bottom: 6px; 
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.2px;
        }

        .header-box p {
            color: #94a3b8;
            font-size: 13px;
        }

        .form-group { 
            margin-bottom: 20px; 
        }

        label { 
            display: block; 
            margin-bottom: 8px; 
            color: #94a3b8; 
            font-weight: 600; 
            font-size: 13px;
        }

        input[type="text"] { 
            width: 100%; 
            padding: 14px 16px; 
            border: 1px solid rgba(56, 189, 248, 0.2); 
            border-radius: 14px; 
            box-sizing: border-box; 
            font-size: 14px;
            transition: all 0.2s ease;
            outline: none;
            background-color: rgba(30, 41, 59, 0.6);
            color: #f8fafc;
        }

        input[type="text"]::placeholder {
            color: #64748b;
        }

        input[type="text"]:focus {
            border-color: #34d399;
            box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.15);
            background: rgba(30, 41, 59, 0.9);
        }

        button[type="submit"] { 
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
        }

        button[type="submit"]:hover { 
            opacity: 0.95;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(52, 211, 153, 0.35);
        }

        button[type="submit"]:active {
            transform: scale(0.99);
        }

        .result-card { 
            background: rgba(30, 41, 59, 0.65); 
            padding: 24px; 
            border-radius: 16px; 
            margin-top: 25px; 
            border: 1px solid rgba(56, 189, 248, 0.25);
            backdrop-filter: blur(8px);
        }

        .result-card h3 {
            margin-top: 0;
            margin-bottom: 16px;
            font-size: 16px;
            color: #34d399;
            border-bottom: 1px solid rgba(56, 189, 248, 0.15);
            padding-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .result-card p {
            margin: 10px 0;
            font-size: 13px;
            color: #f8fafc;
            display: flex;
            justify-content: space-between;
        }

        .result-card p strong {
            color: #94a3b8;
            font-weight: 500;
            width: 140px;
            flex-shrink: 0;
        }

        .error { 
            background: rgba(239, 68, 68, 0.12); 
            color: #f87171; 
            padding: 14px; 
            border-radius: 14px; 
            margin-top: 20px; 
            text-align: center; 
            font-weight: 600; 
            font-size: 13px;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .btn-bill { 
            display: block; 
            text-align: center; 
            background: linear-gradient(135deg, #38bdf8 0%, #0284c7 100%); 
            color: #0f172a; 
            padding: 14px; 
            text-decoration: none; 
            border-radius: 14px; 
            margin-top: 20px; 
            font-weight: 700; 
            font-size: 14px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(56, 189, 248, 0.25);
        }

        .btn-bill:hover { 
            opacity: 0.95;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(56, 189, 248, 0.35);
        }

        .container > a[href="dashboard.jsp"] {
            display: block; 
            text-align: center; 
            margin-top: 25px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: color 0.2s ease;
        }

        .container > a[href="dashboard.jsp"]:hover {
            color: #34d399;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-box">
            <div class="brand-tag">🔍 Records Lookup</div>
            <h2>Search Appointment</h2>
            <p>Query patient appointment records by unique reference code</p>
        </div>

        <form action="search-appointment.jsp" method="get">
            <div class="form-group">
                <label>Enter Appointment Number:</label>
                <input type="text" name="apptNo" required placeholder="e.g., SUN-8098">
            </div>
            <button type="submit">Search Appointment</button>
        </form>

        <% 
            String searchNo = request.getParameter("apptNo");
            if (searchNo != null && !searchNo.trim().isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM appointments WHERE appointment_number = ?");
                    ps.setString(1, searchNo.trim());
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
        %>
                        <div class="result-card">
                            <h3>
                                <span>Appointment Details</span>
                                <span style="font-size: 12px; background: rgba(52, 211, 153, 0.15); color: #34d399; padding: 3px 8px; border-radius: 6px; border: 1px solid rgba(52, 211, 153, 0.3);"><%= rs.getString("appointment_number") %></span>
                            </h3>
                            <p><strong>Patient Name:</strong> <span><%= rs.getString("patient_name") %></span></p>
                            <p><strong>Address:</strong> <span><%= rs.getString("address") %></span></p>
                            <p><strong>Contact Number:</strong> <span><%= rs.getString("contact_number") %></span></p>
                            <p><strong>Dentist Assigned:</strong> <span><%= rs.getString("dentist_name") %></span></p>
                            <p><strong>Treatment Type:</strong> <span><%= rs.getString("treatment_type") %></span></p>
                            <p><strong>Date & Time:</strong> <span><%= rs.getString("appointment_date") %> at <%= rs.getString("appointment_time") %></span></p>
                            
                            <a href="print-bill.jsp?apptNo=<%= rs.getString("appointment_number") %>" class="btn-bill">Proceed to Calculate & Print Bill</a>
                        </div>
        <% 
                    } else {
                        out.println("<div class='error'>Appointment Number not found in system records!</div>");
                    }
                    conn.close();
                } catch(Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>
        <a href="dashboard.jsp">&larr; Back to Dashboard</a>
    </div>
</body>
</html>