<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!--현재 URI 저장-->
<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}"/>

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

<!-- ================= SIDEBAR ================= -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<a href="${path}/adminHome.ad" class="brand-link"> <img
		src="${path}/resources/admin/dist/img/AdminLTELogo.png"
		class="brand-image img-circle elevation-3"> <span
		class="brand-text font-weight-light">맛침내 (관리자)</span> <!-- 관리자 페이지 임을 표시 -->
	</a>

	<div class="sidebar">

		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column"
				data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
             with font-awesome or any other icon font library -->
             
             	<!-- 하위 메뉴 없는 경우 -->
             	<!-- KPI 대시보드 메뉴 시작 -->
				<li class="nav-item">
					<!-- class 뒤에 active 붙여서 현재 선택한 메뉴임을 표시 가능 -->
					<a href="${path}/adminHome.ad" class="nav-link ${fn:contains(currentURI, 'adminHome') ? 'active' : ''}"> 
						<i class="nav-icon fas fa-tachometer-alt"></i>
						<!-- <p>Dashboard(통계)</p> -->
						KPI 대시보드
					</a>
				</li>
             	<!-- KPI 대시보드 메뉴 끝 -->
				
				<!-- 회원 관리 메뉴 시작 -->
				<li class="nav-item ${fn:contains(currentURI, '.adme') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, '.adme') ? 'active' : ''}"> 
						<i class="fa-solid fa-users"></i>
						회원 관리

						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/memberList.adme" class="nav-link ${fn:contains(currentURI, 'memberList') ? 'active' : ''}"> 
								전체 회원
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/bannedList.adme" class="nav-link ${fn:contains(currentURI, 'bannedList') ? 'active' : ''}">
								제재 회원
							</a>
						</li>
					</ul>
				</li>
				<!-- 회원 관리 메뉴 끝 -->
				
				<!-- 장소 관리 메뉴 시작 -->
				<li class="nav-item ${fn:contains(currentURI, 'place')||fn:contains(currentURI, 'adre')||fn:contains(currentURI, 'adac')||fn:contains(currentURI, 'adfe') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'place')||fn:contains(currentURI, 'adre')||fn:contains(currentURI, 'adac')||fn:contains(currentURI, 'adfe') ? 'active' : ''}"> 
						<i class="fa-solid fa-location-dot"></i>
						장소 관리
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/restaurantList.adre" class="nav-link ${fn:contains(currentURI, 'restaurant') ? 'active' : ''}"> 
								맛집 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/accommodation.adac" class="nav-link ${fn:contains(currentURI, 'accommodation') ? 'active' : ''}">
								숙소 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/festivalList.adfe" class="nav-link ${fn:contains(currentURI, 'festival') ? 'active' : ''}">
								축제 관리
							</a>
						</li>
					</ul>
				</li>
				<!-- 장소 관리 메뉴 끝 -->
				
				<!-- 예약 관리 메뉴 시작: 하위 메뉴 있음 -->
				<!-- <li class="nav-item menu-open"> -->
				<li class="nav-item ${fn:contains(currentURI, 'resDashboard')||fn:contains(currentURI, 'reservationList') ? 'menu-open' : ''}">
					<a href="#" class="nav-link ${fn:contains(currentURI, 'resDashboard')||fn:contains(currentURI, 'reservationList') ? 'active' : ''}"> 
						<i class="fa-solid fa-calendar"></i>
						예약 관리
						<i class="right fas fa-angle-left"></i>
					</a>
					<!-- 예약 관리 하위메뉴 시작 -->
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/resDashboard.ad" class="nav-link ${fn:contains(currentURI, 'resDashboard') ? 'active' : ''}"> 
								예약 통계 대시보드
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/reservationList.ad" class="nav-link ${fn:contains(currentURI, 'reservationList') ? 'active' : ''}">
								예약 내역
							</a>
						</li>
					</ul>
					<!-- 예약 관리 하위메뉴 끝 -->
				</li>
				<!-- 예약 관리 메뉴 끝 -->
				
				<!-- 공지/이벤트 관리 메뉴 시작 -->
				<li class="nav-item ${fn:contains(currentURI, 'notice') ? 'menu-open' : ''}">
					<a href="${path}/noticeList.adnt" class="nav-link ${fn:contains(currentURI, 'notice') ? 'active' : ''}"> 
						<i class="fa-solid fa-bullhorn"></i>
						공지/이벤트 관리
						<i class="right fas fa-angle-left"></i> 
					</a>
					
					<!-- 공지/이벤트 관리 하위메뉴 시작 -->
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/noticeList.adnt" class="nav-link ${fn:contains(currentURI, 'noticeList') ? 'active' : ''}"> 
								공지/이벤트 목록
							</a>
						</li>
					</ul>
					<!-- 공지/이벤트 관리 하위메뉴 끝 -->
				</li>
				<!-- 공지/이벤트 관리 메뉴 끝 -->

				<!-- 커뮤니티 관리 메뉴 시작 -->
				<li class="nav-item ${fn:contains(currentURI, 'community')||fn:contains(currentURI, 'adco') ? 'menu-open' : ''}">
					<a href="${path}/communityHome.adco" class="nav-link ${fn:contains(currentURI, 'community')||fn:contains(currentURI, 'adco') ? 'active' : ''}"> 
						<i class="fa-solid fa-comments"></i>
						커뮤니티 관리
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<!-- 커뮤니티 관리 하위메뉴 열기 시작 -->
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/communityHome.adco" class="nav-link ${fn:contains(currentURI, 'communityHome') ? 'active' : ''}"> 
								게시글 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/commentList.adco" class="nav-link ${fn:contains(currentURI, 'commentList') ? 'active' : ''}">
								댓글 관리
							</a>
						</li>
					</ul>
					<!-- 커뮤니티 관리 하위메뉴 열기 끝 -->
				</li>
				<!-- 커뮤니티 관리 메뉴 끝 -->
				
				<!-- 고객 지원 메뉴 시작 : 하위 메뉴 있음 -->
				<li class="nav-item ${currentURI.contains('Inquiry') || currentURI.contains('Faq') ? 'menu-open' : ''}">
				    <a href="#" class="nav-link ${currentURI.contains('Inquiry') || currentURI.contains('Faq') ? 'active' : ''}"> 
				        <i class="fa-solid fa-comments"></i>
				            문의/FAQ 관리
				            <i class="right fas fa-angle-left"></i>
				    </a>
				    
				    <ul class="nav nav-treeview">
				        <li class="nav-item">
				            <a href="${path}/adInquiryList.adsp" class="nav-link ${currentURI.contains('Inquiry') ? 'active' : ''}">
				                1:1 문의 관리
				            </a>
				        </li>
				        
				        <li class="nav-item">
				            <a href="${path}/adFaqList.adsp" class="nav-link ${currentURI.contains('Faq') ? 'active' : ''}">
				                FAQ 관리
				            </a>
				        </li>
				    </ul>
				</li>
				<!-- 고객 지원 메뉴 끝 -->
				
				<!-- <li class="nav-item">
					<a href="#" class="nav-link active"> 
					<a href="#" class="nav-link"> 
						아이콘을 쓰고 싶다면 아래 주석 해제해서 메뉴에 맞는 아이콘 넣어서 사용
						<i class="nav-icon fas fa-tachometer-alt"></i>
						커뮤니티 관리 
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="#" class="nav-link"> 
								공지사항 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link">
								이벤트 관리
							</a>
						</li>
					</ul>
				</li> -->
				<!-- 커뮤니티 관리 메뉴 끝 -->
			</ul>
		</nav>
	</div>
</aside>

<!-- ================= JS ================= -->