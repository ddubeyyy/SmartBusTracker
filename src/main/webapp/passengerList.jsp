<%@ page import="java.sql.*, com.smartbus.util.DBConnection" %>
<%
    HttpSession sessionbe = request.getSession(false);
    if (session == null || !"driver".equals(sessionbe.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement(
            "SELECT s.username, s.name, s.checked_in FROM users s JOIN buses b ON s.bus_id = b.id WHERE b.driver_username = ? AND s.role = 'student'"
        );
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
%>
<table border="1">
    <tr><th>Username</th><th>Name</th><th>Checked In</th></tr>
    <%
        while (rs.next()) {
    %>
        <tr>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getBoolean("checked_in") ? "Yes" : "No" %></td>
        </tr>
    <%
        }
    }
    catch(Exception e) {
        e.printStackTrace();
    }
%>
</table>
