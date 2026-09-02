<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sunrise Dental - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; }
        .container { width: 400px; margin: 100px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { color: #1a202c; text-align: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #4a5568; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background-color: #3182ce; color: white; border: none; padding: 10px; border-radius: 4px; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #2b6cb0; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Sunrise Dental Login</h2>
        <form action="dashboard.jsp" method="get">
            <div class="form-group"><label>Username:</label><input type="text" name="username" required></div>
            <div class="form-group"><label>Password:</label><input type="password" name="password" required></div>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>