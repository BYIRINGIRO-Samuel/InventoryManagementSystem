<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<aside>
		<div class="top">
			<div class="logo">
				<img src="./images/logo.png" />
				<h2>
					RCA <span class="danger">LIBRARY</span>
				</h2>
			</div>
			<div class="close" id="close-btn">
				<span class="material-icons-sharp"> close </span>
			</div>
		</div>
		<div class="sidebar">
			<a href="dashboard.jsp" class="active"> <span class="material-icons-sharp"> grid_view </span>
				<h3>Dashboard</h3>
			</a> <a href="product?action=list"> <span class="material-icons-sharp">
					inventory </span>
				<h3>Products</h3>
			</a> <a href="category?action=list"> <span class="material-icons-sharp">
					category </span>
				<h3>Categories</h3>
			</a> <a href="supplier?action=list"> <span class="material-icons-sharp"> local_shipping </span>
				<h3>Suppliers</h3>
			</a> <a href="product?action=new"> <span class="material-icons-sharp">
					add_circle_outline </span>
				<h3>Add Product</h3>
			</a> <a href="auth?action=logout"> <span class="material-icons-sharp"> logout </span>
				<h3>Logout</h3>
			</a>
		</div>
	</aside>