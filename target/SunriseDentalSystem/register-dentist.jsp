<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Add Dentist</title>
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

        input[type="text"], select { 
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

        input[type="text"]::placeholder {
            color: #64748b;
        }

        input[type="text"]:focus, select:focus {
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
            <h2>Register Dentist</h2>
            <p>Add a new specialist to the clinic roster</p>
        </div>

        <% 
            String dName = request.getParameter("dentistName");
            String dSpeciality = request.getParameter("speciality");
            
            if (dName != null && !dName.trim().isEmpty() && dSpeciality != null && !dSpeciality.trim().isEmpty()) {
                if (!dName.matches("^[a-zA-Z\\s\\.]+$")) {
                    out.println("<div class='error'>Validation Error: Dentist name must contain only letters and spaces (no digits allowed).</div>");
                } else {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "");
                        PreparedStatement ps = conn.prepareStatement("INSERT INTO dentists (dentist_name, speciality) VALUES (?, ?)");
                        ps.setString(1, dName.trim());
                        ps.setString(2, dSpeciality.trim());
                        ps.executeUpdate();
                        conn.close();
                        out.println("<div class='success'>Dentist Registered Successfully!</div>");
                    } catch(Exception e) {
                        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                    }
                }
            }
        %>
        
        <form action="register-dentist.jsp" method="post">
            <div class="form-group">
                <label>Dentist Name</label>
<input type="text" name="dentistName" pattern="^[a-zA-Z\s\.]+$" required placeholder="e.g., Dr. Samantha Mary" title="Name should contain only letters and spaces">            </div>
            <div class="form-group">
                <label>Speciality</label>
                <select name="speciality" required>
                    <option value="">-- Select Speciality --</option>
                    <option value="General Dentistry">General Dentistry</option>
                    <option value="Orthodontics">Orthodontics</option>
                    <option value="Periodontics">Periodontics</option>
                    <option value="Endodontics">Endodontics</option>
                    <option value="Oral Surgery">Oral Surgery</option>
                </select>
            </div>
            <button type="submit">Save Dentist</button>
        </form>
        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
    </div>
</body>
</html>