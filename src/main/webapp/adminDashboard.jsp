<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    HttpSession session = request.getSession(false);
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Smart Bus</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="p-4">
    <div class="container">
        <h2 class="mb-4">Welcome, Admin</h2>

        <!-- ✅ STATUS MESSAGES -->
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-info">
                <%= request.getParameter("status") %>
            </div>
        <% } %>

        <!-- ✅ Add New Bus -->
        <div class="mb-4">
            <h5>Add New Bus</h5>
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
                    <input type="number" name="driverId" class="form-control" placeholder="Driver User ID" required>
                </div>
                <div class="col-12">
                    <button class="btn btn-primary">Add Bus</button>
                </div>
            </form>
        </div>

        <!-- ✅ Assign Student to Bus -->
        <div class="mb-4">
            <h5>Assign Student to Bus</h5>
            <form action="assignStudent" method="post" class="row g-3">
                <div class="col-md-6">
                    <input type="text" name="student_username" class="form-control" placeholder="Student Username" required>
                </div>
                <div class="col-md-6">
                    <input type="number" name="bus_id" class="form-control" placeholder="Bus ID" required>
                </div>
                <div class="col-12">
                    <button class="btn btn-success">Assign</button>
                </div>
            </form>
        </div>

        <!-- ✅ View Student Count -->
        <div class="mb-4">
    <h5>View Student Count for a Bus</h5>
    <div class="row g-3">
        <div class="col-md-4">
            <input type="number" id="busIdInput" class="form-control" placeholder="Enter Bus ID">
        </div>
        <div class="col-md-4">
            <button class="btn btn-info" onclick="getStudentCount()">Get Count</button>
        </div>
        <div class="col-md-4">
            <div id="countResult" class="alert alert-secondary" style="display:none;"></div>
        </div>
    </div>
</div>

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


        <!-- ✅ View All Buses -->
        <div class="mb-4">
            <h5>All Buses</h5>
            <jsp:include page="busList.jsp" />
        </div>
    </div>
</body>
</html>
