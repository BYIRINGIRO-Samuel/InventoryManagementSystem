<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="false" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>404 - Page Not Found</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                text-align: center;
                padding: 20px;
            }

            .error-container {
                max-width: 500px;
            }

            .error-code {
                font-size: 8rem;
                font-weight: bold;
                color: #001f3f;
                line-height: 1;
                margin-bottom: 1rem;
            }

            .error-message {
                font-size: 1.5rem;
                margin-bottom: 2rem;
                color: #6c757d;
            }
        </style>
    </head>

    <body>
        <div class="error-container fade-in">
            <div class="error-code">404</div>
            <h1 class="error-message">Oops! The page you're looking for doesn't exist.</h1>
            <p style="margin-bottom: 2rem;">It might have been moved or deleted.</p>
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-primary btn-lg">
                <i class="fas fa-home"></i> Back to Dashboard
            </a>
        </div>
    </body>

    </html>