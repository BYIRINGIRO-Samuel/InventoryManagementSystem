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
                <title>Product Details - Stockio</title>
                <link rel="stylesheet" href="css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            </head>

            <body>
                <div class="container wide-view">
                    <jsp:include page="includes/sidebar.jsp" />

                    <main>
                        <div class="d-flex justify-between align-center mb-3">
                            <h1 class="page-title">
                                <span class="material-icons-sharp">inventory_2</span> Product Details
                            </h1>
                            <a href="product?action=list" class="btn btn-secondary">
                                <span class="material-icons-sharp">arrow_back</span> Back to Products
                            </a>
                        </div>

                        <div class="card mb-3">
                            <div class="d-flex justify-between align-center mb-2">
                                <h2 class="h2">${product.name}</h2>
                                <div class="d-flex gap-1">
                                    <a href="product?action=edit&id=${product.id}" class="btn btn-warning">
                                        <span class="material-icons-sharp">edit</span> Edit
                                    </a>
                                    <button onclick="deleteProduct(${product.id}, '${product.name}')"
                                        class="btn btn-danger">
                                        <span class="material-icons-sharp">delete</span> Delete
                                    </button>
                                </div>
                            </div>

                            <div class="grid-view" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
                                <div class="form-group">
                                    <strong>SKU</strong>
                                    <p class="text-muted">${product.sku}</p>
                                </div>
                                <div class="form-group">
                                    <strong>Category</strong>
                                    <p class="text-muted">
                                        ${not empty product.category ? product.category.name : 'Uncategorized'}
                                    </p>
                                </div>
                                <div class="form-group">
                                    <strong>Supplier</strong>
                                    <p class="text-muted">
                                        ${not empty product.supplier ? product.supplier.name : 'No Supplier'}
                                    </p>
                                </div>
                            </div>

                            <div class="grid-view mt-2"
                                style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
                                <div class="form-group">
                                    <strong>Price</strong>
                                    <p class="text-muted">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                    </p>
                                </div>
                                <div class="form-group">
                                    <strong>Cost Price</strong>
                                    <p class="text-muted">
                                        <fmt:formatNumber value="${product.costPrice}" type="currency"
                                            currencySymbol="$" />
                                    </p>
                                </div>
                                <div class="form-group">
                                    <strong>Quantity in Stock</strong>
                                    <p class="text-muted">
                                        <span
                                            class="badge ${product.quantityInStock <= product.reorderLevel ? 'bg-danger' : 'bg-success'}"
                                            style="color: white; padding: 0.2rem 0.5rem; border-radius: var(--border-radius-1);">
                                            ${product.quantityInStock}
                                        </span>
                                    </p>
                                </div>
                                <div class="form-group">
                                    <strong>Reorder Level</strong>
                                    <p class="text-muted">${product.reorderLevel}</p>
                                </div>
                            </div>

                            <div class="form-group mt-2">
                                <strong>Description</strong>
                                <p class="text-muted">${product.description}</p>
                            </div>
                        </div>

                        <!-- Stock Transaction History (if available) -->
                        <c:if test="${not empty transactions}">
                            <div class="card">
                                <div class="d-flex justify-between align-center mb-2">
                                    <h2 class="h2">Stock History</h2>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Type</th>
                                                <th>Quantity</th>
                                                <th>Reason</th>
                                                <th>User</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="transaction" items="${transactions}">
                                                <tr>
                                                    <td>
                                                        <fmt:formatDate value="${transaction.transactionDate}"
                                                            pattern="yyyy-MM-dd HH:mm" />
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${transaction.type == 'IN' ? 'bg-success' : 'bg-danger'}"
                                                            style="color: white; padding: 0.2rem 0.5rem; border-radius: var(--border-radius-1);">
                                                            ${transaction.type}
                                                        </span>
                                                    </td>
                                                    <td>${transaction.quantity}</td>
                                                    <td>${transaction.reason}</td>
                                                    <td>${transaction.user.fullName}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>
                    </main>
                </div>

                <script>
                    function deleteProduct(id, name) {
                        if (confirm('Are you sure you want to delete ' + name + '?')) {
                            window.location.href = 'product?action=delete&id=' + id;
                        }
                    }
                </script>
            </body>

            </html>