<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-14
 * 최종수정일: 2026-03-16
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티/ 커뮤니티 > 자유게시판</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/community.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<script src="${path}/resources/js/community/community.js" defer></script>

</head>
<body>
<div class="wrap">

<c:if test="${param.msg == 'delete'}">
	<script>
	    alert("게시글이 삭제되었습니다.");
	</script>
</c:if>

<c:if test="${param.msg == 'write'}">
	<script>
	    alert("게시글이 등록되었습니다.");
	</script>
</c:if>

<c:if test="${param.msg == 'update'}">
	<script>
	    alert("게시글이 수정되었습니다.");
	</script>
</c:if>

	<%@ include file="../../common/header.jsp"%>

	<div class="comm-tabs">
		<div class="container">
			<a href="${path}/community_free.co" class="tab ${tab eq 'free' ? 'on' : ''}">자유게시판</a>
			<a href="${path}/community_notice.co" class="tab ${tab eq 'notice' ? 'on' : ''}">공지사항</a>
			<a href="${path}/community_event.co" class="tab ${tab eq 'event' ? 'on' : ''}">이벤트</a>
		</div>
	</div>

	<div class="page-body">
		<div class="container">
		
			<!-- 경로 -->
			<div class="breadcrumb-area">
			    <a href="${path}/community_free.co">커뮤니티</a>
			    <i class="bi bi-chevron-right"></i>
			    <span class="cur">자유게시판</span>
			</div>

			<!-- 인기글 TOP3 -->
			<div class="popular-top3-wrap">
			    <div class="section-title-row">
			        <h2 class="section-title">
			            <i class="bi bi-fire text-warning"></i> 인기글 TOP 3
			        </h2>
			        <span class="section-sub">전체 게시글 기준 인기글</span>
			    </div>
			
			    <div class="popular-top3-grid">
			        <c:forEach var="dto" items="${popularList}" varStatus="status">
			            <a href="${path}/community_detail.co?post_id=${dto.post_id}"
			               class="popular-card text-decoration-none text-dark">
			
			                <div class="popular-rank ${status.count == 1 ? 'gold' : status.count == 2 ? 'silver' : 'bronze'}">
			                    ${status.count}
			                </div>
			
			                <div class="popular-thumb">
			                    <img
			                        src="${not empty dto.repImage and not empty dto.repImage.image_url ? dto.repImage.image_url : path.concat('/resources/images/common/no-image.png')}"
			                        alt="${dto.title}"
			                        class="popular-thumb-img">
			                </div>
			
			                <div class="popular-content">
			                    <div class="popular-category-row">
			                        <span class="badge-category">${dto.category}</span>
			                    </div>
			
			                    <div class="popular-title">${dto.title}</div>
			
			                    <div class="popular-meta">
			                        <span><i class="bi bi-eye"></i> ${dto.view_count}</span>
			                        <span><i class="bi bi-heart-fill text-danger"></i> ${dto.like_count}</span>
			                    </div>
			                </div>
			            </a>
			        </c:forEach>
			    </div>
			</div>

			<section class="guide-banner">
				<div class="guide-banner-icon">
					<i class="bi bi-lightbulb-fill"></i>
				</div>
				<div class="guide-banner-text">
					<strong>커뮤니티 이용 안내</strong> 서로를 존중하는 건강한 여행 커뮤니티를 만들어 주세요.
					욕설·비방·홍보성 게시물은 예고 없이 삭제될 수 있습니다.
				</div>
			</section>

			<section class="board-section">
				<div class="board-card">

					<div class="filter-bar">
						<div class="tag-chips">
						    <a href="${path}/community_free.co"
						       class="chip ${empty param.category ? 'on' : ''}">전체</a>
						
						    <a href="${path}/community_free.co?category=맛집수다"
						       class="chip ${param.category eq '맛집수다' ? 'on' : ''}">맛집수다</a>
						
						    <a href="${path}/community_free.co?category=숙소수다"
						       class="chip ${param.category eq '숙소수다' ? 'on' : ''}">숙소수다</a>
						
						    <a href="${path}/community_free.co?category=축제수다"
						       class="chip ${param.category eq '축제수다' ? 'on' : ''}">축제수다</a>
						
						    <a href="${path}/community_free.co?category=정보공유"
						       class="chip ${param.category eq '정보공유' ? 'on' : ''}">정보공유</a>
						
						    <a href="${path}/community_free.co?category=동행구해요"
						       class="chip ${param.category eq '동행구해요' ? 'on' : ''}">동행구해요</a>
						</div>

						<c:if test="${sessionScope.sessionID != null}">
						    <a href="${path}/community_create.co" class="btn-write">
						        <i class="bi bi-pencil-fill" style="font-size: .7rem;"></i> 글쓰기
						    </a>
						</c:if>
					</div>

					<div class="board-head">
						<span>구분</span>
						<span>제목</span>
						<span class="c">카테고리</span>
						<span class="c">작성자</span>
						<span class="c">조회</span>
						<span class="c">추천</span>
						<span class="r">날짜</span>
					</div>
					
					<div class="board-body">
					    <c:choose>
					        <c:when test="${empty freeBoardList}">
					            <div class="empty">
					                <i class="bi bi-chat-square-text"></i>
					                등록된 게시글이 없습니다.
					            </div>
					        </c:when>
					
					        <c:otherwise>
					            <c:forEach var="post" items="${freeBoardList}">
					                <a href="${path}/community_detail.co?post_id=${post.post_id}" class="board-row">
					
					                    <span>
					                        <span class="bdg bdg-free">자유</span>
					                    </span>
					
					                    <span class="board-title">
					                        <span class="title-text">
					                            <c:out value="${post.title}"/>
					                        </span>
					                    </span>
					
					                    <span class="c">
					                        <c:choose>
					                            <c:when test="${not empty post.category}">
					                                <span class="board-category-chip">
					                                    <c:out value="${post.category}"/>
					                                </span>
					                            </c:when>
					                            <c:otherwise>
					                                <span class="board-category-empty">-</span>
					                            </c:otherwise>
					                        </c:choose>
					                    </span>
					
					                    <span class="c meta">
					                        <c:out value="${post.user_id}"/>
					                    </span>
					
					                    <span class="c meta">
					                        ${post.view_count}
					                    </span>
					
					                    <span class="c meta hot">
					                        <i class="bi bi-heart-fill" style="font-size:.65rem;"></i> ${post.like_count}
					                    </span>
					
					                    <span class="r meta">
					                        <fmt:formatDate value="${post.postDate}" pattern="yyyy.MM.dd"/>
					                    </span>
					                </a>
					            </c:forEach>
					        </c:otherwise>
					    </c:choose>
					</div>
				</div>
			</section>

			<!-- 페이징 -->
			<c:if test="${paging.count > 0}">
			    <nav class="paging">
			
			        <!-- 이전 블록 -->
			        <c:if test="${paging.startPage > paging.pageBlock}">
			            <c:url var="prevUrl" value="/community_free.co">
			                <c:param name="pageNum" value="${paging.prev}" />
			                <c:if test="${not empty category}">
			                    <c:param name="category" value="${category}" />
			                </c:if>
			            </c:url>
			            <a class="pg" href="${prevUrl}">‹</a>
			        </c:if>
			
			        <!-- 페이지 번호 -->
			        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
			            <c:url var="pageUrl" value="/community_free.co">
			                <c:param name="pageNum" value="${i}" />
			                <c:if test="${not empty category}">
			                    <c:param name="category" value="${category}" />
			                </c:if>
			            </c:url>
			
			            <a class="pg ${paging.currentPage == i ? 'on' : ''}" href="${pageUrl}">
			                ${i}
			            </a>
			        </c:forEach>
			
			        <!-- 다음 블록 -->
			        <c:if test="${paging.endPage < paging.pageCount}">
			            <c:url var="nextUrl" value="/community_free.co">
			                <c:param name="pageNum" value="${paging.next}" />
			                <c:if test="${not empty category}">
			                    <c:param name="category" value="${category}" />
			                </c:if>
			            </c:url>
			            <a class="pg" href="${nextUrl}">›</a>
			        </c:if>
			
			    </nav>
			</c:if>

			<!-- 검색바 -->
			<div class="search-row">
			    <form class="search-box" action="${path}/community_free.co" method="get">
			        <input type="hidden" name="category" value="${category}" />
			
			        <select name="searchType">
			            <option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
			            <option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
			            <option value="title_content" ${searchType eq 'title_content' ? 'selected' : ''}>제목+내용</option>
			            <option value="writer" ${searchType eq 'writer' ? 'selected' : ''}>작성자</option>
			        </select>
			
			        <input type="text"
			               name="searchKeyword"
			               value="${searchKeyword}"
			               placeholder="검색어를 입력하세요">
			
			        <button type="submit">검색</button>
			    </form>
			</div>

		</div>
	</div>

	<%@ include file="../../common/footer.jsp"%>

</div>
</body>
</html>