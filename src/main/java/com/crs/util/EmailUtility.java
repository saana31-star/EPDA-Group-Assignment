package com.crs.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtility {

	// CONFIGURE YOUR EMAIL HERE
	private static final String SENDER_EMAIL = "crsgroupbm@gmail.com";
	private static final String SENDER_PASSWORD = "loyu hmtq mppr zxpl";

	private static Session getEmailSession() {
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587"); // TLS Port
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true"); // Enable TLS Encryption

		return Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
			}
		});
	}

	public static void sendResetLink(String recipientEmail, String resetLink) {
		try {
			Message message = new MimeMessage(getEmailSession());
			message.setFrom(new InternetAddress(SENDER_EMAIL, "Course Recovery System"));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
			message.setSubject("Security Alert: Password Reset Requested");

			// Writing a clean HTML email
			String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
					+ "<h2 style='color: #AE82A4;'>Password Reset Request</h2>"
					+ "<p>We received a request to reset the password for your Course Recovery System account.</p>"
					+ "<p>Click the secure link below to set a new password. This link will expire in 15 minutes.</p>"
					+ "<br>" + "<a href='" + resetLink
					+ "' style='background-color: #D88DB4; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>Reset My Password</a>"
					+ "<br><br>"
					+ "<p style='font-size: 12px; color: #999;'>If you did not request this, please ignore this email.</p>"
					+ "</div>";

			message.setContent(htmlContent, "text/html; charset=utf-8");

			// Send the email!
			Transport.send(message);
			System.out.println("SUCCESS: Password reset email sent to " + recipientEmail);

		} catch (Exception e) {
			System.err.println("FAILED to send email: " + e.getMessage());
			e.printStackTrace();
		}
	}

	public static void sendRecoveryNotification(String recipientEmail, String studentName, String course,
			String strategy) {

		// 1. Setup Mail Server Properties
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

		// 2. Create Session
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
			}
		});

		try {
			// 3. Create Message
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(SENDER_EMAIL));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
			message.setSubject("Course Recovery Plan Approved - " + course);

			// 4. Email Body
			String emailContent = "Dear " + studentName + ",\n\n"
					+ "A recovery plan has been created for your failed course: " + course + "\n" + "Action Plan: "
					+ strategy + "\n\n" + "Please log in to the portal to view your milestones.\n\n"
					+ "Regards,\nCourse Recovery System Admin";

			message.setText(emailContent);

			// 5. Send
			Transport.send(message);
			System.out.println("✅ Email sent successfully to " + recipientEmail);

		} catch (Exception e) {
			System.err.println("❌ Failed to send email: " + e.getMessage());
			e.printStackTrace();
		}
	}
}