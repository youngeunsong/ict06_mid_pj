-- 사용자용 커뮤니티 메뉴 사용을 위한 쿼리 모음

--------------------------------------
-- 커뮤니티 > 자유게시판
--------------------------------------
-- 자유게시판 목록 총 갯수
SELECT COUNT(*)
  FROM COMMUNITY
 WHERE status = 'DISPLAY'
   AND category = '맛집수다' -- 축제수다 숙소수다 정보공유 동행구해요
   
-- 페이징 : 자유게시판 목록(카테고리 필터)
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
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY post_id DESC) AS rn,
               post_id,
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
         WHERE status = 'DISPLAY'
       AND category = '맛집수다' -- 축제수다 숙소수다 정보공유 동행구해요
   )
 WHERE rn BETWEEN 1 AND 10;

-- 인기글 TOP3
SELECT *
  FROM (
        SELECT c.post_id,
               c.user_id,
               c.title,
               c.content,
               c.category,
               c.view_count,
               c.like_count,
               c.status,
               c.created_at,
               c.updated_at,
               img.image_id          AS rep_image_id,
               img.target_id         AS rep_target_id,
               img.target_type       AS rep_target_type,
               img.image_url         AS rep_image_url,
               img.is_representative AS rep_is_representative,
               img.sort_order        AS rep_sort_order,
               img.created_at        AS rep_created_at
          FROM COMMUNITY c
          LEFT JOIN IMAGE_STORE img
            ON c.post_id = img.target_id
           AND img.target_type = 'COMMUNITY'
           AND img.is_representative = 'Y'
         WHERE c.status = 'DISPLAY'
         ORDER BY c.like_count DESC, c.view_count DESC, c.post_id DESC
       )
 WHERE ROWNUM <= 3

-- 게시글 상세 
SELECT c.post_id,
       c.user_id,
       c.title,
       c.content,
       c.category,
       c.view_count,
       c.like_count,
       c.status,
       c.created_at,
       c.updated_at,
       img.image_id          AS rep_image_id,
       img.target_id         AS rep_target_id,
       img.target_type       AS rep_target_type,
       img.image_url         AS rep_image_url,
       img.is_representative AS rep_is_representative,
       img.sort_order        AS rep_sort_order,
       img.created_at        AS rep_created_at
  FROM COMMUNITY c
  LEFT JOIN IMAGE_STORE img
    ON c.post_id = img.target_id
   AND img.target_type = 'COMMUNITY'
   AND img.is_representative = 'Y'
 WHERE c.post_id = 167;

-- 조회수 증가
UPDATE COMMUNITY
   SET view_count = view_count + 1
 WHERE post_id = 167;

SELECT view_count
  FROM COMMUNITY
WHERE post_id = 167;

-- 게시글 작성
INSERT INTO COMMUNITY (
    post_id,
    user_id,
    title,
    content,
    category
) VALUES (
    SEQ_POST.NEXTVAL,
    'user01',
    '맛집 리뷰 제목',
    '맛집 리뷰 내용',
    '맛집수다'
)

SELECT *
  FROM COMMUNITY
WHERE title = '맛집 리뷰 제목';


-- 게시글 작성 (이미지 추가)
INSERT INTO IMAGE_STORE (
	        image_id,
	        target_id,
	        target_type,
	        image_url,
	        is_representative,
	        sort_order,
	        created_at
	    ) VALUES (
	        SEQ_IMAGE.NEXTVAL,
	        #{target_id},
	        'COMMUNITY',
	        #{image_url},
	        #{is_representative},
	        #{sort_order},
	        SYSTIMESTAMP
	    )

-- 게시글 1건 확인 쿼리	   
SELECT * FROM COMMUNITY WHERE post_id = 1;
-- 대표 이미지 확인 쿼리
SELECT * FROM IMAGE_STORE WHERE TARGET_ID = 57;
-- 본문 이미지 확인 쿼리
SELECT content FROM COMMUNITY WHERE post_id = 167;


-- 대표 이미지 테스트를 위한 업데이트 쿼리
UPDATE IMAGE_STORE
SET image_url = 'https://substackcdn.com/image/fetch/$s_!KsAZ!,w_1456,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F3a8d8ed3-7f51-41a8-ae12-81ec59bae0ec_4032x3024.jpeg'
WHERE TARGET_ID = 20


