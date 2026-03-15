-- 사용자용 커뮤니티 메뉴 사용을 위한 쿼리 모음

-- 자유게시판 목록
SELECT post_id,
       user_id,
       title,
       content,
       category,
       view_count,
       like_count,
       status,
       created_at,
       updated_at
  FROM COMMUNITY
 WHERE category = 'FREE'
   AND status = 'DISPLAY'
 ORDER BY post_id DESC;
 
 -- 이벤트 목록 목록
 SELECT post_id,
       user_id,
       title,
       content,
       category,
       view_count,
       like_count,
       status,
       created_at,
       updated_at
  FROM COMMUNITY
 WHERE category = 'EVENT'
   AND status = 'DISPLAY'
 ORDER BY post_id DESC;
 
 -- 게시글 상세
 SELECT post_id,
       user_id,
       title,
       content,
       category,
       view_count,
       like_count,
       status,
       created_at,
       updated_at
  FROM COMMUNITY
 WHERE post_id = 60;
 
 -- 댓글 목록
 SELECT comment_id,
       post_id,
       user_id,
       content,
       status,
       created_at,
       updated_at
  FROM COMMUNITY_COMMENT
 WHERE post_id = 60
   AND status = 'DISPLAY'
 ORDER BY comment_id ASC;