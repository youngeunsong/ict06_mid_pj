<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>

<script>
	<c:choose>
		<c:when test="${updateCnt == 1}">
			alert('정보가 수정되었습니다.');
			location.href = '${path}/adminHome.ad';
		</c:when>
		<c:when test="${updateCnt == -1}">
			alert('현재 비밀번호가 일치하지 않습니다.');
			history.back();
		</c:when>
		<c:when test="${updateCnt == -2}">
			alert('새 비밀번호가 일치하지 않습니다.');
			history.back();
		</c:when>
		<c:otherwise>
			alert('수정에 실패했습니다. 다시 시도해주세요.');
			history.back();
		</c:otherwise>
	</c:choose>
</script>
	
