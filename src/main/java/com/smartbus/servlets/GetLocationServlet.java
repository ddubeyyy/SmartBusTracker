package com.smartbus.servlets;

import java.io.*;
import java.sql.*;
import java.util.logging.Level;

import javax.servlet.http.*;
import com.smartbus.util.DBConnection;
import java.util.logging.Logger;

public class GetLocationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(GetLocationServlet.class.getName());
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        String busIdStr = req.getParameter("bus_id");

        if (busIdStr == null) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Missing bus_id\"}");
            return;
        }

        int busId = Integer.parseInt(busIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT latitude, longitude FROM bus_location WHERE bus_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, busId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                double lat = rs.getDouble("latitude");
                double lng = rs.getDouble("longitude");

                out.print("{\"latitude\": " + lat + ", \"longitude\": " + lng + "}");
            } else {
                res.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Bus not found\"}");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Database error while fetching location", e);
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Internal error\"}");
        }
    }
}
