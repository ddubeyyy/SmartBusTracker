package com.smartbus.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartbus.util.DBConnection;
import com.smartbus.util.HashUtil;

import java.util.logging.Logger;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
@WebServlet("/register")

public class RegisterServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(RegisterServlet.class.getName());

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement checkStmt = con.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                logger.warning("Registration failed: Username already exists - " + username);
                res.sendRedirect("register.jsp?status=exists");
                return;
            }

            String hashedPassword = HashUtil.hashPassword(password);
            PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)");
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, role);
            ps.executeUpdate();

            logger.info("New user registered: " + username + " as " + role);
            res.sendRedirect("login.jsp?registered=true");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during registration", e);
            res.sendRedirect("register.jsp?status=error");
        }
    }
}
