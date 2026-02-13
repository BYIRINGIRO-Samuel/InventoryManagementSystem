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
            <title>Suppliers - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <div class="d-flex justify-between align-center mb-3">
                    <h1 class="page-title">
                        <i class="fas fa-truck"></i> Suppliers Management
                    </h1>
                    <a href="supplier-form.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Supplier
                    </a>
                </div>

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

                <!-- Search Section -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-search"></i> Search Suppliers
                        </h2>
                    </div>

                    <form action="supplier" method="get" class="search-container">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="search" class="search-input" placeholder="Search suppliers..."
                            value="${searchTerm}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Search
                        </button>
                        <a href="supplier?action=list" class="btn btn-secondary">
                            <i class="fas fa-refresh"></i> Reset
                        </a>
                    </form>
                </div>

                <!-- Suppliers Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-list"></i> Suppliers List
                        </h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty suppliers}">
                            <div class="text-center p-3">
                                <i class="fas fa-truck"
                                    style="font-size: 4rem; color: var(--gray); margin-bottom: 1rem;"></i>
                                <h3>No Suppliers Found</h3>
                                <p>Start by adding your first supplier.</p>
                                <a href="supplier-form.jsp" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Add First Supplier
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-container">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Supplier Name</th>
                                            <th>Contact Person</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Address</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="supplier" items="${suppliers}">
                                            <tr>
                                                <td><strong>${supplier.name}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty supplier.contactPerson}">
                                                            ${supplier.contactPerson}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty supplier.email}">
                                                            <a href="mailto:${supplier.email}">${supplier.email}</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty supplier.phone}">
                                                            <a href="tel:${supplier.phone}">${supplier.phone}</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty supplier.address}">
                                                            ${supplier.address}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <a href="supplier?action=view&id=${supplier.id}"
                                                            class="btn btn-info btn-sm" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="supplier?action=edit&id=${supplier.id}"
                                                            class="btn btn-warning btn-sm" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="product?action=list&supplierId=${supplier.id}"
                                                            class="btn btn-success btn-sm" title="View Products">
                                                            <i class="fas fa-boxes"></i>
                                                        </a>
                                                        <button
                                                            onclick="deleteSupplier(${supplier.id}, '${supplier.name}')"
                                                            class="btn btn-danger btn-sm" title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <script>
                function deleteSupplier(supplierId, supplierName) {
                    if (confirm(`Are you sure you want to delete "${supplierName}"? This action cannot be undone.`)) {
                        window.location.href = `supplier?action=delete&id=${supplierId}`;
                    }
                }
            </script>
        </body>

        </html>