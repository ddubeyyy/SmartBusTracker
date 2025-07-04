<%@ page import="java.sql.*, com.smartbus.util.DBConnection" %>
<table border="1">
<tr><th>Bus No</th><th>Route</th><th>Capacity</th><th>Driver ID</th></tr>

<%
    try (Connection con = DBConnection.getConnection()) {
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM buses");

        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("bus_number") %></td>
    <td><%= rs.getString("route_name") %></td>
    <td><%= rs.getInt("capacity") %></td>
    <td><%= rs.getInt("driver_id") %></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.print("Error loading buses.");
    }
%>
</table>