-- 게시글 삭제
UPDATE COMMUNITY
   SET status = 'HIDDEN',
       updated_at = SYSTIMESTAMP
 WHERE post_id = 166;

-- 게시글 수정
UPDATE COMMUNITY
   SET title = '맛집 리뷰 제목2',
       content = '맛집 리뷰 내용2',
       category = '맛집수다',
       updated_at = SYSTIMESTAMP
 WHERE post_id = 181;

-- 게시글 수정 시 기존 COMMUNITY 대표 이미지 전체 삭제
-- 게시글 내부 이미지는 게시글 내부 url값으로 들어가기 때문에 쿼리 삭제 불가능
DELETE FROM IMAGE_STORE
 WHERE target_type = 'COMMUNITY'
   AND target_id = 166;

-- 검색 게시글 갯수
SELECT COUNT(*)
  FROM COMMUNITY
 WHERE status = 'DISPLAY'
   AND category = '맛집수다'
   AND title LIKE '%리뷰%'

-- 검색 게시글 리스트
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
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY post_id DESC) AS rn,
               post_id,
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
         WHERE status = 'DISPLAY'
           AND title LIKE '%리%'
       )
 WHERE rn BETWEEN 1 AND 10
 
-- 게시글 좋아요 여부 체크
-- 좋아요 있으면 1/ 없으면 0
SELECT COUNT(*)
  FROM COMMUNITY_LIKE
 WHERE user_id = 'user01'
   AND post_id = 57;

-- 게시글 좋아요 추가
INSERT INTO COMMUNITY_LIKE (
    like_id, user_id, post_id, created_at
) VALUES (
    SEQ_COMMUNITY_LIKE.NEXTVAL,
    'user01',
    57,
    SYSTIMESTAMP
)

-- 게시글 좋아요 삭제
DELETE FROM COMMUNITY_LIKE
WHERE user_id = 'user01'
  AND post_id = 57;
 
-- 게시글 좋아요 증가
 UPDATE COMMUNITY
    SET like_count = NVL(like_count, 0) + 1
  WHERE post_id = 57;

-- 게시글 좋아요 감소
UPDATE COMMUNITY
SET like_count = CASE
                    WHEN NVL(like_count, 0) > 0 THEN like_count - 1
                    ELSE 0
                 END
WHERE post_id = 57;
 
--------------------------------------
-- 커뮤니티 > 댓글 목록
--------------------------------------
 -- 댓글 목록
 SELECT comment_id,
       post_id,
       user_id,
       content,
       status,
       created_at,
       updated_at
  FROM COMMUNITY_COMMENT
 WHERE post_id = 100
   AND status = 'DISPLAY'
 ORDER BY comment_id ASC
 
 -- 댓글 등록
INSERT INTO COMMUNITY_COMMENT (
    comment_id,
    post_id,
    user_id,
    content,
    status,
    created_at
)
VALUES (
    SEQ_COMMENT.NEXTVAL,
    161,
    'user02',
    'test다~~',
    'DISPLAY',
    SYSTIMESTAMP
)

-- 댓글 작성자 검증
SELECT comment_id,
       post_id,
       user_id,
       content,
       status,
       created_at,
       updated_at
  FROM COMMUNITY_COMMENT
 WHERE comment_id = 4041;

-- 댓글삭제 / 화면에서 안보이게 status 'HIDDEN'으로 업데이트
UPDATE COMMUNITY_COMMENT
   SET status = 'HIDDEN'
 WHERE comment_id = 4041; 
 

--------------------------------------
-- 커뮤니티 > 공지사항
--------------------------------------
-- 공지사항 - 상단 고정 공지        
SELECT notice_id,
       admin_id,
       category,
       title,
       content,
       image_url,
       view_count,
       is_top,
       created_at,
       updated_at
  FROM NOTICE
 WHERE category = 'NOTICE'
   AND is_top = 'Y'
 ORDER BY notice_id DESC;

SELECT *
FROM NOTICE

 -- 공지사항 일반 목록
-- 검색 조건 변수 (테스트 시 직접 값 입력)
-- searchKeyword : '공지'
-- searchType    : 'title' / 'content' / 'all'
-- end           : 10

