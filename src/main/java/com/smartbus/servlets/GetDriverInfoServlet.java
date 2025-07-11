package com.smartbus.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.smartbus.util.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/getDriverInfo")
public class GetDriverInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        String studentUsername = (String) session.getAttribute("username");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT u.username, u.contact FROM users u " +
                         "JOIN buses b ON u.id = b.driver_id " +
                         "JOIN students s ON s.bus_id = b.id " +
                         "WHERE s.username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, studentUsername);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String driverName = rs.getString("username");
                String contact = rs.getString("contact");

                res.setContentType("application/json");
                res.getWriter().write("{\"name\":\"" + driverName + "\", \"contact\":\"" + contact + "\"}");
            } else {
                res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
