package com.sunrisedental.dao;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import static org.junit.jupiter.api.Assertions.*;

public class UserDAOTest {
    private UserDAO userDAO;

    @BeforeEach
    public void setUp() {
        userDAO = new UserDAO();
    }

    // Wrong credential test
    @Test
    public void testUserAuthenticationTDD() {
        boolean isAuthenticated = userDAO.validateUser("admin", "wrongpassword");
        assertFalse(isAuthenticated, "The UserDAO must reject incorrect passwords.");
    }


    // Blank field / empty credentials test
    @Test
    public void testUserAuthenticationBlankField() {
        boolean isAuthenticated = userDAO.validateUser("", "");
        assertFalse(isAuthenticated, "The UserDAO must reject blank or empty credentials.");
    }

    // Correct credential test (with SHA-256 hash)

    @Test
    public void testUserAuthenticationSuccess() {
        boolean isAuthenticated = userDAO.validateUser("admin", hashPassword("admin123"));
        assertTrue(isAuthenticated, "The UserDAO must accept valid credentials with a hashed password.");
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        
    }
}