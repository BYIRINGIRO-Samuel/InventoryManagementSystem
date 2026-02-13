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
            <title>${empty category ? 'Add New Category' : 'Edit Category'} - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <div class="d-flex justify-between align-center mb-3">
                    <h1 class="page-title">
                        <i class="fas fa-${empty category ? 'plus' : 'edit'}"></i>
                        ${empty category ? 'Add New Category' : 'Edit Category'}
                    </h1>
                    <a href="category?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Categories
                    </a>
                </div>

                <!-- Display messages -->
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${param.error}
                    </div>
                </c:if>

                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-info-circle"></i> Category Information
                        </h2>
                    </div>

                    <form action="category" method="post">
                        <input type="hidden" name="action" value="${empty category ? 'add' : 'update'}">
                        <c:if test="${not empty category}">
                            <input type="hidden" name="id" value="${category.id}">
                        </c:if>

                        <div class="form-group">
                            <label class="form-label">Category Name <span style="color: red;">*</span></label>
                            <input type="text" name="name" class="form-control" value="${category.name}"
                                placeholder="Enter category name" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="4"
                                placeholder="Enter category description...">${category.description}</textarea>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> ${empty category ? 'Add Category' : 'Update Category'}
                            </button>
                            <button type="reset" class="btn btn-secondary btn-lg">
                                <i class="fas fa-undo"></i> Reset
                            </button>
                            <a href="category?action=list" class="btn btn-outline btn-lg">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>