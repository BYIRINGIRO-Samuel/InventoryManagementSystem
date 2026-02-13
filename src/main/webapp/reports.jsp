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
            <link rel="stylesheet" href="css/main.css">
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body>
            <div class="container wide-view">
                <jsp:include page="includes/sidebar.jsp" />

                <main>
                    <h1 class="page-title">
                        <span class="material-icons-sharp">bar_chart</span> Reports & Analytics
                    </h1>

                    <!-- Report Cards -->
                    <div class="grid-view mb-3">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <span class="material-icons-sharp">inventory_2</span> Inventory Report
                                </h3>
                            </div>
                            <p class="text-muted mt-2 mb-2">Comprehensive overview of your inventory status, stock
                                levels, and product performance.</p>
                            <button onclick="generateInventoryReport()" class="btn btn-primary">
                                <span class="material-icons-sharp">description</span> Generate Report
                            </button>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <span class="material-icons-sharp text-warning">warning</span> Low Stock Report
                                </h3>
                            </div>
                            <p class="text-muted mt-2 mb-2">Products that are running low and need to be restocked soon.
                            </p>
                            <button onclick="generateLowStockReport()" class="btn btn-warning">
                                <span class="material-icons-sharp">description</span> Generate Report
                            </button>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <span class="material-icons-sharp text-success">attach_money</span> Value Report
                                </h3>
                            </div>
                            <p class="text-muted mt-2 mb-2">Total inventory value, profit margins, and financial
                                insights.</p>
                            <button onclick="generateValueReport()" class="btn btn-success">
                                <span class="material-icons-sharp">description</span> Generate Report
                            </button>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <span class="material-icons-sharp text-primary">history</span> Activity Report
                                </h3>
                            </div>
                            <p class="text-muted mt-2 mb-2">Recent stock movements, transactions, and system activity.
                            </p>
                            <button onclick="generateActivityReport()" class="btn btn-info">
                                <span class="material-icons-sharp">description</span> Generate Report
                            </button>
                        </div>
                    </div>

                    <!-- Charts Section -->
                    <div class="grid-view" style="gap: 2rem; margin-top: 2rem;">
                        <!-- Inventory by Category Chart -->
                        <div class="card">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <span class="material-icons-sharp">pie_chart</span> Inventory by Category
                                </h2>
                            </div>
                            <canvas id="categoryChart" width="400" height="300"></canvas>
                        </div>

                        <!-- Stock Levels Chart -->
                        <div class="card">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <span class="material-icons-sharp">bar_chart</span> Stock Levels
                                </h2>
                            </div>
                            <canvas id="stockChart" width="400" height="300"></canvas>
                        </div>
                    </div>

                    <!-- Monthly Trends -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h2 class="card-title">
                                <span class="material-icons-sharp">show_chart</span> Monthly Inventory Trends
                            </h2>
                        </div>
                        <canvas id="trendsChart" width="800" height="400"></canvas>
                    </div>

                    <!-- Export Options -->
                    <div class="card mt-3">
                        <div class="card-header mb-2">
                            <h2 class="card-title">
                                <span class="material-icons-sharp">download</span> Export Options
                            </h2>
                        </div>
                        <div class="d-flex gap-1" style="flex-wrap: wrap;">
                            <button onclick="exportToPDF()" class="btn btn-danger">
                                <span class="material-icons-sharp">picture_as_pdf</span> Export to PDF
                            </button>
                            <button onclick="exportToExcel()" class="btn btn-success">
                                <span class="material-icons-sharp">table_view</span> Export to Excel
                            </button>
                            <button onclick="exportToCSV()" class="btn btn-info">
                                <span class="material-icons-sharp">grid_on</span> Export to CSV
                            </button>
                            <button onclick="printReport()" class="btn btn-secondary">
                                <span class="material-icons-sharp">print</span> Print Report
                            </button>
                        </div>
                    </div>
                </main>
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
                                    '#001f3f', // Navy Blue
                                    '#5cb85c', // Success
                                    '#f0ad4e', // Warning
                                    '#d9534f', // Danger
                                    '#7d8da1'  // Accent
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
                                    '#5cb85c', // Success
                                    '#f0ad4e', // Warning
                                    '#d9534f'  // Danger
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
                                borderColor: '#5cb85c',
                                backgroundColor: 'rgba(92, 184, 92, 0.1)',
                                tension: 0.4
                            }, {
                                label: 'Stock Out',
                                data: [28, 48, 40, 19, 86, 27],
                                borderColor: '#d9534f',
                                backgroundColor: 'rgba(217, 83, 79, 0.1)',
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