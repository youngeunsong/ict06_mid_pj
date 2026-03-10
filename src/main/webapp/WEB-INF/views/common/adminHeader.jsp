<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- ================= header ================= -->
<!--begin::Header-->
<nav class="app-header navbar navbar-expand bg-body">
	<!--begin::Container-->
	<div class="container-fluid">
		<!--begin::Left-->
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" data-lte-toggle="sidebar" href="#" role="button">
					<i class="fas fa-bars"></i>
				</a>
			</li>
			<li class="nav-item d-none d-md-block">
				<a href="${path}/adminHome.ad" class="nav-link">ADMIN DASHBOARD</a>
			</li>
		</ul>
		<!--end::Left-->
		
		<!--begin::Right-->
		<ul class="navbar-nav ms-auto">
			<!--User Home 버튼-->
			<li class="nav-item me-2">
				<a href="${path}/main.do" class="nav-link btn btn-outline-primary btn-sm px-3"
					style="border-radius:20px; font-size:0.85rem; border-color:#01D281; color:#01D281;">
					<i class="fas fa-external-link-alt me-1"></i>User Home
				</a>
			</li>
			
			<!--관리자 드롭다운-->
			<li class="nav-item dropdown user-menu">
			<a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
				<i class="bi bi-person-circle" style="font-size:1.4rem; color:#01D281;"></i>
				<span class="d-none d-md-inline ml-1">${sessionScope.sessionID}</span>
			</a>
			<ul class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
					<li class="user-header" style="background-color:#01D281">
	                	<i class="bi bi-person-circle" style="font-size:4rem; color:#fff;"></i>
	                	<p>
	                		${sessionScope.sessionID}
	                		<small>관리자</small>
	                	</p>
					</li>
					<li class="user-footer">
						<a href="${path}/logout.do" class="btn btn-danger btn-flat float-end">
							<i class="fas fa-power-off mr-1"></i>LOGOUT
						</a>
					</li>
				</ul>
			</li>
			
		</ul>
		<!--end::Right-->
		
	</div>
</nav>

<!-- ================= JS ================= -->