<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = (String) currentSession.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Bus | Admin Dashboard</title>

    <!-- Bootstrap, FontAwesome, Fonts -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            font-family: 'Poppins', sans-serif;
            color: #fff;
            padding: 20px;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 20px;
            padding: 30px;
            backdrop-filter: blur(14px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            margin-bottom: 25px;
        }
        .navbar {
            border-radius: 15px;
            padding: 15px 30px;
            background-color: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }
        .navbar-brand {
            color: #fff;
            font-weight: 600;
        }
        .btn-outline-light, .btn {
            border-radius: 10px;
            font-weight: 500;
        }
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #fff;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: none;
        }
        .btn-primary, .btn-success, .btn-info {
            background-color: #43cea2;
            border: none;
            font-weight: bold;
            color: white;
        }
        .btn-primary:hover, .btn-success:hover, .btn-info:hover {
            background-color: #2bc0e4;
        }
    </style>
</head>
<body>

<!-- ✅ NAVBAR -->
<nav class="navbar navbar-expand-lg mb-4">
    <span class="navbar-brand h4 mb-0">🚍 Smart Bus - Admin Dashboard</span>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light ms-auto">Logout</a>

</nav>

<div class="container">
    <div class="glass-card">
        <h3>Welcome, Admin 👋</h3>

        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-info mt-3">
                <%= request.getParameter("status") %>
            </div>
        <% } %>

        <!-- ✅ Add New Bus -->
        <div class="glass-card">
            <div class="section-title"><i class="fas fa-bus me-2"></i> Add New Bus</div>
            <form action="addBus" method="post" class="row g-3">
                <div class="col-md-3">
                    <input type="text" name="busNumber" class="form-control" placeholder="Bus Number" required>
                </div>
                <div class="col-md-3">
                    <input type="number" name="capacity" class="form-control" placeholder="Capacity" required>
                </div>
                <div class="col-md-3">
                    <input type="text" name="routeName" class="form-control" placeholder="Route Name">
                </div>
                <div class="col-md-3">
                    <select name="driverId" class="form-select" required>
                        <option value="">Select Driver</option>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/smart_bus", "root", "your_password");
                                String userCollege = (String) session.getAttribute("college_name");

                                PreparedStatement ps = conn.prepareStatement(
                                    "SELECT id, username FROM users WHERE role = 'driver' AND college_name = ?"
                                );
                                ps.setString(1, userCollege);
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("username") %></option>
                        <% 
                                }
                                rs.close(); ps.close(); conn.close();
                            } catch (Exception e) {
                                out.println("<option>Error loading drivers</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="col-12 text-end">
                    <button class="btn btn-primary px-4">Add Bus</button>
                </div>
            </form>
        </div>

        <!-- ✅ Assign Student to Bus -->
        <div class="glass-card">
            <div class="section-title"><i class="fas fa-user-check me-2"></i> Assign Student to Bus</div>
            <form action="assignStudent" method="post" class="row g-3">
                <div class="col-md-6">
                    <input type="text" name="student_username" class="form-control" placeholder="Student Username" required>
                </div>
                <div class="col-md-6">
                    <input type="number" name="bus_id" class="form-control" placeholder="Bus ID" required>
                </div>
                <div class="col-12 text-end">
                    <button class="btn btn-success px-4">Assign</button>
                </div>
            </form>
        </div>

        <!-- ✅ View Student Count -->
        <div class="glass-card">
            <div class="section-title"><i class="fas fa-users me-2"></i> View Student Count for a Bus</div>
            <div class="row g-3">
                <div class="col-md-4">
                    <input type="number" id="busIdInput" class="form-control" placeholder="Enter Bus ID">
                </div>
                <div class="col-md-4">
                    <button class="btn btn-info px-4" onclick="getStudentCount()">Get Count</button>
                </div>
                <div class="col-md-4">
                    <div id="countResult" class="alert alert-secondary" style="display:none;"></div>
                </div>
            </div>
        </div>

        <!-- ✅ All Buses -->
        <div class="glass-card">
            <div class="section-title"><i class="fas fa-list-alt me-2"></i> All Buses</div>
            <jsp:include page="busList.jsp" />
        </div>
    </div>
</div>

<!-- ✅ JS -->
<script>
    function getStudentCount() {
        const busId = document.getElementById("busIdInput").value;
        if (!busId) return;

        fetch("studentCount?busId=" + busId)
            .then(res => res.json())
            .then(data => {
                const resultDiv = document.getElementById("countResult");
                resultDiv.innerHTML = `Student Count: <strong>${data.count}</strong>`;
                resultDiv.style.display = "block";
            })
            .catch(() => {
                document.getElementById("countResult").innerHTML = "Error fetching count.";
            });
    }
</script>

</body>
</html>
