package com.smartbus.servlets;

import java.io.IOException;
import java.sql.*;

import com.smartbus.util.DBConnection;
import com.smartbus.util.HashUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateDriverProfile")
public class UpdateDriverProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"driver".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        String oldUsername = (String) session.getAttribute("username");
        String newUsername = req.getParameter("username");
        String contact = req.getParameter("contact");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            String hashedPass = HashUtil.hashPassword(password);
            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET username = ?, contact = ?, password_hash = ? WHERE username = ?"
            );
            ps.setString(1, newUsername);
            ps.setString(2, contact);
            ps.setString(3, hashedPass);
            ps.setString(4, oldUsername);
            ps.executeUpdate();

            session.setAttribute("username", newUsername);
            res.sendRedirect("driverDashboard.jsp?updated=true");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("updateDriverProfile.jsp?error=true");
        }
    }
}
