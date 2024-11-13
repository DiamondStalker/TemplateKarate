//package org.example;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.ResultSet;
//import java.sql.Statement;
//import java.util.HashMap;
//import java.util.Map;
//
//public class DbUtils {
//    public static Map<String, Object> executeQuery(String dbUrl, String user, String password, String query) throws Exception {
//        Class.forName("org.postgresql.Driver");
//        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(query)) {
//
//            Map<String, Object> result = new HashMap<>();
//            while (rs.next()) {
//                result.put("response", rs.getObject("response"));
//            }
//            return result;
//        }
//    }
//}


package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DbUtils {

    public static List<Map<String, Object>> executeQuery(String dbUrl, String user, String password, String query) throws ClassNotFoundException, SQLException {
        Class.forName("org.postgresql.Driver");

        List<Map<String, Object>> results = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            int columnCount = rs.getMetaData().getColumnCount();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = rs.getMetaData().getColumnName(i);
                    row.put(columnName, rs.getObject(i));
                }
                results.add(row);
            }
        }
        return results;
    }
}

