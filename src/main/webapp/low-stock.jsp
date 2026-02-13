<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <!-- Check if user is logged in -->
                <c:if test="${empty sessionScope.user}">
                    <c:redirect url="login.jsp" />
                </c:if>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Low Stock Alert - Stockio</title>
                    <link rel="stylesheet" href="css/main.css">
                    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
                </head>

                <body>
                    <div class="container wide-view">
                        <jsp:include page="includes/sidebar.jsp" />

                        <main>
                            <div class="d-flex justify-between align-center mb-3">
                                <h1 class="page-title">
                                    <span class="material-icons-sharp text-warning">warning</span> Low Stock Alert
                                </h1>
                                <a href="product?action=list" class="btn btn-secondary">
                                    <span class="material-icons-sharp">arrow_back</span> Back to Products
                                </a>
                            </div>

                            <!-- Alert Summary -->
                            <div class="alert alert-warning">
                                <div class="d-flex align-center gap-1">
                                    <span class="material-icons-sharp">warning</span>
                                    <div>
                                        <strong>Attention Required!</strong> The following products are running low on
                                        stock and need immediate attention.
                                    </div>
                                </div>
                            </div>

                            <!-- Low Stock Products -->
                            <c:choose>
                                <c:when test="${empty products}">
                                    <div class="card text-center p-3">
                                        <span class="material-icons-sharp text-success icon-large">check_circle</span>
                                        <h3>All Good!</h3>
                                        <p>No products are currently running low on stock.</p>
                                        <a href="product?action=list" class="btn btn-primary mt-2">
                                            <span class="material-icons-sharp">inventory_2</span> View All Products
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card">
                                        <div class="d-flex justify-between align-center mb-2">
                                            <h2 class="h2">
                                                <span class="material-icons-sharp align-middle">list</span> Products
                                                Requiring
                                                Attention
                                            </h2>
                                            <div class="d-flex gap-1">
                                                <button onclick="restockAll()" class="btn btn-success">
                                                    <span class="material-icons-sharp">add</span> Restock All
                                                </button>
                                                <button onclick="exportLowStock()" class="btn btn-info">
                                                    <span class="material-icons-sharp">download</span> Export List
                                                </button>
                                            </div>
                                        </div>

                                        <div class="table-responsive">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th>Product</th>
                                                        <th>SKU</th>
                                                        <th>Category</th>
                                                        <th>Current Stock</th>
                                                        <th>Reorder Level</th>
                                                        <th>Supplier</th>
                                                        <th>Priority</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="product" items="${products}">
                                                        <tr>
                                                            <td>
                                                                <strong>${product.name}</strong>
                                                                <c:if test="${not empty product.description}">
                                                                    <br><small
                                                                        class="text-muted">${product.description}</small>
                                                                </c:if>
                                                            </td>
                                                            <td><strong>${product.sku}</strong></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty product.category}">
                                                                        <span
                                                                            class="badge badge-info">${product.category.name}</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">No Category</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge badge-danger">${product.quantityInStock}</span>
                                                            </td>
                                                            <td>${product.reorderLevel}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty product.supplier}">
                                                                        ${product.supplier.name}
                                                                        <c:if
                                                                            test="${not empty product.supplier.phone}">
                                                                            <br><small><a
                                                                                    href="tel:${product.supplier.phone}">${product.supplier.phone}</a></small>
                                                                        </c:if>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">No Supplier</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${product.quantityInStock == 0}">
                                                                        <span class="badge badge-danger">CRITICAL</span>
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${product.quantityInStock <= (product.reorderLevel / 2)}">
                                                                        <span class="badge badge-warning">HIGH</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-info">MEDIUM</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex gap-1 justify-content-center">
                                                                    <button
                                                                        class="btn btn-success btn-sm quick-restock-btn"
                                                                        data-product-id="${product.id}"
                                                                        data-product-name="${product.name}"
                                                                        title="Quick Restock">
                                                                        <span class="material-icons-sharp">add</span>
                                                                    </button>
                                                                    <a href="product?action=view&id=${product.id}"
                                                                        class="btn btn-info btn-sm"
                                                                        title="View Details">
                                                                        <span
                                                                            class="material-icons-sharp">visibility</span>
                                                                    </a>
                                                                    <c:if test="${not empty product.supplier}">
                                                                        <button
                                                                            class="btn btn-warning btn-sm contact-supplier-btn"
                                                                            data-name="${product.supplier.name}"
                                                                            data-email="${product.supplier.email}"
                                                                            data-phone="${product.supplier.phone}"
                                                                            title="Contact Supplier">
                                                                            <span
                                                                                class="material-icons-sharp">phone</span>
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Quick Actions -->
                                    <div class="card mt-2">
                                        <div class="card-header mb-2">
                                            <h2 class="h2">
                                                <span class="material-icons-sharp align-middle">bolt</span> Quick
                                                Actions
                                            </h2>
                                        </div>
                                        <div class="grid-view">
                                            <button onclick="generatePurchaseOrder()" class="btn btn-primary">
                                                <span class="material-icons-sharp">description</span> Generate Purchase
                                                Order
                                            </button>
                                            <button onclick="notifySuppliers()" class="btn btn-warning">
                                                <span class="material-icons-sharp">email</span> Notify All Suppliers
                                            </button>
                                            <button onclick="scheduleRestock()" class="btn btn-info">
                                                <span class="material-icons-sharp">event</span> Schedule Restock
                                            </button>
                                            <button onclick="setAutoReorder()" class="btn btn-success">
                                                <span class="material-icons-sharp">sync</span> Enable Auto-Reorder
                                            </button>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </main>
                    </div>

                    <!-- Quick Restock Modal -->
                    <div id="restockModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header d-flex justify-between align-center mb-3">
                                <h3>Quick Restock</h3>
                                <span class="close" onclick="closeRestockModal()">&times;</span>
                            </div>
                            <form id="restockForm" action="product" method="post">
                                <input type="hidden" name="action" value="updateStock">
                                <input type="hidden" name="type" value="IN">
                                <input type="hidden" name="productId" id="restockProductId">

                                <div class="form-group">
                                    <label class="form-label">Product:</label>
                                    <input type="text" id="restockProductName" class="form-control" readonly>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Quantity to Add:</label>
                                    <input type="number" name="quantity" class="form-control" min="1" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Reason:</label>
                                    <input type="text" name="reason" class="form-control"
                                        value="Restock - Low Stock Alert" required>
                                </div>

                                <div class="d-flex gap-2 justify-end mt-3">
                                    <button type="button" class="btn btn-secondary"
                                        onclick="closeRestockModal()">Cancel</button>
                                    <button type="submit" class="btn btn-success">Add Stock</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            // Add event listeners for contact supplier buttons
                            document.querySelectorAll('.contact-supplier-btn').forEach(button => {
                                button.addEventListener('click', function () {
                                    const name = this.dataset.name;
                                    const email = this.dataset.email;
                                    const phone = this.dataset.phone;
                                    contactSupplier(name, email, phone);
                                });
                            });

                            // Add event listeners for quick restock buttons
                            document.querySelectorAll('.quick-restock-btn').forEach(button => {
                                button.addEventListener('click', function () {
                                    const productId = this.dataset.productId;
                                    const productName = this.dataset.productName;
                                    quickRestock(productId, productName);
                                });
                            });
                        });

                        function quickRestock(productId, productName) {
                            document.getElementById('restockProductId').value = productId;
                            document.getElementById('restockProductName').value = productName;
                            document.getElementById('restockModal').style.display = 'block';
                        }

                        function closeRestockModal() {
                            document.getElementById('restockModal').style.display = 'none';
                        }

                        function contactSupplier(name, email, phone) {
                            let message = `Contact ${name}:\n\n`;
                            if (email) message += `Email: ${email}\n`;
                            if (phone) message += `Phone: ${phone}\n`;

                            if (email) {
                                const subject = encodeURIComponent('Restock Request - Stockio');
                                const body = encodeURIComponent('Hello,\n\nWe need to restock some products. Please contact us to discuss.\n\nBest regards,\nStockio Team');
                                window.open(`mailto:${email}?subject=${subject}&body=${body}`);
                            } else if (phone) {
                                window.open(`tel:${phone}`);
                            } else {
                                alert(message);
                            }
                        }

                        function restockAll() {
                            if (confirm('This will create restock requests for all low stock items. Continue?')) {
                                alert('Restock requests created for all items!');
                            }
                        }

                        function exportLowStock() {
                            let csv = 'Product Name,SKU,Current Stock,Reorder Level,Priority\n';

                            document.querySelectorAll('tbody tr').forEach(row => {
                                const cells = row.cells;
                                const productName = cells[0].textContent.trim().split('\n')[0];
                                const sku = cells[1].textContent.trim();
                                const currentStock = cells[3].textContent.trim();
                                const reorderLevel = cells[4].textContent.trim();
                                const priority = cells[6].textContent.trim();

                                csv += `"${productName}","${sku}","${currentStock}","${reorderLevel}","${priority}"\n`;
                            });

                            const blob = new Blob([csv], { type: 'text/csv' });
                            const url = window.URL.createObjectURL(blob);
                            const a = document.createElement('a');
                            a.href = url;
                            a.download = 'low-stock-report.csv';
                            a.click();
                            window.URL.revokeObjectURL(url);
                        }

                        function generatePurchaseOrder() {
                            alert('Purchase order generation feature would be implemented here.');
                        }

                        function notifySuppliers() {
                            alert('Suppliers notification feature would be implemented here.');
                        }

                        function scheduleRestock() {
                            alert('Schedule restock feature would be implemented here.');
                        }

                        function setAutoReorder() {
                            alert('Auto-reorder feature would be implemented here.');
                        }

                        // Close modal when clicking outside
                        window.onclick = function (event) {
                            if (event.target == document.getElementById('restockModal')) {
                                closeRestockModal();
                            }
                        }
                    </script>
                </body>

                </html>