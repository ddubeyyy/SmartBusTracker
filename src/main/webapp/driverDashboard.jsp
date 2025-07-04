<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Driver Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="p-4">
    <h3>Welcome Driver</h3>

    <form method="post" action="updateLocation">
        <div class="row g-3">
            <div class="col">
                <input type="text" name="latitude" class="form-control" placeholder="Latitude" required>
            </div>
            <div class="col">
                <input type="text" name="longitude" class="form-control" placeholder="Longitude" required>
            </div>
            <div class="col">
                <button class="btn btn-success" type="submit">Update Location</button>
            </div>
        </div>
    </form>

    <div class="mt-3">
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-info">
                <%= request.getParameter("status") %>
            </div>
        <% } %>
    </div>
</body>
</html>
