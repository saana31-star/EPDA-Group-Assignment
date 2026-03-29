package com.crs.controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

import com.crs.dao.UserDAO;
import com.crs.model.User;
import com.crs.util.EmailUtility;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

	@EJB
	private UserDAO userDAO;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		User user = userDAO.findUserByEmail(email);

		if (user != null) {
			// Generate a secure, random 36-character token
			String token = UUID.randomUUID().toString();
			userDAO.createPasswordResetToken(user.getUserId(), token);

			// The link they will click in their email
			String resetLink = request.getRequestURL().toString().replace("ForgotPasswordServlet", "reset_password.jsp?token=" + token);

			EmailUtility.sendResetLink(email, resetLink);
		}

		// Always show the same generic message for security (prevents hackers from guessing valid emails)
		response.sendRedirect("forgot_password.jsp?msg=CheckEmail");
	}
}