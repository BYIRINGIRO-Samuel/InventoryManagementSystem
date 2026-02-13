<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header class="header">
            <div class="header-content">
                <a href="dashboard.jsp" class="logo">
                    <img src="assets/images/logo.png" alt="Stockio"
                        style="height: 40px; margin-right: 10px; vertical-align: middle;"
                        onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';">
                    <span style="display: none;">
                        <span
                            style="background: linear-gradient(45deg, #8B4513, #D2691E); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: bold; font-size: 1.8rem;">
                            📦 Stockio
                        </span>
                    </span>
                </a>

                <nav>
                    <ul class="nav-menu">
                        <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="product?action=list"><i class="fas fa-box"></i> Products</a></li>
                        <li><a href="category?action=list"><i class="fas fa-tags"></i> Categories</a></li>
                        <li><a href="supplier?action=list"><i class="fas fa-truck"></i> Suppliers</a></li>
                        <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                        <c:if test="${sessionScope.userRole == 'ADMIN'}">
                            <li><a href="users.jsp"><i class="fas fa-users"></i> Users</a></li>
                        </c:if>
                    </ul>
                </nav>

                <div class="user-info">
                    <div class="user-avatar">
                        ${sessionScope.user.fullName.substring(0,1).toUpperCase()}
                    </div>
                    <div>
                        <div style="font-weight: bold;">${sessionScope.user.fullName}</div>
                        <div style="font-size: 0.8rem; opacity: 0.8;">${sessionScope.userRole}</div>
                    </div>
                    <a href="auth?action=logout" class="btn btn-outline btn-sm">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </header>

        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <script>
            // Add active class to current page
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-menu a');

                navLinks.forEach(link => {
                    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                        link.style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
                    }
                });
            });
        </script>