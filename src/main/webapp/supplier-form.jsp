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
            <title>${empty supplier ? 'Add New Supplier' : 'Edit Supplier'} - Stockio</title>
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet">
            <link rel="stylesheet" href="css/main.css">
        </head>

        <body>
            <div class="container wide-view">
                <jsp:include page="includes/sidebar.jsp" />

                <main>
                    <div class="d-flex justify-between align-center mb-3">
                        <h1 class="page-title">
                            <span class="material-icons-sharp">${empty supplier ? 'add_circle' : 'edit'}</span>
                            ${empty supplier ? 'Add New Supplier' : 'Edit Supplier'}
                        </h1>
                        <a href="supplier?action=list" class="btn btn-secondary">
                            <span class="material-icons-sharp">arrow_back</span> Back to Suppliers
                        </a>
                    </div>

                    <!-- Display messages -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <span class="material-icons-sharp">error</span> ${param.error}
                        </div>
                    </c:if>

                    <div class="card mb-3">
                        <div class="d-flex justify-between align-center mb-2">
                            <h2 class="h2">Supplier Information</h2>
                        </div>

                        <form action="supplier" method="post">
                            <input type="hidden" name="action" value="${empty supplier ? 'add' : 'update'}">
                            <c:if test="${not empty supplier}">
                                <input type="hidden" name="id" value="${supplier.id}">
                            </c:if>

                            <!-- Basic Information -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Supplier Name <span class="text-danger">*</span></label>
                                    <input type="text" name="name" class="form-control" value="${supplier.name}"
                                        placeholder="Enter supplier name" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Contact Person</label>
                                    <input type="text" name="contactPerson" class="form-control"
                                        value="${supplier.contactPerson}" placeholder="Contact person name">
                                </div>
                            </div>

                            <!-- Contact Information -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="email" class="form-control" value="${supplier.email}"
                                        placeholder="supplier@example.com">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" name="phone" class="form-control" value="${supplier.phone}"
                                        placeholder="+1 (555) 123-4567">
                                </div>
                            </div>

                            <!-- Address -->
                            <div class="form-group">
                                <label class="form-label">Address</label>
                                <textarea name="address" class="form-control" rows="3"
                                    placeholder="Enter supplier address...">${supplier.address}</textarea>
                            </div>

                            <div class="d-flex gap-2 mt-3">
                                <button type="submit" class="btn btn-primary">
                                    <span class="material-icons-sharp">save</span> ${empty supplier ? 'Add Supplier' :
                                    'Update Supplier'}
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <span class="material-icons-sharp">restart_alt</span> Reset
                                </button>
                                <a href="supplier?action=list" class="btn btn-outline-secondary">
                                    <span class="material-icons-sharp">close</span> Cancel
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Quick Contact Test -->
                    <div class="card">
                        <div class="d-flex justify-between align-center mb-2">
                            <h2 class="h2">Quick Contact Test</h2>
                        </div>
                        <div class="d-flex gap-2">
                            <button onclick="testEmail()" class="btn btn-info" id="testEmailBtn" disabled>
                                <span class="material-icons-sharp">email</span> Test Email
                            </button>
                            <button onclick="testPhone()" class="btn btn-success" id="testPhoneBtn" disabled>
                                <span class="material-icons-sharp">phone</span> Test Phone
                            </button>
                        </div>
                    </div>
                </main>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const emailInput = document.querySelector('input[name="email"]');
                    const phoneInput = document.querySelector('input[name="phone"]');
                    const testEmailBtn = document.getElementById('testEmailBtn');
                    const testPhoneBtn = document.getElementById('testPhoneBtn');

                    // Enable/disable test buttons based on input
                    emailInput.addEventListener('input', function () {
                        testEmailBtn.disabled = !this.value.trim();
                    });

                    phoneInput.addEventListener('input', function () {
                        testPhoneBtn.disabled = !this.value.trim();
                    });

                    // Initial check
                    testEmailBtn.disabled = !emailInput.value.trim();
                    testPhoneBtn.disabled = !phoneInput.value.trim();
                });

                function testEmail() {
                    const email = document.querySelector('input[name="email"]').value;
                    if (email) {
                        window.open(`mailto:${email}?subject=Test Email from Stockio&body=Hello, this is a test email from our Inventory Management System.`);
                    }
                }

                function testPhone() {
                    const phone = document.querySelector('input[name="phone"]').value;
                    if (phone) {
                        window.open(`tel:${phone}`);
                    }
                }
            </script>
        </body>

        </html>