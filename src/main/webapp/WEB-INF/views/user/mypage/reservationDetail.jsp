<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약상세</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet"
	href="${path}/resources/css/user/mypage/reservationDetail.css">
</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<div class="reservation_detail_wrap">
			<div class="reservation_detail_inner">

				<div class="page-header">
					<h2>
						<img src="${path}/resources/images/common/locationMarker.png"
							class="title-marker"> 예약 상세
					</h2>
				</div>

				<div class="reservation_card">

					<div class="reservation_image_area">
						<c:choose>
							<c:when test="${not empty dto.placeDTO.image_url}">
								<img src="${dto.placeDTO.image_url}" alt="장소 이미지"
									class="reservation_image">
							</c:when>
							<c:otherwise>
								<div class="no_image">이미지 준비중</div>
							</c:otherwise>
						</c:choose>
					</div>

					<div class="reservation_content_area">

						<div class="place_summary">
							<c:choose>
								<c:when test="${dto.placeDTO.place_type eq 'REST'}">
									<div class="place_type_badge badge_rest">맛집</div>
								</c:when>
								<c:when test="${dto.placeDTO.place_type eq 'ACC'}">
									<div class="place_type_badge badge_acc">숙소</div>
								</c:when>
								<c:when test="${dto.placeDTO.place_type eq 'FEST'}">
									<div class="place_type_badge badge_fest">축제</div>
								</c:when>
								<c:otherwise>
									<div class="place_type_badge">장소</div>
								</c:otherwise>
							</c:choose>

							<h3 class="place_name">${dto.placeDTO.name}</h3>
							<p class="place_address">${dto.placeDTO.address}</p>
						</div>

						<div class="detail_section">
							<h4 class="section_title">예약 정보</h4>

							<div class="detail_row">
								<div class="detail_label">예약번호</div>
								<div class="detail_value">${dto.reservation_id}</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">예약일</div>
								<div class="detail_value">
									<fmt:formatDate value="${dto.resDate}" pattern="yyyy-MM-dd" />
								</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">이용일정</div>
								<div class="detail_value">
									<fmt:formatDate value="${dto.check_in}" pattern="yyyy-MM-dd" />
									<c:if test="${not empty dto.check_out}">
										&nbsp;~&nbsp;
										<fmt:formatDate value="${dto.check_out}" pattern="yyyy-MM-dd" />
									</c:if>
								</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">방문시간</div>
								<div class="detail_value">
									<c:choose>
										<c:when test="${not empty dto.visit_time}">
											${dto.visit_time}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">인원</div>
								<div class="detail_value">${dto.guest_count}명</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">요청사항</div>
								<div class="detail_value request_note">
									<c:choose>
										<c:when test="${not empty dto.request_note}">
											${dto.request_note}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="detail_row">
								<div class="detail_label">예약상태</div>
								<div class="detail_value">
									<span
										class="status_badge
										<c:if test='${dto.status eq "PENDING"}'> pending</c:if>
										<c:if test='${dto.status eq "RESERVED"}'> reserved</c:if>
										<c:if test='${dto.status eq "COMPLETED"}'> completed</c:if>
										<c:if test='${dto.status eq "CANCELLED"}'> cancelled</c:if>
										<c:if test='${dto.status eq "NOSHOW"}'> noshow</c:if>
									">
										<c:choose>
											<c:when test="${dto.status eq 'PENDING'}">예약대기</c:when>
											<c:when test="${dto.status eq 'RESERVED'}">예약확정</c:when>
											<c:when test="${dto.status eq 'COMPLETED'}">이용완료</c:when>
											<c:when test="${dto.status eq 'CANCELLED'}">예약취소</c:when>
											<c:when test="${dto.status eq 'NOSHOW'}">미방문</c:when>
											<c:otherwise>${dto.status}</c:otherwise>
										</c:choose>
									</span>
								</div>
							</div>
						</div>

						<div class="delete_info">
							예약 취소 시 시점에 따라 <strong>취소 수수료</strong>가 발생할 수 있습니다.<br> 상세
							정책은 해당 장소의 운영 기준에 따라 달라질 수 있습니다.
						</div>

						<div class="button_area">
							<button type="button" class="btn_line"
								onclick="location.href='${path}/viewReservations.do'">목록으로</button>

							<c:choose>
								<c:when test="${dto.status eq 'COMPLETED'}">
									<c:choose>
										<c:when test="${surveyWrittenCnt > 0}">
											<button type="button" class="btn_disabled" disabled>리뷰
												완료</button>
										</c:when>
										<c:otherwise>
											<button type="button" class="btn_point"
												onclick="location.href='${path}/surveyReview.rv?reservation_id=${dto.reservation_id}'">
												리뷰쓰기</button>
										</c:otherwise>
									</c:choose>
								</c:when>

								<c:when test="${dto.status eq 'CANCELLED'}">
									<button type="button" class="btn_disabled" disabled>취소된
										예약</button>
								</c:when>

								<c:when test="${dto.status eq 'NOSHOW'}">
									<button type="button" class="btn_disabled" disabled>미방문</button>
								</c:when>

								<c:otherwise>
									<button type="button" class="btn_delete"
										onclick="if(confirm('정말 예약을 취소하시겠습니까?')) location.href='${path}/cancelReservationAction.do?reservation_id=${dto.reservation_id}'">
										예약취소</button>
								</c:otherwise>
							</c:choose>
						</div>

					</div>
				</div>

			</div>
		</div>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>