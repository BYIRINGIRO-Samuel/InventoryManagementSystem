<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!-- Check if user is logged in -->
            <c:if test="${empty sessionScope.user}">
                <c:redirect url="login.jsp" />
            </c:if>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard - Stockio</title>
                <link rel="stylesheet" href="css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="container">
                    <h1 class="page-title fade-in">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </h1>

                    <!-- Welcome Message -->
                    <div class="card fade-in">
                        <div class="card-header">
                            <h2 class="card-title">Welcome back, ${sessionScope.user.fullName}!</h2>
                        </div>
                        <p>Here's an overview of your inventory management system.</p>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="dashboard-grid fade-in">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-boxes"></i>
                            </div>
                            <div class="stat-number" id="totalProducts">0</div>
                            <div class="stat-label">Total Products</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-number" id="lowStockItems">0</div>
                            <div class="stat-label">Low Stock Items</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-tags"></i>
                            </div>
                            <div class="stat-number" id="totalCategories">0</div>
                            <div class="stat-label">Categories</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-truck"></i>
                            </div>
                            <div class="stat-number" id="totalSuppliers">0</div>
                            <div class="stat-label">Suppliers</div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card fade-in">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-bolt"></i> Quick Actions
                            </h2>
                        </div>
                        <div class="dashboard-grid">
                            <a href="product-form.jsp" class="btn btn-primary btn-lg">
                                <i class="fas fa-plus"></i> Add New Product
                            </a>
                            <a href="product?action=lowstock" class="btn btn-warning btn-lg">
                                <i class="fas fa-exclamation-triangle"></i> View Low Stock
                            </a>
                            <a href="category-form.jsp" class="btn btn-info btn-lg">
                                <i class="fas fa-tag"></i> Add Category
                            </a>
                            <a href="supplier-form.jsp" class="btn btn-success btn-lg">
                                <i class="fas fa-truck"></i> Add Supplier
                            </a>
                        </div>
                    </div>

                    <!-- Recent Activity & Charts -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 2rem;">
                        <!-- Recent Stock Transactions -->
                        <div class="card fade-in">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <i class="fas fa-history"></i> Recent Activity
                                </h2>
                            </div>
                            <div id="recentActivity">
                                <div class="spinner"></div>
                            </div>
                        </div>

                        <!-- Inventory Chart -->
                        <div class="card fade-in">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <i class="fas fa-chart-pie"></i> Inventory Overview
                                </h2>
                            </div>
                            <canvas id="inventoryChart" width="400" height="200"></canvas>
                        </div>
                    </div>

                    <!-- Low Stock Alerts -->
                    <div class="card fade-in" id="lowStockAlerts" style="display: none;">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-exclamation-triangle"></i> Low Stock Alerts
                            </h2>
                        </div>
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>SKU</th>
                                        <th>Current Stock</th>
                                        <th>Reorder Level</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="lowStockTableBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        loadDashboardData();
                        loadRecentActivity();
                        loadInventoryChart();
                        loadLowStockAlerts();
                    });

                    function loadDashboardData() {
                        // Simulate API calls - replace with actual AJAX calls to servlets
                        fetch('api/dashboard-stats')
                            .then(response => response.json())
                            .then(data => {
                                document.getElementById('totalProducts').textContent = data.totalProducts || 0;
                                document.getElementById('lowStockItems').textContent = data.lowStockItems || 0;
                                document.getElementById('totalCategories').textContent = data.totalCategories || 0;
                                document.getElementById('totalSuppliers').textContent = data.totalSuppliers || 0;
                            })
                            .catch(error => {
                                // Fallback with sample data
                                document.getElementById('totalProducts').textContent = '156';
                                document.getElementById('lowStockItems').textContent = '12';
                                document.getElementById('totalCategories').textContent = '8';
                                document.getElementById('totalSuppliers').textContent = '24';
                            });
                    }

                    function loadRecentActivity() {
                        // Simulate recent activity data
                        setTimeout(() => {
                            const activities = [
                                { type: 'IN', product: 'Laptop Dell XPS', quantity: 5, time: '2 hours ago' },
                                { type: 'OUT', product: 'Mouse Wireless', quantity: 3, time: '4 hours ago' },
                                { type: 'IN', product: 'Keyboard Mechanical', quantity: 10, time: '6 hours ago' },
                                { type: 'ADJUSTMENT', product: 'Monitor 24"', quantity: 2, time: '1 day ago' }
                            ];

                            let html = '';
                            activities.forEach(activity => {
                                const icon = activity.type === 'IN' ? 'fa-arrow-up text-success' :
                                    activity.type === 'OUT' ? 'fa-arrow-down text-danger' :
                                        'fa-edit text-warning';

                                html += `
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.5rem 0; border-bottom: 1px solid var(--light-brown);">
                            <div>
                                <i class="fas \${icon}"></i>
                                <strong>\${activity.product}</strong>
                                <span class="badge badge-\${activity.type === 'IN' ? 'success' : activity.type === 'OUT' ? 'danger' : 'warning'}">
                                    \${activity.type} \${activity.quantity}
                                </span>
                            </div>
                            <small class="text-muted">\${activity.time}</small>
                        </div>
                    `;
                            });

                            document.getElementById('recentActivity').innerHTML = html;
                        }, 1000);
                    }

                    function loadInventoryChart() {
                        const ctx = document.getElementById('inventoryChart').getContext('2d');

                        new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Electronics', 'Office Supplies', 'Furniture', 'Accessories', 'Others'],
                                datasets: [{
                                    data: [35, 25, 20, 15, 5],
                                    backgroundColor: [
                                        '#8B4513',
                                        '#D2691E',
                                        '#CD853F',
                                        '#F5DEB3',
                                        '#DEB887'
                                    ],
                                    borderWidth: 2,
                                    borderColor: '#fff'
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'bottom'
                                    }
                                }
                            }
                        });
                    }

                    function loadLowStockAlerts() {
                        // Simulate low stock data
                        setTimeout(() => {
                            const lowStockItems = [
                                { name: 'Wireless Mouse', sku: 'WM001', stock: 3, reorderLevel: 10 },
                                { name: 'USB Cable', sku: 'UC002', stock: 5, reorderLevel: 15 },
                                { name: 'Notebook A4', sku: 'NB003', stock: 2, reorderLevel: 20 }
                            ];

                            if (lowStockItems.length > 0) {
                                document.getElementById('lowStockAlerts').style.display = 'block';

                                let html = '';
                                lowStockItems.forEach(item => {
                                    html += `
                            <tr>
                                <td><strong>\${item.name}</strong></td>
                                <td>\${item.sku}</td>
                                <td><span class="badge badge-danger">\${item.stock}</span></td>
                                <td>\${item.reorderLevel}</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" onclick="restockItem('\${item.sku}')">
                                        <i class="fas fa-plus"></i> Restock
                                    </button>
                                </td>
                            </tr>
                        `;
                                });

                                document.getElementById('lowStockTableBody').innerHTML = html;
                            }
                        }, 1500);
                    }

                    function restockItem(sku) {
                        // Redirect to restock page or open modal
                        window.location.href = `product?action=restock&sku=\${sku}`;
                    }

                    // Add some animation to stat cards
                    function animateNumbers() {
                        const statNumbers = document.querySelectorAll('.stat-number');

                        statNumbers.forEach(element => {
                            const target = parseInt(element.textContent);
                            let current = 0;
                            const increment = target / 50;

                            const timer = setInterval(() => {
                                current += increment;
                                if (current >= target) {
                                    element.textContent = target;
                                    clearInterval(timer);
                                } else {
                                    element.textContent = Math.floor(current);
                                }
                            }, 30);
                        });
                    }

                    // Animate numbers when page loads
                    setTimeout(animateNumbers, 500);
                </script>
            </body>

            </html>