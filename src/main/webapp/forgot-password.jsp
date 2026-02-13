<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Stockio</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #f0f2f5 0%, #dce1eb 100%);
            padding: 2rem 0;
        }

        .forgot-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 31, 63, 0.2);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
            padding: 3rem;
        }

        .forgot-title {
            color: #001f3f;
            font-size: 2rem;
            margin-bottom: 1rem;
            text-align: center;
        }
        
        .forgot-subtitle {
            color: #6C757D;
            text-align: center;
            margin-bottom: 2rem;
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

        .forgot-footer {
            text-align: center;
            margin-top: 2rem;
            color: #6C757D;
        }

        .forgot-footer a {
            color: #001f3f;
            text-decoration: none;
            font-weight: 500;
        }

        .forgot-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="forgot-container fade-in">
        <h2 class="forgot-title">Forgot Password?</h2>
        <p class="forgot-subtitle">Enter your email address and we'll send you instructions to reset your password.</p>

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
            <input type="hidden" name="action" value="forgot-password">

            <div class="form-group">
                <i class="fas fa-envelope form-icon"></i>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <button type="submit" class="btn btn-primary btn-lg w-100">
                <i class="fas fa-paper-plane"></i> Send Reset Link
            </button>
        </form>

        <div class="forgot-footer">
            <p>Remember your password? <a href="login.jsp">Sign In</a></p>
        </div>
    </div>

    <script>
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
