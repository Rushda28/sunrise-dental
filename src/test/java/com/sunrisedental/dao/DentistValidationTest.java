package com.sunrisedental.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class DentistValidationTest {

    @Test
    public void testDentistNameValidationRegex() {
        // Valid names containing letters, spaces, and periods
        String validName1 = "Dr. Samantha Mary";
        String validName2 = "John Doe";
        
        // Invalid names containing numbers or prohibited characters
        String invalidNameWithDigits = "Dr. John 2nd";
        String invalidNameWithSymbols = "Dr. Smith#";

        String regex = "^[a-zA-Z\\s\\.]+$";

        assertTrue(validName1.matches(regex), "Valid name with title and spaces should pass.");
        assertTrue(validName2.matches(regex), "Valid name with spaces should pass.");
        assertFalse(invalidNameWithDigits.matches(regex), "Dentist name containing digits must fail validation.");
        assertFalse(invalidNameWithSymbols.matches(regex), "Dentist name containing special symbols must fail validation.");
    }
    // Blank field validation test
    @Test
    public void testBlankFieldValidation() {
        String emptyName = "";
        String whitespaceName = "   ";
        String validName = "Dr. Robert";

        boolean isEmptyOrBlank1 = (emptyName == null || emptyName.trim().isEmpty());
        boolean isEmptyOrBlank2 = (whitespaceName == null || whitespaceName.trim().isEmpty());
        boolean isValid = (validName != null && !validName.trim().isEmpty());

        assertTrue(isEmptyOrBlank1, "Empty name string should be detected as blank.");
        assertTrue(isEmptyOrBlank2, "Whitespace-only name string should be detected as blank.");
        assertTrue(isValid, "A properly populated name should pass blank check.");
    }
}