<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집어때 - 지도 탐색</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet" href="${path}/resources/css/user/restaurant/restaurant.css">

<!-- 컨트롤러에서 API 키 전달받기 -->
<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&libraries=services&autoload=false"></script>
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp" %>

    <div class="content-wrapper">
        <div class="main-tab-wrapper" style="display:flex; justify-content:center; margin-bottom:30px;">
            <div class="nav-pill-group" onclick="location.href='${path}/bestRestaurants.rs'" style="cursor:pointer;">
                <div class="nav-pill-item active">내 주변</div>
                <div class="nav-pill-item best-link">베스트 맛집</div>
            </div>
        </div>

        <div class="search-container">
            <div class="search-main-row">
                <div class="search-input-group">
                    <input type="text" id="keywordInput" placeholder="맛집을 검색하세요"
                           onkeyup="if(event.keyCode==13) doKeywordSearch()">
                    <i class="fa fa-search text-muted" onclick="doKeywordSearch()"></i>
                </div>

                <div class="distance-filter">
                    <span class="distance-label">반경</span>
                    <div class="step-wrapper">
                        <div class="step-line-bg"></div>
                        <div id="activeLine" class="step-line-active"></div>
                        <div class="step-nodes">
                            <div class="dist-node" data-label="1k"  onclick="setDistance(1.0,   0,   this)"></div>
                            <div class="dist-node" data-label="5k"  onclick="setDistance(5.0,   25,  this)"></div>
                            <div class="dist-node" data-label="10k" onclick="setDistance(10.0,  50,  this)"></div>
                            <div class="dist-node" data-label="50k" onclick="setDistance(50.0,  75,  this)"></div>
                            <div class="dist-node" data-label="All" onclick="setDistance(600.0, 100, this)"></div>
                        </div>
                    </div>
                </div>

                <button type="button" class="btn-filter-icon" onclick="toggleFilter()">
                    <i class="fa fa-filter"></i>
                </button>
            </div>

            <div id="filterArea" class="filter-detail-area">
                <div class="filter-group">
                    <%-- 지역 필터 추가 --%>
                    <select id="provinceSelect" onchange="updateRegionOptions()">
                        <option value="">지역 선택</option>
                        <option value="서울">서울</option>
                        <option value="경기">경기</option>
                        <option value="인천">인천</option>
                        <option value="대전">대전</option>
                        <option value="대구">대구</option>
                        <option value="울산">울산</option>
                        <option value="광주">광주</option>
                        <option value="부산">부산</option>
                 	    <option value="제주">제주</option>
                    </select>

                    <select id="categorySelect" class="form-select shadow-none" onchange="searchData()">
                        <option value="">카테고리 전체</option>
                        <option value="한식">한식</option>
                        <option value="양식">양식</option>
                        <option value="일식">일식</option>
                        <option value="중식">중식</option>
                        <option value="카페">카페</option>
                        <option value="이색음식">이색음식</option>
                        <option value="식음료">식음료</option>
                        <option value="기타">기타</option>
                    </select>

                    <select id="ratingSelect" class="form-select shadow-none" onchange="searchData()">
                        <option value="0.0">별점 전체</option>
                        <option value="1.0">⭐ 이상</option>
                        <option value="2.0">⭐⭐ 이상</option>
                        <option value="3.0">⭐⭐⭐ 이상</option>
                        <option value="4.0">⭐⭐⭐⭐ 이상</option>
                    </select>

                    <button type="button" class="btn btn-sm btn-outline-secondary"
                            onclick="resetFilters()" style="font-size:11px; border-radius:10px;">초기화</button>
                </div>
            </div>
        </div>

        <div id="map"></div>
        <div id="resListArea" class="mt-4"></div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>

<script type="text/javascript">

// 시/도 - 구/군 매핑 데이터
const regionMap = {
};

var map;
var markers = [];
var myCustomOverlay = null;
var isClickMoving = false;
var isDistanceLocked = false;

var favoritePlaceIds = ${not empty favoritePlaceIds ? favoritePlaceIds : '[]'}.map(String);

var savedConfig = localStorage.getItem("resSearchConfig");
var currentSearchConfig = savedConfig ? JSON.parse(savedConfig) : {
    lat: ${not empty userLat ? userLat : 37.5665},
    lng: ${not empty userLng ? userLng : 126.9780},
    radius: 5.0,
    minRating: 0.0,
    keyword: "",
    category: "",
    province: "",
    district: "",
    pageNum: 1
};

