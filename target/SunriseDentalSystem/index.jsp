<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.sql.*" %>
<%!
    // SHA-256 Hashing Utility Function
    public String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
%>
<%
    String errorMessage = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String inputUser = request.getParameter("username");
        String inputPass = request.getParameter("password");
        
        if (inputUser != null && inputPass != null) {
            String hashedInputPass = hashPassword(inputPass);
            
            String dbUrl = "jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPass = ""; 
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                     PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?")) {
                    
                    stmt.setString(1, inputUser);
                    stmt.setString(2, hashedInputPass);
                    
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            // Authentication successful: store session and redirect
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("role", rs.getString("role"));
                            response.sendRedirect("dashboard.jsp");
                            return;
                        } else {
                            errorMessage = "Invalid username or password.";
                        }
                    }
                }
            } catch (Exception e) {
                errorMessage = "Database error: " + e.getMessage();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental - Staff Access</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, rgba(52, 211, 153, 0.2) 0%, transparent 70%);
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
            background: radial-gradient(circle, rgba(56, 189, 248, 0.2) 0%, transparent 70%);
            bottom: -120px;
            right: -120px;
            border-radius: 50%;
            z-index: 0;
        }
        .wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }
        .card {
            background: rgba(15, 23, 42, 0.78);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(52, 211, 153, 0.25);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px -15px rgba(16, 185, 129, 0.2);
        }
        .brand-header {
            margin-bottom: 28px;
            text-align: center;
        }
        .brand-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(52, 211, 153, 0.12);
            color: #34d399;
            font-size: 12px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 14px;
            letter-spacing: 0.3px;
            border: 1px solid rgba(52, 211, 153, 0.25);
        }
        .brand-header h1 {
            font-size: 24px;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.2px;
            margin-bottom: 6px;
        }
        .brand-header p {
            color: #94a3b8;
            font-size: 13px;
        }
        .error-banner {
            background: rgba(239, 68, 68, 0.2);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: #fca5a5;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 18px;
            text-align: center;
        }
        .field {
            margin-bottom: 18px;
        }
        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #cbd5e1;
            margin-bottom: 6px;
        }
        .input-box {
            position: relative;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 10px;
            padding: 12px 14px;
            color: #ffffff;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        input[type="text"]::placeholder, input[type="password"]::placeholder {
            color: #64748b;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #34d399;
            background: rgba(30, 41, 59, 0.9);
            box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.2);
        }
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #34d399 0%, #0ea5e9 100%);
            color: #0f172a;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 8px;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
        }
        .btn-submit:hover {
            opacity: 0.95;
            transform: translateY(-1px);
        }
        .btn-submit:active {
            transform: translateY(0);
        }
        .footer-note {
            text-align: center;
            margin-top: 24px;
            font-size: 12px;
            color: #64748b;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="card">
            <div class="brand-header">
                <div class="brand-tag">🌿 Sunrise Dental Portal</div>
                <h1>Staff Login</h1>
                <p>Enter your credentials to manage clinical records</p>
            </div>
            
            <% if (!errorMessage.isEmpty()) { %>
                <div class="error-banner"><%= errorMessage %></div>
            <% } %>

            <form action="index.jsp" method="post">
                <div class="field">
                    <label>Username</label>
                    <div class="input-box">
                        <input type="text" name="username" placeholder="e.g. staff_admin" required>
                    </div>
                </div>
                <div class="field">
                    <label>Password</label>
                    <div class="input-box">
                        <input type="password" name="password" placeholder="••••••••••••" required>
                    </div>
                </div>
                <button type="submit" class="btn-submit">Sign In</button>
            </form>

            <div class="footer-note">
                Sunrise Dental Management System &copy; 2026
            </div>
        </div>
    </div>
</body>
</html>