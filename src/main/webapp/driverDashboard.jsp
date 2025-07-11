<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession Connsession = request.getSession(false);
    if (session == null || !"driver".equals(Connsession.getAttribute("role"))) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }

    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Driver Dashboard</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
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
    .btn-outline-danger, .btn {
      border-radius: 10px;
      font-weight: 500;
    }
    h4 {
      font-weight: 600;
    }
    #map {
      height: 300px;
      border-radius: 15px;
      overflow: hidden;
    }
    .form-control, .form-select {
      border-radius: 10px;
      border: none;
    }
    .btn-primary, .btn-success, .btn-danger {
      background-color: #43cea2;
      border: none;
      font-weight: bold;
      color: white;
    }
    .btn-primary:hover, .btn-success:hover, .btn-danger:hover {
      background-color: #2bc0e4;
    }
    label {
      margin-top: 10px;
      color: #ddd;
    }
  </style>
</head>
<body>
  <!-- ✅ Navbar -->
  <nav class="navbar d-flex justify-content-between mb-4">
    <span class="navbar-brand">🚌 Driver Dashboard</span>
    <form action="logout" method="post">
      <button type="submit" class="btn btn-outline-danger btn-sm">Logout</button>
    </form>
  </nav>

  <div class="container">
    <div class="glass-card">
      <h3>Welcome, <%= username %> 👋</h3>

      <!-- ✅ 1. Live Location -->
      <h4 class="mt-4">📍 Your Live Location</h4>
      <div id="map" class="mb-4"></div>

      <!-- ✅ 2. Assigned Route -->
      <h4>🛣 Assigned Route</h4>
      <ul>
      <%
        try (Connection con = com.smartbus.util.DBConnection.getConnection()) {
          PreparedStatement ps = con.prepareStatement(
            "SELECT rs.stop_name FROM route_stops rs JOIN buses b ON rs.bus_id = b.bus_id WHERE b.driver_id = (SELECT id FROM users WHERE username = ?)"
          );
          ps.setString(1, username);
          ResultSet rs = ps.executeQuery();
          while (rs.next()) {
      %>
          <li><%= rs.getString("stop_name") %></li>
      <%
          }
        } catch (Exception e) {
          out.println("<li class='text-danger'>Could not fetch stops</li>");
        }
      %>
      </ul>

      <!-- ✅ 3. Passenger List -->
      <h4>👥 Passenger List</h4>
      <table class="table table-bordered table-sm text-white">
        <thead><tr><th>Name</th><th>Pickup Stop</th></tr></thead>
        <tbody>
      <%
        try (Connection con = com.smartbus.util.DBConnection.getConnection()) {
          PreparedStatement ps = con.prepareStatement(
            "SELECT u.username, u.pickup_stop FROM users u JOIN students_buses sb ON u.id = sb.student_id WHERE sb.bus_id = (SELECT bus_id FROM buses WHERE driver_id = (SELECT id FROM users WHERE username = ?))"
          );
          ps.setString(1, username);
          ResultSet rs = ps.executeQuery();
          while (rs.next()) {
      %>
          <tr>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("pickup_stop") %></td>
          </tr>
      <%
          }
        } catch (Exception e) {
          out.println("<tr><td colspan='2' class='text-danger'>Error loading passengers</td></tr>");
        }
      %>
        </tbody>
      </table>

      <!-- ✅ 4. Report Issue -->
      <h4>🚨 Report an Issue</h4>
      <form action="reportIssue" method="post" class="mb-4">
        <textarea name="message" class="form-control" rows="3" placeholder="Describe the issue..." required></textarea>
        <button class="btn btn-danger mt-2">Report</button>
      </form>

      <!-- ✅ 5. Profile Update -->
      <h4>👤 Update Profile</h4>
      <form action="updateProfile" method="post" class="row g-2 mb-4">
        <div class="col-md-6">
          <input type="text" name="contact" class="form-control" placeholder="New Contact Number" required>
        </div>
        <div class="col-md-6">
          <input type="password" name="password" class="form-control" placeholder="New Password (optional)">
        </div>
        <div class="col-md-12">
          <button class="btn btn-primary mt-2">Update Profile</button>
        </div>
      </form>

      <!-- ✅ 6. Update Status -->
      <h4>🕓 Update Bus Status</h4>
      <form action="updateStatus" method="post">
        <select name="status" class="form-select w-50 mb-2">
          <option value="on_time">On Time</option>
          <option value="delayed">Delayed</option>
        </select>
        <button class="btn btn-success">Update Status</button>
      </form>
    </div>
  </div>

  <!-- ✅ Leaflet Location Script -->
  <script>
    const map = L.map('map').setView([28.6139, 77.2090], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    const marker = L.marker([28.6139, 77.2090]).addTo(map).bindPopup("Your Location").openPopup();

    function updateLocation() {
      if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(function(position) {
          const lat = position.coords.latitude;
          const lon = position.coords.longitude;

          marker.setLatLng([lat, lon]);
          map.setView([lat, lon]);

          fetch('/updateLocation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ latitude: lat, longitude: lon })
          }).then(res => {
            if (res.ok) console.log("Location updated!");
          });
        });
      } else {
        alert("Geolocation not supported.");
      }
    }

    updateLocation();
    setInterval(updateLocation, 10000);
  </script>
</body>
</html>
