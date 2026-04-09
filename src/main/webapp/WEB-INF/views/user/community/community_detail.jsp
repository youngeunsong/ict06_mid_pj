<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-16
 * 최종수정일: 2026-03-23
 * 적용 외부 API : Kakao 공유 API
 (PC : 정상 작동/ 모바일 : URL 올바르게 들어가나 페이지 못 불러옴 <= 정상)
  ㄴ localhost 링크 대상 서버가 모바일에서 접근 불가
  
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 > 자유게시판 > 게시글</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/community.css">

<script src="${path}/resources/js/community/community_detail.js" defer></script>

<!-- 카카오 공유 API -->
<c:set var="shareUrl"
       value="${pageContext.request.scheme}://${pageContext.request.serverName}${path}/community_detail.co?post_id=${dto.post_id}" />

<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js"
        crossorigin="anonymous"></script>

<script>
	window.kakaoShareData = {
	    title: '${dto.title}',
	    description: '맛침내 커뮤니티 자유 게시판',
	    imageUrl: '${not empty dto.repImage and not empty dto.repImage.image_url ? dto.repImage.image_url : "https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_small.png"}',
	    webUrl: '${shareUrl}',
	    mobileWebUrl: '${shareUrl}'
	};
</script>

<script src="${path}/resources/js/common/kakaoShare.js"></script>
<!-- 카카오 공유 API -->

