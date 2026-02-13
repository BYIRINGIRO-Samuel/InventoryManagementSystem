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
            <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" />
            <link rel="stylesheet" href="css/main.css">
        </head>

        <body>
            <div class="container wide-view">
                <jsp:include page="includes/sidebar.jsp" />

                <main>
                    <h1>Categories Management</h1>

                    <div class="d-flex justify-between align-center mt-3 mb-3">
                        <div class="date">
                            <input type="date">
                        </div>
                        <a href="category-form.jsp" class="btn btn-primary">
                            <span class="material-icons-sharp">add</span> Add New Category
                        </a>
                    </div>

                    <!-- Display messages -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger"
                            style="background: var(--color-danger); color: white; padding: 1rem; border-radius: var(--border-radius-1); margin-bottom: 1rem;">
                            <span class="material-icons-sharp"
                                style="font-size: 1.2rem; vertical-align: middle; margin-right: 0.5rem;">error</span>
                            ${param.error}
                        </div>
                    </c:if>

                    <c:if test="${param.message != null}">
                        <div class="alert alert-success"
                            style="background: var(--color-success); color: white; padding: 1rem; border-radius: var(--border-radius-1); margin-bottom: 1rem;">
                            <span class="material-icons-sharp"
                                style="font-size: 1.2rem; vertical-align: middle; margin-right: 0.5rem;">check_circle</span>
                            ${param.message}
                        </div>
                    </c:if>

                    <!-- Categories Grid -->
                    <c:choose>
                        <c:when test="${empty categories}">
                            <div class="card text-center"
                                style="display: flex; flex-direction: column; align-items: center; padding: 3rem;">
                                <span class="material-icons-sharp"
                                    style="font-size: 4rem; color: var(--color-info-dark); margin-bottom: 1rem;">category</span>
                                <h3>No Categories Found</h3>
                                <p>Start by creating your first product category.</p>
                                <a href="category-form.jsp" class="btn btn-primary mt-2">
                                    <span class="material-icons-sharp">add</span> Add First Category
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid-view">
                                <c:forEach var="category" items="${categories}">
                                    <div class="card">
                                        <div class="d-flex justify-between align-center mb-3">
                                            <h3 style="font-size: 1.2rem; color: var(--color-primary);">${category.name}
                                            </h3>
                                            <div class="d-flex gap-1">
                                                <a href="category?action=edit&id=${category.id}" class="btn btn-warning"
                                                    style="padding: 0.4rem 0.6rem;">
                                                    <span class="material-icons-sharp"
                                                        style="font-size: 1.2rem;">edit</span>
                                                </a>
                                                <button onclick="deleteCategory(${category.id}, '${category.name}')"
                                                    class="btn btn-danger" style="padding: 0.4rem 0.6rem;">
                                                    <span class="material-icons-sharp"
                                                        style="font-size: 1.2rem;">delete</span>
                                                </button>
                                            </div>
                                        </div>
                                        <p class="mb-3">${category.description}</p>
                                        <div class="d-flex justify-between align-center mt-2">
                                            <small class="text-muted"
                                                style="display: flex; align-items: center; gap: 0.3rem;">
                                                <span class="material-icons-sharp"
                                                    style="font-size: 1rem;">calendar_today</span>
                                                Created: ${category.createdAt.toLocalDate()}
                                            </small>
                                            <a href="product?action=list&categoryId=${category.id}"
                                                class="btn btn-primary"
                                                style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                                                View Products
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
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