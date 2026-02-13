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
                <meta charset="UTF-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Products - Stockio</title>
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
            </head>

            <body>
                <div class="container wide-view">
                    <%@ include file="includes/sidebar.jsp" %>
                        <main>
                            <div class="d-flex justify-between align-center mb-3">
                                <h1 class="page-title">
                                    <span class="material-icons-sharp">inventory_2</span> Products Management
                                </h1>
                                <a href="product?action=new" class="btn btn-primary">
                                    <span class="material-icons-sharp">add</span> Add New Product
                                </a>
                            </div>

                            <!-- Messages -->
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

                            <!-- Insights / Stats -->
                            <div class="insights">
                                <div class="sales">
                                    <span class="material-icons-sharp">inventory_2</span>
                                    <div class="middle">
                                        <div class="left">
                                            <h3>Total Products</h3>
                                            <h1>${products.size()}</h1>
                                        </div>
                                    </div>
                                </div>
                                <div class="expenses">
                                    <span class="material-icons-sharp">warning</span>
                                    <div class="middle">
                                        <div class="left">
                                            <h3>Low Stock Items</h3>
                                            <h1 id="lowStockCount">0</h1>
                                        </div>
                                    </div>
                                </div>
                                <div class="income">
                                    <span class="material-icons-sharp">attach_money</span>
                                    <div class="middle">
                                        <div class="left">
                                            <h3>Total Inventory Value</h3>
                                            <h1 id="totalValue">$0</h1>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Search -->
                            <div class="card mt-3">
                                <div class="d-flex justify-between align-center mb-2">
                                    <h2 class="h2">Search Products</h2>
                                </div>
                                <form action="product" method="get" class="d-flex gap-1 flex-wrap">
                                    <input type="hidden" name="action" value="search">
                                    <input type="text" name="search" class="form-control flex-grow-1 min-w-200"
                                        placeholder="Search products..." value="${searchTerm}">
                                    <select name="categoryId" class="form-control w-auto">
                                        <option value="">All Categories</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.id}" ${param.categoryId==category.id ? 'selected'
                                                : '' }>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                    <select name="supplierId" class="form-control w-auto">
                                        <option value="">All Suppliers</option>
                                        <c:forEach var="supplier" items="${suppliers}">
                                            <option value="${supplier.id}" ${param.supplierId==supplier.id ? 'selected'
                                                : '' }>${supplier.name}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-icons-sharp">search</span> Search
                                    </button>
                                    <a href="product?action=list" class="btn btn-secondary">
                                        <span class="material-icons-sharp">refresh</span> Reset
                                    </a>
                                </form>
                            </div>

                            <!-- Table -->
                            <div class="card mt-3">
                                <div class="d-flex justify-between align-center mb-2">
                                    <h2 class="h2">Products List</h2>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>SKU</th>
                                                <th>Product Name</th>
                                                <th>Category</th>
                                                <th>Supplier</th>
                                                <th>Price</th>
                                                <th>Stock</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="product" items="${products}">
                                                <tr>
                                                    <td><strong>${product.sku}</strong></td>
                                                    <td>${product.name}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty product.category}">
                                                                <span
                                                                    class="badge badge-info">${product.category.name}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${not empty product.supplier ? product.supplier.name : 'N/A'}
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${product.price}" type="currency"
                                                            currencySymbol="$" />
                                                    </td>
                                                    <td>${product.quantityInStock}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.quantityInStock == 0}">
                                                                <span class="badge badge-danger">Out of Stock</span>
                                                            </c:when>
                                                            <c:when
                                                                test="${product.quantityInStock <= product.minStockLevel}">
                                                                <span class="badge badge-warning">Low Stock</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-success">In Stock</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex gap-1 justify-content-center">
                                                            <a href="product?action=edit&id=${product.id}"
                                                                class="btn btn-warning btn-sm">
                                                                <span class="material-icons-sharp fs-1-2">edit</span>
                                                            </a>
                                                            <a href="product?action=delete&id=${product.id}"
                                                                class="btn btn-danger btn-sm"
                                                                onclick="return confirm('Are you sure you want to delete this product?')">
                                                                <span class="material-icons-sharp fs-1-2">delete</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </main>
                        <%@ include file="includes/header.jsp" %>
                </div>

                <script src="${pageContext.request.contextPath}/js/script.js"></script>
                <script>
                    // Calculate stats client-side or server-side. 
                    // Here we can use simple JS to sum up values if not provided by server.
                    // For now, let's just populate with what we have.
                    // Ideally these should be calculated on the server and passed as attributes.

                    // Simple client-side calculation example for Total Value (if needed)
                    let totalValue = 0;
                    let lowStock = 0;
                    <c:forEach var="p" items="${products}">
                        totalValue += ${p.price * p.quantityInStock};
                        if (${p.quantityInStock <= p.minStockLevel}) lowStock++;
                    </c:forEach>

                    document.getElementById('totalValue').innerText = '$' + totalValue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                    document.getElementById('lowStockCount').innerText = lowStock;
                </script>
            </body>

            </html>