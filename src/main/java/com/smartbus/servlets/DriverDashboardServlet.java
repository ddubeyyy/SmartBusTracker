package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/driverDashboard")
public class DriverDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"driver".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        String username = (String) session.getAttribute("username");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT bus_number, capacity, type FROM buses WHERE driver_username = ?"
            );
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("busNumber", rs.getString("bus_number"));
                req.setAttribute("capacity", rs.getInt("capacity"));
                req.setAttribute("type", rs.getString("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            req.getRequestDispatcher("driverDashboard.jsp").forward(req, res);
        } catch (Exception ex) {
            res.sendRedirect("login.jsp?error=internal");
        }
    }
}
