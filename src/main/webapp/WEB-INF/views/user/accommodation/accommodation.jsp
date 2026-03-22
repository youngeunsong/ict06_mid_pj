<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집어때 - 지도 탐색</title>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet"
	href="${path}/resources/css/user/accommodation/accommodation.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services&autoload=false"></script>
<script type="text/javascript">
	var map;
	var markers = [];
	var myCustomOverlay = null; 
	var isClickMoving = false;

	// JSP에서 전달된 북마크 리스트 (타입 불일치 방지를 위해 항상 문자열 배열로 관리)
	var favoritePlaceIds = ${not empty favoritePlaceIds ? favoritePlaceIds : '[]'}.map(String);
	
	var savedConfig = localStorage.getItem("resSearchConfig");
	var currentSearchConfig = savedConfig ? JSON.parse(savedConfig) : {
	    lat: ${not empty userLat ? userLat : 37.5665},
	    lng: ${not empty userLng ? userLng : 126.9780},
	    radius: 5.0, 
	    minRating: 0.0, 
	    keyword: "", 
	    category: "", 
	    pageNum: 1
	};

function saveToLocal() {
    localStorage.setItem("resSearchConfig", JSON.stringify(currentSearchConfig));
}

	$(document).ready(function() {
	    kakao.maps.load(function() {
	        $("#keywordInput").val(currentSearchConfig.keyword);
	        $("#categorySelect").val(currentSearchConfig.category);
	        $("#ratingSelect").val(currentSearchConfig.minRating.toFixed(1));
	        updateDistanceUI(currentSearchConfig.radius);
	
	        var mapContainer = document.getElementById('map');
	        map = new kakao.maps.Map(mapContainer, {
	            center: new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng),
	            level: 5
	        });
	
	        if (navigator.geolocation) {
	            navigator.geolocation.getCurrentPosition(function(pos) {
	                currentSearchConfig.lat = pos.coords.latitude;
	                currentSearchConfig.lng = pos.coords.longitude;
	                var newCenter = new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng);
	                map.setCenter(newCenter);
	                saveToLocal();
	                refreshAll();
	            }, function() {
	                refreshAll();
	            });
	        } else {
	            refreshAll();
	        }
	
	        kakao.maps.event.addListener(map, 'idle', function() {
	            if (isClickMoving) return;
	            var center = map.getCenter();
	            currentSearchConfig.lat = center.getLat();
	            currentSearchConfig.lng = center.getLng();
	            saveToLocal();
	            refreshAll();
        });
    });

    // 북마크 클릭 이벤트 - 색상 강제 적용 로직 추가
    $(document).on('click', '.bookmark-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();

        const btn = $(this);
        const placeId = String(btn.attr('data-place-id')); 
        const icon = btn.find('i');

        $.ajax({
            url: "${path}/favoriteToggle.rs",
            type: "POST",
            data: { "place_id": placeId },
            success: function(res) {
                if (res.needLogin) {
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${path}/login.me"; 
                    return;
                }
                if (res.ok) {
                    if (res.favorite) {
                        // [수정] 클래스 변경 + 인라인 색상 주입
                        icon.removeClass('fa-regular text-muted').addClass('fa-solid text-success')
                            .css('color', '#00E600');
                        if(!favoritePlaceIds.includes(placeId)) favoritePlaceIds.push(placeId);
                    } else {
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

function toggleFilter() { $("#filterArea").slideToggle(200); }

function setDistance(val, percent, element) {
    currentSearchConfig.radius = val;
    updateDistanceUI(val);
    saveToLocal();
    searchData();
}

function searchData(filterType) { 
    const categorySelect = $("#categorySelect");
    const ratingSelect = $("#ratingSelect");

    if (filterType === 'category') {
        if (categorySelect.val() !== "") {
            ratingSelect.val("0.0").prop('disabled', true).css('opacity', '0.5');
        } else {
            ratingSelect.prop('disabled', false).css('opacity', '1');
        }
    } else if (filterType === 'rating') {
        if (ratingSelect.val() !== "0.0") {
            categorySelect.val("").prop('disabled', true).css('opacity', '0.5');
        } else {
            categorySelect.prop('disabled', false).css('opacity', '1');
        }
    }

    currentSearchConfig.keyword = $("#keywordInput").val(); 
    currentSearchConfig.minRating = parseFloat(ratingSelect.val());
    currentSearchConfig.category = categorySelect.val();
    currentSearchConfig.pageNum = 1;
    saveToLocal();
    refreshAll(); 
}

function refreshAll() {
    $.ajax({
        url: "${path}/getNearbyMarkersAjax.ac",
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "json",
        success: function(data) { updateMarkers(data); }
    });
    $.ajax({
        url: "${path}/accommodationAjax.ac",
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "html",
        success: function(html) { $("#resListArea").html(html); }
    });
}

function updateMarkers(data) {
    markers.forEach(m => m.setMap(null));
    markers = [];
    if (myCustomOverlay) myCustomOverlay.setMap(null);
    if (!data || data.length === 0) return;

    data.forEach(function(acc) {
        var p = acc.placeDTO || acc.placedto || acc;
        if (!p || !p.latitude) return;
        
        var coords = new kakao.maps.LatLng(Number(p.latitude), Number(p.longitude));
        var marker = new kakao.maps.Marker({ position: coords, map: map });
        marker.placeId = String(p.place_id);

        kakao.maps.event.addListener(marker, 'click', function() {
            isClickMoving = true;
            if (myCustomOverlay) myCustomOverlay.setMap(null);
            
            var imgPath = p.image_url && p.image_url !== 'null' ? 
                          (p.image_url.startsWith('http') ? p.image_url : '${path}/resources/images/common/' + p.image_url) : 
                          '${path}/resources/images/common/no-image.png';

            // [수정] 지도 위 팝업에서도 북마크 색상 정확히 판단
            var isFav = favoritePlaceIds.includes(String(p.place_id));

            var content = `
                <div class="custom-overlay-card">
                    <div style="position:relative; margin-bottom:12px;">
                        <img src="\${imgPath}" style="width:100%; height:110px; object-fit:cover; border-radius:12px;" onerror="this.src='${path}/resources/images/common/no-image.png'">
                        
                        <button type="button" class="bookmark-btn" data-place-id="\${p.place_id}" 
                                style="position:absolute; top:8px; right:8px; background:white; border:none; border-radius:50%; width:30px; height:30px; z-index:11; display:flex; align-items:center; justify-content:center; box-shadow:0 2px 6px rgba(0,0,0,0.15);">
                            <i class="\${isFav ? 'fa-solid text-success' : 'fa-regular text-muted'} fa-bookmark" 
                               style="font-size:16px; \${isFav ? 'color:#00E600 !important;' : ''}"></i>
                        </button>

                        <div onclick="closeMyOverlay()" style="position:absolute; top:-10px; right:-10px; cursor:pointer; background:white; width:26px; height:26px; border-radius:50%; text-align:center; line-height:24px; border:1px solid #eee; font-weight:bold; box-shadow:0 2px 5px rgba(0,0,0,0.1);">×</div>
                    </div>
                    <div style="text-align:left; padding:0 4px;">
                        <div style="font-weight:bold; font-size:16px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">\${p.name}</div>
                        <div style="font-size:12px; color:#999; margin-bottom:10px;"><i class="bi bi-geo-alt-fill text-danger"></i> \${acc.category || '숙소'}</div>
                        <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid #f0f0f0; padding-top:10px; font-size:12px;">
                            <div style="display:flex; gap:10px; color:#666;">
                                <span><i class="fa-regular fa-eye text-primary"></i> \${p.view_count || 0}</span>
                                <span><i class="fa-regular fa-star text-warning"></i> \${p.avg_rating || 0.0}</span>
                                <span><i class="fa-regular fa-comment" style="color:#00E600;"></i> \${p.review_count || 0}</span>
                            </div>
                        </div>
                    </div>
                    <button onclick="location.href='${path}/accommodationDetail.ac?place_id=\${p.place_id}'" 
                            style="width:100%; margin-top:12px; border:none; background:#00E600 !important; color:white !important; padding:10px; border-radius:10px; font-weight:bold; cursor:pointer;">상세보기</button>
                </div>`;

            myCustomOverlay = new kakao.maps.CustomOverlay({ content: content, map: map, position: marker.getPosition(), yAnchor: 0.9 });
            map.panTo(coords);
            setTimeout(() => isClickMoving = false, 500);
        });
        markers.push(marker);
    });
}

function showMarkerDetail(placeId) {
    const targetMarker = markers.find(m => String(m.placeId) === String(placeId));
    if (targetMarker) {
        kakao.maps.event.trigger(targetMarker, 'click');
        $('html, body').animate({ scrollTop: $("#map").offset().top - 120 }, 400);
    }
}

function closeMyOverlay() { if (myCustomOverlay) myCustomOverlay.setMap(null); }

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

function resetFilters() {
    $("#keywordInput").val(""); 
    $("#categorySelect").val("").prop('disabled', false).css('opacity', '1');
    $("#ratingSelect").val("0.0").prop('disabled', false).css('opacity', '1');
    updateDistanceUI(5.0); 

    currentSearchConfig.keyword = "";
    currentSearchConfig.category = "";
    currentSearchConfig.minRating = 0.0;
    currentSearchConfig.radius = 5.0;
    currentSearchConfig.pageNum = 1;

    localStorage.removeItem("resSearchConfig"); 
    saveToLocal();
    if (myCustomOverlay) myCustomOverlay.setMap(null);
    refreshAll();
}

function changePage(page) {
    currentSearchConfig.pageNum = page;
    saveToLocal();
    $.ajax({
        url: "${path}/accommodationAjax.ac", 
        type: "GET", 
        data: currentSearchConfig, 
        dataType: "html",
        success: function(html) {
            $("#resListArea").html(html);
            $('html, body').animate({ scrollTop: $("#resListArea").offset().top - 100 }, 300);
        }
    });
}
</script>
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp" %>
    <div class="content-wrapper">
        <div class="search-container">
            <div class="search-main-row">
                <div class="search-input-group">
                    <input type="text" id="keywordInput" placeholder="숙소를 검색하세요" onkeyup="if(event.keyCode==13)searchData()">
                    <i class="fa fa-search text-muted" onclick="searchData()"></i>
                </div>

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

                <button type="button" class="btn-filter-icon" onclick="toggleFilter()">
                    <i class="fa fa-filter"></i>
                </button>
            </div>

            <div id="filterArea" class="filter-detail-area">
                <div class="filter-group">
                    <span class="fw-bold text-muted" style="font-size:12px;">상세 설정:</span>
                    <select id="categorySelect" class="form-select shadow-none" onchange="searchData('category')">
                        <option value="">카테고리 전체</option>
                        <option value="일반숙박업">일반숙박업</option>
                        <option value="펜션">펜션</option>
                        <option value="호스텔">호스텔</option>
                        <option value="서비스드레지던스">서비스드레지던스</option>
                        <option value="한옥스테이">한옥스테이</option>
                        <option value="관광호텔">관광호텔</option>
                        <option value="홈스테이">홈스테이</option>
                        <option value="수상관광호텔">수상관광호텔</option>
                        <option value="한국전통호텔">한국전통호텔</option>
                        <option value="가족호텔">가족호텔</option>
                        <option value="유스호스텔">유스호스텔</option>
                        <option value="콘도미니엄">콘도미니엄</option>
                        <option value="휴양펜션">휴양펜션</option>
                    </select>

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
        </div>

        <div id="map"></div>
        <div id="resListArea" class="mt-4"></div>
    </div>
    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>