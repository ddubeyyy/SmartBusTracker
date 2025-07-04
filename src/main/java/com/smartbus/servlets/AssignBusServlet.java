package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/assignBus")
public class AssignBusServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(AssignBusServlet.class.getName());
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int studentId = Integer.parseInt(req.getParameter("studentId"));
        int busId = Integer.parseInt(req.getParameter("busId"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement check = con.prepareStatement("SELECT * FROM students_buses WHERE student_id = ?");
            check.setInt(1, studentId);
            if (check.executeQuery().next()) {
                res.sendRedirect("adminDashboard.jsp?status=alreadyAssigned");
                return;
            }

            PreparedStatement ps = con.prepareStatement("INSERT INTO students_buses (student_id, bus_id) VALUES (?, ?)");
            ps.setInt(1, studentId);
            ps.setInt(2, busId);
            ps.executeUpdate();
            res.sendRedirect("adminDashboard.jsp?status=success");

        } catch (Exception e) {
        	logger.log(Level.SEVERE, "Error adding bus", e);
            res.sendRedirect("adminDashboard.jsp?status=error");
        }
    }
}
