package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.logging.*;
import org.json.JSONObject;

@WebServlet("/updateLocation")
public class UpdateLocationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(UpdateLocationServlet.class.getName());

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"driver".equals(session.getAttribute("role"))) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String username = (String) session.getAttribute("username");
        BufferedReader reader = req.getReader();
        StringBuilder jsonBuilder = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            jsonBuilder.append(line);
        }

        try {
            JSONObject json = new JSONObject(jsonBuilder.toString());
            double lat = json.getDouble("latitude");
            double lon = json.getDouble("longitude");

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement("UPDATE users SET latitude = ?, longitude = ? WHERE username = ?");
                ps.setDouble(1, lat);
                ps.setDouble(2, lon);
                ps.setString(3, username);
                ps.executeUpdate();

                logger.info("Location updated for user: " + username);
                res.setStatus(HttpServletResponse.SC_OK);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating location", e);
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
