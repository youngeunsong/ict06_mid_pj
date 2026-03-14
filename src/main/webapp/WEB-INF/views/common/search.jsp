<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>검색바 화면 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/search.css">
<link rel="stylesheet" href="${path}/resources/css/common/bookmark.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script> <!-- 아이콘 -->

<script src="${path}/resources/js/search/search.js" defer></script>
<script src="${path}/resources/js/search/bookmark.js" defer></script>

</head>
<body>
	<div class="wrap">
		<!-- header 시작 -->
		<%@ include file="header.jsp" %>
		<!-- header 끝 -->
		
		<!-- 컨텐츠 시작 -->
		<div class="container py-4" style="max-width:1000px;">
			<!-- 전체화면 : 기본화면S -->
			<section id="viewAllPage">
				<!-- 검색 결과 타이틀 -->
			    <div class="d-flex align-items-center gap-2 mb-3">
			        <h4 class="mb-0">“<span class="text-success fw-semibold" >${keyword}</span>”에 대한 검색결과 ${listCnt}개</h4>
			    </div>
				
				<br>
				
		    	<!-- 카테고리 필터 -->
			    <div class="chip-tabs d-flex flex-wrap gap-2 justify-content-center mb-3">
			        <button class="btn btn-outline-success active" onclick="openFilter('ALL')">전체</button>
			        <button class="btn btn-outline-success" onclick="openFilter('REST')">맛집</button>
			        <button class="btn btn-outline-success" onclick="openFilter('ACC')">숙소</button>
			        <button class="btn btn-outline-success" onclick="openFilter('FEST')">축제</button>
			    </div>
	    		<hr>
	    		
	    		<!-- 즐겨찾기 중, 로그인 여부를 따지기 위한 세션 값 히든 -->
	    		<input type="hidden" id="contextPath" value="${path}">
				<input type="hidden" id="loginUserId" value="${sessionScope.sessionID}">
			
		    	<!-- 맛집 섹션 S -->
			    <div class="d-flex justify-content-between align-items-center mb-3 mt-5">
			        <h5 class="fw-bold mb-0">맛집(${restListCnt})</h5>
			        <input type="hidden" id="restListCnt" value="${restListCnt}">
			    </div>
			
			    <div class="row g-3">
				    <c:forEach var="restDTO" items="${restList}" varStatus="st">
				        <div class="col-6 col-md-4 col-lg-3 searchRestCard ${st.index >= 8 ? 'd-none' : ''}">
						    <div class="search-card-wrap">
						        <a href="${path}/restaurantDetail.rs?place_id=${restDTO.place_id}" class="place-card text-decoration-none text-dark">
					                <div class="place-card__thumb-wrap position-relative">
					                    <img src="${restDTO.image_url}"
					                         class="thumb-img"
					                         alt="${restDTO.name}">
					
					                    <button type="button"
					                            class="bookmark-btn"
					                            data-place-id="${restDTO.place_id}"
					                            onclick="toggleBookmark(event, this)">
					                        <i class="${favoritePlaceIds.contains(restDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
					                    </button>
					                </div>
					
					                <div class="place-card__body">
					                    <div class="place-card__title">${restDTO.name}</div>
					
					                    <div class="place-card__address">
					                        <i class="bi bi-geo-alt-fill text-danger"></i>
					                        ${restDTO.address}
					                    </div>
					
					                    <div class="place-card__meta">
					                        <span><i class="fa-regular fa-eye"></i> ${restDTO.view_count}</span>
					                        <span><i class="fa-regular fa-heart"></i> <c:out value="${avgRatingMap[restDTO.place_id]}" default="0"/></span>
					                        <span><i class="fa-regular fa-comment"></i> <c:out value="${reviewCountMap[restDTO.place_id]}" default="0"/></span>
					                    </div>
					                </div>
				
				            	</a>
				            </div>
				        </div>
				    </c:forEach>
				</div>
			
		    	<!-- 더보기 버튼 -->
			    <div class="text-center mt-3">
			        <button class="btn btn-outline-secondary px-4" onclick="openFilter('REST')">
			        	전체보기 +
			        </button>
			    </div>
		    	<!-- 맛집 섹션 E -->
		    
		    	<!-- 숙소 섹션 S -->
		    	<div class="mt-5 mb-4">
				    <div class="d-flex justify-content-between align-items-center mb-3 mt-5">
				        <h5 class="fw-bold mb-0">숙소(${accListCnt})</h5>
				        <input type="hidden" id="accListCnt" value="${accListCnt}">
				    </div>
			
			    <div class="row g-3">
				    <c:forEach var="accDTO" items="${accList}" varStatus="st">
				       <div class="col-6 col-md-4 col-lg-3 searchAccCard ${st.index >= 8 ? 'd-none' : ''}">
						    <div class="search-card-wrap">
						        <a href="${path}/accommodationDetail.ac?place_id=${accDTO.place_id}" class="place-card text-decoration-none text-dark">
					                <div class="place-card__thumb-wrap position-relative">
					                    <img src="${accDTO.image_url}"
					                         class="thumb-img"
					                         alt="${accDTO.name}">
					
					                    <button type="button"
					                            class="bookmark-btn"
					                            data-place-id="${accDTO.place_id}"
					                            onclick="toggleBookmark(event, this)">
					                        <i class="${favoritePlaceIds.contains(accDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
					                    </button>
					                </div>
					
					                <div class="place-card__body">
					                    <div class="place-card__title">${accDTO.name}</div>
					
					                    <div class="place-card__address">
					                        <i class="bi bi-geo-alt-fill text-danger"></i>
					                        ${accDTO.address}
					                    </div>
					
					                    <div class="place-card__meta">
					                        <span><i class="fa-regular fa-eye"></i> ${accDTO.view_count}</span>
					                        <span><i class="fa-regular fa-heart"></i> <c:out value="${avgRatingMap[accDTO.place_id]}" default="0"/></span>
					                        <span><i class="fa-regular fa-comment"></i> <c:out value="${reviewCountMap[accDTO.place_id]}" default="0"/></span>
					                    </div>
					                </div>
				
				            	</a>
				            </div>
				        </div>
				    </c:forEach>
				</div>
			
		    	<!-- 더보기 버튼 -->
			    <div class="text-center mt-3">
			        <button class="btn btn-outline-secondary px-4" onclick="openFilter('ACC')">
			        	전체보기 +
			        </button>
			    </div>
		    	</div>
		    	<!-- 숙소 섹션 E -->
		    
		    
		    	<!-- 축제 섹션 S -->
		    	<div class="mt-5 mb-4">
				    <div class="d-flex justify-content-between align-items-center mb-3 mt-5">
				        <h6 class="fw-bold mb-0 fs-5">축제(${festListCnt})</h6>
				        <input type="hidden" id="festListCnt" value="${festListCnt}">
				        <a href="${path}/festival.fe" class="text-muted small text-decoration-none">전체 축제보기 ></a>
				    </div>
				
				    <!-- 캐러셀 -->
				    <div id="eventCarousel" class="carousel slide" data-bs-ride="false">
				
				        <div class="carousel-inner">
							<c:forEach var="festDTO" items="${festList}" varStatus="st">
								<!-- 4개 슬라이드 시작 -->
								<c:if test="${st.index % 4 == 0}">
						            <!-- 1페이지 (슬라이드 1) -->
						            <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
						                <div class="row g-3">
								</c:if>		
											<!-- 카드 -->					
						                    <div class="col-6 col-md-3">
											    <div class="search-card-wrap">
											        <a href="${path}/festivalDetail.fe?place_id=${festDTO.placeDTO.place_id}"
											           class="place-card text-decoration-none text-dark">
											
											            <div class="place-card__thumb-wrap position-relative">
											                <img src="${festDTO.placeDTO.image_url}"
											                     class="thumb-img"
											                     alt="${festDTO.placeDTO.name}">
											
											                <button type="button"
											                        class="bookmark-btn"
											                        data-place-id="${festDTO.placeDTO.place_id}"
											                        onclick="toggleBookmark(event, this)">
											                    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(festDTO.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
											                </button>
											
											                <span class="status-badge">${festDTO.status}</span>
											            </div>
											
											            <div class="place-card__body">
											                <div class="place-card__title">${festDTO.placeDTO.name}</div>
											
											                <div class="place-card__address">
											                    <i class="bi bi-geo-alt-fill text-danger"></i>
											                    ${festDTO.placeDTO.address}
											                </div>
											
											                <div class="place-card__meta">
											                    <span>${festDTO.start_date} ~ ${festDTO.end_date}</span>
											                </div>
											            </div>
											        </a>
											    </div>
											</div>
					                    <!-- 4개 슬라이드 닫기 -->
					            <c:if test="${st.index % 4 == 3 || st.last }">
					                    </div>
				    				</div>
					            </c:if>
				            </c:forEach>
				        
				        </div>
			
				        <!-- 하단 : 페이지 표시 + 화살표 -->
				        <div class="d-flex align-items-center justify-content-between mt-3">
			
				            <!-- 페이지 번호 표시 -->
				            <div class="d-flex align-items-center gap-2">
				                <span id="carouselPageInfo" class="fw-bold small">1 / 2</span>
				                <div class="progress" style="width:80px; height:4px;">
				                    <div id="carouselProgress"
				                         class="progress-bar bg-dark"
				                         style="width:50%;">
				                    </div>
				                </div>
				            </div>
			
				            <!-- 이전/다음 화살표 -->
				            <div class="d-flex gap-2">
				                <button class="btn btn-sm btn-outline-secondary rounded-circle"
				                        style="width:32px; height:32px; padding:0;"
				                        data-bs-target="#eventCarousel" data-bs-slide="prev">
				                    &#8249;
				                </button>
				                <button class="btn btn-sm btn-outline-secondary rounded-circle"
				                        style="width:32px; height:32px; padding:0;"
				                        data-bs-target="#eventCarousel" data-bs-slide="next">
				                    &#8250;
				                </button>
				            </div>
			        	</div>
			        <!-- 하단 : 페이지 표시 + 화살표 -->
			    </div>
			    <!-- 축제 섹션 E -->
			</section>
			<!-- 전체화면 : 기본화면E -->
			
			
			<!-- 필터(AJAX) 화면 : 처음엔 숨김 -->
			<section id="viewFilterPage" class="d-none">
			  <!-- 상단: 타이틀 + 정렬 -->
			  <div class="d-flex align-items-center justify-content-between gap-2 mb-3">
			    <h4 id="resultTitle" class="mb-0"></h4>
			
			    <div class="dropdown">
			      <button class="btn btn-sm btn-outline-secondary dropdown-toggle" id="sortLabel" data-bs-toggle="dropdown">
			        인기순
			      </button>
			      <ul class="dropdown-menu">
			        <li><button class="dropdown-item" onclick="changeSort('popular')">인기순</button></li>
			        <li><button class="dropdown-item" onclick="changeSort('latest')">최신순</button></li>
			      </ul>
			    </div>
			  </div>
			  
			  <br>
			
			  <!-- 카테고리 탭 -->
			  <div class="chip-tabs d-flex flex-wrap gap-2 justify-content-center mb-3">
			    <button class="btn btn-outline-success active" data-type="ALL">전체</button>
			    <button class="btn btn-outline-success" data-type="REST">맛집</button>
			    <button class="btn btn-outline-success" data-type="ACC">숙소</button>
			    <button class="btn btn-outline-success" data-type="FEST">축제</button>
			  </div>
			
			  <hr>
			
			  <!-- AJAX 결과 페이지 -->
			  <div id="ajaxResultWrap" class="mt-3"></div>
			
			  <input type="hidden" id="searchKeyword" value="${keyword}">
			</section>
		
		</div>
		<!-- 컨텐츠 끝 -->
		
		<!-- footer 시작 -->
		<%@ include file="footer.jsp" %>
		<!-- footer 끝 -->
		
		
	</div>
</body>
</html>