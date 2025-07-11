# SmartBusTracker 🚍

SmartBusTracker is a smart transportation management system designed to monitor and manage bus tracking for educational institutions or private bus services. It enables real-time tracking of buses, route management, and user-friendly access to location updates.

---

## 🔧 Tech Stack

- **Java (Servlets/JSP or Spring Boot)**
- **MySQL / JDBC**
- **Maven**
- **Jenkins** (CI/CD)
- **Docker**
- **Apache Tomcat**
- **HTML/CSS/JavaScript** (for frontend)

---

## 📦 Features

### 🚌 Bus Management
- Add, update, and remove buses
- Assign unique IDs and driver details

### 👩‍🏫 User Authentication
- Secure login for **Admin**, **Students**, and **Drivers**
- Session-based login system

### 🗺️ Real-Time Location Tracking
- GPS coordinates simulation or integration (e.g., with Google Maps API)
- Show current bus location on the map

### 🧭 Route Management
- Define routes: source, stops, destination
- View estimated arrival times and delays

### 🧾 Student Module
- Login and view assigned bus details
- See real-time location of their bus
- Notifications (optional)

### 👨‍💻 Admin Module
- Dashboard to manage:
  - Buses
  - Drivers
  - Routes
  - Students
- Generate reports and logs

### 🧪 CI/CD Pipeline (DevOps)
- Jenkins pipeline:
  - Pull code from GitHub
  - Build WAR using Maven
  - Create Docker Image
  - Push to Docker Hub
  - Deploy container

---

## 🚀 Project Structure

```plaintext
SmartBusTracker/
├── src/
│   ├── main/
│   │   ├── java/          # Java files (Servlets/Controllers/Services)
│   │   └── webapp/        # JSP, HTML, CSS, JS files
├── Dockerfile
├── Jenkinsfile
├── pom.xml
└── README.md