SELECT *
  FROM (
        SELECT ROWNUM AS rn, A.*
          FROM (
                SELECT notice_id,
                       admin_id,
                       category,
                       title,
                       content,
                       image_url,
                       view_count,
                       is_top,
                       created_at,
                       updated_at
                  FROM NOTICE
                 WHERE category = 'NOTICE'
                   AND is_top = 'N'

                -- ▼ searchType에 따라 아래 셋 중 하나만 활성화

                -- [1] searchType = 'title' 일 때
                   AND title LIKE '%' || '공지' || '%'

                -- [2] searchType = 'content' 일 때
                -- AND content LIKE '%' || '공지' || '%'

                -- [3] searchType = 'all' (otherwise) 또는 기타일 때
                -- AND (
                --       title   LIKE '%' || '공지' || '%'
                --    OR content LIKE '%' || '공지' || '%'
                --     )

                 ORDER BY notice_id DESC
               ) A
         WHERE ROWNUM <= 10   -- #{end} 값
       )

-- 공지사항 페이징
SELECT COUNT(*)
  FROM NOTICE
 WHERE category = 'NOTICE'
   AND is_top = 'N'

-- ▼ searchKeyword = '공지' 가 있을 때만 아래 조건 추가
-- searchType에 따라 셋 중 하나만 활성화

-- [1] searchType = 'title' 일 때
   AND title LIKE '%' || '공지' || '%'

-- [2] searchType = 'content' 일 때
-- AND content LIKE '%' || '공지' || '%'

-- [3] searchType = 'all' (otherwise) 또는 기타일 때
-- AND (
--       title   LIKE '%' || '공지' || '%'
--    OR content LIKE '%' || '공지' || '%'
--     )       
       
   
SELECT *
FROM NOTICE n 
WHERE category = 'EVENT'

 -- 이벤트 상단 고정
 SELECT notice_id,
       admin_id,
       category,
       title,
       content,
       image_url,
       view_count,
       is_top,
       created_at,
       updated_at
  FROM NOTICE
 WHERE category = 'EVENT'
   AND is_top = 'Y'
 ORDER BY notice_id DESC

-- 이벤트 상단 고정 테스트를 위한 임시 쿼리 ----------------
-- 트리거 비활성화
ALTER TRIGGER TRG_NOTICE_ADMIN_CHECK DISABLE;

-- UPDATE 실행
UPDATE NOTICE
   SET is_top = 'Y'
 WHERE notice_id = 30;

COMMIT;

-- 트리거 다시 활성화
ALTER TRIGGER TRG_NOTICE_ADMIN_CHECK ENABLE;

COMMIT;
----------------------------------------------------------------

SELECT category, is_top, COUNT(*) cnt
FROM NOTICE
WHERE category = 'NOTICE'
GROUP BY category, is_top
ORDER BY is_top;

SELECT COUNT(*)
FROM NOTICE
WHERE category = 'NOTICE'
  AND is_top = 'N';

SELECT category, is_top, COUNT(*) cnt
FROM NOTICE
WHERE category = 'EVENT'
GROUP BY category, is_top
ORDER BY is_top;

SELECT COUNT(*)
FROM NOTICE
WHERE category = 'EVENT'
  AND is_top = 'N';

-- 종류 이벤트
SELECT *
  FROM (
        SELECT ROWNUM AS rn, A.*
          FROM (
                SELECT notice_id,
                       admin_id,
                       category,
                       title,
                       content,
                       image_url,
                       view_count,
                       is_top,
                       created_at,
                       updated_at
                  FROM NOTICE
                 WHERE category = 'EVENT'
                   AND is_top = 'N'
                   AND title LIKE '%이벤트%'
                 ORDER BY notice_id DESC
               ) A
         WHERE ROWNUM <= 10
       )
 WHERE rn >= 1
 
 -- 이벤트 페이징
 SELECT COUNT(*)
  FROM NOTICE
 WHERE category = 'EVENT'
   AND is_top = 'N'
   AND title LIKE '%이벤트%'
   
-- 상세(공지/ 이벤트 공통 활용)
   SELECT notice_id,
               admin_id,
               category,
               title,
               content,
               image_url,
               view_count,
               is_top,
               created_at,
               updated_at
          FROM NOTICE
         WHERE notice_id = 40
 
 

