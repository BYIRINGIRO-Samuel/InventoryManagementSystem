<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="login.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Sale - Stockio</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
<div class="container wide-view">
    <jsp:include page="includes/sidebar.jsp" />
    <main>
        <div class="d-flex justify-between align-center mb-3">
            <h1 class="page-title">
                <span class="material-icons-sharp">shopping_cart</span> Create Sale
            </h1>
            <a href="sales?action=list" class="btn btn-secondary">
                <span class="material-icons-sharp">arrow_back</span> Back to Sales
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <span class="material-icons-sharp">error</span> ${param.error}
            </div>
        </c:if>

        <div class="card mb-3">
            <h2 class="h2">Customer</h2>
            <form action="sales" method="post" id="salesForm">
                <input type="hidden" name="action" value="create">
                <div class="form-group">
                    <label class="form-label">Customer Name</label>
                    <input type="text" name="customerName" class="form-control" placeholder="Walk-in customer">
                </div>

                <h2 class="h2">Items</h2>
                <div id="itemsContainer">
                    <div class="form-row item-row">
                        <div class="form-group">
                            <label class="form-label">Product</label>
                            <select name="itemProductId" class="form-control">
                                <option value="">Select Product</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.id}">${p.name} (${p.sku})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Quantity</label>
                            <input type="number" name="itemQuantity" class="form-control" min="1" value="1">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Price</label>
                            <input type="number" name="itemPrice" class="form-control" step="0.01" min="0" placeholder="0.00">
                        </div>
                        <button type="button" class="btn btn-danger" onclick="removeRow(this)">
                            <span class="material-icons-sharp">delete</span>
                        </button>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary" onclick="addRow()">
                    <span class="material-icons-sharp">add</span> Add Item
                </button>

                <div class="card bg-white mt-3">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Total</label>
                            <div id="orderTotal" class="form-control fw-bold">$0.00</div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <button type="submit" class="btn btn-primary">
                        <span class="material-icons-sharp">save</span> Create Sale
                    </button>
                    <a href="sales?action=list" class="btn btn-outline-secondary">
                        <span class="material-icons-sharp">close</span> Cancel
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>
<script>
function addRow() {
    const container = document.getElementById('itemsContainer');
    const row = document.querySelector('.item-row').cloneNode(true);
    row.querySelectorAll('input').forEach(i => i.value = i.name === 'itemQuantity' ? 1 : '');
    container.appendChild(row);
    calculateTotal();
}
function removeRow(btn) {
    const rows = document.querySelectorAll('.item-row');
    if (rows.length > 1) {
        btn.closest('.item-row').remove();
        calculateTotal();
    }
}
function calculateTotal() {
    let total = 0;
    document.querySelectorAll('.item-row').forEach(row => {
        const qty = parseInt(row.querySelector('input[name="itemQuantity"]').value) || 0;
        const price = parseFloat(row.querySelector('input[name="itemPrice"]').value) || 0;
        total += qty * price;
    });
    document.getElementById('orderTotal').textContent = '$' + total.toFixed(2);
}
document.addEventListener('input', function(e) {
    if (e.target.matches('input[name="itemQuantity"], input[name="itemPrice"]')) {
        calculateTotal();
    }
});
</script>
</body>
</html>
