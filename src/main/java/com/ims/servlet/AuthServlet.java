package com.ims.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ims.dao.UserDAO;
import com.ims.model.User;
import com.ims.util.PasswordUtil;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp?message=Logged out successfully");
            return;
        }
        
        response.sendRedirect("login.jsp");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=Please fill in all fields");
            return;
        }
        
        try {
            String hashedPassword = PasswordUtil.hashPassword(password);
            User user = userDAO.authenticate(username.trim(), hashedPassword);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole().toString());
                
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=Invalid username or password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Login failed. Please try again.");
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        
        // Validation
        if (username == null || email == null || password == null || confirmPassword == null || fullName == null ||
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || 
            confirmPassword.trim().isEmpty() || fullName.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=Please fill in all fields");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=Passwords do not match");
            return;
        }
        
        if (password.length() < 6) {
            response.sendRedirect("register.jsp?error=Password must be at least 6 characters long");
            return;
        }
        
        try {
            // Check if username or email already exists
            if (userDAO.existsByUsername(username.trim())) {
                response.sendRedirect("register.jsp?error=Username already exists");
                return;
            }
            
            if (userDAO.existsByEmail(email.trim())) {
                response.sendRedirect("register.jsp?error=Email already exists");
                return;
            }
            
            // Create new user
            User user = new User();
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setFullName(fullName.trim());
            user.setRole(User.Role.USER);
            
            userDAO.save(user);
            
            response.sendRedirect("login.jsp?message=Registration successful! Please login.");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
        }
    }
}