function saveToLocal() {
    localStorage.setItem("resSearchConfig", JSON.stringify(currentSearchConfig));
}

// ✅ 반경 잠금
function lockDistanceFilter() {
    isDistanceLocked = true;
    currentSearchConfig.radius = 600.0;
    saveToLocal();
    updateDistanceUI(600.0);
    $(".distance-filter").css({"opacity": "0.5", "pointer-events": "none"});
}

// ✅ 반경 해제
function unlockDistanceFilter() {
    isDistanceLocked = false;
    currentSearchConfig.radius = 5.0;
    saveToLocal();
    updateDistanceUI(5.0);
    $(".distance-filter").css({"opacity": "1", "pointer-events": "auto"});
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
                map.setCenter(new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng));
                saveToLocal();
                
             	// 사용자 현재 위치를 마커로 표시 시작 ------------------
             	var newCenter = new kakao.maps.LatLng(currentSearchConfig.lat, currentSearchConfig.lng);
             	
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
    	     	
                // refreshAll();
    	        refreshAll(false); // 가까운 맛집 마커로 이동 잠금
            }, function() {
            	// refreshAll();
    	        refreshAll(false); // 가까운 맛집 마커로 이동 잠금
            });
        } else {
        	// refreshAll();
	        refreshAll(false); // 가까운 맛집 마커로 이동 잠금
        }

        kakao.maps.event.addListener(map, 'idle', function() {
            if (isClickMoving) return;

            var center = map.getCenter();
            currentSearchConfig.lat = center.getLat();
            currentSearchConfig.lng = center.getLng();
            saveToLocal();
            refreshAll(false);
        });
    });

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
                    location.href = "${path}/login.do";
                    return;
                }
                if (res.ok) {
                    if (res.favorite) {
                        icon.removeClass('fa-regular text-muted').addClass('fa-solid text-success').css('color', '#00E600');
                        if (!favoritePlaceIds.includes(placeId)) favoritePlaceIds.push(placeId);
                    } else {
                        icon.removeClass('fa-solid text-success').addClass('fa-regular text-muted').css('color', '#dee2e6');
                        favoritePlaceIds = favoritePlaceIds.filter(id => id !== placeId);
                    }
                }
            },
            error: function() { alert("통신 중 오류가 발생했습니다."); }
        });
    });
});

// ✅ 반경 UI 업데이트
function updateDistanceUI(radius) {
    var percent = 0;
    var label = "5k";
    if      (radius == 1.0)                      { percent = 0;   label = "1k";  }
    else if (radius == 5.0)                      { percent = 25;  label = "5k";  }
    else if (radius == 10.0)                     { percent = 50;  label = "10k"; }
    else if (radius == 50.0)                     { percent = 75;  label = "50k"; }
    else if (radius >= 100.0) { percent = 100; label = "All"; }

    $('#activeLine').css('width', percent + '%');
    $('.dist-node').removeClass('active');
    $(`.dist-node[data-label="${label}"]`).addClass('active');
}

function toggleFilter() { $("#filterArea").slideToggle(200); }

// ✅ 잠금 상태면 클릭 무시
function setDistance(val, percent, element) {
    if (isDistanceLocked) return;
    currentSearchConfig.radius = val;
    updateDistanceUI(val);
    saveToLocal();
    refreshAll(false);
}

// ✅ 키워드 검색 전용 — 잠금/해제 처리
function doKeywordSearch() {
    const keyword = $("#keywordInput").val();
    if (keyword !== "") {
        lockDistanceFilter();
    } else {
        const hasRegion = currentSearchConfig.province !== ""
                       || currentSearchConfig.district !== "";
        if (!hasRegion) unlockDistanceFilter();
    }
    searchData();
}

// ✅ searchData — 잠금/해제 로직 없음, 값 수집 + 검색만
function searchData() {
    currentSearchConfig.keyword   = $("#keywordInput").val();
    currentSearchConfig.minRating = parseFloat($("#ratingSelect").val());
    currentSearchConfig.category  = $("#categorySelect").val();
    currentSearchConfig.province  = $("#provinceSelect").val();
    currentSearchConfig.district  = $("#districtSelect").val();
    currentSearchConfig.pageNum   = 1;
    saveToLocal();
    refreshAll(true);
}

