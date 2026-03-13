<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>게시글 상세</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/commuity_detail.css">

<script src="${path}/resources/js/community/community_detail.js" defer></script>

</head>
<body>
<div class="wrap">

	<!-- header -->
    <%@ include file="../../common/header.jsp" %>

    <div class="page-body">
        <div class="container detail-container">

            <!-- breadcrumb -->
            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
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

                <div class="post-body">
                    ${dto.content}
                </div>

                <div class="like-area">
                    <button type="button" class="btn-like">
                        <i class="bi bi-heart"></i>
                        좋아요 ${dto.like_count}
                    </button>
                </div>

                <div class="post-footer">
				    <a href="${path}/community_free.co" class="btn-list">
				        <i class="bi bi-list-ul"></i> 목록
				    </a>
				
				    <c:if test="${sessionScope.sessionID == dto.user_id}">
				        <div class="post-footer-right">
				            <a href="${path}/community_modify.co?post_id=${dto.post_id}" class="btn-edit">
				                <i class="bi bi-pencil-square"></i> 수정
				            </a>
				
				            <form action="${path}/community_delete.co" method="post" style="display:inline;">
				                <input type="hidden" name="post_id" value="${dto.post_id}">
				                <button type="submit"
				                        class="btn-del"
				                        onclick="return confirm('게시글을 삭제하시겠습니까?');">
				                    <i class="bi bi-trash"></i> 삭제
				                </button>
				            </form>
				        </div>
				    </c:if>
				</div>

            </div>

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