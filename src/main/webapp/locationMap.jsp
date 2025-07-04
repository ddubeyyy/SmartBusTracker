<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Live Bus Tracking</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <link rel="stylesheet" href="css/styles.css" />

    <style>
        #map {
            height: 500px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h3>Live Bus Location (OpenStreetMap)</h3>
    <div id="map"></div>
</div>

<script>
    // Default map center (Delhi) — will auto update
    var map = L.map('map').setView([28.6139, 77.2090], 13);

    // Add OpenStreetMap layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    // Create a marker (initial)
    var marker = L.marker([28.6139, 77.2090]).addTo(map);

    // Load location from servlet
    function updateLocation() {
        fetch("getLocation?bus_id=1")  // Change to dynamic bus_id if needed
            .then(res => res.json())
            .then(data => {
                var lat = parseFloat(data.latitude);
                var lng = parseFloat(data.longitude);
                marker.setLatLng([lat, lng]);
                map.setView([lat, lng], 15);
            })
            .catch(err => console.error("Location update failed:", err));
    }

    updateLocation();              // Initial load
    setInterval(updateLocation, 5000); // Refresh every 5 sec
</script>

</body>
</html>
