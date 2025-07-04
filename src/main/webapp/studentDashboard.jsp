<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        #map { height: 400px; }
    </style>
</head>
<body class="p-4">
    <h3>Welcome Student</h3>
    <div id="map" class="mt-4"></div>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
        const map = L.map('map').setView([28.644800, 77.216721], 12); // default to Delhi

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        const marker = L.marker([28.644800, 77.216721]).addTo(map);

        function fetchLocation() {
            fetch('getLocation')
                .then(res => res.json())
                .then(data => {
                    if (data.latitude && data.longitude) {
                        const lat = parseFloat(data.latitude);
                        const lng = parseFloat(data.longitude);
                        marker.setLatLng([lat, lng]);
                        map.setView([lat, lng], 15);
                    }
                });
        }

        fetchLocation();
        setInterval(fetchLocation, 5000); // every 5 seconds
    </script>
</body>
</html>
