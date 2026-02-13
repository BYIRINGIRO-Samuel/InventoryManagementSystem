<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                    background: linear-gradient(135deg, #f0f2f5 0%, #dce1eb 100%);
                }

                .login-container {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 20px 40px rgba(0, 31, 63, 0.2);
                    overflow: hidden;
                    width: 100%;
                    max-width: 900px;
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    min-height: 500px;
                }

                .login-left {
                    background: linear-gradient(135deg, #001f3f 0%, #003366 100%);
                    color: white;
                    padding: 3rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                }

                .login-right {
                    padding: 3rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }

                .brand-logo {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                }

                .brand-title {
                    font-size: 2.5rem;
                    font-weight: bold;
                    margin-bottom: 1rem;
                }

                .brand-subtitle {
                    font-size: 1.1rem;
                    opacity: 0.9;
                    line-height: 1.6;
                }

                .login-title {
                    color: #001f3f;
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
                    color: #001f3f;
                    z-index: 1;
                }

                .login-footer {
                    text-align: center;
                    margin-top: 2rem;
                    color: #6C757D;
                }

                .login-footer a {
                    color: #001f3f;
                    text-decoration: none;
                    font-weight: 500;
                }

                .login-footer a:hover {
                    text-decoration: underline;
                }

                @media (max-width: 768px) {
                    .login-container {
                        grid-template-columns: 1fr;
                        margin: 1rem;
                    }

                    .login-left {
                        padding: 2rem;
                    }

                    .login-right {
                        padding: 2rem;
                    }
                }
            </style>
        </head>

        <body>
            <div class="login-container fade-in">
                <div class="login-left">
                    <div class="brand-logo">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <h1 class="brand-title">Stockio</h1>
                    <p class="brand-subtitle">
                        Professional Inventory Management System<br>
                        Streamline your business operations with our comprehensive solution
                    </p>
                </div>

                <div class="login-right">
                    <h2 class="login-title">Welcome Back</h2>

                    <!-- Display messages -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${param.error}
                        </div>
                    </c:if>

                    <c:if test="${param.message != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${param.message}
                        </div>
                    </c:if>

                    <form action="auth" method="post">
                        <input type="hidden" name="action" value="login">

                        <div class="form-group">
                            <i class="fas fa-user form-icon"></i>
                            <input type="text" name="username" class="form-control" placeholder="Username or Email"
                                required>
                        </div>

                        <div class="form-group">
                            <i class="fas fa-lock form-icon"></i>
                            <input type="password" name="password" class="form-control" placeholder="Password" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100">
                            <i class="fas fa-sign-in-alt"></i> Sign In
                        </button>
                    </form>

                    <div class="login-footer">
                        <p>Don't have an account? <a href="register.jsp">Create Account</a></p>
                        <p><a href="forgot-password.jsp">Forgot Password?</a></p>
                    </div>
                </div>
            </div>

            <script>
                // Add some interactive effects
                document.addEventListener('DOMContentLoaded', function () {
                    const inputs = document.querySelectorAll('.form-control');

                    inputs.forEach(input => {
                        input.addEventListener('focus', function () {
                            this.parentElement.querySelector('.form-icon').style.color = '#003366';
                        });

                        input.addEventListener('blur', function () {
                            this.parentElement.querySelector('.form-icon').style.color = '#001f3f';
                        });
                    });
                });
            </script>
        </body>

        </html>