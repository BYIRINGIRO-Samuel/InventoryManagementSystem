<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Stockio - Inventory Management System</title>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Sharp" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/custom-chart.css" />
</head>

<body>
	<div class="container">
		<%@ include file="includes/sidebar.jsp" %>
			<main>
				<h1>Dashboard</h1>

				<div class="date">
					<input type="date" />
				</div>

				<div class="insights">
					<div class="sales">
						<span class="material-icons-sharp"> analytics </span>
						<div class="middle">
							<div class="left">
								<h3>Total Sales</h3>
								<h1>${totalSalesAmount}</h1>
							</div>
						</div>
						<small class="text-muted"> Overall </small>
					</div>
					<div class="expenses">
						<span class="material-icons-sharp"> warning </span>
						<div class="middle">
							<div class="left">
								<h3>Low Stock Items</h3>
								<h1>${lowStockCount}</h1>
							</div>
						</div>
						<small class="text-muted"> Current </small>
					</div>
					<div class="income">
						<span class="material-icons-sharp"> inventory_2 </span>
						<div class="middle">
							<div class="left">
								<h3>Total Products</h3>
								<h1>${productsCount}</h1>
							</div>
						</div>
						<small class="text-muted"> Active </small>
					</div>
				</div>
				<!-- End of Insights -->

				<div class="recent-orders">
					<h2>Recent Sales</h2>
					<table id="sales-table">
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
							<c:forEach var="o" items="${recentOrders}">
								<tr>
									<td><strong>${o.orderNumber}</strong></td>
									<td>${empty o.customerName ? 'N/A' : o.customerName}</td>
									<td>${o.totalAmount}</td>
									<td>${o.status}</td>
									<td>${o.createdAt}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<a href="product?action=list">Show All</a>
				</div>
			</main>
			<%@ include file="includes/right-sidebar.jsp" %>
	</div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.6.0/chart.min.js"
		integrity="sha512-GMGzUEevhWh8Tc/njS0bDpwgxdCJLQBWG3Z2Ct+JGOpVnEmjvNx6ts4v6A2XJf1rZ0u2crp1WZu3hZ2TdnUZOA=="
		crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<script src="${pageContext.request.contextPath}/js/script.js"></script>
	<script src="${pageContext.request.contextPath}/js/charts.js"></script>
</body>

</html>
