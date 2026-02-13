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
            <title>Categories - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <div class="d-flex justify-between align-center mb-3">
                    <h1 class="page-title">
                        <i class="fas fa-tags"></i> Categories Management
                    </h1>
                    <a href="category-form.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Category
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

                <!-- Categories Grid -->
                <c:choose>
                    <c:when test="${empty categories}">
                        <div class="card text-center">
                            <i class="fas fa-tags"
                                style="font-size: 4rem; color: var(--gray); margin-bottom: 1rem;"></i>
                            <h3>No Categories Found</h3>
                            <p>Start by creating your first product category.</p>
                            <a href="category-form.jsp" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Add First Category
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="dashboard-grid">
                            <c:forEach var="category" items="${categories}">
                                <div class="card">
                                    <div class="card-header d-flex justify-between align-center">
                                        <h3 class="card-title">${category.name}</h3>
                                        <div>
                                            <a href="category?action=edit&id=${category.id}"
                                                class="btn btn-warning btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button onclick="deleteCategory(${category.id}, '${category.name}')"
                                                class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <p>${category.description}</p>
                                    <div class="d-flex justify-between align-center mt-2">
                                        <small class="text-muted">
                                            <i class="fas fa-calendar"></i>
                                            Created: ${category.createdAt.toLocalDate()}
                                        </small>
                                        <a href="product?action=list&categoryId=${category.id}"
                                            class="btn btn-info btn-sm">
                                            <i class="fas fa-boxes"></i> View Products
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <script>
                function deleteCategory(categoryId, categoryName) {
                    if (confirm(`Are you sure you want to delete "${categoryName}"? This action cannot be undone.`)) {
                        window.location.href = `category?action=delete&id=${categoryId}`;
                    }
                }
            </script>
        </body>

        </html>