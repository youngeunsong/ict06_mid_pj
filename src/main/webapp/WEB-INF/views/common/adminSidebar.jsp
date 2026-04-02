<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />

<style>
	.nav-treeview {
		padding-left: 1.2rem !important;
	}

	.nav-treeview .nav-icon {
		font-size: 0.75rem !important;
		margin-right: 0.35rem;
	}

	body.sidebar-collapse .nav-sidebar .nav-link p,
	body.sidebar-collapse .brand-text {
		display: none !important;
	}

	body.sidebar-collapse .nav-sidebar .nav-link .nav-icon,
	body.sidebar-collapse .nav-sidebar .nav-link i {
		display: inline-block !important;
		font-size: 1rem !important;
		margin-right: 0 !important;
	}

	body.sidebar-collapse .nav-sidebar .nav-link {
		text-align: center;
		overflow: hidden;
		white-space: nowrap;
		padding-left: .5rem !important;
		padding-right: .5rem !important;
	}

	body.sidebar-collapse .nav-sidebar .nav-link .right {
		display: none !important;
	}
</style>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<a href="${path}/adminHome.ad" class="brand-link">
		<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
			 class="brand-image img-circle elevation-3" alt="Admin Logo">
		<span class="brand-text font-weight-light">맛침내 (관리자)</span>
	</a>

	<div class="sidebar">
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column"
				data-widget="treeview" role="menu" data-accordion="false">

				<li class="nav-item">
					<a href="${path}/adminHome.ad" class="nav-link ${fn:contains(currentURI, 'adminHome') ? 'active' : ''}">
						<i class="nav-icon fas fa-tachometer-alt"></i>
						<p>KPI 대시보드</p>
					</a>
				</li>

				<li class="nav-item ${fn:contains(currentURI, '.adme') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, '.adme') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-users"></i>
						<p>회원 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/memberList.adme" class="nav-link ${fn:contains(currentURI, 'memberList') ? 'active' : ''}">
								<i class="nav-icon fas fa-user"></i>
								<p>전체 회원</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/bannedList.adme" class="nav-link ${fn:contains(currentURI, 'bannedList') ? 'active' : ''}">
								<i class="nav-icon fas fa-user-slash"></i>
								<p>제재 회원</p>
							</a>
						</li>
					</ul>
				</li>

				<li class="nav-item ${fn:contains(currentURI, 'place') || fn:contains(currentURI, 'adre') || fn:contains(currentURI, 'adac') || fn:contains(currentURI, 'adfe') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'place') || fn:contains(currentURI, 'adre') || fn:contains(currentURI, 'adac') || fn:contains(currentURI, 'adfe') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-location-dot"></i>
						<p>장소 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/restaurantList.adre" class="nav-link ${fn:contains(currentURI, 'restaurant') ? 'active' : ''}">
								<i class="nav-icon fas fa-utensils"></i>
								<p>맛집 관리</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/accommodation.adac" class="nav-link ${fn:contains(currentURI, 'accommodation') ? 'active' : ''}">
								<i class="nav-icon fas fa-bed"></i>
								<p>숙소 관리</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/festivalList.adfe" class="nav-link ${fn:contains(currentURI, 'festival') ? 'active' : ''}">
								<i class="nav-icon fas fa-ticket-alt"></i>
								<p>축제 관리</p>
							</a>
						</li>
					</ul>
				</li>

				<li class="nav-item ${fn:contains(currentURI, 'resDashboard') || fn:contains(currentURI, 'reservationList') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'resDashboard') || fn:contains(currentURI, 'reservationList') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-calendar"></i>
						<p>예약 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/resDashboard.ad" class="nav-link ${fn:contains(currentURI, 'resDashboard') ? 'active' : ''}">
								<i class="nav-icon fas fa-chart-line"></i>
								<p>예약 통계 대시보드</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/reservationList.ad" class="nav-link ${fn:contains(currentURI, 'reservationList') ? 'active' : ''}">
								<i class="nav-icon fas fa-calendar-check"></i>
								<p>예약 내역</p>
							</a>
						</li>
					</ul>
				</li>

				<li class="nav-item ${fn:contains(currentURI, 'notice') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'notice') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-bullhorn"></i>
						<p>공지/이벤트 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/noticeList.adnt" class="nav-link ${fn:contains(currentURI, 'noticeList') ? 'active' : ''}">
								<i class="nav-icon fas fa-bullhorn"></i>
								<p>공지/이벤트 목록</p>
							</a>
						</li>
					</ul>
				</li>

				<li class="nav-item ${fn:contains(currentURI, 'community') || fn:contains(currentURI, 'adco') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'community') || fn:contains(currentURI, 'adco') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-comments"></i>
						<p>커뮤니티 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/communityHome.adco" class="nav-link ${fn:contains(currentURI, 'communityHome') ? 'active' : ''}">
								<i class="nav-icon fas fa-pen"></i>
								<p>게시글 관리</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/commentList.adco" class="nav-link ${fn:contains(currentURI, 'commentList') ? 'active' : ''}">
								<i class="nav-icon fas fa-comments"></i>
								<p>댓글 관리</p>
							</a>
						</li>
					</ul>
				</li>

				<li class="nav-item ${currentURI.contains('Inquiry') || currentURI.contains('Faq') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${currentURI.contains('Inquiry') || currentURI.contains('Faq') ? 'active' : ''}">
						<i class="nav-icon fa-solid fa-circle-question"></i>
						<p>문의/FAQ 관리 <i class="right fas fa-angle-left"></i></p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/adInquiryList.adsp" class="nav-link ${currentURI.contains('Inquiry') ? 'active' : ''}">
								<i class="nav-icon fas fa-envelope"></i>
								<p>1:1 문의 관리</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/adFaqList.adsp" class="nav-link ${currentURI.contains('Faq') ? 'active' : ''}">
								<i class="nav-icon fas fa-question-circle"></i>
								<p>FAQ 관리</p>
							</a>
						</li>
					</ul>
				</li>

			</ul>
		</nav>
	</div>
</aside>
