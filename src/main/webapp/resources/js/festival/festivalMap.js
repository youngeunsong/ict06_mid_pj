/*
 * @author 송영은
 * 최초작성일: 2026-03-23	
 * 최종수정일: 2026-03-23
카카오지도 API 문서 및 샘플 코드를 이용하여 작성. 
*/
var container = document.getElementById('map');
var options = {
	center: new kakao.maps.LatLng(33.450701, 126.570667),
	level: 3
};

var map = new kakao.maps.Map(container, options);

// 1. 현재 위치 가져오기 (HTML5 Geolocation)
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(lat, lon); // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
        
        // 2. 지도 중심을 현재 위치로 변경
        map.setCenter(locPosition);
        
        // 3. 마커 이미지 변경
        var imageSrc = path + '/resources/images/common/locationMarker.png', // 마커이미지의 주소입니다    
	    imageSize = new kakao.maps.Size(64, 82), // 마커이미지의 크기입니다
	    imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
      
		// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
		var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
    	markerPosition = new kakao.maps.LatLng(37.54699, 127.09598); // 마커가 표시될 위치입니다
        
        // 4. 현재 위치 마커로 표시 
        var marker = new kakao.maps.Marker({  
            map: map, 
            position: locPosition,
            image: markerImage
        });
        
    });
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치를 설정합니다
    var locPosition = new kakao.maps.LatLng(37.566826, 126.978656); // 서울 시청
    map.setCenter(locPosition);
}
