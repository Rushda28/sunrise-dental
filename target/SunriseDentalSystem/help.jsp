<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Help & System Guide</title>
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
            padding: 40px 20px; 
            display: flex;
            justify-content: center;
            align-items: flex-start;
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
            max-width: 640px; 
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
            margin-bottom: 30px;
        }

        h2 { 
            color: #ffffff; 
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.2px;
            margin-bottom: 6px;
        }

        .header-box p {
            color: #94a3b8;
            font-size: 13px;
        }

        .guide-grid {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .guide-card {
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 16px;
            padding: 20px;
            transition: all 0.2s ease;
            display: flex;
            gap: 16px;
            align-items: flex-start;
        }

        .guide-card:hover {
            border-color: #34d399;
            transform: translateY(-2px);
            background: rgba(30, 41, 59, 0.85);
        }

        .guide-number {
            background: rgba(52, 211, 153, 0.15);
            color: #34d399;
            font-weight: 700;
            font-size: 14px;
            width: 32px;
            height: 32px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            border: 1px solid rgba(52, 211, 153, 0.3);
        }

        .guide-content h3 {
            color: #ffffff;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .guide-content p {
            color: #94a3b8;
            line-height: 1.5;
            font-size: 13px;
        }

        .guide-content strong {
            color: #38bdf8;
            font-weight: 600;
        }

        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 30px; 
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
            <div class="brand-tag">🌿 Documentation</div>
            <h2>Sunrise Dental Help Guide</h2>
            <p>Quick operational walkthrough for clinical management & records</p>
        </div>
        
        <div class="guide-grid">
            <div class="guide-card">
                <div class="guide-number">01</div>
                <div class="guide-content">
                    <h3>Register Dentist</h3>
                    <p>Add new dental professionals to the system directory. Provide the practitioner's full name and assign their clinical specialty (e.g., <strong>General Dentistry</strong>, <strong>Orthodontics</strong>).</p>
                </div>
            </div>

            <div class="guide-card">
                <div class="guide-number">02</div>
                <div class="guide-content">
                    <h3>Register Appointment</h3>
                    <p>Book patient consultations by filling in patient credentials, address, contact details, preferred dentist, and treatment category. The system automatically issues a unique appointment code starting with <strong>SUN-</strong> (e.g., SUN-8098).</p>
                </div>
            </div>

            <div class="guide-card">
                <div class="guide-number">03</div>
                <div class="guide-content">
                    <h3>Search Appointment</h3>
                    <p>Quickly look up existing schedules using your unique custom appointment number (e.g., <strong>SUN-8098</strong>). Instantly view complete patient specifications and transition seamlessly into checkout.</p>
                </div>
            </div>

            <div class="guide-card">
                <div class="guide-number">04</div>
                <div class="guide-content">
                    <h3>Calculate & Print Bill</h3>
                    <p>Dynamically computes standard treatment costs coupled with hospital service fees. Review itemized figures directly on the invoice card and trigger instant printing for physical patient billing receipts.</p>
                </div>
            </div>
        </div>

        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
    </div>
</body>
</html>