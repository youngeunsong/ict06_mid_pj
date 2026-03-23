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