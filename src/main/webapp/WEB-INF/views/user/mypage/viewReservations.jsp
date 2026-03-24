<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 예약목록</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet"
	href="${path}/resources/css/user/mypage/viewReservations.css">
</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<section class="my-reservation-section">
			<div class="page-header">
				<h2>
					<i class="bi bi-calendar-check"></i> 내 예약목록
				</h2>
			</div>

			<!-- 상태 필터 -->
			<div class="filter-tabs">
				<button class="filter-tab ${empty status or status eq 'all' ? 'active' : ''}"
					onclick="filterReservation('all')">전체</button>

				<button class="filter-tab ${status eq 'RESERVED' ? 'active' : ''}"
					onclick="filterReservation('RESERVED')">예약확정</button>

				<button class="filter-tab ${status eq 'COMPLETED' ? 'active' : ''}"
					onclick="filterReservation('COMPLETED')">이용완료</button>

				<button class="filter-tab ${status eq 'CANCELLED' ? 'active' : ''}"
					onclick="filterReservation('CANCELLED')">취소</button>

				<button class="filter-tab ${status eq 'NOSHOW' ? 'active' : ''}"
					onclick="filterReservation('NOSHOW')">미방문</button>
			</div>

			<c:choose>
				<c:when test="${not empty list}">
					<div class="reservation-list">
						<c:forEach var="res" items="${list}">
							<div class="reservation-card"
								onclick="location.href='${path}/reservationDetail.do?reservation_id=${res.reservation_id}'">

								<div class="reservation-card-inner">

									<c:choose>
										<c:when test="${not empty res.placeDTO.image_url}">
											<div class="reservation-thumb"
												style="background-image:url('${res.placeDTO.image_url}');">
												<c:choose>
													<c:when test="${res.placeDTO.place_type eq 'REST'}">
														<span class="type-chip badge-rest">맛집</span>
													</c:when>
													<c:when test="${res.placeDTO.place_type eq 'ACC'}">
														<span class="type-chip badge-acc">숙소</span>
													</c:when>
													<c:when test="${res.placeDTO.place_type eq 'FEST'}">
														<span class="type-chip badge-fest">축제</span>
													</c:when>
													<c:otherwise>
														<span class="type-chip badge-etc">기타</span>
													</c:otherwise>
												</c:choose>
											</div>
										</c:when>
										<c:otherwise>
											<div class="reservation-thumb no-image">
												<c:choose>
													<c:when test="${res.placeDTO.place_type eq 'REST'}">
														<span class="type-chip badge-rest">맛집</span>
													</c:when>
													<c:when test="${res.placeDTO.place_type eq 'ACC'}">
														<span class="type-chip badge-acc">숙소</span>
													</c:when>
													<c:when test="${res.placeDTO.place_type eq 'FEST'}">
														<span class="type-chip badge-fest">축제</span>
													</c:when>
													<c:otherwise>
														<span class="type-chip badge-etc">기타</span>
													</c:otherwise>
												</c:choose>
												<i class="bi bi-image"></i>
											</div>
										</c:otherwise>
									</c:choose>

									<div class="reservation-content">
										<div class="reservation-top">
											<div>
												<h3 class="place-name">${res.placeDTO.name}</h3>
												<p class="place-address">
													<i class="bi bi-geo-alt"></i> ${res.placeDTO.address}
												</p>
											</div>

											<div>
												<c:choose>
													<c:when test="${res.status eq 'PENDING'}">
														<span class="badge-status badge-pending">예약 대기</span>
													</c:when>
													<c:when test="${res.status eq 'RESERVED'}">
														<span class="badge-status badge-reserved">예약 확정</span>
													</c:when>
													<c:when test="${res.status eq 'COMPLETED'}">
														<span class="badge-status badge-completed">이용 완료</span>
													</c:when>
													<c:when test="${res.status eq 'CANCELLED'}">
														<span class="badge-status badge-cancelled">예약 취소</span>
													</c:when>
													<c:when test="${res.status eq 'NOSHOW'}">
														<span class="badge-status badge-noshow">미방문</span>
													</c:when>
													<c:otherwise>
														<span class="badge-status badge-pending">${res.status}</span>
													</c:otherwise>
												</c:choose>
											</div>
										</div>

										<div class="reservation-meta">
											<div class="meta-line">
												<span class="meta-label">예약번호 :</span>
												<span class="meta-value">${res.reservation_id}</span>
											</div>

											<div class="meta-line">
												<span class="meta-label">예약일 :</span>
												<span class="meta-value">
													<fmt:formatDate value="${res.resDate}" pattern="yyyy-MM-dd" />
												</span>
											</div>

											<div class="meta-line">
												<span class="meta-label">이용일정 :</span>
												<span class="meta-value">
													<c:choose>
														<c:when test="${res.placeDTO.place_type eq 'ACC'}">
															<fmt:formatDate value="${res.check_in}" pattern="yyyy-MM-dd" />
															~
															<fmt:formatDate value="${res.check_out}" pattern="yyyy-MM-dd" />
														</c:when>
														<c:otherwise>
															<fmt:formatDate value="${res.check_in}" pattern="yyyy-MM-dd" />
														</c:otherwise>
													</c:choose>
												</span>
											</div>

											<div class="meta-line">
												<span class="meta-label">방문시간 / 인원 :</span>
												<span class="meta-value">
													<c:choose>
														<c:when test="${not empty res.visit_time}">
															${res.visit_time} / ${res.guest_count}명
														</c:when>
														<c:otherwise>
															- / ${res.guest_count}명
														</c:otherwise>
													</c:choose>
												</span>
											</div>
										</div>

										<c:if test="${not empty res.request_note}">
											<div class="request-inline">
												<span class="meta-label">요청사항 :</span>
												<span class="meta-value">${res.request_note}</span>
											</div>
										</c:if>

										<div class="payment-text">
											결제번호 :
											<c:choose>
												<c:when test="${not empty res.payment_id}">
													${res.payment_id}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</div>
									</div>

								</div>
							</div>
						</c:forEach>
					</div>

					<c:if test="${paging.pageCount > 1}">
						<div class="paging-wrap">
							<ul class="pagination">

								<c:if test="${paging.prev != 0}">
									<li class="page-item">
										<a class="page-link"
											href="${path}/viewReservations.do?pageNum=${paging.prev}&status=${status}">
											이전
										</a>
									</li>
								</c:if>

								<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
									<li class="page-item ${i == paging.currentPage ? 'active' : ''}">
										<a class="page-link"
											href="${path}/viewReservations.do?pageNum=${i}&status=${status}">
											${i}
										</a>
									</li>
								</c:forEach>

								<c:if test="${paging.next != 0 && paging.next <= paging.pageCount}">
									<li class="page-item">
										<a class="page-link"
											href="${path}/viewReservations.do?pageNum=${paging.next}&status=${status}">
											다음
										</a>
									</li>
								</c:if>

							</ul>
						</div>
					</c:if>
				</c:when>

				<c:otherwise>
					<div class="no-data">
						<i class="bi bi-calendar-x"></i>
						<p>
							아직 예약 내역이 없네요.<br>
							궁금한 장소가 있다면 상세 페이지에서 예약해 보세요!
						</p>
						<a href="${path}/main.do" class="btn-sig">홈 화면으로 가기</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<%@ include file="../../common/footer.jsp"%>
	</div>

	<script>
		function filterReservation(status) {
			location.href = '${path}/viewReservations.do?status=' + status;
		}
	</script>
</body>
</html>