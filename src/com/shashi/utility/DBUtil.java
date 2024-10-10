package com.shashi.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

public class DBUtil {
    private static Connection conn;

    public DBUtil() {
    }

    public static Connection provideConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                ResourceBundle rb = ResourceBundle.getBundle("application");
                String connectionString = rb.getString("db.connectionString");
                String driverName = rb.getString("db.driverName");
                String username = rb.getString("db.username");
                String password = rb.getString("db.password");
                try {
                    Class.forName(driverName);
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
                conn = DriverManager.getConnection(connectionString, username, password);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return conn;
    }

    // 취약한 SQL 쿼리를 수행하는 메소드
    public static ResultSet executeVulnerableQuery(String userInput) {
        ResultSet rs = null;
        try {
            Statement stmt = conn.createStatement();
            // 사용자 입력을 직접 쿼리에 포함
            String query = "SELECT * FROM users WHERE username = '" + userInput + "';";
            rs = stmt.executeQuery(query);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rs;
    }

    public static void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeConnection(ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeConnection(Statement stmt) {
        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
