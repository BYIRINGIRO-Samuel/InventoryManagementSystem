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
            <link rel="stylesheet" href="css/main.css">
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
        </head>

        <body>
            <div class="container wide-view">
                <jsp:include page="includes/sidebar.jsp" />

                <main>
                    <div class="d-flex justify-between align-center mb-3">
                        <h1 class="page-title">
                            <span class="material-icons-sharp">local_shipping</span> Suppliers Management
                        </h1>
                        <a href="supplier-form.jsp" class="btn btn-primary">
                            <span class="material-icons-sharp">add</span> Add New Supplier
                        </a>
                    </div>

                    <!-- Display messages -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <span class="material-icons-sharp">error</span> ${param.error}
                        </div>
                    </c:if>

                    <c:if test="${param.message != null}">
                        <div class="alert alert-success">
                            <span class="material-icons-sharp">check_circle</span> ${param.message}
                        </div>
                    </c:if>

                    <!-- Search Section -->
                    <div class="card mb-3">
                        <div class="d-flex justify-between align-center mb-2">
                            <h2 class="h2">Search Suppliers</h2>
                        </div>

                        <form action="supplier" method="get" class="d-flex gap-1">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="search" class="form-control" placeholder="Search suppliers..."
                                value="${searchTerm}" style="flex: 1;">
                            <button type="submit" class="btn btn-primary">
                                <span class="material-icons-sharp">search</span> Search
                            </button>
                            <a href="supplier?action=list" class="btn btn-secondary">
                                <span class="material-icons-sharp">refresh</span> Reset
                            </a>
                        </form>
                    </div>

                    <!-- Suppliers Table -->
                    <div class="card">
                        <div class="d-flex justify-between align-center mb-2">
                            <h2 class="h2">Suppliers List</h2>
                        </div>

                        <c:choose>
                            <c:when test="${empty suppliers}">
                                <div class="text-center p-3">
                                    <span class="material-icons-sharp icon-large text-info">local_shipping</span>
                                    <h3>No Suppliers Found</h3>
                                    <p>Start by adding your first supplier.</p>
                                    <a href="supplier-form.jsp" class="btn btn-primary mt-2">
                                        <span class="material-icons-sharp">add</span> Add First Supplier
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
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
                                                                <a href="mailto:${supplier.email}"
                                                                    class="text-primary">${supplier.email}</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty supplier.phone}">
                                                                <a href="tel:${supplier.phone}"
                                                                    class="text-primary">${supplier.phone}</a>
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
                                                                <span class="material-icons-sharp">visibility</span>
                                                            </a>
                                                            <a href="supplier?action=edit&id=${supplier.id}"
                                                                class="btn btn-warning btn-sm" title="Edit">
                                                                <span class="material-icons-sharp">edit</span>
                                                            </a>
                                                            <a href="product?action=list&supplierId=${supplier.id}"
                                                                class="btn btn-success btn-sm" title="View Products">
                                                                <span class="material-icons-sharp">inventory_2</span>
                                                            </a>
                                                            <button
                                                                onclick="deleteSupplier(${supplier.id}, '${supplier.name}')"
                                                                class="btn btn-danger btn-sm" title="Delete">
                                                                <span class="material-icons-sharp">delete</span>
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
                </main>
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