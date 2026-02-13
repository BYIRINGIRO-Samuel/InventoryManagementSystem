<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <c:if test="${empty sessionScope.user}">
                <c:redirect url="login.jsp" />
            </c:if>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Sales - Stockio</title>
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
            </head>

            <body>
                <div class="container wide-view">
                    <%@ include file="includes/sidebar.jsp" %>
                        <main>
                            <div class="d-flex justify-between align-center mb-3">
                                <h1 class="page-title">
                                    <span class="material-icons-sharp">point_of_sale</span> Sales Orders
                                </h1>
                                <a href="sales?action=new" class="btn btn-primary">
                                    <span class="material-icons-sharp">add_shopping_cart</span> Create Sale
                                </a>
                            </div>

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

                            <div class="card mt-3">
                                <div class="d-flex justify-between align-center mb-2">
                                    <h2 class="h2">Orders</h2>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Order #</th>
                                                <th>Customer</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="o" items="${orders}">
                                                <tr>
                                                    <td><strong>${o.orderNumber}</strong></td>
                                                    <td>${empty o.customerName ? 'N/A' : o.customerName}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                            currencySymbol="$" />
                                                    </td>
                                                    <td>${o.status}</td>
                                                    <td>${o.createdAt}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </main>
                </div>
                <script src="${pageContext.request.contextPath}/js/script.js"></script>
            </body>

            </html>