<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Smart Bus Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
        body {
            background: linear-gradient(to bottom right, #f2fbff, #ffffff);
            font-family: 'Segoe UI', sans-serif;
        }

        .hero-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 60px 5%;
            background: linear-gradient(to right, rgba(224, 247, 250, 0.95), rgba(255, 255, 255, 0.95));
            position: relative;
            overflow: hidden;
        }

        .hero-section::after {
            content: "";
            background: url('schoolBus.png') no-repeat right center;
            background-size: 600px;
            opacity: 1;
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            z-index: 0;
        }

        .hero-text {
            max-width: 60%;
            position: relative;
            z-index: 1;
        }

        .hero-text h1 {
            font-size: 3.5rem;
            font-weight: bold;
            color: #004d40;
        }

        .hero-text p {
            font-size: 1.2rem;
            color: #333;
        }

        .hero-text a {
            margin-right: 15px;
        }

        .role-cards {
		    margin-top: 60px;
		    font-family: 'Nunito', sans-serif;
		}
		
		.card {
		    border-radius: 20px;
		    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
		    transition: transform 0.3s ease, box-shadow 0.3s ease;
		    background-color: #fff;
		    border: none;
		}
		
		.card:hover {
		    transform: translateY(-8px);
		    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
		}
		.card h4 {
		    font-family: 'Poppins', sans-serif;
		    font-weight: 700;
		    font-size: 1.4rem;
		    margin-bottom: 10px;
		}
		
		.card p {
		    font-weight: 500;
		    color: #444;
		    font-size: 1rem;
		}
		
		.card .btn {
		    margin-top: 15px;
		    padding: 10px 24px;
		    font-weight: 600;
		    border-radius: 8px;
		    font-family: 'Poppins', sans-serif;
		    transition: background-color 0.3s ease, transform 0.2s ease;
		}
		
		.btn-primary:hover {
		    background-color: #005ce6;
		}
		
		.btn-success:hover {
		    background-color: #218838;
		}
		
		.btn-warning:hover {
		    background-color: #ffca2c;
		    color: #000;
		}

        #map {
            height: 350px;
            border-radius: 15px;
            margin-top: 40px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .footer {
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #555;
            margin-top: 60px;
        }
    </style>
</head>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600&family=Poppins:wght@500;700&display=swap" rel="stylesheet">

<body>

    <!-- 🌟 Hero Banner -->
    <div class="hero-section">
        <div class="hero-text">
            <h1>Welcome to Smart Bus Tracker</h1>
            <p class="lead">Real-time Tracking • Secure Login • Easy Management</p>
            <a href="login.jsp" class="btn btn-dark px-4 py-2">Login</a>
            <a href="register.jsp" class="btn btn-outline-dark px-4 py-2">Register</a>
        </div>
    </div>

    <!-- 🎴 Role Cards -->
	<div class="container role-cards">
	    <div class="row text-center">
	        <div class="col-md-4 mb-4">
	            <div class="card p-4">
	                <h4>Admin</h4>
	                <p>Manage drivers, students, buses, and monitor assignments.</p>
	                <a href="login.jsp" class="btn btn-primary">Admin Panel</a>
	            </div>
	        </div>
	        <div class="col-md-4 mb-4">
	            <div class="card p-4">
	                <h4>Driver</h4>
	                <p>Login to update your bus location and view assigned routes.</p>
	                <a href="login.jsp" class="btn btn-success">Driver Login</a>
	            </div>
	        </div>
	        <div class="col-md-4 mb-4">
	            <div class="card p-4">
	                <h4>Student</h4>
	                <p>Track your assigned bus and view its live location.</p>
	                <a href="login.jsp" class="btn btn-warning">Student Access</a>
	            </div>
	        </div>
	    </div>
	</div>


    <!-- 🗺️ Live Map Section -->
    <div class="container">
        <h3 class="text-center mb-4 mt-5">Live Bus Tracking Map</h3>
        <div id="map"></div>
    </div>

    <div class="footer">
        &copy; 2025 Smart Bus Tracker | Developed by Disha Dubey
    </div>

    <!-- 🧭 Map Script -->
    <script>
        const map = L.map('map').setView([28.6139, 77.2090], 12); // Delhi
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        L.marker([28.6139, 77.2090]).addTo(map)
            .bindPopup('Smart Bus HQ')
            .openPopup();
    </script>
</body>
</html>
