package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/studentCount")
public class StudentCountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(StudentCountServlet.class.getName());

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int busId = Integer.parseInt(req.getParameter("busId"));
        int count = 0;

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM students_buses WHERE bus_id = ?");
            ps.setInt(1, busId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

            res.setContentType("application/json");
            PrintWriter out = res.getWriter();
            out.print("{\"count\":" + count + "}");
            out.flush();

            logger.info("Student count for bus " + busId + ": " + count);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fetching student count", e);
        }
    }
}
