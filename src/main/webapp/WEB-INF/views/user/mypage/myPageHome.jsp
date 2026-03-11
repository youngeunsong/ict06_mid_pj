<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 공통 설정 파일(경로, 태그라이브러리 등) 포함 --%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 | 맛침내!</title>
    <%-- 부트스트랩 및 폰트어썸 등 외부 라이브러리 설정 포함 --%>
    <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
    
    <style>
        /* CSS 변수 선언: 포인트 컬러를 한 곳에서 관리 */
        :root { --point-color: #0CB574; }
        
        /* 전체 배경색 및 폰트 설정 */
        body { background-color: #f8f9fa; font-family: 'Pretendard', sans-serif; }
        
        /* 프로필 카드: 초록색 배경과 그림자 효과 */
        .profile_card { 
            background: var(--point-color); border-radius: 20px; color: white; 
            box-shadow: 0 8px 16px rgba(12, 181, 116, 0.2); 
        }
        
        /* 프로필 이미지: 원형 테두리와 반투명 배경 */
        .profile_img { 
            width: 80px; height: 80px; background: rgba(255,255,255,0.2); 
            border-radius: 50%; border: 2px solid rgba(255,255,255,0.5);
            display: flex; align-items: center; justify-content: center; margin: 0 auto;
        }
        
        /* 활동 아이템(즐겨찾기 등): 마우스 올리면 위로 살짝 올라가는 효과 */
        .activity_item { 
            border-radius: 20px; transition: 0.3s; cursor: pointer; border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        .activity_item:hover { transform: translateY(-5px); border: 1px solid var(--point-color); }
        
        /* 아이콘 박스: 둥근 배경 안에 아이콘 배치 */
        .icon_box { 
            width: 50px; height: 50px; background: #f0fdf4; border-radius: 50%; 
            display: flex; align-items: center; justify-content: center; margin: 0 auto;
            position: relative; /* 뱃지 위치의 기준점 */
        }
        
        /* 숫자 뱃지: 아이콘 오른쪽 상단에 작게 표시 */
        .count_badge { position: absolute; top: -5px; right: -5px; font-size: 10px; }
        
        /* 맛집 카드: 공통 카드 디자인 */
        .custom_card { border-radius: 15px; overflow: hidden; border: none; box-shadow: 0 4px 10px rgba(0,0,0,0.05); transition: 0.3s; height: 100%; }
        .custom_card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
        
        /* 카드 이미지 영역: 배경이미지로 꽉 채움 */
        .card_img { height: 160px; background-size: cover; background-position: center; position: relative; background-color: #eee; }
        
        /* 순위 뱃지 (BEST 1 등): 이미지 왼쪽 상단 검은색 라벨 */
        .rank_badge { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.7); color: white; font-size: 11px; padding: 2px 8px; border-radius: 5px; }
    </style>
</head>
<body>
<!-- 
<부트스트랩>
m : Margin(바깥쪽 여백), p : Padding(안쪽 여백)
t (top): 위 / b (bottom): 아래 / s (start): 왼쪽 / e (end): 오른쪽
x: 좌우 / y: 위아래 / (없음): 상하좌우 전체
g : Gutter -> 부트스트랩의 row 안에서 자식 요소(col)들 사이의 간격
 -->

    <div class="wrap">
        <%-- 공통 헤더 포함 --%>
        <%@ include file="../../common/header.jsp"%>

        <%-- 메인 컨테이너: 상하 여백(my-5) --%>
        <div class="container my-5">
            <%-- 그리드 시스템 시작: 간격(g-4) --%>
            <div class="row g-4">
                
                <aside class="col-lg-3">
                    <%-- 프로필 정보 표시 섹션 --%>
                    <div class="profile_card p-4 text-center mb-4">
                        <div class="profile_img mb-3"><i class="fa-solid fa-user fa-2x"></i></div>
                        <p class="mb-1 small">반가워요!</p>
                        <h3 class="fw-bold h4 mb-3">${sessionID} 님</h3>
                        <a href="${path}/modifyUser.do" class="btn btn-light btn-sm rounded-pill fw-bold px-3 text-success">정보 수정/탈퇴</a>
                    </div>
                    
                    <%-- 캘린더 요약 섹션 --%>
                    <div class="card border-0 shadow-sm p-4 rounded-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0">2026년 3월</h5>
                            <i class="fa-regular fa-calendar-days text-secondary"></i>
                        </div>
                        <%-- 추후 캘린더 라이브러리가 들어갈 자리 --%>
                        <div class="bg-light rounded-3 d-flex align-items-center justify-content-center text-muted" style="height: 250px; border: 2px dashed #e9ecef;">
                            <p class="small">캘린더 공간</p>
                        </div>
                    </div>
                </aside>

                <main class="col-lg-9">
                    
                    <h4 class="fw-bold mb-4">나의 활동현황</h4>
                    <div class="row g-3 mb-5 text-center">
                        <div class="col-md-4">
                            <div class="card activity_item p-4" onclick="location.href='${path}/viewBookmarks.do'">
                                <div class="icon_box mb-3">
                                    <i class="fa-regular fa-heart text-success fs-4"></i>
                                    <span class="badge rounded-pill bg-primary count_badge">0</span>
                                </div>
                                <span class="fw-bold">즐겨찾기</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card activity_item p-4" onclick="location.href='${path}/viewReservations.do'">
                                <div class="icon_box mb-3">
                                    <i class="fa-regular fa-calendar-check text-success fs-4"></i>
                                    <span class="badge rounded-pill bg-primary count_badge">0</span>
                                </div>
                                <span class="fw-bold">예약 목록</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card activity_item p-4" onclick="location.href='${path}/viewInquiries.do'">
                                <div class="icon_box mb-3">
                                    <i class="fa-regular fa-envelope text-success fs-4"></i>
                                    <span class="badge rounded-pill bg-primary count_badge">0</span>
                                </div>
                                <span class="fw-bold">1:1 문의</span>
                            </div>
                        </div>
                    </div>

					<!-- 나중에 foreach문으로 카드 3개 반복 예정  -->
                    <h4 class="fw-bold mb-4">내가 최근 본 콘텐츠</h4>
                    <div class="row g-3 mb-5">
                        <div class="col-md-4">
                            <div class="card custom_card">
                                <div class="card_img" style="background-image: url('https://picsum.photos/id/429/300/200');"></div>
                                <div class="card-body p-3">
                                    <%-- text-truncate: 긴 제목은 ...으로 생략 --%>
                                    <p class="fw-bold mb-0 text-truncate" style="font-size: 1.05rem;">장어의꿈</p>
                                    <%-- d-block mt-1: 주소를 무조건 다음 줄로 보내고 약간의 간격 추가 --%>
                                    <small class="text-muted d-block mt-1">경기 남양주시</small>
                                </div>
                            </div>
                        </div>
                        </div>

                    <h4 class="fw-bold mb-4">맛침내! 베스트 추천 맛집</h4>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="card custom_card">
                                <div class="card_img" style="background-image: url('https://picsum.photos/id/488/300/200');">
                                    <span class="rank_badge">BEST 1</span>
                                </div>
                                <div class="card-body p-3">
                                    <p class="fw-bold mb-0 text-truncate" style="font-size: 1.05rem;">속초 중앙시장 닭강정</p>
                                    <small class="text-muted d-block mt-1">강원 속초시</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <%-- 공통 푸터 포함 --%>
        <%@ include file="../../common/footer.jsp"%>
    </div>
</body>
</html>