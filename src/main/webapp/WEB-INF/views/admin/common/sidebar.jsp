<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<style>
	/* 하위메뉴(nav-treeview) 전체에 왼쪽여백 추가 */
	.nav-treeview {
		padding-left: 1.5rem !important;
	}
	
	/* 하위메뉴 아이템 아이콘 크기 줄이기 */
	.nav-treeview .nav-icon {
		font-size: 0.8rem !important;
		margin-left: 0.2rem;
	}
</style>

<!--begin::Sidebar-->
<aside class="app-sidebar bg-body-secondary shadow" data-bs-theme="dark">
	<!--begin::Sidebar Brand-->
	<div class="sidebar-brand">
	<!--begin::Brand Link-->
	<a href="${path}/adminHome.ad" class="brand-link">
		<%-- <a href="${path}/admin/home" class="brand-link"> --%>
			<!--begin::Brand Image-->
			<img
				src="${path}/resources/assets/img/AdminLTELogo.png"
				alt="AdminLTE Logo"
				class="brand-image opacity-75 shadow"
			/>
			<!--end::Brand Image-->
			
			<!--begin::Brand Text-->
			<!-- <span class="brand-text fw-light">AdminLTE 4</span> -->
			<span class="brand-text fw-light">관리자 페이지</span>
		<!--end::Brand Text-->
		</a>
		<!--end::Brand Link-->
		</div>
		<!--end::Sidebar Brand-->
		
		<!--begin::Sidebar Wrapper-->
		<div class="sidebar-wrapper">
		<nav class="mt-2">
		<!--begin::Sidebar Menu-->
			<ul
				class="nav sidebar-menu flex-column"
				role="navigation"
				aria-label="Main navigation"
				data-accordion="false"
				id="navigation"
			>
				<li class="nav-item">
					<a href="${path}/adminHome.ad" class="nav-link active">
						<i class="nav-icon bi bi-speedometer"></i>
						<p>Dashboard(통계)
						</p>
					</a>
				</li>

				<li class="nav-item">
					<!-- <a href="#" class="nav-link" data-lte-toggle="treeview"> -->
					<a href="${path}/supportHome.adsp" class="nav-link" data-lte-toggle="treeview">
						<i class="nav-icon bi bi-headset"></i>
						<p>
							고객지원
							<i class="nav-arrow bi bi-chevron-right"></i>
						</p>
					</a>

					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/admin/qna/list" class="nav-link">
								<i class="nav-icon bi bi-chevron-right"></i>
								<p>1:1 문의</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/admin/faq/list" class="nav-link">
								<i class="nav-icon bi bi-chevron-right"></i>
								<p>FAQ</p>
							</a>
						</li>
					</ul>
				</li>
                  
				<li class="nav-item">
					<%-- <a href="#" class="nav-link" data-lte-toggle="treeview"> --%>
					<a href="${path}/getReservationList.ad" class="nav-link" data-lte-toggle="treeview">
						<i class="nav-icon bi bi-calendar-check"></i>
						<p>
							예약 관리
							<i class="nav-arrow bi bi-chevron-right"></i>
						</p>
						</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/adminDashboard.ad" class="nav-link">
								<i class="nav-icon bi bi-chevron-right"></i>
								<p>예약 통계 대시보드</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/getReservationList.ad" class="nav-link">
                    			<i class="nav-icon bi bi-chevron-right"></i>
                    			<p>예약내역</p>
                    		</a>
                    	</li>
					</ul>
				</li>

				<li class="nav-item">
					<a href="${path}/communityHome.adco" class="nav-link" data-lte-toggle="treeview">
					<!-- <a href="#" class="nav-link" data-lte-toggle="treeview"> -->
						<i class="nav-icon bi bi-chat-dots"></i>
						<p>
							커뮤니티 관리
							<i class="nav-arrow bi bi-chevron-right"></i>
						</p>
					</a>
				<ul class="nav nav-treeview">
					<li class="nav-item">
						<a href="${path}/admin/notice/list" class="nav-link">
							<i class="nav-icon bi bi-chevron-right"></i>
							<p>공지사항</p>
						</a>
					</li>
					<li class="nav-item">
						<a href="${path}/admin/event/list" class="nav-link">
							<i class="nav-icon bi bi-chevron-right"></i>
							<p>이벤트</p>
						</a>
					</li>
				</ul>
				</li>

				<li class="nav-item">
					<a href="${path}/placeHome.adpl" class="nav-link" data-lte-toggle="treeview">
						<i class="nav-icon bi bi-geo-alt"></i>
						<p>
							장소 관리
							<i class="nav-arrow bi bi-chevron-right"></i>
						</p>
					</a>
				<ul class="nav nav-treeview">
					<li class="nav-item">
						<a href="${path}/admin/place/restaurant" class="nav-link">
							<i class="nav-icon bi bi-chevron-right"></i>
							<p>맛집</p>
						</a>
					</li>
					<li class="nav-item">
						<a href="${path}/admin/place/accommodation" class="nav-link">
							<i class="nav-icon bi bi-chevron-right"></i>
							<p>숙소</p>
						</a>
					</li>
					<li class="nav-item">
						<a href="${path}/admin/place/festival" class="nav-link">
							<i class="nav-icon bi bi-chevron-right"></i>
							<p>축제</p>
						</a>
					</li>
				</ul>
			</li>
		</ul>
		<!--end::Sidebar Menu-->
	</nav>
</div>
	<!--end::Sidebar Wrapper-->
</aside>
<!--end::Sidebar-->