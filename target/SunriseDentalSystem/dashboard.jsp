<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental - Dashboard</title>
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
            padding: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow-x: hidden;
        }

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

        .dashboard-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 1200px;
            background: rgba(15, 23, 42, 0.78);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(52, 211, 153, 0.25);
            border-radius: 24px;
            padding: 35px;
            box-shadow: 0 25px 50px -12px rgba(14, 165, 233, 0.2);
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 30px;
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 12px;
            border-right: 1px solid rgba(56, 189, 248, 0.15);
            padding-right: 25px;
        }

        .brand-box {
            margin-bottom: 15px;
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

        .sidebar h2 {
            font-size: 20px;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.2px;
        }

        .sidebar p {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 4px;
        }

        .nav-links {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 15px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 12px;
            color: #f8fafc;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .nav-item:hover {
            background: rgba(52, 211, 153, 0.15);
            border-color: #34d399;
            transform: translateX(4px);
        }

        .nav-item.logout {
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.25);
            color: #f87171;
            margin-top: auto;
        }

        .nav-item.logout:hover {
            background: rgba(239, 68, 68, 0.2);
            border-color: #f87171;
        }

        .main-content {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .stat-card {
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 16px;
            padding: 20px;
        }

        .stat-card h3 {
            font-size: 13px;
            font-weight: 500;
            color: #94a3b8;
            margin-bottom: 8px;
        }

        .stat-card .value {
            font-size: 24px;
            font-weight: 700;
            color: #34d399;
        }

        .data-section {
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 16px;
            padding: 24px;
        }

        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 13px;
        }

        th {
            color: #94a3b8;
            font-weight: 600;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(56, 189, 248, 0.15);
        }

        td {
            padding: 12px 0;
            color: #e2e8f0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .badge {
            background: rgba(52, 211, 153, 0.12);
            color: #34d399;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            border: 1px solid rgba(52, 211, 153, 0.25);
        }

        @media (max-width: 900px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            .sidebar {
                border-right: none;
                border-bottom: 1px solid rgba(56, 189, 248, 0.15);
                padding-right: 0;
                padding-bottom: 20px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Left Side: Navigation Sidebar -->
        <div class="sidebar">
            <div class="brand-box">
                <div class="brand-tag">🌿 Control Center</div>
                <h2>System Dashboard</h2>
                <p>Manage clinical operations & records</p>
            </div>
            
            <div class="nav-links">
                <a href="register-appointment.jsp" class="nav-item">1. Register Appointment</a>
                <a href="register-dentist.jsp" class="nav-item">2. Add New Dentist</a>
                <a href="manage-appointments.jsp" class="nav-item">3. Manage Appointment Statuses</a>
                <a href="search-appointment.jsp" class="nav-item">4. Search Appointment</a>
                <a href="reports.jsp" class="nav-item">5. Clinic Reports & Analytics</a>
                <a href="help.jsp" class="nav-item">6. Help & Support</a>
                <a href="index.jsp" class="nav-item logout">Logout</a>
            </div>
        </div>

        <!-- Right Side: Analytics & Live Data Display -->
        <div class="main-content">
            <%
                int upcomingAppointmentsCount = 0;
                int todayAppointments = 0;
                int activeDentistsCount = 0;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                    
                    Statement st1 = conn.createStatement();
                    ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM dentists");
                    if(rs1.next()) activeDentistsCount = rs1.getInt(1);

                    // Count upcoming active appointments (excluding cancelled and completed)
                    Statement st2 = conn.createStatement();
                    ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM appointments WHERE appointment_date >= CURDATE() AND (status IS NULL OR (status != 'Cancelled' AND status != 'Completed'))");
                    if(rs2.next()) upcomingAppointmentsCount = rs2.getInt(1);

                    Statement st3 = conn.createStatement();
                    ResultSet rs3 = st3.executeQuery("SELECT COUNT(*) FROM appointments WHERE appointment_date = CURDATE() AND (status IS NULL OR (status != 'Cancelled' AND status != 'Completed'))");
                    if(rs3.next()) todayAppointments = rs3.getInt(1);
                    
                    conn.close();
                } catch(Exception e) {}
            %>

            <!-- Quick Metrics Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Active Dentists</h3>
                    <div class="value"><%= activeDentistsCount %></div>
                </div>
                <div class="stat-card">
                    <h3>Upcoming Appointments</h3>
                    <div class="value"><%= upcomingAppointmentsCount %></div>
                </div>
                <div class="stat-card">
                    <h3>Today's Schedule</h3>
                    <div class="value"><%= todayAppointments %></div>
                </div>
            </div>

            <!-- Today's Appointments Focus Table -->
            <div class="data-section">
                <div class="section-title">
                    <span>Today's Priority Appointments</span>
                    <span class="badge">Live Queue</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Appt ID</th>
                            <th>Patient Name</th>
                            <th>Assigned Dentist</th>
                            <th>Treatment</th>
                            <th>Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                                Statement st = conn.createStatement();
                                // Filter strictly for active appointments matching today's date (excluding cancelled and completed)
                                ResultSet rs = st.executeQuery("SELECT appointment_number, patient_name, dentist_name, treatment_type, appointment_time FROM appointments WHERE appointment_date = CURDATE() AND (status IS NULL OR (status != 'Cancelled' AND status != 'Completed')) ORDER BY appointment_time ASC");
                                
                                boolean hasData = false;
                                while(rs.next()) {
                                    hasData = true;
                        %>
                                    <tr>
                                        <td><span class="badge"><%= rs.getString("appointment_number") %></span></td>
                                        <td><%= rs.getString("patient_name") %></td>
                                        <td><%= rs.getString("dentist_name") %></td>
                                        <td><%= rs.getString("treatment_type") %></td>
                                        <td><%= rs.getString("appointment_time") %></td>
                                    </tr>
                        <% 
                                }
                                if(!hasData) {
                                    out.println("<tr><td colspan='5' style='text-align:center; color:#94a3b8;'>No active appointments scheduled for today. Enjoy your day!</td></tr>");
                                }
                                conn.close();
                            } catch(Exception e) {
                                out.println("<tr><td colspan='5' style='text-align:center; color:#f87171;'>Unable to load today's schedule: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>