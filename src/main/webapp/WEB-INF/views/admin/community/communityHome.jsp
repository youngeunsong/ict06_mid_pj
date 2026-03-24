<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<fmt:setTimeZone value="Asia/Seoul" />
<!-- ad_reservation.css -->
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_reservation.css" />

<meta charset="UTF-8">
<title>커뮤니티 관리</title>
</head>
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<!-- ================= CONTENT ================= -->
		<div class="content-wrapper">
			<!-- 컨텐츠 시작 -->
			<section class="content-header">
				<div class="container-fluid">
					<h1>커뮤니티 게시글 관리</h1>
				</div>
			</section>
			
			<section class="content">
				<div class="container-fluid">
					<%--필터 영역--%>
					<div class="filter-box mb-3 p-3 bg-white shadow-sm rounded">
						<div class="d-flex align-items-center justify-content-end flex-wrap" style="gap:15px;">
							
							<%-- 검색 영역 --%>
							<form action="${path}/communityHome.adco" method="get" class="d-flex align-items-center" style="gap:10px;">
								<div class="input-group input-group-sm" style="width:400px;">

									<%--검색 종류 선택--%>
									<select name="searchType" class="form-control col-4" style="border-radius: 4px 0 0 4px;">
										<option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
										<option value="user_id" ${searchType == 'user_id' ? 'selected' : ''}>작성자 ID</option>
										<option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
									</select>
									
									<%--키워드 검색 영역--%>
									<input type="text" id="keyword" name="keyword" class="form-control"	placeholder="검색어 입력" value="${keyword}">
									<div class="input-group-append">
										<button class="btn btn-dark btn-sm" type="submit">
											<i class="bi bi-search"></i>
										</button>
									</div>
								</div>
								
								<a href="${path}/communityHome.adco" class="btn btn-outline-secondary btn-sm" title="초기화">
									<i class="bi bi-arrow-clockwise"></i>
								</a>
							</form>
						</div>
					</div>
					
					
					<div class="card">
						<div class="card-header">
							<!-- 일괄처리 tag 버튼 -->
							<button type="button" class="tag tag-warning active" onclick="bulkAction('hide')">숨김</button>
							<button type="button" class="tag tag-success active" onclick="bulkAction('show')">숨김 해제</button>
							<button type="button" class="tag tag-danger active" onclick="bulkAction('delete')">삭제</button>
						</div>
					
						<!--begin::card-body-->
						<div class="card-body table-responsive p-0">
							<table class="table table-hover text-nowrap text-center">
								<thead>
									<tr>
										<th><input type="checkbox" id="checkAll"></th>
										<th>번호</th>
										<th>카테고리</th>
										<th>제목</th>
										<th>작성자</th>
										<th>조회</th>
										<th>추천</th>
										<th>상태</th>
										<th>작성일</th>
										<th>관리</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${empty postList}">
											<tr>
												<td colspan="10">게시글이 없습니다.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach var="post" items="${postList}">
												<tr>
													<td><input type="checkbox" class="post-check" value="${post.post_id}"></td>
													<td>${post.post_id}</td>
													<td>${post.category}</td>
													<td>
														<a href="${path}/communityDetail.adco?post_id=${post.post_id}">
															${post.title}
														</a>
													</td>
													<td>${post.user_id}</td>
													<td>${post.view_count}</td>
													<td>${post.like_count}</td>
													<td>
														<c:choose>
															<c:when test="${post.status eq 'DISPLAY'}">
																<span class="badge badge-success">정상</span>
															</c:when>
															<c:when test="${post.status eq 'HIDDEN'}">
																<span class="badge badge-warning">삭제</span>
															</c:when>
															<c:when test="${post.status eq 'BANNED'}">
																<span class="badge badge-danger">숨김</span>
															</c:when>
														</c:choose>
													</td>
													<td><fmt:formatDate value="${post.postDate}" pattern="yyyy.MM.dd" /></td>
													<td>
														<c:choose>
															<c:when test="${post.status eq 'DISPLAY'}">
																<button type="button" class="tag tag-warning" onclick="hidePost(${post.post_id})">숨김</button>
															</c:when>
															<c:when test="${post.status eq 'BANNED'}">
																<button type="button" class="tag tag-success" onclick="showPost(${post.post_id})">숨김해제</button>
															</c:when>
														</c:choose>
														<c:if test="${post.status ne 'HIDDEN'}">
															<button type="button" class="tag tag-danger" onclick="deletePost(${post.post_id})">삭제</button>
														</c:if>
														<button type="button" class="tag tag-info" onclick="location.href='${path}/communityDetail.adco?post_id=${post.post_id}'">상세보기</button>
													</td>
												</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
						<!--end::card-body-->

						<!--begin::card-footer-->
						<div class="card-footer clearfix">
							<ul class="pagination pagination-sm m-0 float-right">
								<c:if test="${paging.prev > 0}">
									<li class="page-item">
										<a class="page-link" href="${path}/communityHome.adco?pageNum=${paging.prev}&searchType=${searchType}&keyword=${keyword}">«</a>
									</li>
								</c:if>
								<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
									<li class="page-item ${paging.currentPage == i ? 'active' : ''}">
										<a class="page-link" href="${path}/communityHome.adco?pageNum=${i}&searchType=${searchType}&keyword=${keyword}">${i}</a>
									</li>
								</c:forEach>
								<c:if test="${paging.next > 0}">
									<li class="page-item">
										<a class="page-link" href="${path}/communityHome.adco?pageNum=${paging.next}&searchType=${searchType}&keyword=${keyword}">»</a>
									</li>
								</c:if>
							</ul>
						</div>
						<!--end::card-footer-->
						
					</div>
				</div>
			</section>
		</div>
		<!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
		<!--begin::Footer-->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		<!--end::Footer-->
	
	</div>
	<!--end::div Wrapper-->

<script>const path = "${path}";</script>
<script src="${path}/resources/js/admin/community.js"></script>

</body>
<!--end::Body-->
</html>