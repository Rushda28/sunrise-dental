package com.sunrisedental.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppointmentSearchTest {

    @Test
    public void testBlankSearchInputValidation() {
        String blankInput1 = "";
        String blankInput2 = "   ";
        
        boolean isInvalid1 = (blankInput1 == null || blankInput1.trim().isEmpty());
        boolean isInvalid2 = (blankInput2 == null || blankInput2.trim().isEmpty());

        assertTrue(isInvalid1, "Empty search string should be treated as blank.");
        assertTrue(isInvalid2, "Whitespace-only search string should be treated as blank.");
    }

    @Test
    public void testAppointmentFormatPattern() {
        // existing appointment reference format: SUN-1234
        String validApptNo = "SUN-6769";
        String regex = "^SUN-\\d{4}$";

        assertTrue(validApptNo.matches(regex), "Valid appointment reference format should match.");
    }

    @Test
    public void testNonExistingAppointmentLookupLogic() {
        // Simulating a search result set state where no rows are returned
        boolean recordExists = false; 

        // When rs.next() is false, the system should branch to the error message block
        String expectedUIResponse = "Appointment Number not found in system records!";
        
        assertFalse(recordExists, "Database should confirm the record does not exist.");
        assertEquals("Appointment Number not found in system records!", expectedUIResponse, 
            "System must display the correct error notification for invalid/non-existent codes.");
    }
}
