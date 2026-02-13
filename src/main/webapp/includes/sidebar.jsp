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
		<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
		<c:set var="uri" value="${pageContext.request.requestURI}" />
		<c:set var="servletPath" value="${pageContext.request.servletPath}" />
		<c:set var="action" value="${param.action}" />
		<c:set var="isDashboard" value="${fn:endsWith(uri, '/dashboard.jsp')}" />
		<c:set var="isProducts" value="${fn:endsWith(uri, '/products.jsp') or fn:endsWith(uri, '/product-details.jsp') or (servletPath == '/product' and (action == 'list' or action == 'search' or action == 'lowstock'))}" />
		<c:set var="isCategories" value="${fn:endsWith(uri, '/categories.jsp') or fn:endsWith(uri, '/category-form.jsp') or (servletPath == '/category' and (action == 'list' or action == 'new'))}" />
		<c:set var="isSuppliers" value="${fn:endsWith(uri, '/suppliers.jsp') or fn:endsWith(uri, '/supplier-form.jsp') or (servletPath == '/supplier' and (action == 'list' or action == 'new'))}" />
		<c:set var="isAddProduct" value="${fn:endsWith(uri, '/product-form.jsp') or (servletPath == '/product' and action == 'new')}" />
		<div class="sidebar">
			<a href="dashboard.jsp" class="${isDashboard ? 'active' : ''}"> <span class="material-icons-sharp"> grid_view </span>
				<h3>Dashboard</h3>
			</a> <a href="product?action=list" class="${isProducts ? 'active' : ''}"> <span class="material-icons-sharp">
					inventory </span>
				<h3>Products</h3>
			</a> <a href="category?action=list" class="${isCategories ? 'active' : ''}"> <span class="material-icons-sharp">
					category </span>
				<h3>Categories</h3>
			</a> <a href="supplier?action=list" class="${isSuppliers ? 'active' : ''}"> <span class="material-icons-sharp"> local_shipping </span>
				<h3>Suppliers</h3>
			</a> <a href="product?action=new" class="${isAddProduct ? 'active' : ''}"> <span class="material-icons-sharp">
					add_circle_outline </span>
				<h3>Add Product</h3>
			</a> <a href="auth?action=logout"> <span class="material-icons-sharp"> logout </span>
				<h3>Logout</h3>
			</a>
		</div>
	</aside>
