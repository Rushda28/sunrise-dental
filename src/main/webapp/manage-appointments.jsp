<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental - Manage Appointments</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #064e3b 0%, #0f172a 50%, #0369a1 100%);
            color: #f8fafc;
            min-height: 100vh;
            padding: 30px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(52, 211, 153, 0.25);
            border-radius: 24px;
            padding: 35px;
            box-shadow: 0 25px 50px -12px rgba(14, 165, 233, 0.2);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 1px solid rgba(56, 189, 248, 0.15);
            padding-bottom: 15px;
        }
        .header h2 { font-size: 22px; color: #fff; }
        .back-btn {
            background: rgba(30, 41, 59, 0.8);
            border: 1px solid rgba(56, 189, 248, 0.3);
            color: #38bdf8;
            padding: 8px 16px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .back-btn:hover { background: rgba(56, 189, 248, 0.15); }
        
        .filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            background: rgba(30, 41, 59, 0.6);
            padding: 15px;
            border-radius: 14px;
            border: 1px solid rgba(56, 189, 248, 0.2);
            align-items: center;
        }
        .filter-bar input[type="date"] {
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid rgba(56, 189, 248, 0.3);
            color: #fff;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 13px;
        }
        .btn {
            background: #059669;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 13px;
            transition: background 0.2s;
        }
        .btn:hover { background: #047857; }
        .btn-reset {
            background: rgba(100, 116, 139, 0.4);
            text-decoration: none;
            display: inline-block;
            padding: 8px 16px;
            border-radius: 8px;
            color: #cbd5e1;
            font-size: 13px;
            font-weight: 600;
        }
        .btn-reset:hover { background: rgba(100, 116, 139, 0.6); }

        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 13px; }
        th { color: #94a3b8; font-weight: 600; padding-bottom: 12px; border-bottom: 1px solid rgba(56, 189, 248, 0.15); }
        td { padding: 14px 0; color: #e2e8f0; border-bottom: 1px solid rgba(255, 255, 255, 0.04); }
        
        .badge {
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-Scheduled { background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3); }
        .badge-Completed { background: rgba(52, 211, 153, 0.15); color: #34d399; border: 1px solid rgba(52, 211, 153, 0.3); }
        .badge-Cancelled { background: rgba(239, 68, 68, 0.15); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.3); }

        .action-form { display: inline-flex; gap: 6px; }
        .action-btn-complete { background: rgba(52, 211, 153, 0.2); color: #34d399; border: 1px solid rgba(52, 211, 153, 0.4); padding: 4px 8px; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 600; }
        .action-btn-complete:hover { background: rgba(52, 211, 153, 0.4); }
        .action-btn-cancel { background: rgba(239, 68, 68, 0.2); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.4); padding: 4px 8px; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 600; }
        .action-btn-cancel:hover { background: rgba(239, 68, 68, 0.4); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Upcoming Appointments Management</h2>
            <a href="dashboard.jsp" class="back-btn">&larr; Back to Dashboard</a>
        </div>

        <%
            // Handle Status Update Action
            String updateId = request.getParameter("updateId");
            String newStatus = request.getParameter("newStatus");
            if(updateId != null && newStatus != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                    PreparedStatement pstmt = conn.prepareStatement("UPDATE appointments SET status = ? WHERE appointment_number = ?");
                    pstmt.setString(1, newStatus);
                    pstmt.setString(2, updateId);
                    pstmt.executeUpdate();
                    conn.close();
                } catch(Exception e) {}
            }

            String filterDate = request.getParameter("filterDate");
        %>

        <!-- Filter Form -->
        <form method="GET" class="filter-bar">
            <label style="font-size: 13px; font-weight: 600; color: #94a3b8;">Filter by Specific Date:</label>
            <input type="date" name="filterDate" value="<%= filterDate != null ? filterDate : "" %>">
            <button type="submit" class="btn">Apply Filter</button>
            <a href="manage-appointments.jsp" class="btn-reset">Reset</a>
        </form>

        <!-- Appointments Table -->
        <table>
            <thead>
                <tr>
                    <th>Appt ID</th>
                    <th>Patient Name</th>
                    <th>Dentist</th>
                    <th>Treatment</th>
                    <th>Date & Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC", "root", "");
                        
                        // Base query strictly restricted to today or future dates
                        String query = "SELECT appointment_number, patient_name, dentist_name, treatment_type, appointment_date, appointment_time, COALESCE(status, 'Scheduled') as status FROM appointments WHERE appointment_date >= CURDATE()";
                        
                        if(filterDate != null && !filterDate.trim().isEmpty()) {
                            // If a specific date is chosen, override to filter precisely for that date
                            query = "SELECT appointment_number, patient_name, dentist_name, treatment_type, appointment_date, appointment_time, COALESCE(status, 'Scheduled') as status FROM appointments WHERE appointment_date = ?";
                        }
                        
                        query += " ORDER BY appointment_date ASC, appointment_time ASC";
                        
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        if(filterDate != null && !filterDate.trim().isEmpty()) {
                            pstmt.setString(1, filterDate);
                        }
                        
                        ResultSet rs = pstmt.executeQuery();
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                            String apptNo = rs.getString("appointment_number");
                            String status = rs.getString("status");
                %>
                            <tr>
                                <td><strong><%= apptNo %></strong></td>
                                <td><%= rs.getString("patient_name") %></td>
                                <td><%= rs.getString("dentist_name") %></td>
                                <td><%= rs.getString("treatment_type") %></td>
                                <td><%= rs.getString("appointment_date") + " at " + rs.getString("appointment_time") %></td>
                                <td><span class="badge badge-<%= status %>"><%= status %></span></td>
                                <td>
                                    <form method="GET" class="action-form">
                                        <% if(filterDate != null && !filterDate.trim().isEmpty()) { %>
                                            <input type="hidden" name="filterDate" value="<%= filterDate %>">
                                        <% } %>
                                        <input type="hidden" name="updateId" value="<%= apptNo %>">
                                        <% if(!status.equals("Completed")) { %>
                                            <button type="submit" name="newStatus" value="Completed" class="action-btn-complete">Mark Completed</button>
                                        <% } %>
                                        <% if(!status.equals("Cancelled")) { %>
                                            <button type="submit" name="newStatus" value="Cancelled" class="action-btn-cancel">Cancel</button>
                                        <% } %>
                                    </form>
                                </td>
                            </tr>
                <%
                        }
                        if(!hasData) {
                            out.println("<tr><td colspan='7' style='text-align:center; color:#94a3b8; padding: 25px;'>No upcoming appointments found.</td></tr>");
                        }
                        conn.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='7' style='text-align:center; color:#f87171;'>Error loading records: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>