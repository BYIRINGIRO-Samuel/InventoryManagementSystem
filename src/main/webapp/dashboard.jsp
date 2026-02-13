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
								<h1>$25,024</h1>
							</div>
							<div class="progress">
								<svg>
									<circle cx="38" cy="38" r="36"></circle>
								</svg>
								<div class="number">
									<p>81%</p>
								</div>
							</div>
						</div>
						<small class="text-muted"> Last 24 Hours </small>
					</div>
					<!-- End of Sales -->
					<div class="expenses">
						<span class="material-icons-sharp"> bar_chart </span>
						<div class="middle">
							<div class="left">
								<h3>Total Expenses</h3>
								<h1>$14,160</h1>
							</div>
							<div class="progress">
								<svg>
									<circle cx="38" cy="38" r="36"></circle>
								</svg>
								<div class="number">
									<p>62%</p>
								</div>
							</div>
						</div>
						<small class="text-muted"> Last 24 Hours </small>
					</div>
					<!-- End of Expenses -->
					<div class="income">
						<span class="material-icons-sharp"> stacked_line_chart </span>
						<div class="middle">
							<div class="left">
								<h3>Total Income</h3>
								<h1>$10,864</h1>
							</div>
							<div class="progress">
								<svg>
									<circle cx="38" cy="38" r="36"></circle>
								</svg>
								<div class="number">
									<p>44%</p>
								</div>
							</div>
						</div>
						<small class="text-muted"> Last 24 Hours </small>
					</div>
					<!-- End of Income -->
				</div>
				<!-- End of Insights -->

				<div class="recent-orders">
					<h2>Recent Orders</h2>
					<table id="product-table">
						<thead>
							<tr>
								<th>Product Name</th>
								<th>Product Number</th>
								<th>Payment</th>
								<th>Status</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<!-- Table rows are populated by js/charts.js or script.js -->
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