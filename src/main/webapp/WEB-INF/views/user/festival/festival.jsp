<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-26
 * 참고 코드: bestRestaurants.jsp의 css, restaurant.jsp
지도를 이용해 내 위치 주변 축제 위주로 조회   
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>맛침내-축제 지도 탐색</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="${path}/resources/css/user/festival/festival.css"/>
<link rel="stylesheet" href="${path}/resources/css/user/restaurant/restaurant.css">

<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services&autoload=false"></script>
<!-- [JS에서 사용할 공통 path 설정] -->
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- 카카오지도 API 처리 JS 코드 -->
<script type="text/javascript">
// 전역 변수 설정: 지도 객체, 마커 배열, 오버레이 상태 등 관리
var map;
var markers = [];
var myCustomOverlay = null; 
var isClickMoving = false;

// JSP에서 전달된 북마크 리스트 (로그인 유저의 찜 목록)를 문자열 배열로 관리
var favoritePlaceIds = ${not empty favoritePlaceIds ? favoritePlaceIds : '[]'}.map(String);

// 로컬 스토리지에서 이전 검색 설정 불러오기 (없으면 기본값 설정)
var savedConfig = localStorage.getItem("resSearchConfig");
var currentSearchConfig = savedConfig ? JSON.parse(savedConfig) : {
    lat: ${not empty userLat ? userLat : 37.5665},
    lng: ${not empty userLng ? userLng : 126.9780},
    radius: 5.0, 
    minRating: 0.0, 
    keyword: "", 
    pageNum: 1
};
	
// 현재 검색 설정을 브라우저 로컬 스토리지에 저장하는 함수
function saveToLocal() {
    localStorage.setItem("resSearchConfig", JSON.stringify(currentSearchConfig));
}

$(document).ready(function() {
    // 카카오맵 SDK 로드 후 실행
    kakao.maps.load(function() {
        // 기존 설정값들을 UI 요소에 반영
        $("#keywordInput").val(currentSearchConfig.keyword);
        $("#ratingSelect").val(currentSearchConfig.minRating.toFixed(1));
        updateDistanceUI(currentSearchConfig.radius);
        // 지도 생성 및 중심좌표 설정
        var mapContainer = document.getElementById('map');
        map = new kakao.maps.Map(mapContainer, {
            center: new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng),
            level: 5
        });

        // 브라우저 Geolocation을 이용해 사용자 현재 위치 파악
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(pos) {
                currentSearchConfig.lat = pos.coords.latitude;
                currentSearchConfig.lng = pos.coords.longitude;
                var newCenter = new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng);
                map.setCenter(newCenter);
                saveToLocal();
                
             	// 사용자 현재 위치를 마커로 표시 시작 ------------------
             	// 마커 이미지 변경
		        var imageSrc = '${path}/resources/images/common/myLocation.png', // 마커이미지의 주소입니다    
			    imageSize = new kakao.maps.Size(64, 62), // 마커이미지의 크기입니다
			    imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
		      
				// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
				var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
		    	markerPosition = new kakao.maps.LatLng(37.54699, 127.09598); // 마커가 표시될 위치입니다
		        
		        // 4. 현재 위치 마커로 표시 
		        var marker = new kakao.maps.Marker({  
		            map: map, 
		            position: newCenter,
		            image: markerImage
		        });
		     	// 사용자 현재 위치를 마커로 표시 끝 ------------------
             	 
                refreshAll(); // 데이터 갱신
            }, function() {
                refreshAll(); // 위치 권한 거부 시 기존 중심좌표로 갱신
            });
        } else {
            refreshAll();
       }

        // 지도가 이동을 멈췄을 때(idle) 발생하는 이벤트: 현재 위치 기준으로 재검색
        kakao.maps.event.addListener(map, 'idle', function() {
            if (isClickMoving) return; // 마커 클릭으로 인한 이동 시에는 무시
            var center = map.getCenter();
            currentSearchConfig.lat = center.getLat();
            currentSearchConfig.lng = center.getLng();
            saveToLocal();
            refreshAll();
        });
    });

    // 동적으로 생성된 북마크 버튼에 대한 클릭 이벤트 핸들러 (Ajax 처리)
    $(document).on('click', '.bookmark-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();

        const btn = $(this);
        const placeId = String(btn.attr('data-place-id')); 
        const icon = btn.find('i');

        $.ajax({
            url: "${path}/favoriteToggle.fe",
            type: "POST",
            data: { "place_id": placeId },
            success: function(res) {
                if (res.needLogin) {
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${path}/login.do";  
                    return;
                }
                if (res.ok) {
                    if (res.favorite) {
                        // 즐겨찾기 추가 시: 초록색 아이콘으로 변경
                        icon.removeClass('fa-regular text-muted').addClass('fa-solid text-success')
                            .css('color', '#00E600');
                        if(!favoritePlaceIds.includes(placeId)) favoritePlaceIds.push(placeId);
                    } else {
                        // 즐겨찾기 해제 시: 회색 빈 아이콘으로 변경
                        icon.removeClass('fa-solid text-success').addClass('fa-regular text-muted')
                            .css('color', '#dee2e6');
                        favoritePlaceIds = favoritePlaceIds.filter(id => id !== placeId);
                    }
                }
            },
            error: function() {
                alert("통신 중 오류가 발생했습니다.");
            }
        });
    });
});

