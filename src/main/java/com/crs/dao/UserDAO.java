package com.crs.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.crs.config.DBConnection;
import com.crs.model.User;
import jakarta.ejb.Stateless;

@Stateless
public class UserDAO {

	public User validateUser(String username, String password) {
		User user = null;
		String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, username);
			stmt.setString(2, password);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				user = new User();
				user.setUserId(rs.getInt("user_id"));
				user.setUsername(rs.getString("username"));
				user.setRole(rs.getString("role"));
				user.setEmail(rs.getString("email"));
				// Do not store password in session for security
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	// 1. Find a user by their email address
	public User findUserByEmail(String email) {
		try (Connection conn = DBConnection.getConnection()) {
			PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
			stmt.setString(1, email);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return new User(rs.getInt("user_id"), rs.getString("username"), 
						rs.getString("password"), rs.getString("role"), rs.getString("email"));
			}
		} catch (Exception e) { e.printStackTrace(); }
		return null;
	}

	// 2. Save the secure token with a 15-minute expiration
	public void createPasswordResetToken(int userId, String token) {
		try (Connection conn = DBConnection.getConnection()) {
			// MySQL will automatically calculate 15 minutes from the current server time
			String sql = "INSERT INTO password_reset_tokens (token, user_id, expiry_date) VALUES (?, ?, NOW() + INTERVAL 15 MINUTE)";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, token);
			stmt.setInt(2, userId);
			stmt.executeUpdate();
		} catch (Exception e) { e.printStackTrace(); }
	}

	// 3. Validate the token and update the password if valid
	public boolean resetPasswordIfValid(String token, String newPassword) {
		try (Connection conn = DBConnection.getConnection()) {
			// Check if token exists AND is not expired
			String checkSql = "SELECT user_id FROM password_reset_tokens WHERE token = ? AND expiry_date > NOW()";
			PreparedStatement checkStmt = conn.prepareStatement(checkSql);
			checkStmt.setString(1, token);
			ResultSet rs = checkStmt.executeQuery();

			if (rs.next()) {
				int userId = rs.getInt("user_id");

				// Update the password
				PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET password = ? WHERE user_id = ?");
				updateStmt.setString(1, newPassword); // Remember to hash this in a real-world app!
				updateStmt.setInt(2, userId);
				updateStmt.executeUpdate();

				// Delete the token so it can't be used again
				PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM password_reset_tokens WHERE token = ?");
				deleteStmt.setString(1, token);
				deleteStmt.executeUpdate();

				return true; // Success!
			}
		} catch (Exception e) { e.printStackTrace(); }
		return false; // Token was invalid or expired
	}
}