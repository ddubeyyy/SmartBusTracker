<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Bus Login</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        .form-control {
            border-radius: 10px;
            padding: 10px 15px;
        }

        .form-label {
            color: #ddd;
            margin-bottom: 6px;
        }

        .btn-custom {
            background-color: #43cea2;
            border: none;
            padding: 12px;
            font-weight: bold;
            border-radius: 12px;
        }

        .btn-custom:hover {
            background-color: #185a9d;
            color: #fff;
        }

        .login-card h2 {
            font-weight: 600;
            margin-bottom: 25px;
        }

        .login-card a {
            color: #ffc;
            text-decoration: none;
        }

        .login-card a:hover {
            text-decoration: underline;
        }

        .alert {
            border-radius: 10px;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h2 class="text-center"><i class="fas fa-sign-in-alt me-2"></i>Smart Bus Login</h2>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" name="username" class="form-control" id="username" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" class="form-control" id="password" required>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-custom">Login</button>
            </div>
        </form>

        <% 
    String error = request.getParameter("error");
    if ("invalid".equals(error)) { 
%>
    <div class="alert alert-danger mt-3 text-center">
        Invalid username or password.
    </div>
<% } %>


        <div class="mt-3 text-center">
            <a href="register.jsp"><i class="fas fa-user-plus me-1"></i>Don't have an account? Register here</a>
        </div>
    </div>

</body>
</html>
