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
    <title>Supplier Details - Stockio</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <div class="d-flex justify-between align-center mb-3">
            <h1 class="page-title">
                <i class="fas fa-truck"></i> Supplier Details
            </h1>
            <a href="supplier?action=list" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Suppliers
            </a>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-info-circle"></i> ${supplier.name}
                </h2>
            </div>

            <!-- Basic Information -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Supplier Name</label>
                    <div class="form-control" style="background: var(--light-bg);">
                        ${supplier.name}
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Contact Person</label>
                    <div class="form-control" style="background: var(--light-bg);">
                        ${not empty supplier.contactPerson ? supplier.contactPerson : 'N/A'}
                    </div>
                </div>
            </div>

            <!-- Contact Information -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="form-control" style="background: var(--light-bg);">
                        <c:choose>
                            <c:when test="${not empty supplier.email}">
                                <a href="mailto:${supplier.email}">${supplier.email}</a>
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <div class="form-control" style="background: var(--light-bg);">
                        <c:choose>
                            <c:when test="${not empty supplier.phone}">
                                <a href="tel:${supplier.phone}">${supplier.phone}</a>
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Address -->
            <div class="form-group">
                <label class="form-label">Address</label>
                <div class="form-control" style="background: var(--light-bg); min-height: 80px;">
                    ${not empty supplier.address ? supplier.address : 'N/A'}
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-2 mt-3">
                <a href="supplier?action=edit&id=${supplier.id}" class="btn btn-warning btn-lg">
                    <i class="fas fa-edit"></i> Edit Supplier
                </a>
                <a href="product?action=list&supplierId=${supplier.id}" class="btn btn-info btn-lg">
                    <i class="fas fa-boxes"></i> View Products
                </a>
                <button onclick="deleteSupplier(${supplier.id}, '${supplier.name}')" class="btn btn-danger btn-lg">
                    <i class="fas fa-trash"></i> Delete Supplier
                </button>
            </div>
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
