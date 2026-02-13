<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>500 - Server Error</title>
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
                max-width: 600px;
            }

            .error-code {
                font-size: 8rem;
                font-weight: bold;
                color: #d9534f;
                line-height: 1;
                margin-bottom: 1rem;
            }

            .error-message {
                font-size: 1.5rem;
                margin-bottom: 2rem;
                color: #6c757d;
            }

            .stack-trace {
                text-align: left;
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 8px;
                font-family: monospace;
                font-size: 0.8rem;
                overflow: auto;
                max-height: 200px;
                margin-top: 2rem;
                border: 1px solid #dee2e6;
            }
        </style>
    </head>

    <body>
        <div class="error-container fade-in">
            <div class="error-code">500</div>
            <h1 class="error-message">Something went wrong on our end.</h1>
            <p>We're working to fix it. Please try again later.</p>

            <div style="margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-primary">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <button onclick="location.reload()" class="btn btn-outline">
                    <i class="fas fa-sync"></i> Retry
                </button>
            </div>

            <% if (request.getAttribute("javax.servlet.error.exception") !=null) { %>
                <div class="stack-trace">
                    <strong>Error Details:</strong><br>
                    <%= ((Exception)request.getAttribute("javax.servlet.error.exception")).getMessage() %>
                </div>
                <% } %>
        </div>
    </body>

    </html>