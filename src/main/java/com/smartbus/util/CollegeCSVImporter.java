package com.smartbus.util;

import java.io.*;
import java.sql.*;
import java.util.*;

public class CollegeCSVImporter {
    public static void main(String[] args) { 
    	String csvFilePath = "C:\\Users\\lenovo\\OneDrive\\Desktop\\college.csv";
// Update this path
        String line; 
        Set<String> uniqueColleges = new HashSet<>();

        try (Connection con = DBConnection.getConnection();
             BufferedReader br = new BufferedReader(new FileReader(csvFilePath))) {

            PreparedStatement ps = con.prepareStatement("INSERT IGNORE INTO colleges(name) VALUES(?)");

            while ((line = br.readLine()) != null) {
                String collegeName = line.trim();
                if (!collegeName.isEmpty() && uniqueColleges.add(collegeName)) {
                    ps.setString(1, collegeName);
                    ps.executeUpdate();
                }
            }

            System.out.println("Colleges inserted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