function refreshAll(autoClickFirstMarker = true) {
    $.ajax({
        url: "${path}/getNearbyMarkersAjax.rs",
        type: "GET",
        data: currentSearchConfig,
        dataType: "json",
        success: function(data) {
            updateMarkers(data);
            if (autoClickFirstMarker && data && data.length > 0) {
                const p = data[0].placeDTO || data[0];
                if (p && p.place_id) {
                    setTimeout(() => showMarkerDetail(p.place_id), 200);
                }
            }
        }
    });
    $.ajax({
        url: "${path}/restaurantAjax.rs",
        type: "GET",
        data: currentSearchConfig,
        dataType: "html",
        success: function(html) { $("#resListArea").html(html); }
    });
}

function updateMarkers(data) {
    if (markers && markers.length > 0) markers.forEach(m => m.setMap(null));
    markers = [];
    if (myCustomOverlay) myCustomOverlay.setMap(null);

    if (!data || data.length === 0) {
        console.warn("표시할 맛집 데이터가 없습니다.");
        return;
    }

    var imageSrc    = '${path}/resources/images/user/restaurant/markerImage.png';
    var imageSize   = new kakao.maps.Size(160, 50);
    var imageOption = { offset: new kakao.maps.Point(80, 50) };
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

    data.forEach(function(res) {
        var p = res.placeDTO || res.placedto || res;
        if (!p || !p.latitude || !p.longitude) return;

        var coords = new kakao.maps.LatLng(Number(p.latitude), Number(p.longitude));
        var marker = new kakao.maps.Marker({ position: coords, map: map, image: markerImage });
        marker.placeId = String(p.place_id);

        kakao.maps.event.addListener(marker, 'click', function() {
            isClickMoving = true;
            if (myCustomOverlay) myCustomOverlay.setMap(null);

            var imgPath = p.image_url && p.image_url !== 'null'
                ? (p.image_url.startsWith('http') ? p.image_url : '${path}/resources/images/common/' + p.image_url)
                : '${path}/resources/images/common/no-image.png';

            var isFav = favoritePlaceIds.includes(String(p.place_id));

            var content = `
                <div class="custom-overlay-card">
                    <div style="position:relative; margin-bottom:12px;">
                        <img src="\${imgPath}" style="width:100%; height:110px; object-fit:cover; border-radius:12px;"
                             onerror="this.src='${path}/resources/images/common/no-image.png'">
                        <button type="button" class="bookmark-btn" data-place-id="\${p.place_id}">
                            <i class="\${isFav ? 'fa-solid text-success' : 'fa-regular text-muted'} fa-bookmark"
                               style="color: \${isFav ? '#00E600' : '#ccc'} !important;"></i>
                        </button>
                        <div onclick="closeMyOverlay()"
                             style="position:absolute; top:-10px; right:-10px; cursor:pointer; background:white;
                                    width:26px; height:26px; border-radius:50%; text-align:center; line-height:24px;
                                    border:1px solid #eee; font-weight:bold; box-shadow:0 2px 5px rgba(0,0,0,0.1); z-index:1001;">×</div>
                    </div>
                    <div style="text-align:left; padding:0 4px;">
                        <div style="font-weight:bold; font-size:16px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">\${p.name}</div>
                        <div style="font-size:12px; color:#999; margin-bottom:10px;"><i class="bi bi-geo-alt-fill text-danger"></i> \${res.category || '맛집'}</div>
                        <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid #f0f0f0; padding-top:10px; font-size:12px;">
                            <div style="display:flex; gap:10px; color:#666;">
                                <span><i class="fa-regular fa-eye text-primary"></i> \${p.view_count || 0}</span>
                                <span><i class="fa-regular fa-star text-warning"></i> \${p.avg_rating || 0.0}</span>
                                <span><i class="fa-regular fa-comment" style="color:#00E600;"></i> \${p.review_count || 0}</span>
                            </div>
                        </div>
                    </div>
                    <button onclick="location.href='${path}/restaurantDetail.rs?place_id=\${p.place_id}'"
                            style="width:100%; margin-top:12px; border:none; background:#00E600 !important;
                                   color:white !important; padding:10px; border-radius:10px; font-weight:bold; cursor:pointer;">상세보기</button>
                </div>`;

            myCustomOverlay = new kakao.maps.CustomOverlay({
                content: content, map: map,
                position: marker.getPosition(),
                xAnchor: 0.5, yAnchor: 1.0
            });

            var projection  = map.getProjection();
            var markerPoint = projection.pointFromCoords(coords);
            var targetPoint = new kakao.maps.Point(markerPoint.x, markerPoint.y - 150);
            map.panTo(projection.coordsFromPoint(targetPoint));

            setTimeout(() => isClickMoving = false, 500);
        });
        markers.push(marker);
    });
    console.log("대형 마커 로드 완료: " + markers.length + "개");
}

