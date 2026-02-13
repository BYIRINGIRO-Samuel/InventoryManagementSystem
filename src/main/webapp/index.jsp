<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!-- Redirect logic -->
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <c:redirect url="dashboard.jsp" />
            </c:when>
            <c:otherwise>
                <c:redirect url="login.jsp" />
            </c:otherwise>
        </c:choose>