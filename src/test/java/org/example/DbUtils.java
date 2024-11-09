package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class DbUtils {
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

    public static Map<String, Object> executeQuery(String dbUrl, String user, String password, String query, String columnName) throws Exception {
        Class.forName("org.postgresql.Driver");
        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            Map<String, Object> result = new HashMap<>();
            while (rs.next()) {
                if (columnName != null && !columnName.isEmpty()) {
                    result.put(columnName, rs.getObject(columnName));
                } else {
                    int columnCount = rs.getMetaData().getColumnCount();
                    for (int i = 1; i <= columnCount; i++) {
                        String colName = rs.getMetaData().getColumnName(i);
                        result.put(colName, rs.getObject(i));
                    }
                }
            }
            return result;
        }
    }


}





