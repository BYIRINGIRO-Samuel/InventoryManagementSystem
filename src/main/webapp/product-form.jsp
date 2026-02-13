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
            <title>${empty product ? 'Add New Product' : 'Edit Product'} - Stockio</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <jsp:include page="includes/header.jsp" />

            <div class="container">
                <div class="d-flex justify-between align-center mb-3">
                    <h1 class="page-title">
                        <i class="fas fa-${empty product ? 'plus' : 'edit'}"></i>
                        ${empty product ? 'Add New Product' : 'Edit Product'}
                    </h1>
                    <a href="product?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Products
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
                            <i class="fas fa-info-circle"></i> Product Information
                        </h2>
                    </div>

                    <form action="product" method="post" id="productForm">
                        <input type="hidden" name="action" value="${empty product ? 'add' : 'update'}">
                        <c:if test="${not empty product}">
                            <input type="hidden" name="id" value="${product.id}">
                        </c:if>

                        <!-- Basic Information -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">SKU <span style="color: red;">*</span></label>
                                <input type="text" name="sku" class="form-control" value="${product.sku}"
                                    placeholder="Product SKU" required ${not empty product ? 'readonly' : '' }>
                                <small class="text-muted">Unique product identifier</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Product Name <span style="color: red;">*</span></label>
                                <input type="text" name="name" class="form-control" value="${product.name}"
                                    placeholder="Product Name" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="3"
                                placeholder="Product description...">${product.description}</textarea>
                        </div>

                        <!-- Pricing Information -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Selling Price</label>
                                <div style="position: relative;">
                                    <span
                                        style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--gray);">$</span>
                                    <input type="number" name="price" class="form-control" value="${product.price}"
                                        step="0.01" min="0" placeholder="0.00" style="padding-left: 30px;">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Cost Price</label>
                                <div style="position: relative;">
                                    <span
                                        style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--gray);">$</span>
                                    <input type="number" name="costPrice" class="form-control"
                                        value="${product.costPrice}" step="0.01" min="0" placeholder="0.00"
                                        style="padding-left: 30px;">
                                </div>
                            </div>
                        </div>

                        <!-- Inventory Information -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Initial Quantity</label>
                                <input type="number" name="quantity" class="form-control"
                                    value="${empty product ? '0' : product.quantityInStock}" min="0" placeholder="0">
                                <small class="text-muted">Current stock quantity</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Reorder Level</label>
                                <input type="number" name="reorderLevel" class="form-control"
                                    value="${empty product ? '10' : product.reorderLevel}" min="0" placeholder="10">
                                <small class="text-muted">Minimum stock level before reorder alert</small>
                            </div>
                        </div>

                        <!-- Category and Supplier -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Category</label>
                                <select name="categoryId" class="form-control">
                                    <option value="">Select Category</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}" ${product.category.id==category.id ? 'selected'
                                            : '' }>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">
                                    <a href="category-form.jsp" target="_blank">Add new category</a>
                                </small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Supplier</label>
                                <select name="supplierId" class="form-control">
                                    <option value="">Select Supplier</option>
                                    <c:forEach var="supplier" items="${suppliers}">
                                        <option value="${supplier.id}" ${product.supplier.id==supplier.id ? 'selected'
                                            : '' }>
                                            ${supplier.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">
                                    <a href="supplier-form.jsp" target="_blank">Add new supplier</a>
                                </small>
                            </div>
                        </div>

                        <!-- Profit Margin Display -->
                        <div class="card" style="background: var(--light-gray); margin: 1rem 0;">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="fas fa-calculator"></i> Profit Analysis
                                </h3>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Profit Margin</label>
                                    <div id="profitMargin" class="form-control"
                                        style="background: white; font-weight: bold;">
                                        Calculate automatically
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Profit Amount</label>
                                    <div id="profitAmount" class="form-control"
                                        style="background: white; font-weight: bold;">
                                        $0.00
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> ${empty product ? 'Add Product' : 'Update Product'}
                            </button>
                            <button type="reset" class="btn btn-secondary btn-lg">
                                <i class="fas fa-undo"></i> Reset
                            </button>
                            <a href="product?action=list" class="btn btn-outline btn-lg">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-bolt"></i> Quick Actions
                        </h2>
                    </div>
                    <div class="dashboard-grid">
                        <button onclick="generateSKU()" class="btn btn-info">
                            <i class="fas fa-magic"></i> Generate SKU
                        </button>
                        <button onclick="duplicateProduct()" class="btn btn-warning" ${empty product ? 'disabled' : ''
                            }>
                            <i class="fas fa-copy"></i> Duplicate Product
                        </button>
                        <button onclick="previewProduct()" class="btn btn-success">
                            <i class="fas fa-eye"></i> Preview
                        </button>
                        <button onclick="saveAsDraft()" class="btn btn-secondary">
                            <i class="fas fa-save"></i> Save as Draft
                        </button>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    calculateProfit();

                    // Add event listeners for price calculations
                    document.querySelector('input[name="price"]').addEventListener('input', calculateProfit);
                    document.querySelector('input[name="costPrice"]').addEventListener('input', calculateProfit);

                    // Form validation
                    document.getElementById('productForm').addEventListener('submit', function (e) {
                        if (!validateForm()) {
                            e.preventDefault();
                        }
                    });
                });

                function calculateProfit() {
                    const sellingPrice = parseFloat(document.querySelector('input[name="price"]').value) || 0;
                    const costPrice = parseFloat(document.querySelector('input[name="costPrice"]').value) || 0;

                    if (sellingPrice > 0 && costPrice > 0) {
                        const profit = sellingPrice - costPrice;
                        const margin = ((profit / sellingPrice) * 100).toFixed(2);

                        document.getElementById('profitAmount').textContent = '$' + profit.toFixed(2);
                        document.getElementById('profitMargin').textContent = margin + '%';

                        // Color coding
                        if (margin < 10) {
                            document.getElementById('profitMargin').style.color = 'var(--danger)';
                        } else if (margin < 25) {
                            document.getElementById('profitMargin').style.color = 'var(--warning)';
                        } else {
                            document.getElementById('profitMargin').style.color = 'var(--success)';
                        }
                    } else {
                        document.getElementById('profitAmount').textContent = '$0.00';
                        document.getElementById('profitMargin').textContent = '0%';
                        document.getElementById('profitMargin').style.color = 'var(--gray)';
                    }
                }

                function generateSKU() {
                    const name = document.querySelector('input[name="name"]').value;
                    const category = document.querySelector('select[name="categoryId"] option:checked').text;

                    let sku = '';

                    if (category && category !== 'Select Category') {
                        sku += category.substring(0, 3).toUpperCase();
                    } else {
                        sku += 'PRD';
                    }

                    if (name) {
                        sku += name.substring(0, 3).toUpperCase().replace(/[^A-Z]/g, '');
                    }

                    // Add random number
                    sku += Math.floor(Math.random() * 1000).toString().padStart(3, '0');

                    document.querySelector('input[name="sku"]').value = sku;
                }

                function duplicateProduct() {
                    if (confirm('This will create a copy of the current product. Continue?')) {
                        // Clear ID and SKU for new product
                        document.querySelector('input[name="action"]').value = 'add';
                        document.querySelector('input[name="sku"]').value = '';
                        document.querySelector('input[name="sku"]').readOnly = false;
                        generateSKU();

                        // Update form title
                        document.querySelector('.page-title').innerHTML = '<i class="fas fa-copy"></i> Duplicate Product';
                    }
                }

                function previewProduct() {
                    const formData = new FormData(document.getElementById('productForm'));
                    let preview = 'Product Preview:\n\n';

                    for (let [key, value] of formData.entries()) {
                        if (value && key !== 'action') {
                            preview += `${key.charAt(0).toUpperCase() + key.slice(1)}: ${value}\n`;
                        }
                    }

                    alert(preview);
                }

                function saveAsDraft() {
                    // Save form data to localStorage
                    const formData = new FormData(document.getElementById('productForm'));
                    const draftData = {};

                    for (let [key, value] of formData.entries()) {
                        draftData[key] = value;
                    }

                    localStorage.setItem('productDraft', JSON.stringify(draftData));
                    alert('Product saved as draft!');
                }

                function loadDraft() {
                    const draft = localStorage.getItem('productDraft');
                    if (draft) {
                        const draftData = JSON.parse(draft);

                        for (let [key, value] of Object.entries(draftData)) {
                            const element = document.querySelector(`[name="${key}"]`);
                            if (element) {
                                element.value = value;
                            }
                        }

                        calculateProfit();
                    }
                }

                function validateForm() {
                    const sku = document.querySelector('input[name="sku"]').value.trim();
                    const name = document.querySelector('input[name="name"]').value.trim();

                    if (!sku) {
                        alert('SKU is required!');
                        return false;
                    }

                    if (!name) {
                        alert('Product name is required!');
                        return false;
                    }

                    const price = parseFloat(document.querySelector('input[name="price"]').value) || 0;
                    const costPrice = parseFloat(document.querySelector('input[name="costPrice"]').value) || 0;

                    if (price > 0 && costPrice > 0 && price < costPrice) {
                        if (!confirm('Selling price is lower than cost price. This will result in a loss. Continue?')) {
                            return false;
                        }
                    }

                    return true;
                }

                // Load draft on page load if available
                if (localStorage.getItem('productDraft') && ${empty product }) {
                    if (confirm('A draft product was found. Would you like to load it?')) {
                        loadDraft();
                    }
                }

                // Clear draft after successful submission
                document.getElementById('productForm').addEventListener('submit', function () {
                    localStorage.removeItem('productDraft');
                });
            </script>
        </body>

        </html>