// 반경 선택 바(UI)의 시각적 위치를 업데이트하는 함수
function updateDistanceUI(radius) {
    var percent = 0;
    var label = "5k";
    if(radius == 1.0) { percent = 0; label = "1k"; }
    else if(radius == 5.0) { percent = 25; label = "5k"; }
    else if(radius == 10.0) { percent = 50; label = "10k"; }
    else if(radius == 50.0) { percent = 75; label = "50k"; }
    else if(radius == 100.0) { percent = 100; label = "All"; }

    $('#activeLine').css('width', percent + '%');
    $('.dist-node').removeClass('active');
    $(`.dist-node[data-label="${label}"]`).addClass('active');
}	

// 필터 영역(별점)을 슬라이드 애니메이션으로 열고 닫음
function toggleFilter() { $("#filterArea").slideToggle(200); }

// 반경 노드를 클릭했을 때 거리 설정 및 재검색
function setDistance(val, percent, element) {
    currentSearchConfig.radius = val;
    updateDistanceUI(val);
    saveToLocal();
    searchData();
}

// 검색 버튼 클릭 또는 필터 변경 시 실행되는 메인 검색 함수
function searchData(filterType) { 
    const ratingSelect = $("#ratingSelect");

    currentSearchConfig.keyword = $("#keywordInput").val(); 
    currentSearchConfig.minRating = parseFloat(ratingSelect.val());
    currentSearchConfig.pageNum = 1; // 검색 시 1페이지부터 시작
    saveToLocal();
    refreshAll(); 
}

// 지도 마커와 하단 리스트를 동시에 갱신하는 함수
function refreshAll() {
    // 1. 지도에 표시할 마커 데이터 가져오기 (JSON)
    $.ajax({
        url:  "${path}/getNearbyFeMarkersAjax.fe",
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "json",
        success: function(data) { updateMarkers(data); }
    });
    // 2. 하단 리스트 영역 갱신 (HTML 조각)
    $.ajax({
        url:  "${path}/festivalAjax.fe",
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "html",
        success: function(html) { $("#resListArea").html(html); }
    });
}

