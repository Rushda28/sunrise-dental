package com.sunrisedental.util;

import java.util.UUID;

public class CodeGenerator {
    public static String generateAppointmentNumber() {
        String uniqueID = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        return "SUN-" + uniqueID;
    }
}
