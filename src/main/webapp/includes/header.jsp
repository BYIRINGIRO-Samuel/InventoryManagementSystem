<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="header">
    <div class="header-content">
        <a href="dashboard" class="logo">Stockio</a>
        
        <ul class="nav-menu">
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="product?action=list">Products</a></li>
            <li><a href="category?action=list">Categories</a></li>
            <li><a href="supplier?action=list">Suppliers</a></li>
        </ul>
        
        <div class="user-info">
            <div class="user-avatar">
                ${not empty sessionScope.user ? sessionScope.user.fullName.substring(0, 1) : 'U'}
            </div>
            <span style="color: var(--white); font-weight: 500;">
                ${not empty sessionScope.user ? sessionScope.user.fullName : 'User'}
            </span>
            <a href="auth?action=logout" style="color: var(--white); margin-left: 1rem; display: flex; align-items: center;" title="Logout">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </div>
</div>
