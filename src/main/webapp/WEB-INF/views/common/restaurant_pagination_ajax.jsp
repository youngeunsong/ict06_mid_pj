<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card-footer bg-white border-0 py-3">
    <div class="d-flex justify-content-between align-items-center">
        <small class="text-muted">
            총 <b>${totalCount}</b>건
        </small>
        
        <nav>
            <ul class="pagination pagination-sm m-0">

                <c:choose>
                    <c:when test="${paging.startPage > paging.pageBlock}">
                        <li class="page-item">
                            <a class="page-link border-0 mx-1" href="javascript:void(0)" 
                               onclick="changePage(${paging.prev})">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled">
                            <a class="page-link border-0 mx-1" href="javascript:void(0)">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                    <li class="page-item ${i == paging.currentPage ? 'active' : ''}">
                        <a class="page-link border-0 mx-1" href="javascript:void(0)"
                           onclick="changePage(${i})"
                           style="${i == paging.currentPage ? 'background-color:#01D281; border-color:#01D281; color:#fff;' : ''}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>

                <c:choose>
                    <c:when test="${paging.endPage < paging.pageCount}">
                        <li class="page-item">
                            <a class="page-link border-0 mx-1" href="javascript:void(0)"
                               onclick="changePage(${paging.next})">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled">
                            <a class="page-link border-0 mx-1" href="javascript:void(0)">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</div>
<%-- 
    [비동기 지도 리스트용 페이지네이션]
    - 기존 게시판 스타일(Green/No-Border) 유지
    - href 대신 onclick="changePage()"를 사용하여 지도 새로고침 방지
    ===============================================================
    [ 비동기(Ajax) 페이지네이션 사용 이유 - 핵심 3요소 ]
    
    1. 지도 상태 유지 (No Reload)
       - 페이지 전체가 새로고침되면 사용자가 움직여놓은 '지도 위치'가 
         초기화되므로, 이를 방지하고 현재 지도 화면을 고정함.
         
    2. 사용자 경험(UX) 개선
       - 화면 깜빡임 없이 리스트만 부드럽게 전환되어 
         웹이 아닌 '앱' 같은 반응 속도를 제공함.
         
    3. 스크립트 연동 (JS Control)
       - 단순히 페이지 이동만 하는 것이 아니라, 클릭 시 
         '리스트 상단 스크롤'이나 '마커 강조' 같은 추가 기능을 실행하기 위함.
    ===============================================================
--%>