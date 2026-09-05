package com.sunrisedental.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class BillCalculationTest {

    @Test
    public void testBillTotalCalculation() {
        double consultationFee = 1500.0;
        double treatmentCost = 20000.0;
        double expectedTotal = 21500.0;

        double calculatedTotal = consultationFee + treatmentCost;

        assertEquals(expectedTotal, calculatedTotal, 0.01,
                "Total payable should equal consultation fee plus treatment cost.");
    }
}