</head>
<body>
<div class="wrap">
	<!-- 컨트롤러에서 API 키 받아오기 -->
	<input type="hidden" id="kakaoShareApiKey" th:value="${kakaoShareApiKey}" />

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

	<!-- header -->
    <%@ include file="../../common/header.jsp" %>
    
    <div class="comm-tabs">
	    <div class="container">
	        <a href="${path}/community_free.co" class="tab on">자유게시판</a>
	        <a href="${path}/community_notice.co" class="tab">공지사항</a>
	        <a href="${path}/community_event.co" class="tab">이벤트</a>
	    </div>
	</div>

	<!-- 숨김/삭제된 게시글 접근 차단:시작 -->
	<c:if test="${not empty errorMsg}">
		<!-- 경고창 모달:시작 -->
		<div class="modal fade" id="errorModal" tabindex="-1">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-body text-center py-4">
						<i class="bi bi-exclamation-circle text-danger" style="font-size:2rem;"></i>
						<p class="mt-3 mb-0">${errorMsg}</p>
					</div>
					<div class="modal-footer justify-content-center">
						<button type="button" class="btn btn-secondary" onclick="history.back()">확인</button>
					</div>
				</div>
			</div>
		</div>
		<script>
			document.addEventListener("DOMContentLoaded", function() {
				var modal = new bootstrap.Modal(document.getElementById('errorModal'));
				modal.show();
			});
		</script>
		<!-- 경고창 모달:끝 -->
	</c:if>
	<!-- 숨김/삭제된 게시글 접근 차단:끝 -->
	
    <div class="page-body">
        <div class="container">

            <!-- breadcrumb -->
            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <a href="${path}/community_free.co">자유게시판</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <span class="cur">자유게시판 상세</span>
            </div>

            <!-- post -->
            <div class="post-box">

                <div class="post-header">
                    <span class="post-cat">${dto.category}</span>

                    <h3 class="post-title">${dto.title}</h3>
                    
                    <div class="post-meta">
                        <div class="post-author">
                            <div class="avatar">
                                ${dto.user_id != null ? fn:substring(dto.user_id, 0, 1) : 'U'}
                            </div>
                            <div>
                                <div class="author-name">${dto.user_id}</div>
                                <div class="author-date">
                                    <fmt:formatDate value="${dto.postDate}" pattern="yyyy.MM.dd HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="post-stats">
                            <span><i class="bi bi-eye"></i> ${dto.view_count}</span>
                            <span><i class="bi bi-heart"></i> ${dto.like_count}</span>
                        </div>
                    </div>
                </div>
                
                <!-- 다중 이미지 + 썸네일 구조 (Fallback 포함) -->
                <c:choose>
                    <c:when test="${not empty imageList}">
                        <div class="post-cover">
                            <img src="${imageList[0].image_url}" alt="${dto.title}" class="post-cover-img" id="mainImage">
                        </div>
                        <!-- 썸네일 영역 (2장 이상) -->
                        <c:if test="${fn:length(imageList) > 1}">
                            <div class="thumbnail-list mt-3 d-flex justify-content-center gap-2">
                                <c:forEach var="image" items="${imageList}" begin="0" end="4">
                                    <img src="${image.image_url}" class="thumb-img" alt="썸네일">
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:when test="${not empty dto.repImage and not empty dto.repImage.image_url}">
                        <div class="post-cover">
                            <img src="${dto.repImage.image_url}" alt="${dto.title}" class="post-cover-img" id="mainImage">
                        </div>
                    </c:when>
                </c:choose>

                <div class="post-body">
                    ${dto.content}
                </div>

				<!-- 하단 액션 버튼 영역 -->
				<div class="detail-action-wrap">
				    <div class="detail-action-bar">
				
						<button type="button"
						        class="pill-btn like-pill-btn"
						        id="likeBtn"
						        data-post-id="${dto.post_id}"
						        data-path="${path}"
						        data-session-id="${sessionScope.sessionID}">
						    <i class="bi bi-heart"></i>
						    <span>좋아요</span>
						    <span class="divider">|</span>
						    <span id="likeCount">${dto.like_count}</span><span>명</span>
						</button>
				
				        <a href="${path}/community_free.co" class="pill-btn list-pill-btn">
				            <i class="bi bi-list"></i>
				            <span>목록</span>
				        </a>
				
				        <button type="button" id="kakaoShareBtn" class="pill-btn kakao-pill-btn">
				            <span class="kakao-dot">💬</span>
				            <span>카카오톡 공유</span>
				        </button>
				    </div>
				</div>
				
				<c:if test="${sessionScope.sessionID == dto.user_id}">
				    <div class="post-footer mt-3">
				        <a href="${path}/community_modify.co?post_id=${dto.post_id}" class="btn btn-outline-secondary">수정</a>
				
				        <form action="${path}/community_delete.co" method="post" style="display:inline;">
				            <input type="hidden" name="post_id" value="${dto.post_id}">
				            <button type="submit"
				                    class="btn btn-outline-danger"
				                    onclick="return confirm('게시글을 삭제하시겠습니까?');">
				                삭제
				            </button>
				        </form>
				    </div>
				</c:if>
				
				
            <!-- 게시글 댓글 S -->
            <div class="comment-box">
			    <div class="comment-header">
			        <i class="bi bi-chat-left-text"></i>
			        댓글
			        <span class="comment-count">${fn:length(commentList)}</span>
			    </div>
			
			    <c:choose>
			        <c:when test="${empty commentList}">
			            <div class="comment-empty">
			                <i class="bi bi-chat-square-dots"></i>
			                아직 등록된 댓글이 없습니다.
			            </div>
			        </c:when>
			
			        <c:otherwise>
			            <c:forEach var="comment" items="${commentList}">
			                <div class="comment-item">
			                    <div class="comment-top">
									<%-- 댓글 삭제 --%>
								    <div class="comment-author-wrap">
								        <div class="comment-avatar">
								            ${fn:substring(comment.user_id,0,1)}
								        </div>
								
								        <div>
								            <span class="comment-name">${comment.user_id}</span>
								            <span class="comment-date">
								                <fmt:formatDate value="${comment.commentDate}" pattern="yyyy.MM.dd HH:mm"/>
								            </span>
								        </div>
								    </div>
								
								    <%-- 작성자만 삭제 가능 --%>
								    <c:if test="${sessionScope.sessionID == comment.user_id}">
									    <form action="${path}/comment_delete.co" method="post">
									        <input type="hidden" name="comment_id" value="${comment.comment_id}">
									        <input type="hidden" name="post_id" value="${dto.post_id}">
									        <button type="submit"
									                class="btn-comment-del"
									                onclick="return confirm('댓글을 삭제하시겠습니까?');">
									            삭제
									        </button>
									    </form>
									</c:if>
								
								</div>

			
			                    <div class="comment-content">
			                        ${comment.content}
			                    </div>
			                </div>
			            </c:forEach>
			        </c:otherwise>
			    </c:choose>
			    
			    <!-- 댓글 입력 S -->
				<c:choose>
				    <c:when test="${sessionScope.sessionID != null}">
				        <form action="${path}/comment_insert.co" method="post">
				            <input type="hidden" name="post_id" value="${dto.post_id}">
				
				            <div class="comment-write">
				                <div class="write-avatar">
				                    ${fn:substring(sessionScope.sessionID, 0, 1)}
				                </div>
				
				                <textarea name="content" rows="2" placeholder="댓글을 입력하세요" required></textarea>
				
				                <button type="submit" class="btn-comment-submit">등록</button>
				            </div>
				        </form>
				    </c:when>
				
				    <c:otherwise>
				        <div class="login-required">
				            댓글을 작성하려면 <a href="${path}/login.do">로그인</a> 해주세요.
				        </div>
				    </c:otherwise>
				</c:choose>
				<!-- 댓글 입력 E -->
				
			</div>
			<!-- 게시글 댓글 E -->

        </div>
    </div>

	<!-- footer -->
    <%@ include file="../../common/footer.jsp" %>

</div>
</body>
</html>