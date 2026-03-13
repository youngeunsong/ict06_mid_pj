<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="card-footer bg-white border-0 py-3">
    <div class="d-flex justify-content-between align-items-center">
        <nav>
            <ul class="pagination pagination-sm m-0">

                <c:choose>
                    <c:when test="${paging.startPage > paging.pageBlock}">
                        <li class="page-item">
                            <a class="page-link border-0 mx-1"
                               href="?pageNum=${paging.prev}&keyword=${keyword}&areaCode=${areaCode}&category=${param.category}">
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
                        <a class="page-link border-0 mx-1"
                           href="?pageNum=${i}&keyword=${keyword}&areaCode=${areaCode}&category=${param.category}"
                           style="${i == paging.currentPage ? 'background-color:#01D281; border-color:#01D281; color:#fff;' : ''}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>

                <c:choose>
                    <c:when test="${paging.endPage < paging.pageCount}">
                        <li class="page-item">
                            <a class="page-link border-0 mx-1"
                               href="?pageNum=${paging.next}&keyword=${keyword}&areaCode=${areaCode}&category=${param.category}">
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