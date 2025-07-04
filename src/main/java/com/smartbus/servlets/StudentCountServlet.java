package com.smartbus.servlets;

import com.smartbus.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/studentCount")
public class StudentCountServlet extends HttpServlet {
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

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
