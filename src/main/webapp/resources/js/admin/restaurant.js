/* restaurant.js */

/* 페이지가 로드된 후 실행 */
window.onload = function() {
	var areaCode = "${areaCode}";
	if (areaCode) {
		/* 페이징 영역(card-footer) 내의 모든 <a> 태그를 찾습니다. */
	    var pageLinks = document.querySelectorAll(".card-footer .page-link");
	            
	    pageLinks.forEach(function(link) {
	    	var currentHref = link.getAttribute("href");
	                
		    /* 이미 areaCode가 붙어있지 않은 경우에만 붙여줍니다. */
		    if (currentHref && currentHref.indexOf("areaCode") === -1) {
		    	/* 주소에 ?가 있으면 &로, 없으면 ?로 연결 */
		        var separator = currentHref.indexOf("?") !== -1 ? "&" : "?";
		        link.setAttribute("href", currentHref + separator + "areaCode=" + areaCode);
		    }
	    });
	}
};
	
/* 기존 필터 변경 함수는 유지 */
function handleFilterChange(areaCode) {
	location.href = "${path}/restaurant.ad?areaCode=" + areaCode + "&pageNum=1";
}