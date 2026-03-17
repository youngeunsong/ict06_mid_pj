<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- JSTL --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 컨텍스트 경로 --%>
<c:set var="path" value="${pageContext.request.contextPath}" scope="application"/>

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%-- Bootstrap CSS --%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<%-- AdminLTE CSS --%>
<link rel="stylesheet" href="${path}/resources/css/adminlte.min.css">

<%-- Font Awesome --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Bootstrap Icons --%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<%-- Bootstrap JS --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<%-- AdminLTE JS --%>
<script src="${path}/resources/js/adminlte.min.js"></script>