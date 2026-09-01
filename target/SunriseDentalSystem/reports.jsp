<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Clinic Reports</title>
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
            align-items: flex-start;
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

        .container { 
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 650px; 
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

        select { 
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

        select:focus {
            border-color: #34d399;
            background: rgba(30, 41, 59, 0.9);
            box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.2);
        }

        .action-row {
            display: flex;
            gap: 12px;
            margin-top: 8px;
        }

        button, .download-btn { 
            flex: 1;
            background: linear-gradient(135deg, #34d399 0%, #0ea5e9 100%);
            color: #0f172a;
            border: none; 
            padding: 12px; 
            border-radius: 10px; 
            font-size: 14px; 
            font-weight: 700;
            cursor: pointer; 
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .download-btn {
            background: rgba(30, 41, 59, 0.8);
            color: #34d399;
            border: 1px solid rgba(52, 211, 153, 0.4);
            box-shadow: none;
        }

        button:hover, .download-btn:hover { 
            opacity: 0.95;
            transform: translateY(-1px);
        }

        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 25px; 
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid rgba(56, 189, 248, 0.2);
        }

        th, td { 
            padding: 12px 14px; 
            text-align: left; 
            font-size: 13px; 
        }

        th { 
            background: rgba(52, 211, 153, 0.15); 
            color: #34d399; 
            font-weight: 600;
            border-bottom: 1px solid rgba(52, 211, 153, 0.25);
        }

        td {
            background: rgba(30, 41, 59, 0.4);
            border-bottom: 1px solid rgba(56, 189, 248, 0.1);
            color: #e2e8f0;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 25px; 
            text-decoration: none; 
            color: #94a3b8; 
            font-weight: 600;
            font-size: 13px;
            transition: color 0.2s ease;
        }

        .back-link:hover { 
            color: #34d399;
        }

        .error { 
            background: rgba(239, 68, 68, 0.1); 
            color: #f87171; 
            padding: 12px; 
            border-radius: 10px; 
            margin-top: 20px; 
            text-align: center; 
            font-size: 13px;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-box">
            <div class="brand-tag">🌿 Sunrise Dental</div>
            <h2>Clinic Management Reports</h2>
            <p>Analyze treatment demands and dentist work allocations</p>
        </div>

        <form method="get">
            <div class="form-group">
                <label>Select Report Type</label>
                <select name="reportType" required>
                    <option value="">-- Choose Report Metric --</option>
                    <option value="treatment" <%= "treatment".equals(request.getParameter("reportType")) ? "selected" : "" %>>Treatment Popularity Report</option>
                    <option value="workload" <%= "workload".equals(request.getParameter("reportType")) ? "selected" : "" %>>Dentist Workload Report</option>
                </select>
            </div>
            <div class="action-row">
                <button type="submit">Generate Report</button>
                <% 
                    String currentType = request.getParameter("reportType");
                    if (currentType != null && !currentType.isEmpty()) { 
                %>
                    <a href="reports.jsp?reportType=<%= currentType %>&export=csv" class="download-btn">&#11015; Download CSV</a>
                <% } %>
            </div>
        </form>

        <%
            String reportType = request.getParameter("reportType");
            String export = request.getParameter("export");

            if (reportType != null && !reportType.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "");
                    Statement st = conn.createStatement();
                    ResultSet rs = null;

                    if ("csv".equals(export)) {
                        response.setContentType("text/csv");
                        response.setHeader("Content-Disposition", "attachment; filename=\"sunrise-dental-" + reportType + "-report.csv\"");
                        java.io.PrintWriter writer = response.getWriter();

                        if ("treatment".equals(reportType)) {
                            writer.println("Treatment Type,Request Count");
                            rs = st.executeQuery("SELECT treatment_type, COUNT(*) AS cnt FROM appointments GROUP BY treatment_type");
                            while(rs.next()) {
                                writer.println("\"" + rs.getString("treatment_type") + "\"," + rs.getInt("cnt"));
                            }
                        } else if ("workload".equals(reportType)) {
                            writer.println("Dentist Name,Total Bookings");
                            rs = st.executeQuery("SELECT dentist_name, COUNT(*) AS cnt FROM appointments GROUP BY dentist_name");
                            while(rs.next()) {
                                writer.println("\"" + rs.getString("dentist_name") + "\"," + rs.getInt("cnt"));
                            }
                        }
                        writer.flush();
                        conn.close();
                        return; // Stop rendering HTML when exporting CSV
                    }
        %>
        <table>
            <% if ("treatment".equals(reportType)) { %>
                <tr>
                    <th>Treatment Type</th>
                    <th>Request Count</th>
                </tr>
                <%
                    rs = st.executeQuery("SELECT treatment_type, COUNT(*) AS cnt FROM appointments GROUP BY treatment_type");
                    boolean hasRows = false;
                    while(rs.next()) {
                        hasRows = true;
                %>
                    <tr>
                        <td><%= rs.getString("treatment_type") %></td>
                        <td><%= rs.getInt("cnt") %></td>
                    </tr>
                <% 
                    }
                    if (!hasRows) {
                %>
                    <tr><td colspan="2" style="text-align: center; color: #94a3b8;">No records found.</td></tr>
                <% } %>
            <% } else if ("workload".equals(reportType)) { %>
                <tr>
                    <th>Dentist Name</th>
                    <th>Total Bookings</th>
                </tr>
                <%
                    rs = st.executeQuery("SELECT dentist_name, COUNT(*) AS cnt FROM appointments GROUP BY dentist_name");
                    boolean hasWorkloadRows = false;
                    while(rs.next()) {
                        hasWorkloadRows = true;
                %>
                    <tr>
                        <td><%= rs.getString("dentist_name") %></td>
                        <td><%= rs.getInt("cnt") %></td>
                    </tr>
                <% 
                    }
                    if (!hasWorkloadRows) {
                %>
                    <tr><td colspan="2" style="text-align: center; color: #94a3b8;">No records found.</td></tr>
                <% } %>
            <% } %>
        </table>
        <%
                    conn.close();
                } catch(Exception e) {
                    out.println("<div class='error'>Error generating report: " + e.getMessage() + "</div>");
                }
            }
        %>

        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
    </div>
</body>
</html>