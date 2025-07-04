package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateLocation")
public class UpdateLocationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int driverId = (int) req.getSession().getAttribute("id");
        String lat = req.getParameter("latitude");
        String lng = req.getParameter("longitude");

        try (Connection con = DBConnection.getConnection()) {
            // Get bus_id for this driver
            PreparedStatement findBus = con.prepareStatement("SELECT bus_id FROM buses WHERE driver_id = ?");
            findBus.setInt(1, driverId);
            ResultSet rs = findBus.executeQuery();

            if (rs.next()) {
                int busId = rs.getInt("bus_id");

                PreparedStatement ps = con.prepareStatement(
                    "REPLACE INTO bus_location (bus_id, latitude, longitude) VALUES (?, ?, ?)"
                );
                ps.setInt(1, busId);
                ps.setString(2, lat);
                ps.setString(3, lng);
                ps.executeUpdate();

                res.sendRedirect("driverDashboard.jsp?status=updated");
            } else {
                res.sendRedirect("driverDashboard.jsp?status=nobus");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("driverDashboard.jsp?status=error");
        }
    }
}
