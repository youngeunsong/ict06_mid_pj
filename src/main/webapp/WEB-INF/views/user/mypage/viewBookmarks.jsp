<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 즐겨찾기</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<style>
    /* [1] 레이아웃 설정 */
    .my-favorite-section {
        max-width: 1200px;
        margin: 50px auto;
        padding: 0 20px;
        min-height: 600px; /* 목록이 없어도 푸터가 아래에 고정되도록 설정 */
    }

    /* [2] 상단 제목 영역 */
    .page-header {
        margin-bottom: 40px;
        border-bottom: 3px solid #0CB574;
        padding-bottom: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .page-header h2 {
        font-size: 28px;
        font-weight: 800;
        color: #222;
        margin: 0;
    }

    .page-header h2 i {
        color: #0CB574; /* 제목 옆 새싹 아이콘 색상 */
        margin-right: 12px;
    }

    /* 총 개수 표시 */
    .count-info { font-size: 16px; color: #666; }
    .count-info strong {
        color: #0CB574; /* 숫자만 초록색으로 강조 */
        font-size: 20px;
        font-weight: 800;
    }

    /* [3] 즐겨찾기 카드 그리드 */
    .bookmark-grid {
        display: grid;
        /* 화면 크기에 맞춰서 카드를 자동으로 정렬 (최소 280px) */
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 30px;
    }

    /* 카드 왼쪽 위 장소 타입 뱃지 */
    .type-tag {
        position: absolute;
        top: 15px;
        left: 15px;
        z-index: 10;
        background-color: #0CB574; /* 초록색 배경 */
        color: #fff;
        padding: 5px 14px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
        box-shadow: 0 2px 5px rgba(0,0,0,0.15);
    }

    /* [4] 즐겨찾기 목록이 비어있을 때 (데이터 없음) */
    .no-data {
        grid-column: 1 / -1; /* 그리드 칸을 가로로 길게 합침 */
        text-align: center;
        padding: 120px 0;
        background-color: #f0fbf7; /* 연한 초록색 배경 */
        border-radius: 15px;
        border: 1px dashed #0CB574; /* 초록색 점선 테두리 */
    }

    .no-data i { 
        font-size: 60px; 
        color: #0CB574; 
        margin-bottom: 25px;
        opacity: 0.7;
    }

    .no-data p {
        font-size: 18px;
        color: #555;
        margin-bottom: 25px;
    }

    /* [5] 0CB574 스타일 버튼 */
    .btn-sig {
        background-color: #0CB574; /* 초록색 버튼 */
        color: white !important;
        padding: 12px 40px;
        border-radius: 5px;
        font-weight: 600;
        font-size: 16px;
        transition: 0.3s;
        border: none;
        display: inline-block;
        text-decoration: none;
    }

    .btn-sig:hover {
        background-color: #098a58; /* 마우스 올렸을 때 조금 더 어두운 초록색 */
        transform: translateY(-3px); /* 위로 살짝 올라가는 효과 */
        box-shadow: 0 5px 15px rgba(12, 181, 116, 0.3);
    }
</style>
</head>
<body>
    <div class="wrap">
        <%-- 공통 헤더 포함 --%>
        <%@ include file="../../common/header.jsp"%>

        <section class="my-favorite-section">
            <div class="page-header">
                <h2><i class="fa-solid fa-seedling"></i>내 즐겨찾기</h2>
                
                <div class="count-info">
                    <%-- 전체 목록 개수를 실시간으로 계산해서 표시 --%>
                    전체 <strong>${fn:length(list)}</strong>곳의 소중한 장소들
                </div>
            </div>

            <div class="bookmark-grid">
                <%-- Controller에서 보낸 favoriteList를 하나씩 꺼내서 카드로 만듦 --%>
                <c:forEach var="place" items="${list}">
                    <div class="position-relative">
                        <%-- 장소 카테고리 (맛집, 숙소 등) 표시 --%>
                        <span class="type-tag">
                            <i class="fa-solid fa-location-dot me-1"></i> ${place.place_name}
                        </span>
                        
                        <%-- restCard 레이아웃 사용 --%>
                        <%@ include file="/WEB-INF/views/common/card/restCard.jsp" %>
                    </div>
                </c:forEach>

                <%-- 즐겨찾기한 장소가 아무것도 없을 때만 보여주는 화면 --%>
                <c:if test="${empty list}">
                    <div class="no-data">
                        <i class="fa-solid fa-heart-circle-plus"></i>
                        <p>아직 즐겨찾기에 담은 장소가 없네요.<br>당신만의 특별한 장소를 찾아보세요!</p>
                        <a href="${path}/main.do" class="btn btn-sig">홈 화면으로 가기</a>
                    </div>
                </c:if>
            </div>
        </section>

        <%-- 공통 푸터 포함 --%>
        <%@ include file="../../common/footer.jsp"%>
    </div>
</body>
</html>