// 지도에 마커를 배치하고 클릭 이벤트를 연결하는 함수
function updateMarkers(data) {
    // 기존 마커 및 커스텀 오버레이 초기화
    if (markers && markers.length > 0) {
        markers.forEach(m => m.setMap(null));
    }
    markers = [];
    if (myCustomOverlay) myCustomOverlay.setMap(null);

    if (!data || data.length === 0) {
        console.warn("표시할 축제 데이터가 없습니다.");
        return;
    }
  	
    // 커스텀 마커 이미지 설정 (대형 사이즈 적용)
    var imageSrc = '${path}/resources/images/user/restaurant/markerImage.png'; 
    var imageSize = new kakao.maps.Size(160, 50); 
    var imageOption = { offset: new kakao.maps.Point(80, 50) }; 
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

    // 전달받은 맛집 데이터를 순회하며 마커 생성
    data.forEach(function(res) {
        var p = res.placeDTO || res.placedto || res;
        if (!p || !p.latitude || !p.longitude) return;
        
        var coords = new kakao.maps.LatLng(Number(p.latitude), Number(p.longitude));
        
        var marker = new kakao.maps.Marker({
            position: coords,
            map: map,
            image: markerImage
        });

        marker.placeId = String(p.place_id);

        // 마커 클릭 시 상세 정보를 보여주는 커스텀 오버레이 생성
        kakao.maps.event.addListener(marker, 'click', function() {
            isClickMoving = true;
            if (myCustomOverlay) myCustomOverlay.setMap(null);
            
            // 이미지 경로 처리 (기본 이미지 대응)
            var imgPath = p.image_url && p.image_url !== 'null' ? 
                          (p.image_url.startsWith('http') ? p.image_url : '${path}/resources/images/common/' + p.image_url) : 
                           '${path}/resources/images/common/no-image.png';

            var isFav = favoritePlaceIds.includes(String(p.place_id));

            // 오버레이 내부 HTML 구조 (맛집 정보, 북마크, 상세보기 버튼 등)
            var content = `
                <div class="custom-overlay-card">
                    <div style="position:relative; margin-bottom:12px;">
                        <img src="\${imgPath}" style="width:100%; height:110px; object-fit:cover; border-radius:12px;" onerror="this.src='${path}/resources/images/common/no-image.png'">
                        
                        <button type="button" class="bookmark-btn" data-place-id="\${p.place_id}">
                            <i class="\${isFav ? 'fa-solid text-success' : 'fa-regular text-muted'} fa-bookmark" 
                               style="color: \${isFav ? '#00E600' : '#ccc'} !important;"></i>
                        </button>

                        <div onclick="closeMyOverlay()" style="position:absolute; top:-10px; right:-10px; cursor:pointer; background:white; width:26px; height:26px; border-radius:50%; text-align:center; line-height:24px; border:1px solid #eee; font-weight:bold; box-shadow:0 2px 5px rgba(0,0,0,0.1); z-index:1001;">×</div>
                    </div>
                    <div style="text-align:left; padding:0 4px;">
                        <div style="font-weight:bold; font-size:16px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">\${p.name}</div>
                        <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid #f0f0f0; padding-top:10px; font-size:12px;">
                            <div style="display:flex; gap:10px; color:#666;">
                                <span><i class="fa-regular fa-eye text-primary"></i> \${p.view_count || 0}</span>
                                <span><i class="fa-regular fa-star text-warning"></i> \${p.avg_rating || 0.0}</span>
                                <span><i class="fa-regular fa-comment" style="color:#00E600;"></i> \${p.review_count || 0}</span>
                            </div>
                        </div>
                    </div>
                    <button onclick="location.href='${path}/festivalDetail.fe?place_id=\${p.place_id}'" 
                            style="width:100%; margin-top:12px; border:none; background:#00E600 !important; color:white !important; padding:10px; border-radius:10px; font-weight:bold; cursor:pointer;">상세보기</button>
                </div>`;

            myCustomOverlay = new kakao.maps.CustomOverlay({ 
                content: content, 
                map: map, 
                position: marker.getPosition(), 
                xAnchor: 0.5, // 가로 중앙 정렬 (이게 빠지면 왼쪽으로 치우침)
                yAnchor: 1.0  // 1.0은 카드 본체 하단, 1.1 정도 주어야 10px 삼각형 꼬리까지 포함해서 마커 위에 뜸 
            });
         	// 2. ★ 자연스러운 이동을 위한 좌표 계산
            var projection = map.getProjection();
            var markerPoint = projection.pointFromCoords(coords); // 마커의 화면상 픽셀 좌표
            
            // 마커가 화면 아래에 오도록, 중심점을 마커보다 150px 위로 잡음
            var targetPoint = new kakao.maps.Point(markerPoint.x, markerPoint.y - 150);
            var targetCoords = projection.coordsFromPoint(targetPoint);

            // 3. 딱 한 번만 부드럽게 이동
            map.panTo(targetCoords); 

            setTimeout(() => isClickMoving = false, 500);
        });
        markers.push(marker);
    });

    console.log("대형 마커 로드 완료: " + markers.length + "개");
}

// 리스트의 항목 클릭 시 지도상의 해당 마커로 이동 및 상세 정보 표시
function showMarkerDetail(placeId) {
    const targetMarker = markers.find(m => String(m.placeId) === String(placeId));
    if (targetMarker) {
        kakao.maps.event.trigger(targetMarker, 'click');
        $('html, body').animate({ scrollTop: $("#map").offset().top - 180 }, 400);
    }
}

// 열려있는 커스텀 오버레이를 닫는 함수
function closeMyOverlay() { if (myCustomOverlay) myCustomOverlay.setMap(null); }

// 내 위치 찾기 버튼 클릭 시 사용자 현위치 재설정
function findMyLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(pos) {
            currentSearchConfig.lat = pos.coords.latitude;
            currentSearchConfig.lng = pos.coords.longitude;
            map.setCenter(new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng));
            saveToLocal();
            refreshAll();
        }, function() { refreshAll(); });
    } else { refreshAll(); }
}

