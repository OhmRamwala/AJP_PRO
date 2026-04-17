package com.ekart.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DbUtil {
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream inputStream = DbUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (inputStream == null) {
                throw new IllegalStateException("db.properties not found on classpath");
            }

            PROPERTIES.load(inputStream);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (IOException | ClassNotFoundException exception) {
            throw new ExceptionInInitializerError(exception);
        }
    }

    private DbUtil() {
    }

    public static Connection getConnection() throws SQLException {
        String url = getConfig("EKART_DB_URL", "db.url");
        String user = getConfig("EKART_DB_USER", "db.user");
        String password = getConfig("EKART_DB_PASSWORD", "db.password");
        return DriverManager.getConnection(url, user, password);
    }

    private static String getConfig(String envKey, String propertyKey) {
        String value = System.getenv(envKey);
        if (value != null && !value.isBlank()) {
            return value;
        }
        return PROPERTIES.getProperty(propertyKey);
    }
}
