<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="card-footer bg-white border-0 py-3">
	<div class="d-flex justify-content-between align-items-center">
		<small class="text-muted">Total <b>${totalCount}</b>entries</small>
		<nav>
			<ul class="pagination pagination-sm m-0">
				<c:if test="${paging.startPage} > paging.pageBlock">
					<li class="page-item">
						<a class="page-link border-0 bg-light mx-1" href="?pageNum=${paging.prev}">Previous</a>
					</li>
				</c:if>
				
				<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
					<li class="page-item ${i==paging.currentPage ? 'active':''}">
						<a class="page-link border-0 mx-1" href="?pageNum=${i}"
							style="${i==paging.currentPage ? 'background-color:#01D281;':''}">${i}</a>
					</li>
				</c:forEach>
				
				<c:if test="${paging.endPage < paging.pageCount}">
					<li class="page-item">
						<a class="page-link border-0 bg-light mx-1" href="?pageNum=${paging.next}">Next</a>
					</li>
				</c:if>
			</ul>
		</nav>
	</div>
</div>