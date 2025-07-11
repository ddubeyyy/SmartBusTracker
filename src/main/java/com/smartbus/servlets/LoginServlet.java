package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import com.smartbus.util.HashUtil;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            // Check if user exists
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String inputHash = HashUtil.hashPassword(password);

                if (storedHash.equals(inputHash)) {
                    String role = rs.getString("role");
                    int id = rs.getInt("id");

                    // Set session
                    HttpSession session = req.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);
                    session.setAttribute("id", id);

                    logger.info("Login successful for user: " + username + " (Role: " + role + ")");

                    // Redirect by role
                    if ("admin".equals(role)) {
                        res.sendRedirect("adminDashboard.jsp");
                    } else if ("driver".equals(role)) {
                        res.sendRedirect("driverDashboard.jsp");
                    } else if ("student".equals(role)) {
                        res.sendRedirect("studentDashboard.jsp");
                    }
                    return;
                } else {
                    logger.warning("Invalid password attempt for username: " + username);
                }
            } else {
                logger.warning("Login failed: Username not found - " + username);
            }

            res.sendRedirect("login.jsp?error=true");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Login failed due to error", e);
            res.sendRedirect("login.jsp?error=true");
        }
    }
}
