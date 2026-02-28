<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 목록</title>
</head>
<body>

<script type="text/javascript">
	var path = "${path}";
</script>
<script src="${path}/resources/js/admin/reservation.js"></script>

<h3>getReservationList - list.jsp</h3>

<style>
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
    th { background-color: #f4f4f4; }
    .status-PENDING { color: orange; }
    .status-COMPLETED { color: blue; }
    .status-NOSHOW { color: red; }
    
    .badge {
    padding: 5px 10px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: bold;
    display: inline-block;
    min-width: 60px;
    text-align: center;
	}
.badge-success { background-color: #d4edda; color: #155724; } /* 확정 - 초록 */
.badge-warning { background-color: #fff3cd; color: #856404; } /* 대기 - 노랑 */
.badge-danger { background-color: #f8d7da; color: #721c24; }  /* 취소 - 빨강 */
.badge-secondary { background-color: #e2e3e5; color: #383d41; } /* 완료 - 회색 */
</style>
</head>
<body>

    <h2>예약 목록 관리</h2>

    <form action="${pageContext.request.contextPath}/reslist.ad" method="get">
        <input type="text" name="keyword" value="${param.keyword}" placeholder="아이디 또는 예약번호 검색">
        <button type="submit">검색</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>예약번호</th>
                <th>사용자 ID</th>
                <th>인원</th>
                <th>예약일시</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dto" items="${list}">
                <tr>
                    <td>${dto.reservation_id}</td>
                    <td>${dto.user_id}</td>
                    <td>${dto.guest_count}명</td>
					<td>
                    	<fmt:formatDate value="${dto.resDate}" pattern="yyyy-MM-dd HH:mm"/>
                	</td>
                	<td>
	                    <c:choose>
	                        <c:when test="${dto.status == 'RESERVED'}"><span class="badge badge-success">확정</span></c:when>
	                        <c:when test="${dto.status == 'PENDING'}"><span class="badge badge-warning">결제대기</span></c:when>
	                        <c:when test="${dto.status == 'CANCELLED'}"><span class="badge badge-danger">취소</span></c:when>
	                        <c:when test="${dto.status == 'COMPLETED'}"><span class="badge badge-secondary">이용완료</span></c:when>
	                        <c:otherwise><span class="badge badge-dark">${dto.status}</span></c:otherwise>
	                    </c:choose>
	
	                    <button type="button" class="btn btn-sm btn-outline-primary ml-2" 
	                            onclick="viewDetail('${dto.reservation_id}')">
	                        <i class="fas fa-eye"></i> 상세보기
	                    </button>
	                </td>
	            </tr>
	        </c:forEach>
        
        <c:if test="${empty list}">
            <tr>
                <td colspan="5">조회된 예약 내역이 없습니다.</td>
            </tr>
        </c:if>
    </tbody>
</table>

<!-- MODAL 창 HTML -->
<div class="modal fade" id="resDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">예약 상세 정보</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
			<div class="modal-body">
			    <table class="table table-bordered">
			        <tr>
			            <th class="table-light">예약번호</th>
			            <td id="modal_res_id" colspan="3"></td>
			        </tr>
			        <tr>
			            <th class="table-light">장소명</th>
			            <td id="modal_name"></td>
			            <th class="table-light">예약자ID</th>
			            <td id="modal_user_id"></td>
			        </tr>
			        <tr>
			            <th class="table-light">방문일</th>
			            <td id="modal_check_in"></td>
			            <th class="table-light">퇴실일</th>
			            <td id="modal_check_out"></td>
			        </tr>
			        <tr>
			            <th class="table-light">인원수</th>
			            <td id="modal_guest_count"></td>
			            <th class="table-light">예약상태</th>
			            <td id="modal_status"></td>
			        </tr>
			    </table>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>