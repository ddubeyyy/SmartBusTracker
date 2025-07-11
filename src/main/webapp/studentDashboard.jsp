<%@ page import="java.sql.*, com.smartbus.util.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || !"student".equals(currentSession.getAttribute("role"))) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    String username = (String) currentSession.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>

    <!-- Bootstrap + Leaflet + Fonts -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            min-height: 100vh;
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

        .btn-outline-danger {
            border-radius: 10px;
            font-weight: 500;
        }

        h3 {
            font-weight: 500;
        }

        #map {
            height: 400px;
            border-radius: 15px;
            overflow: hidden;
            margin-top: 20px;
        }

        input[type="text"] {
            border-radius: 10px;
            padding: 10px;
            margin-bottom: 15px;
            width: 100%;
            border: none;
        }

        button[type="submit"] {
            background-color: #43cea2;
            border: none;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: bold;
            color: white;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover {
            background-color: #2bc0e4;
        }

        label {
            margin-top: 10px;
            color: #ddd;
        }

        .leaflet-control-attribution {
            display: none;
        }
    </style>
</head>
<body>

    <!-- ✅ Navbar -->
    <nav class="navbar d-flex justify-content-between mb-4">
        <span class="navbar-brand">🚌 Student Dashboard</span>
        <form action="logout" method="post" style="display:inline;">
		    <button type="submit" class="btn btn-outline-danger">Logout</button>
		</form>

    </nav>

    <div class="container">
        <div class="glass-card">
            <h3>Welcome, <%= username %> 👋</h3>

            <%
                String driver = (String) currentSession.getAttribute("driver_username");
                if (driver != null) {
            %>
                <div class="alert alert-info mt-3">
                    <strong>Assigned Driver:</strong> <%= driver %>
                </div>
            <%
                } else {
            %>
                <div class="alert alert-warning mt-3">
                    No driver assigned yet. Please select pickup and drop stops below.
                </div>
            <%
                }
            %>

            <!-- ✅ Map Section -->
            <div id="map" class="my-4"></div>

            <!-- ✅ Driver Contact Info -->
            <div class="p-3 mt-4 glass-card">
                <h5><i class="fas fa-id-badge me-2"></i>Driver Contact Info</h5>
                <p><strong>Name:</strong> <span id="driverName">Loading...</span></p>
                <p><strong>Phone:</strong> <span id="driverPhone">Loading...</span></p>
            </div>

            <!-- ✅ Pickup/Drop Form -->
            <form action="assignBus" method="post" class="mt-4">
                <label for="pickup">Pickup Stop:</label>
                <input type="text" name="pickup" required>

                <label for="drop">Drop Stop:</label>
                <input type="text" name="drop" required>

                <button type="submit" class="mt-2">Submit</button>
            </form>
        </div>
    </div>

    <!-- ✅ Scripts -->
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([28.644800, 77.216721], 12);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

        const marker = L.marker([28.644800, 77.216721]).addTo(map);
        marker.bindPopup("Driver Location").openPopup();

        function fetchLocation() {
            fetch('getLocation')
                .then(res => res.json())
                .then(data => {
                    if (data.latitude && data.longitude) {
                        const lat = parseFloat(data.latitude);
                        const lng = parseFloat(data.longitude);
                        marker.setLatLng([lat, lng]);
                        map.setView([lat, lng], 14);
                    }
                });
        }

        fetchLocation();
        setInterval(fetchLocation, 5000);

        fetch('getDriverInfo')
            .then(response => response.json())
            .then(data => {
                document.getElementById("driverName").innerText = data.name || "N/A";
                document.getElementById("driverPhone").innerText = data.contact || "N/A";
            })
            .catch(err => console.error("Failed to fetch driver info", err));
    </script>

</body>
</html>
