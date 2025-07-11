package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/assignStudent")
public class AssignStudentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(AssignStudentServlet.class.getName());
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("student_username");
        int busId = Integer.parseInt(req.getParameter("bus_id"));

        try (Connection con = DBConnection.getConnection()) {
            // 1. Find student ID by username
            PreparedStatement userStmt = con.prepareStatement("SELECT id FROM users WHERE username = ? AND role = 'student'");
            userStmt.setString(1, username);
            ResultSet rs = userStmt.executeQuery();

            if (!rs.next()) {
                res.sendRedirect("adminDashboard.jsp?status=studentNotFound");
                return;
            }

            int studentId = rs.getInt("id");

            // 2. Check if already assigned
            PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM students_buses WHERE student_id = ?");
            checkStmt.setInt(1, studentId);
            ResultSet checkRS = checkStmt.executeQuery();

            if (checkRS.next()) {
                res.sendRedirect("adminDashboard.jsp?status=alreadyAssigned");
                return;
            }

            // 3. Assign student to bus
            PreparedStatement insertStmt = con.prepareStatement("INSERT INTO students_buses (student_id, bus_id) VALUES (?, ?)");
            insertStmt.setInt(1, studentId);
            insertStmt.setInt(2, busId);
            insertStmt.executeUpdate();

            res.sendRedirect("adminDashboard.jsp?status=assigned");

        } catch (Exception e) {
        	logger.log(Level.SEVERE, "Error adding bus", e);
            res.sendRedirect("adminDashboard.jsp?status=error");
        }
    }
}