function showMarkerDetail(placeId) {
    const targetMarker = markers.find(m => String(m.placeId) === String(placeId));
    if (targetMarker) {
        kakao.maps.event.trigger(targetMarker, 'click');
        $('html, body').animate({ scrollTop: $("#map").offset().top - 180 }, 400);
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

// ✅ 지역 선택 — 잠금/해제 처리
function updateRegionOptions() {
    const province       = $("#provinceSelect").val();
    const districtSelect = $("#districtSelect");

    districtSelect.empty().append('<option value="">전체</option>');

    if (province && regionMap[province]) {
        regionMap[province].forEach(d => {
            districtSelect.append(`<option value="${d}">${d}</option>`);
        });
    }

    currentSearchConfig.province = province || "";
    currentSearchConfig.district = "";

    if (markers && markers.length > 0) markers.forEach(m => m.setMap(null));
    markers = [];
    $("#resListArea").empty();

    if (province) {
        lockDistanceFilter();
    } else {
        const hasKeyword = $("#keywordInput").val() !== "";
        if (!hasKeyword) unlockDistanceFilter();
    }

    searchData();

    setTimeout(() => {
        if (markers.length > 0) {
            map.setCenter(markers[0].getPosition());
            showMarkerDetail(markers[0].placeId);
        }
    }, 500);
}

// ✅ 구/군 변경 — 잠금 상태 유지
function updateDistrictOption() {
    currentSearchConfig.district = $("#districtSelect").val() || "";
    saveToLocal();
    searchData();
}

function resetFilters() {
    $("#keywordInput").val("");
    $("#categorySelect").val("").prop('disabled', false).css('opacity', '1');
    $("#ratingSelect").val("0.0").prop('disabled', false).css('opacity', '1');
    $("#provinceSelect").val("");
    $("#districtSelect").empty().append('<option value="">전체</option>');

    unlockDistanceFilter();
    localStorage.removeItem("resSearchConfig");
    
    // saveToLocal();
    if (myCustomOverlay) myCustomOverlay.setMap(null);
    // refreshAll();  
    
    // ⭐ 현재 위치 다시 가져오기
    if (navigator.geolocation) {

        navigator.geolocation.getCurrentPosition(function(pos) {

            currentSearchConfig = {
                lat: pos.coords.latitude,
                lng: pos.coords.longitude,
                radius: 5.0,
                minRating: 0.0,
                keyword: "",
                category: "",
                province: "",
                district: "",
                pageNum: 1
            };

            saveToLocal();

            var newCenter = new kakao.maps.LatLng(
                currentSearchConfig.lat,
                currentSearchConfig.lng
            );

            map.setCenter(newCenter); // 내 현재 위치로 지도 중심 이동
            refreshAll(false);   // ⭐ 첫 마커 자동 이동 방지

        }, function() {

            // 위치 못 가져오면 기본값
            currentSearchConfig = {
                lat: 37.5665,
                lng: 126.9780,
                radius: 5.0,
                minRating: 0.0,
                keyword: "",
                category: "",
                province: "",
                district: "",
                pageNum: 1
            };

            saveToLocal();
            map.setCenter(new kakao.maps.LatLng(37.5665, 126.9780));
            refreshAll(false);
        });

    } else {
        refreshAll(false);
    }
}

function changePage(page) {
    currentSearchConfig.pageNum = page;
    saveToLocal();
    $.ajax({
        url: "${path}/restaurantAjax.rs",
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
</body>
</html>