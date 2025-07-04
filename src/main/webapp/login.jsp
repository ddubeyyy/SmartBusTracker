<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Bus Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2 class="text-center mb-4">Smart Bus Tracker - Login</h2>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" id="username" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" id="password" required>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Login</button>
                    </div>
                </form>

                <%-- Optional: Show login error from query param --%>
                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger mt-3">
                        Invalid username or password.
                    </div>
                <% } %>

                <div class="mt-3 text-center">
                    <a href="register.jsp">Don't have an account? Register here</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
