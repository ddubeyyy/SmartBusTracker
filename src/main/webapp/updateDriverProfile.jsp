<%
    HttpSession connsession = request.getSession(false);
    if (session == null || !"driver".equals(connsession.getAttribute("role"))) {
        response.sendRedirect("login.jsp?error=session_expired");
        return;
    }
%>
<form action="updateDriverProfile" method="post">
    <label>New Username: <input type="text" name="username" required></label><br>
    <label>New Contact: <input type="text" name="contact" required></label><br>
    <label>New Password: <input type="password" name="password" required></label><br>
    <input type="submit" value="Update Profile">
</form>
