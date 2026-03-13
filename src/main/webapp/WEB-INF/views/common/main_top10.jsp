<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="setting.jsp"%>

<input type="hidden" id="contextPath" value="${path}">
<input type="hidden" id="loginUserId" value="${sessionScope.sessionID}">

<!-- ==================================================
     [유지] main.js가 사용하는 핵심 구조
     - .top10-viewport
     - #top10Row
     - .top10-card-wrap
=================================================== -->

<!-- 맛집 : 기본 -->
<div class="top10-viewport">
    <div id="top10Row" data-active="REST">
        <c:forEach var="place" items="${RESTtop10}" varStatus="st">
            <c:set var="mode" value="top10" />
            <c:set var="rank" value="${st.index + 1}" />
            <c:set var="rankCls" value="" />
            <c:if test="${st.index == 0}"><c:set var="rankCls" value="top1" /></c:if>
            <c:if test="${st.index == 1}"><c:set var="rankCls" value="top2" /></c:if>
            <c:if test="${st.index == 2}"><c:set var="rankCls" value="top3" /></c:if>
            <%@ include file="card/restCard.jsp" %>
        </c:forEach>
    </div>
</div>

<!-- 맛집 : 히든 -->
<div id="top10Row_REST" class="d-none">
    <c:forEach var="place" items="${RESTtop10}" varStatus="st">
        <c:set var="mode" value="top10" />
        <c:set var="rank" value="${st.index + 1}" />
        <c:set var="rankCls" value="" />
        <c:if test="${st.index == 0}"><c:set var="rankCls" value="top1" /></c:if>
        <c:if test="${st.index == 1}"><c:set var="rankCls" value="top2" /></c:if>
        <c:if test="${st.index == 2}"><c:set var="rankCls" value="top3" /></c:if>
        <%@ include file="card/restCard.jsp" %>
    </c:forEach>
</div>

<!-- 숙소 : 히든 -->
<div id="top10Row_ACC" class="d-none">
    <c:forEach var="place" items="${ACCtop10}" varStatus="st">
        <c:set var="mode" value="top10" />
        <c:set var="rank" value="${st.index + 1}" />
        <c:set var="rankCls" value="" />
        <c:if test="${st.index == 0}"><c:set var="rankCls" value="top1" /></c:if>
        <c:if test="${st.index == 1}"><c:set var="rankCls" value="top2" /></c:if>
        <c:if test="${st.index == 2}"><c:set var="rankCls" value="top3" /></c:if>
        <%@ include file="card/accCard.jsp" %>
    </c:forEach>
</div>