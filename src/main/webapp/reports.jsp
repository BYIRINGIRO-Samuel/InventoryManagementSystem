<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!-- Check if user is logged in -->
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="login.jsp" />
        </c:if>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reports - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body>
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <h1 class="page-title">
                    <i class="fas fa-chart-bar"></i> Reports & Analytics
                </h1>

                <!-- Report Cards -->
                <div class="dashboard-grid">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-boxes"></i> Inventory Report
                            </h3>
                        </div>
                        <p>Comprehensive overview of your inventory status, stock levels, and product performance.</p>
                        <button onclick="generateInventoryReport()" class="btn btn-primary">
                            <i class="fas fa-file-alt"></i> Generate Report
                        </button>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-exclamation-triangle"></i> Low Stock Report
                            </h3>
                        </div>
                        <p>Products that are running low and need to be restocked soon.</p>
                        <button onclick="generateLowStockReport()" class="btn btn-warning">
                            <i class="fas fa-file-alt"></i> Generate Report
                        </button>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-dollar-sign"></i> Value Report
                            </h3>
                        </div>
                        <p>Total inventory value, profit margins, and financial insights.</p>
                        <button onclick="generateValueReport()" class="btn btn-success">
                            <i class="fas fa-file-alt"></i> Generate Report
                        </button>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-history"></i> Activity Report
                            </h3>
                        </div>
                        <p>Recent stock movements, transactions, and system activity.</p>
                        <button onclick="generateActivityReport()" class="btn btn-info">
                            <i class="fas fa-file-alt"></i> Generate Report
                        </button>
                    </div>
                </div>

                <!-- Charts Section -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 2rem;">
                    <!-- Inventory by Category Chart -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-chart-pie"></i> Inventory by Category
                            </h2>
                        </div>
                        <canvas id="categoryChart" width="400" height="300"></canvas>
                    </div>

                    <!-- Stock Levels Chart -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-chart-bar"></i> Stock Levels
                            </h2>
                        </div>
                        <canvas id="stockChart" width="400" height="300"></canvas>
                    </div>
                </div>

                <!-- Monthly Trends -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-chart-line"></i> Monthly Inventory Trends
                        </h2>
                    </div>
                    <canvas id="trendsChart" width="800" height="400"></canvas>
                </div>

                <!-- Export Options -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-download"></i> Export Options
                        </h2>
                    </div>
                    <div class="dashboard-grid">
                        <button onclick="exportToPDF()" class="btn btn-danger">
                            <i class="fas fa-file-pdf"></i> Export to PDF
                        </button>
                        <button onclick="exportToExcel()" class="btn btn-success">
                            <i class="fas fa-file-excel"></i> Export to Excel
                        </button>
                        <button onclick="exportToCSV()" class="btn btn-info">
                            <i class="fas fa-file-csv"></i> Export to CSV
                        </button>
                        <button onclick="printReport()" class="btn btn-secondary">
                            <i class="fas fa-print"></i> Print Report
                        </button>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    initializeCharts();
                });

                function initializeCharts() {
                    // Category Chart
                    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
                    new Chart(categoryCtx, {
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
                                ]
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'bottom'
                                }
                            }
                        }
                    });

                    // Stock Levels Chart
                    const stockCtx = document.getElementById('stockChart').getContext('2d');
                    new Chart(stockCtx, {
                        type: 'bar',
                        data: {
                            labels: ['In Stock', 'Low Stock', 'Out of Stock'],
                            datasets: [{
                                label: 'Products',
                                data: [120, 15, 3],
                                backgroundColor: [
                                    '#28A745',
                                    '#FFC107',
                                    '#DC3545'
                                ]
                            }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });

                    // Trends Chart
                    const trendsCtx = document.getElementById('trendsChart').getContext('2d');
                    new Chart(trendsCtx, {
                        type: 'line',
                        data: {
                            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                            datasets: [{
                                label: 'Stock In',
                                data: [65, 59, 80, 81, 56, 55],
                                borderColor: '#28A745',
                                backgroundColor: 'rgba(40, 167, 69, 0.1)',
                                tension: 0.4
                            }, {
                                label: 'Stock Out',
                                data: [28, 48, 40, 19, 86, 27],
                                borderColor: '#DC3545',
                                backgroundColor: 'rgba(220, 53, 69, 0.1)',
                                tension: 0.4
                            }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });
                }

                function generateInventoryReport() {
                    // Simulate report generation
                    showReportModal('Inventory Report', 'Generating comprehensive inventory report...');
                    setTimeout(() => {
                        updateReportModal('Report generated successfully!', 'Your inventory report is ready for download.');
                    }, 2000);
                }

                function generateLowStockReport() {
                    showReportModal('Low Stock Report', 'Analyzing stock levels...');
                    setTimeout(() => {
                        updateReportModal('Low Stock Report Ready!', 'Found 12 products that need restocking.');
                    }, 1500);
                }

                function generateValueReport() {
                    showReportModal('Value Report', 'Calculating inventory values...');
                    setTimeout(() => {
                        updateReportModal('Value Report Complete!', 'Total inventory value: $125,450.00');
                    }, 2500);
                }

                function generateActivityReport() {
                    showReportModal('Activity Report', 'Compiling recent activities...');
                    setTimeout(() => {
                        updateReportModal('Activity Report Ready!', 'Last 30 days: 156 transactions processed.');
                    }, 1800);
                }

                function showReportModal(title, message) {
                    alert(`${title}\n\n${message}`);
                }

                function updateReportModal(title, message) {
                    alert(`${title}\n\n${message}`);
                }

                function exportToPDF() {
                    alert('PDF export functionality would be implemented here.');
                }

                function exportToExcel() {
                    alert('Excel export functionality would be implemented here.');
                }

                function exportToCSV() {
                    // Simple CSV export simulation
                    let csv = 'Report Type,Generated Date,Status\n';
                    csv += 'Inventory Report,' + new Date().toLocaleDateString() + ',Ready\n';
                    csv += 'Low Stock Report,' + new Date().toLocaleDateString() + ',Ready\n';

                    const blob = new Blob([csv], { type: 'text/csv' });
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = 'reports.csv';
                    a.click();
                    window.URL.revokeObjectURL(url);
                }

                function printReport() {
                    window.print();
                }
            </script>
        </body>

        </html>