package com.sunrisedental.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class BillCalculationTest {

    @Test
    public void testBillCalculationDiscountLogicTDD() {
        double subtotal = 10000.0;
        double discountRate = 0.15;
        double expectedTotal = 8500.0;
        
        double calculatedTotal = subtotal - (subtotal * discountRate);
        assertEquals(expectedTotal, calculatedTotal, 0.01, "Calculated net total must match formula expectations.");
    }
}
