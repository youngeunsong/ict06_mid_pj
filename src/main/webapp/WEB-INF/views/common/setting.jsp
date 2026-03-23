<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- =========================================================
[setting.jsp 역할]
- 공통 최소 설정 파일
- JSTL taglib 선언 + contextPath(${path}) 설정만 담당

[주의]
- Bootstrap / jQuery / AdminLTE / Icons / 공통 CSS·JS는
  bootstrapSettings.jsp에서만 관리한다.
- 화면 리소스를 이 파일에 추가하지 않는다.
========================================================= -->

<%-- JSTL --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 컨텍스트 경로 --%>
<c:set var="path" value="${pageContext.request.contextPath}" scope="application"/>