// 모든 필터 조건 초기화 함수
function resetFilters() {
    $("#keywordInput").val(""); 
    $("#ratingSelect").val("0.0").prop('disabled', false).css('opacity', '1');
    updateDistanceUI(5.0); 

    currentSearchConfig.keyword = "";
    currentSearchConfig.minRating = 0.0;
    currentSearchConfig.radius = 5.0;
    currentSearchConfig.pageNum = 1;

    localStorage.removeItem("resSearchConfig"); 
    saveToLocal();
    if (myCustomOverlay) myCustomOverlay.setMap(null);
    refreshAll();
}

// 페이지네이션 번호 클릭 시 해당 페이지 데이터 로드
function changePage(page) {
    currentSearchConfig.pageNum = page;
    saveToLocal();
    $.ajax({
        url:  "${path}/festivalAjax.fe", 
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "html",
        success: function(html) {
            $("#resListArea").html(html);
            // 리스트 영역으로 부드럽게 스크롤 이동
            $('html, body').animate({ scrollTop: $("#resListArea").offset().top - 100 }, 300);
        }
    });
}
</script>

<!-- 지도용 js -->
<%-- <script src="${path}/resources/js/festival/festivalMap.js"></script> --%>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>
		
		<div class="content-wrapper">
			<!-- 내 주변 / 축제 랭킹 페이지 전환 탭 시작 -->
			<div class="main-tab-wrapper" style="display: flex; justify-content: center; margin-bottom: 30px;">
	            <div class="nav-pill-group" 
	                 onclick="location.href='${path}/bestFestivals.fe'" 
	                 style="cursor: pointer;">
	                <div class="nav-pill-item active">내 주변</div>
	                <div class="nav-pill-item best-link">베스트 축제</div>
	            </div>
	        </div>
			<!-- 내 주변 / 축제 랭킹 페이지 전환 탭 끝 -->
		
			<!-- 검색 설정 영역 시작 -->
			<div class="search-container">
				<!-- 검색 설정 주요 행 시작 -->
				<div class="search-main-row">
					<!-- 검색창 -->
	                <div class="search-input-group">
	                    <input type="text" id="keywordInput" placeholder="축제를 검색하세요" onkeyup="if(event.keyCode==13)searchData()">
	                    <i class="fa fa-search text-muted" onclick="searchData()"></i>
	                </div>
	
					<!-- 반경 제어 필터 -->	
	                <div class="distance-filter">
	                    <span class="distance-label">반경</span>
	                    <div class="step-wrapper">
	                        <div class="step-line-bg"></div>
	                        <div id="activeLine" class="step-line-active"></div>
	                        <div class="step-nodes">
	                            <div class="dist-node" data-label="1k" onclick="setDistance(1.0, 0, this)"></div>
	                            <div class="dist-node" data-label="5k" onclick="setDistance(5.0, 25, this)"></div>
	                            <div class="dist-node" data-label="10k" onclick="setDistance(10.0, 50, this)"></div>
	                            <div class="dist-node" data-label="50k" onclick="setDistance(50.0, 75, this)"></div>
	                            <div class="dist-node" data-label="All" onclick="setDistance(100.0, 100, this)"></div>
	                        </div>
	                    </div>
	                </div>
					
					<!-- 상세 필터 토글 버튼 -->
	                <button type="button" class="btn-filter-icon" onclick="toggleFilter()">
	                    <i class="fa fa-filter"></i>
	                </button>
	            </div>
	            <!-- 검색 설정 주요 행 끝 -->
	            
	            <!-- 세부 필터 시작 -->
	            <div id="filterArea" class="filter-detail-area">
	                <div class="filter-group">
	                    <span class="fw-bold text-muted" style="font-size:12px;">상세 설정:</span>
	                    <select id="ratingSelect" class="form-select shadow-none" onchange="searchData('rating')">
	                        <option value="0.0">별점 전체</option>
	                        <option value="1.0">⭐ 이상</option>
	                        <option value="2.0">⭐⭐ 이상</option>
	                        <option value="3.0">⭐⭐⭐ 이상</option>
	                        <option value="4.0">⭐⭐⭐⭐ 이상</option>
	                    </select>
	                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="resetFilters()" style="font-size:11px; border-radius:10px;">초기화</button>
	                </div>
	            </div>
	            <!-- 세부 필터 끝 -->
			</div>
			<!-- 필터 설정 영역 끝 -->
			
			<!-- 지도 -->
			<div id="map"></div>
			
			<!-- 조건에 맞는 축제 목록 영역 -->
			<div id="resListArea" class="mt-4"></div>
		</div>
		
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>