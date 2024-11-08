package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class DbUtils {
    public static Map<String, Object> executeQuery(String dbUrl, String user, String password, String query) throws Exception {
        Class.forName("org.postgresql.Driver");
        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            Map<String, Object> result = new HashMap<>();
            while (rs.next()) {
                result.put("response", rs.getObject("response"));
            }
            return result;
        }
    }
}


