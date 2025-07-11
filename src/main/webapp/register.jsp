<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.smartbus.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Bus Register</title>

    <!-- Bootstrap -->
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

        .register-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        .form-control, .form-select {
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

        .register-card h2 {
            font-weight: 600;
            margin-bottom: 25px;
        }

        .register-card a {
            color: #ffc;
            text-decoration: none;
        }

        .register-card a:hover {
            text-decoration: underline;
        }

        .alert {
            border-radius: 10px;
        }
    </style>
</head>
<body>

    <div class="register-card">
        <h2 class="text-center"><i class="fas fa-user-plus me-2"></i>Smart Bus - Register</h2>

        <form action="register" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Role</label>
                <select name="role" class="form-select" required>
                    <option value="">Select Role</option>
                    <option value="admin">Admin</option>
                    <option value="driver">Driver</option>
                    <option value="student">Student</option>
                </select>
            </div>

            <!-- ✅ College Dropdown -->
            <div class="mb-3">
                <label class="form-label">Select Your College</label>
                <select name="college" class="form-select" required>
                    <option value="">Select College</option>
                    <%
                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT name FROM colleges ORDER BY name");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                    %>
                        <option value="<%= rs.getString("name") %>"><%= rs.getString("name") %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<option>Error loading colleges</option>");
                        }
                    %>
                </select>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-custom">Register</button>
            </div>
        </form>

        <% String status = request.getParameter("status");
           if (status != null) { %>
           <div class="alert alert-info mt-3 text-center">
               <%= status %>
           </div>
        <% } %>

        <div class="mt-3 text-center">
            <a href="login.jsp"><i class="fas fa-arrow-left me-1"></i>Already have an account? Login here</a>
        </div>
    </div>

</body>
</html>
