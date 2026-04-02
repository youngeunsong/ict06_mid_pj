<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- ================= header ================= -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light border-bottom">
	<div class="container-fluid">

		<!-- Left -->
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" data-widget="pushmenu" href="#" role="button">
					<i class="fas fa-bars"></i>
				</a>
			</li>
			<li class="nav-item d-none d-md-block">
				<a href="${path}/adminHome.ad" class="nav-link" style="color: inherit;"></a>
			</li>
		</ul>

		<!-- Right -->
		<ul class="navbar-nav ml-auto">

			<!-- User Home 버튼 -->
			<li class="nav-item mr-2">
				<a href="${path}/main.do" class="nav-link btn btn-sm px-3 btn-user-home"
				   style="border-radius: 20px; font-size: 0.85rem;">
					<i class="fas fa-external-link-alt mr-1"></i>User Home
				</a>
			</li>

			<!-- 다크모드 토글 -->
			<li class="nav-item mr-1">
				<button id="darkModeToggle" type="button" class="nav-link btn btn-link"
						style="font-size: 1.2rem;" title="다크모드 전환">
					<i class="bi bi-moon-fill"></i>
				</button>
			</li>

			<!-- 알림 벨 -->
			<li class="nav-item dropdown mr-1">
				<a href="#" class="nav-link" data-toggle="dropdown" title="알림">
					<i class="bi bi-bell-fill" style="font-size: 1.2rem;"></i>
					<c:if test="${pendingCount > 0}">
						<span class="badge badge-danger navbar-badge">${pendingCount}</span>
					</c:if>
				</a>

				<div class="dropdown-menu dropdown-menu-right shadow" style="min-width: 300px;">
					<div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom">
						<span class="font-weight-bold">알림</span>
						<small class="text-muted">${pendingCount}건</small>
					</div>

					<div id="alarmList">
						<c:choose>
							<c:when test="${pendingCount > 0}">
								<a href="${path}/reservationList.ad?status=PENDING" class="dropdown-item py-2">
									<i class="bi bi-clock-history text-warning mr-2"></i>
									결제 대기 중인 예약이 <strong>${pendingCount}건</strong> 있습니다.
								</a>
							</c:when>
							<c:otherwise>
								<div class="text-center text-muted py-3">
									<i class="bi bi-bell-slash mb-1 d-block" style="font-size: 1.5rem;"></i>
									새로운 알림이 없습니다.
								</div>
							</c:otherwise>
						</c:choose>
					</div>

					<div class="border-top text-center py-2">
						<a href="${path}/reservationList.ad?status=PENDING" class="text-success"
						   style="font-size: 0.85rem;">
							결제대기 예약 전체보기
						</a>
					</div>
				</div>
			</li>

			<!-- 관리자 드롭다운 -->
			<li class="nav-item dropdown user-menu">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" style="color: inherit;">
					<i class="bi bi-person-circle" style="font-size: 1.4rem; color: #01D281;"></i>
					<span class="d-none d-md-inline ml-1">${sessionScope.sessionID}</span>
				</a>

				<ul class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
					<li class="user-header" style="background-color: #01D281">
						<i class="bi bi-person-circle" style="font-size: 4rem; color: #fff;"></i>
						<p>
							${sessionScope.sessionID}
							<small>관리자</small>
						</p>
					</li>

					<li class="user-footer">
						<div class="text-center py-2">
							<a href="${path}/adminMyPage.ad" class="btn btn-outline-secondary btn-sm">
								<i class="bi bi-person-gear mr-1"></i>프로필/비밀번호 변경
							</a>
						</div>
					</li>

					<li class="user-footer">
						<a href="${path}/logout.do" class="btn btn-danger btn-flat float-end">
							<i class="fas fa-power-off mr-1"></i>LOGOUT
						</a>
					</li>
				</ul>
			</li>

		</ul>
	</div>
</nav>

<script>
document.addEventListener('DOMContentLoaded', function () {

	/* body class 공통 강제 적용 */
	document.body.classList.add('hold-transition');
	document.body.classList.add('sidebar-mini');
	document.body.classList.add('layout-fixed');
	document.body.classList.add('sidebar-no-expand');

	/* 다크모드 */
	const darkBtn = document.getElementById('darkModeToggle');
	if (darkBtn) {
		const icon = darkBtn.querySelector('i');
		const isDark = localStorage.getItem('adminDarkMode') === 'true';

		function applyDark(dark) {
			if (dark) {
				document.body.classList.add('dark-mode');
				if (icon) {
					icon.classList.remove('bi-moon-fill');
					icon.classList.add('bi-sun-fill');
				}
				darkBtn.title = '라이트모드 전환';
			} else {
				document.body.classList.remove('dark-mode');
				if (icon) {
					icon.classList.remove('bi-sun-fill');
					icon.classList.add('bi-moon-fill');
				}
				darkBtn.title = '다크모드 전환';
			}
		}

		applyDark(isDark);

		darkBtn.addEventListener('click', function () {
			const nowDark = document.body.classList.contains('dark-mode');
			localStorage.setItem('adminDarkMode', !nowDark);
			applyDark(!nowDark);
		});
	}

	/* 햄버거 버튼 */
	const pushBtn = document.querySelector('[data-widget="pushmenu"]');
	if (pushBtn) {
		pushBtn.addEventListener('click', function (e) {
			e.preventDefault();
			document.body.classList.toggle('sidebar-collapse');
		});
	}
});
</script>
