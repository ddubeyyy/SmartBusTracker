package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/addBus")
public class AddBusServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AddBusServlet.class.getName());

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String busNumber = req.getParameter("busNumber");
        String route = req.getParameter("routeName");
        int capacity = Integer.parseInt(req.getParameter("capacity"));
        int driverId = Integer.parseInt(req.getParameter("driverId"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO buses (bus_number, route_name, capacity, driver_id) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, busNumber);
            ps.setString(2, route);
            ps.setInt(3, capacity);
            ps.setInt(4, driverId);
            ps.executeUpdate();

            logger.info("Bus added: " + busNumber + ", Driver ID: " + driverId);
            res.sendRedirect("adminDashboard.jsp?status=busAdded");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error adding bus", e);
            res.sendRedirect("adminDashboard.jsp?status=error");
        }
    }
}
