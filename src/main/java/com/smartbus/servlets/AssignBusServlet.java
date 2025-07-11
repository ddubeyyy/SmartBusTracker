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
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(AssignBusServlet.class.getName());

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		HttpSession session = req.getSession(false);
		String role = (String) session.getAttribute("role");

		if ("admin".equals(role)) {
			// 📌 Admin assigning student to a bus
			try {
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
				}
			} catch (Exception e) {
				logger.log(Level.SEVERE, "Error assigning student to bus by admin", e);
				res.sendRedirect("adminDashboard.jsp?status=error");
			}
		} else if ("student".equals(role)) {
			// 📌 Student selecting pickup/drop and system assigning nearest college bus
			String pickup = req.getParameter("pickup");
			String drop = req.getParameter("drop");
			String username = (String) session.getAttribute("username");

			try (Connection con = DBConnection.getConnection()) {
				// 1. Get student's college
				PreparedStatement collegeStmt = con.prepareStatement("SELECT id, college_name FROM users WHERE username = ?");
				collegeStmt.setString(1, username);
				ResultSet collegeRs = collegeStmt.executeQuery();

				if (!collegeRs.next()) {
					res.sendRedirect("studentDashboard.jsp?error=nocollege");
					return;
				}

				int studentId = collegeRs.getInt("id");
				String college = collegeRs.getString("college_name");

				// 2. Save pickup and drop
				PreparedStatement updateStops = con.prepareStatement("UPDATE users SET pickup_stop = ?, drop_stop = ? WHERE username = ?");
				updateStops.setString(1, pickup);
				updateStops.setString(2, drop);
				updateStops.setString(3, username);
				updateStops.executeUpdate();

				// 3. Assign any available bus for that college
				PreparedStatement busStmt = con.prepareStatement(
					"SELECT b.bus_id, u.username as driver FROM buses b JOIN users u ON b.driver_id = u.id WHERE b.college_name = ? LIMIT 1");
				busStmt.setString(1, college);
				ResultSet busRs = busStmt.executeQuery();

				if (busRs.next()) {
					int busId = busRs.getInt("bus_id");

					// Check if already assigned in students_buses
					PreparedStatement check = con.prepareStatement("SELECT * FROM students_buses WHERE student_id = ?");
					check.setInt(1, studentId);
					if (!check.executeQuery().next()) {
						// Insert assignment
						PreparedStatement ps = con.prepareStatement("INSERT INTO students_buses (student_id, bus_id) VALUES (?, ?)");
						ps.setInt(1, studentId);
						ps.setInt(2, busId);
						ps.executeUpdate();
					}

					// Set session values for dashboard
					session.setAttribute("bus_id", busId);
					session.setAttribute("driver_username", busRs.getString("driver"));
					res.sendRedirect("studentDashboard.jsp?assigned=true");
				} else {
					res.sendRedirect("studentDashboard.jsp?assigned=false");
				}

			} catch (Exception e) {
				logger.log(Level.SEVERE, "Error assigning bus to student", e);
				res.sendRedirect("studentDashboard.jsp?error=exception");
			}
		} else {
			// Role not authorized
			res.sendRedirect("login.jsp?error=unauthorized");
		}
	}
}
