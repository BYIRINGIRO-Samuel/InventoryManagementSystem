<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Register - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                    background: linear-gradient(135deg, #8B4513 0%, #D2691E 50%, #F5DEB3 100%);
                    padding: 2rem 0;
                }

                .register-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 20px 40px rgba(139, 69, 19, 0.3);
                    overflow: hidden;
                    width: 100%;
                    max-width: 500px;
                    padding: 3rem;
                }

                .register-title {
                    color: #8B4513;
                    font-size: 2rem;
                    margin-bottom: 2rem;
                    text-align: center;
                }

                .form-group {
                    position: relative;
                    margin-bottom: 1.5rem;
                }

                .form-control {
                    padding-left: 3rem;
                }

                .form-icon {
                    position: absolute;
                    left: 1rem;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #8B4513;
                    z-index: 1;
                }

                .register-footer {
                    text-align: center;
                    margin-top: 2rem;
                    color: #6C757D;
                }

                .register-footer a {
                    color: #8B4513;
                    text-decoration: none;
                    font-weight: 500;
                }

                .register-footer a:hover {
                    text-decoration: underline;
                }

                .password-strength {
                    margin-top: 0.5rem;
                    font-size: 0.8rem;
                }

                .strength-weak {
                    color: #DC3545;
                }

                .strength-medium {
                    color: #FFC107;
                }

                .strength-strong {
                    color: #28A745;
                }
            </style>
        </head>

        <body>
            <div class="register-container fade-in">
                <h2 class="register-title">Create Account</h2>

                <!-- Display messages -->
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${param.error}
                    </div>
                </c:if>

                <form action="auth" method="post" id="registerForm">
                    <input type="hidden" name="action" value="register">

                    <div class="form-group">
                        <i class="fas fa-user form-icon"></i>
                        <input type="text" name="fullName" class="form-control" placeholder="Full Name" required>
                    </div>

                    <div class="form-group">
                        <i class="fas fa-user-circle form-icon"></i>
                        <input type="text" name="username" class="form-control" placeholder="Username" required
                            minlength="3">
                    </div>

                    <div class="form-group">
                        <i class="fas fa-envelope form-icon"></i>
                        <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                    </div>

                    <div class="form-group">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Password"
                            required minlength="6">
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>

                    <div class="form-group">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                            placeholder="Confirm Password" required>
                        <div id="passwordMatch" class="password-strength"></div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>

                <div class="register-footer">
                    <p>Already have an account? <a href="login.jsp">Sign In</a></p>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const passwordInput = document.getElementById('password');
                    const confirmPasswordInput = document.getElementById('confirmPassword');
                    const passwordStrength = document.getElementById('passwordStrength');
                    const passwordMatch = document.getElementById('passwordMatch');
                    const form = document.getElementById('registerForm');

                    // Password strength checker
                    passwordInput.addEventListener('input', function () {
                        const password = this.value;
                        let strength = 0;
                        let message = '';

                        if (password.length >= 6) strength++;
                        if (password.match(/[a-z]/)) strength++;
                        if (password.match(/[A-Z]/)) strength++;
                        if (password.match(/[0-9]/)) strength++;
                        if (password.match(/[^a-zA-Z0-9]/)) strength++;

                        switch (strength) {
                            case 0:
                            case 1:
                                message = 'Weak password';
                                passwordStrength.className = 'password-strength strength-weak';
                                break;
                            case 2:
                            case 3:
                                message = 'Medium password';
                                passwordStrength.className = 'password-strength strength-medium';
                                break;
                            case 4:
                            case 5:
                                message = 'Strong password';
                                passwordStrength.className = 'password-strength strength-strong';
                                break;
                        }

                        passwordStrength.textContent = message;
                    });

                    // Password match checker
                    function checkPasswordMatch() {
                        const password = passwordInput.value;
                        const confirmPassword = confirmPasswordInput.value;

                        if (confirmPassword === '') {
                            passwordMatch.textContent = '';
                            return;
                        }

                        if (password === confirmPassword) {
                            passwordMatch.textContent = 'Passwords match';
                            passwordMatch.className = 'password-strength strength-strong';
                        } else {
                            passwordMatch.textContent = 'Passwords do not match';
                            passwordMatch.className = 'password-strength strength-weak';
                        }
                    }

                    confirmPasswordInput.addEventListener('input', checkPasswordMatch);
                    passwordInput.addEventListener('input', checkPasswordMatch);

                    // Form validation
                    form.addEventListener('submit', function (e) {
                        const password = passwordInput.value;
                        const confirmPassword = confirmPasswordInput.value;

                        if (password !== confirmPassword) {
                            e.preventDefault();
                            alert('Passwords do not match!');
                            return false;
                        }

                        if (password.length < 6) {
                            e.preventDefault();
                            alert('Password must be at least 6 characters long!');
                            return false;
                        }
                    });

                    // Interactive form icons
                    const inputs = document.querySelectorAll('.form-control');

                    inputs.forEach(input => {
                        input.addEventListener('focus', function () {
                            this.parentElement.querySelector('.form-icon').style.color = '#D2691E';
                        });

                        input.addEventListener('blur', function () {
                            this.parentElement.querySelector('.form-icon').style.color = '#8B4513';
                        });
                    });
                });
            </script>
        </body>

        </html>