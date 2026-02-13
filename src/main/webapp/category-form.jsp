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
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
            <link rel="stylesheet" href="css/main.css">
        </head>

        <body>
            <div class="container wide-view">
                <jsp:include page="includes/sidebar.jsp" />

                <main>
                    <div class="d-flex justify-between align-center mb-3">
                        <h1 class="page-title">
                            <span class="material-icons-sharp">${empty category ? 'add_circle' : 'edit'}</span>
                            ${empty category ? 'Add New Category' : 'Edit Category'}
                        </h1>
                        <a href="category?action=list" class="btn btn-secondary">
                            <span class="material-icons-sharp">arrow_back</span> Back to Categories
                        </a>
                    </div>

                    <!-- Display messages -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <span class="material-icons-sharp">error</span> ${param.error}
                        </div>
                    </c:if>

                    <div class="card">
                        <div class="d-flex justify-between align-center mb-2">
                            <h2 class="h2">Category Information</h2>
                        </div>

                        <form action="category" method="post">
                            <input type="hidden" name="action" value="${empty category ? 'add' : 'update'}">
                            <c:if test="${not empty category}">
                                <input type="hidden" name="id" value="${category.id}">
                            </c:if>

                            <div class="form-group">
                                <label class="form-label">Category Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" value="${category.name}"
                                    placeholder="Enter category name" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="4"
                                    placeholder="Enter category description...">${category.description}</textarea>
                            </div>

                            <div class="d-flex gap-2 mt-3">
                                <button type="submit" class="btn btn-primary">
                                    <span class="material-icons-sharp">save</span> ${empty category ? 'Add Category' :
                                    'Update Category'}
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <span class="material-icons-sharp">restart_alt</span> Reset
                                </button>
                                <a href="category?action=list" class="btn btn-outline-secondary">
                                    <span class="material-icons-sharp">close</span> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </body>

        </html>