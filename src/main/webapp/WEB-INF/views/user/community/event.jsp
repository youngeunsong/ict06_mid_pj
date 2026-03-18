<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 반응형 적용 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 - 이벤트</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/community/event.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script> <!-- 아이콘 -->

<script src="${path}/resources/js/community/event.js" defer></script>

</head>
<body>
<div class="wrap">

    <!-- header -->
    <%@ include file="../../common/header.jsp"%>

    <!-- 탭 -->
    <div class="comm-tabs">
        <div class="container">
            <a href="${path}/community_free.co" class="tab ${tab eq 'free' ? 'on' : ''}">자유게시판</a>
            <a href="${path}/community_notice.co" class="tab ${tab eq 'notice' ? 'on' : ''}">공지사항</a>
            <a href="${path}/community_event.co" class="tab ${tab eq 'event' ? 'on' : ''}">이벤트</a>
        </div>
    </div>

    <!-- 본문 -->
    <div class="page-body">
        <div class="container">

            <!-- 경로 -->
            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right" style="font-size: .65rem;"></i>
                <span class="cur">이벤트</span>
            </div>

            <!-- 페이지 타이틀 -->
            <div class="page-title">
                <i class="bi bi-gift-fill text-warning me-1"></i> 이벤트
            </div>

            <!-- 진행 중인 이벤트 -->
            <div class="ongoing-section">
                <div class="section-label">
                    <i class="bi bi-fire text-warning"></i> 진행 중인 이벤트
                </div>

                <div style="display: flex; flex-direction: column; gap: 10px;">

                    <a href="#" class="ongoing-card">
                        <div class="ongoing-img">
                            <img src="https://images.unsplash.com/photo-1522199755839-a2bacb67c546?w=600&q=80" alt="">
                        </div>
                        <div class="ongoing-info">
                            <div>
                                <div class="ongoing-badges">
                                    <span class="bdg bdg-event"><i class="bi bi-gift"></i> 이벤트</span>
                                    <span class="bdg bdg-ongoing">🟢 진행 중</span>
                                    <span class="bdg bdg-pin">📌 고정</span>
                                </div>
                                <div class="ongoing-title">🌸 봄맞이 여행 후기 이벤트 – 최대 5만 포인트 증정</div>
                                <div class="ongoing-desc">
                                    봄 여행을 다녀오셨나요? 맛집내에 여행 후기를 남겨주시면 추첨을 통해 최대 5만 포인트를 드립니다! 지금 바로 참여하세요.
                                </div>
                            </div>
                            <div class="ongoing-meta">
                                <span><i class="bi bi-calendar3"></i> ~ 2026.03.31</span>
                                <span><i class="bi bi-eye"></i> 8,420</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="ongoing-card">
                        <div class="ongoing-img">
                            <img src="https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&q=80" alt="">
                        </div>
                        <div class="ongoing-info">
                            <div>
                                <div class="ongoing-badges">
                                    <span class="bdg bdg-event"><i class="bi bi-gift"></i> 이벤트</span>
                                    <span class="bdg bdg-ongoing">🟢 진행 중</span>
                                    <span class="bdg bdg-pin">📌 고정</span>
                                </div>
                                <div class="ongoing-title">친구 초대하고 포인트 받기 이벤트 (~ 3/31)</div>
                                <div class="ongoing-desc">
                                    친구에게 맛집내를 소개하고 함께 포인트를 받아보세요. 친구가 가입 완료 시 양쪽 모두에게 포인트가 적립됩니다.
                                </div>
                            </div>
                            <div class="ongoing-meta">
                                <span><i class="bi bi-calendar3"></i> ~ 2026.03.31</span>
                                <span><i class="bi bi-eye"></i> 5,310</span>
                            </div>
                        </div>
                    </a>

                </div>
            </div>

            <!-- 종료된 이벤트 -->
            <div class="ended-section">
                <div class="section-label">
                    <i class="bi bi-clock-history" style="color: #adb5bd;"></i>
                    <span style="color: #adb5bd;">종료된 이벤트</span>
                </div>

                <div class="event-grid">

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <img src="https://images.unsplash.com/photo-1545987796-200677ee1011?w=400&q=70" alt="">
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">설날 특집 여행지 추천 이벤트 – 당첨자 발표</div>
                            <div class="event-card-meta">
                                <span>~2026.02.14</span>
                                <span><i class="bi bi-eye me-1"></i>12,430</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <img src="https://images.unsplash.com/photo-1483389127117-b6a2102724ae?w=400&q=70" alt="">
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">겨울 여행 사진 공모전 – 최우수상 항공권 증정</div>
                            <div class="event-card-meta">
                                <span>~2026.01.31</span>
                                <span><i class="bi bi-eye me-1"></i>9,870</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <img src="https://images.unsplash.com/photo-1496275068113-fff8c90750d1?w=400&q=70" alt="">
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">맛집내 출시 1주년 감사 이벤트 – 포인트 100% 증정</div>
                            <div class="event-card-meta">
                                <span>~2025.12.31</span>
                                <span><i class="bi bi-eye me-1"></i>21,040</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <div class="img-placeholder">
                                <i class="bi bi-gift"></i>
                            </div>
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">연말 여행 설문 참여 이벤트 – 스타벅스 쿠폰 증정</div>
                            <div class="event-card-meta">
                                <span>~2025.12.15</span>
                                <span><i class="bi bi-eye me-1"></i>7,550</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <img src="https://images.unsplash.com/photo-1530789253388-582c481c54b0?w=400&q=70" alt="">
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">가을 단풍 여행지 추천 이벤트</div>
                            <div class="event-card-meta">
                                <span>~2025.11.30</span>
                                <span><i class="bi bi-eye me-1"></i>6,130</span>
                            </div>
                        </div>
                    </a>

                    <a href="#" class="event-card ended">
                        <div class="event-card-img">
                            <div class="img-placeholder">
                                <i class="bi bi-gift"></i>
                            </div>
                            <div class="status-overlay">
                                <span class="bdg bdg-end">종료</span>
                            </div>
                        </div>
                        <div class="event-card-body">
                            <div class="event-card-title">첫 리뷰 작성 이벤트 – 포인트 2배 적립</div>
                            <div class="event-card-meta">
                                <span>~2025.10.31</span>
                                <span><i class="bi bi-eye me-1"></i>4,820</span>
                            </div>
                        </div>
                    </a>

                </div>
            </div>

            <!-- 페이지네이션 -->
            <div class="paging">
                <a class="pg">‹</a>
                <a class="pg on">1</a>
                <a class="pg">2</a>
                <a class="pg">›</a>
            </div>

            <!-- 검색 -->
            <div class="search-row">
                <div class="search-box">
                    <input type="text" placeholder="이벤트 검색">
                    <button type="button">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- footer -->
    <%@ include file="../../common/footer.jsp"%>

</div>
</body>
</html>