package com.crs.util;

public class EmailUtility {
    
    public static void sendRecoveryNotification(String toEmail, String studentName, String course, String strategy) {
        // In a real app, you would use Jakarta Mail (JavaMail) here.
        // For this assignment, we simulate the "Sent" status and log it.
        
        System.out.println("=================================================");
        System.out.println(" [EMAIL SYSTEM] SENDING NOTIFICATION...");
        System.out.println(" TO: " + toEmail);
        System.out.println(" SUBJECT: Course Recovery Plan Approved - " + course);
        System.out.println(" -------------------------------------------------");
        System.out.println(" Dear " + studentName + ",");
        System.out.println("");
        System.out.println(" A recovery plan has been created for your failed course: " + course);
        System.out.println(" Action Plan: " + strategy);
        System.out.println("");
        System.out.println(" Please log in to view your milestones.");
        System.out.println("=================================================");
    }
}