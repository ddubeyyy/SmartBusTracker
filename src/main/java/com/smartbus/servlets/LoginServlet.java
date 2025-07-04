package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import com.smartbus.util.HashUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
        	PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND password_hash=?");
        	ps.setString(1, username);
        	ps.setString(2, HashUtil.hashPassword(password));


            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                HttpSession session = req.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("id", rs.getInt("id"));

                if ("admin".equals(role)) {
                    res.sendRedirect("adminDashboard.jsp");
                } else if ("driver".equals(role)) {
                    res.sendRedirect("driverDashboard.jsp");
                } else if ("student".equals(role)) {
                    res.sendRedirect("studentDashboard.jsp");
                }
            } else {
                res.sendRedirect("login.jsp?error=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?error=true");
        }
    }
}
