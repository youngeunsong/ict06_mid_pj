-- 사용자용 검색화면 사용을 위한 쿼리 모음

SELECT *
FROM "MEMBER" m 

SELECT *
FROM FAVORITE f 
WHERE f.USER_ID = 'user10'

-- [통합 전체 페이지]
-- 검색어 기준 맛집 목록 
 SELECT r.RESTAURANT_ID
     , TO_CHAR(r.DESCRIPTION) AS DESCRIPTION
     , r.PHONE
     , r.CATEGORY
     , r.STATUS AS REST_STATUS
     , r.RESTDATE
     , r.AREACODE
     , p.PLACE_ID
     , p.PLACE_TYPE
     , p.NAME
     , p.ADDRESS
     , p.VIEW_COUNT
     , p.IMAGE_URL
     , p.CREATED_AT AS PLACE_CREATED_AT
  FROM RESTAURANT r
  JOIN PLACE p
    ON r.RESTAURANT_ID = p.PLACE_ID
 WHERE (p.NAME LIKE '%서울%'
    OR  p.ADDRESS LIKE '%서울%'
    OR  r.CATEGORY LIKE '%서울%')
 ORDER BY p.VIEW_COUNT DESC
 
-- 검색어 기준 숙소 목록 
 SELECT a.ACCOMMODATION_ID
     , TO_CHAR(a.DESCRIPTION) AS DESCRIPTION
     , a.PHONE
     , a.PRICE
     , a.STATUS AS ACC_STATUS
     , p.PLACE_ID
     , p.PLACE_TYPE
     , p.NAME
     , p.ADDRESS
     , p.VIEW_COUNT
     , p.IMAGE_URL
     , p.CREATED_AT AS PLACE_CREATED_AT
  FROM ACCOMMODATION a
  JOIN PLACE p
    ON a.ACCOMMODATION_ID = p.PLACE_ID
 WHERE (p.NAME LIKE '%서울%'
    OR  p.ADDRESS LIKE '%서울%')
 ORDER BY p.VIEW_COUNT DESC
 
 -- 검색어 기준 축제 목록 
 SELECT f.FESTIVAL_ID
     , TO_CHAR(f.DESCRIPTION) AS DESCRIPTION
     , f.START_DATE
     , f.END_DATE
     , f.STATUS AS FEST_STATUS
     , p.PLACE_ID
     , p.PLACE_TYPE
     , p.NAME
     , p.ADDRESS
     , p.VIEW_COUNT
     , p.IMAGE_URL
     , p.CREATED_AT AS PLACE_CREATED_AT
  FROM FESTIVAL f
 INNER JOIN PLACE p
    ON f.FESTIVAL_ID = p.PLACE_ID
 WHERE (p.NAME LIKE '%서울%'
    OR  p.ADDRESS LIKE '%서울%')
 ORDER BY p.VIEW_COUNT DESC
 
 -- 검색어 기준 장소별 리뷰 통계
 SELECT p.PLACE_ID AS PLACE_ID
     , COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
     , NVL(ROUND(AVG(rv.RATING), 1), 0) AS AVG_RATING
  FROM PLACE p
  LEFT JOIN REVIEW rv
    ON p.PLACE_ID = rv.PLACE_ID
   AND rv.STATUS = 'DISPLAY'
 WHERE (p.NAME LIKE '%서울%'
    OR  p.ADDRESS LIKE '%서울%')
 GROUP BY p.PLACE_ID
 
 -- [즐겨찾기] -------------------------------------------------------
 -- 즐겨찾기 여부 확인 
 SELECT COUNT(*)
  FROM FAVORITE
 WHERE user_id = 'user03';
 
-- 즐겨찾기 추가
INSERT INTO FAVORITE (
    favorite_id,
    user_id,
    place_id
)
VALUES (
    SEQ_FAVORITE.NEXTVAL,
    'user03',
    787
);

-- 즐겨찾기 삭제 
DELETE FROM FAVORITE
 WHERE user_id = 'user03'
   AND place_id = 787;
   
-- 즐겨찾기 정보 조회
SELECT place_id
  FROM FAVORITE
 WHERE user_id = 'user03';

-- [AJAX 카드 목록 + 카드 갯수] -------------------------------------------------------
-- AJAX맛집 카드 목록 (최신순)
SELECT *
FROM (
    SELECT innerQ.*, ROWNUM rn
    FROM (
        SELECT r.RESTAURANT_ID
             , TO_CHAR(r.DESCRIPTION) AS DESCRIPTION
             , r.PHONE
             , r.CATEGORY
             , r.STATUS AS REST_STATUS
             , r.RESTDATE
             , r.AREACODE
             , p.PLACE_ID
             , p.PLACE_TYPE
             , p.NAME
             , p.ADDRESS
             , p.VIEW_COUNT
             , p.IMAGE_URL
             , p.CREATED_AT AS PLACE_CREATED_AT
        FROM RESTAURANT r
        JOIN PLACE p
          ON r.RESTAURANT_ID = p.PLACE_ID
        WHERE (p.NAME LIKE '%서울%'
           OR  p.ADDRESS LIKE '%서울%'
           OR  r.CATEGORY LIKE '%서울%')
                ORDER BY p.CREATED_AT DESC
    ) innerQ
    WHERE ROWNUM <= 5
)
WHERE rn > 1


-- AJAX맛집 카드 목록 (조회수 순)
SELECT *
FROM (
    SELECT innerQ.*, ROWNUM rn
    FROM (
        SELECT r.RESTAURANT_ID
             , TO_CHAR(r.DESCRIPTION) AS DESCRIPTION
             , r.PHONE
             , r.CATEGORY
             , r.STATUS AS REST_STATUS
             , r.RESTDATE
             , r.AREACODE
             , p.PLACE_ID
             , p.PLACE_TYPE
             , p.NAME
             , p.ADDRESS
             , p.VIEW_COUNT
             , p.IMAGE_URL
             , p.CREATED_AT AS PLACE_CREATED_AT
        FROM RESTAURANT r
        JOIN PLACE p
          ON r.RESTAURANT_ID = p.PLACE_ID
        WHERE (p.NAME LIKE '%서울%'
           OR  p.ADDRESS LIKE '%서울 %'
           OR  r.CATEGORY LIKE '%서울%')
                ORDER BY p.VIEW_COUNT DESC
    ) innerQ
    WHERE ROWNUM <= 5
)
WHERE rn > 1

