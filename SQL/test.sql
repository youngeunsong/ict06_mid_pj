-------------------------------------------------
-- 아래부터 ict06_team1_midpj 계정에서 작업
-- mvc_user_tbl : mvc_address_tbl => 1 : 1
-- mvc_user_tbl : mvc_board_tbl => 1 : N

-- 1) 지금 접속한 스키마 확인
SELECT USER FROM dual;

-- 2) 실제 컬럼 타입 재확인 (OWNER 포함해서 보려면 ALL_TAB_COLUMNS)
SELECT owner, table_name, column_name, data_type
FROM all_tab_columns
WHERE table_name = 'MVC_USER_TBL'
  AND column_name = 'USER_ID';

-- 참고) MEMBER
SELECT user_id       -- 계정 ID
     , password      -- 계정 패스워드
     , name          -- 회원명
     , point_balance -- 포인트
     , ROLE          -- 유저: ROLE_USER/ 관리자: admin
FROM MEMBER

SELECT *
FROM "MEMBER" m 

-- 참고) 플레이스
SELECT PLACE_ID   -- 장소 고유 번호 (PK, 부모)
     , place_type -- 구분 (REST: 맛집, ACC: 숙소, FEST: 축제)
     , name       -- 장소/업체 이름
     , address    -- 지번/도로명 주소
     , view_count -- 조회수 (인기순 정렬용)
     , image_url  -- 대표 이미지 경로
     , created_at -- 등록일 (DTO: placeRegDate)
FROM PLACE

UPDATE PLACE
SET created_at =
    CASE TRUNC(DBMS_RANDOM.VALUE(1,5))
        WHEN 1 THEN SYSTIMESTAMP                -- 오늘
        WHEN 2 THEN SYSTIMESTAMP - INTERVAL '1' DAY   -- 어제
        WHEN 3 THEN SYSTIMESTAMP - INTERVAL '2' DAY   -- 그제
        WHEN 4 THEN SYSTIMESTAMP - INTERVAL '7' DAY   -- 일주일 전
    END
WHERE place_id BETWEEN 1 AND 50;

-- 참고) 맛집
SELECT RESTAURANT_ID -- 장소 번호 (PK, FK: PLACE 참조)
     , CATEGORY      -- 음식 종류 (한식, 일식 등)
     , DESCRIPTION   -- 맛집 소개 및 상세 설명
     , PHONE         -- 식당 전화번호
     , STATUS        -- 영업 상태 (OPEN, CLOSED)
FROM RESTAURANT

-- 
SELECT *
FROM ACCOMMODATION

SELECT category, COUNT(*)
FROM COMMUNITY
WHERE status = 'DISPLAY'
GROUP BY category
ORDER BY category;


SELECT *
FROM COMMUNITY
WHERE CATEGORY LIKE '맛집수다'



-- 참고) 리뷰
SELECT REVIEW_ID  -- 리뷰 번호 (PK, 시퀀스)
     , USER_ID    -- 작성자 ID (FK)
     , STATUS     -- 노출 상태 (DISPLAY, HIDDEN)
     , RATING     -- 별점 (1~5점)
     , PLACE_ID   -- 대상 장소 ID (FK)
     , CREATED_AT -- 작성일 (DTO: reviewDate)
     , CONTENT    -- 후기 내용
FROM REVIEW

-- 참고) 축제
SELECT FESTIVAL_ID -- 장소 번호 (PK, FK: PLACE 참조)
     , DESCRIPTION -- 축제 개요 및 행사 내용
     , START_DATE  -- 축제 시작 날짜
     , END_DATE    -- 축제 종료 날짜
     , STATUS      -- 진행 상태 (예정 UPCOMING, 진행중ONGOING, 종료ENDED)
FROM FESTIVAL

-- 참고) 즐겨찾기
SELECT FAVORITE_ID 
	 , USER_ID     
     , PLACE_ID 
     , CREATED_AT 
FROM FAVORITE

-- 참고) 이미지 뱅크
SELECT CREATED_AT        -- 등록일 (DTO: imgUploadDate)
     , IMAGE_ID          -- 이미지 번호 (PK, 시퀀스)
     , IMAGE_URL         -- 실제 이미지 저장 경로
     , IS_REPRESENTATIVE -- 대표 이미지 여부 ('Y', 'N')
     , SORT_ORDER        -- 이미지 출력 순서(number)
     , TARGET_ID         -- 대상 ID (PLACE_ID 혹은 REVIEW_ID)
     , TARGET_TYPE       -- 구분 (PLACE 또는 REVIEW)
FROM IMAGE_STORE
 
-- 2) SEARCH_HISTORY =================================
SELECT HISTORY_ID -- 검색 기록 번호 (PK, 시퀀스)    => NUMBER 
     , USER_ID    -- 사용자 ID(FK)              => VARCHAR2
     , KEYWORD    -- 검색한 키워드                => VARCHAR2
     , CREATED_AT -- 검색 일시 (DTO: searchDate) => TIMESTAMP 
FROM SEARCH_HISTORY

-- [searchMapper] 1. 가장 최근에 검색한 5개 키워드
SELECT keyword
FROM (
	SELECT keyword
      FROM SEARCH_HISTORY
     WHERE user_id = '1'
     ORDER BY HISTORY_ID DESC	
	 )
WHERE ROWNUM <= 5;

-- [searchMapper] 2. 가장 최근에 검색한 5개 키워드 중 일부 삭제하기
DELETE FROM SEARCH_HISTORY
 WHERE keyword = ''
 
-- [searchMapper] 3. 검색 페이지 내 정보 : 업체명과 주소에 키워드와 같은 단어가 있을 시 조회수가 높은 순으로 정렬하여 보여주기
-- 3-1. (미사용) 검색명에 따라 플레이스 검색
SELECT p.place_type
     , p.name
     , p.address
     , p.view_count
     , p.image_url
     , p.created_at
FROM PLACE p
WHERE (name LIKE '%서울%' OR address LIKE '%서울%')
ORDER BY view_count DESC;

-- 3-2. (미사용) 리뷰 수 카운트
SELECT p.PLACE_ID AS PLACE_ID
     , COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
     , NVL(ROUND(AVG(rv.RATING), 1), 0) AS AVG_RATING
  FROM PLACE p
  LEFT JOIN REVIEW rv
    ON p.PLACE_ID = rv.PLACE_ID
   AND rv.STATUS = 'DISPLAY'
 WHERE (p.NAME LIKE '%바다%'
    OR  p.ADDRESS LIKE '%바다%')
 GROUP BY p.PLACE_ID

-- 3-3. (미사용) 검색명에 따른 플레이스 검색 + 리뷰 수 카운트 맛집/숙소
SELECT p.PLACE_TYPE,
       p.NAME,
       p.ADDRESS,
       p.VIEW_COUNT,
       p.IMAGE_URL,
       avg(NVL(rating, 0)) AS rating_avg,
       COUNT(rv.REVIEW_ID) AS REVIEW_COUNT   -- 리뷰 수 추가
FROM PLACE p
    LEFT JOIN REVIEW rv ON p.PLACE_ID = rv.PLACE_ID   -- 리뷰 없어도 표시
WHERE (p.NAME    LIKE '%푸른%'
    OR p.ADDRESS LIKE '%푸른%')
GROUP BY p.PLACE_ID,        -- 장소별로 묶어서 COUNT
         p.PLACE_TYPE,
         p.NAME,
         p.ADDRESS,
         p.VIEW_COUNT,
         p.IMAGE_URL,
         p.CREATED_AT
ORDER BY p.VIEW_COUNT DESC;

-- (실사용) 검색명에 따른 플레이스 검색 + 리뷰 수 카운트하기 위한 식 => 계산은 서비스에서 맛집/숙소
SELECT p.PLACE_TYPE,
       p.NAME,
       p.ADDRESS,
       p.VIEW_COUNT,
       p.IMAGE_URL,
       rv.rating, -- 각 장소 별 별점 평균
       rv.REVIEW_ID -- 리뷰 갯수
FROM PLACE p
    LEFT JOIN REVIEW rv ON p.PLACE_ID = rv.PLACE_ID
WHERE (p.NAME    LIKE '%푸른%'
    OR p.ADDRESS LIKE '%푸른%')
ORDER BY p.VIEW_COUNT DESC;

-- 3-4. (추가) 축제 상세 리스트 가져오기
SELECT f.FESTIVAL_ID 
	 , TO_CHAR(f.DESCRIPTION) AS DESCRIPTION
	 , f.START_DATE 
	 , f.END_DATE 
	 , f.STATUS
	 , p.PLACE_TYPE
     , p.NAME
     , p.ADDRESS
     , p.VIEW_COUNT
     , p.IMAGE_URL
     , rv.rating
     , rv.REVIEW_ID
  FROM FESTIVAL f
 INNER JOIN PLACE p ON f.FESTIVAL_ID = p.PLACE_ID
  LEFT JOIN REVIEW rv  ON p.PLACE_ID = rv.PLACE_ID
 WHERE (p.NAME LIKE '%축제%' OR p.address LIKE '%축제%')
ORDER BY p.VIEW_COUNT DESC;


SELECT f.FESTIVAL_ID 
	 , TO_CHAR(f.DESCRIPTION) AS DESCRIPTION
	 , f.START_DATE 
	 , f.END_DATE 
	 , f.STATUS
	 , p.PLACE_TYPE
     , p.NAME
     , p.ADDRESS
     , p.VIEW_COUNT
     , p.IMAGE_URL
     , avg(NVL(rating, 0)) AS rating_avg
     , COUNT(rv.REVIEW_ID) AS REVIEW_COUNT   -- 리뷰 수 추가
  FROM FESTIVAL f
 INNER JOIN PLACE p ON f.FESTIVAL_ID = p.PLACE_ID
  LEFT JOIN REVIEW rv  ON p.PLACE_ID = rv.PLACE_ID
 WHERE (p.NAME LIKE '%축제%' OR p.address LIKE '%축제%')
GROUP BY f.FESTIVAL_ID 
       , TO_CHAR(f.DESCRIPTION)
       , f.START_DATE 
       , f.END_DATE 
       , f.STATUS
       , p.PLACE_TYPE
       , p.NAME
       , p.ADDRESS
       , p.VIEW_COUNT
       , p.IMAGE_URL 
ORDER BY p.VIEW_COUNT DESC;




SELECT p.PLACE_TYPE,
       p.NAME,
       p.ADDRESS,
       p.VIEW_COUNT,
       p.IMAGE_URL,
       rv.rating, -- 각 장소 별 별점 평균
       rv.REVIEW_ID -- 리뷰 갯수
FROM PLACE p
    LEFT JOIN REVIEW rv ON p.PLACE_ID = rv.PLACE_ID
ORDER BY p.VIEW_COUNT DESC;



SELECT *
FROM (
    SELECT p.place_id,
           p.name,
           p.address,
           p.view_count,
           p.created_at,
           r.category,
           r.phone
    FROM PLACE p
    JOIN RESTAURANT r
      ON p.place_id = r.restaurant_id
    WHERE p.place_type = 'ACC'
      AND p.created_at >= SYSTIMESTAMP -
          CASE 
            WHEN (
                SELECT COUNT(*)
                FROM PLACE
                WHERE place_type = 'ACC'
                  AND created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
            ) < 10
            THEN INTERVAL '60' DAY
            ELSE INTERVAL '30' DAY
          END
    ORDER BY p.view_count DESC
)
WHERE ROWNUM = 1;


-- [MAIN : TOP 10] 식당
SELECT *
  FROM (
    SELECT p.PLACE_ID
         , p.PLACE_TYPE
         , p.NAME
         , p.ADDRESS
         , p.VIEW_COUNT
         , p.IMAGE_URL
         , p.CREATED_AT AS placeRegDate
      FROM PLACE p
     WHERE p.PLACE_TYPE = 'REST'
       AND p.created_at >= SYSTIMESTAMP -
	  CASE 
	    WHEN (
	        SELECT COUNT(*)
	        FROM PLACE
	        WHERE place_type = 'REST'
	          AND created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
	    ) < 10
      THEN INTERVAL '60' DAY
      ELSE INTERVAL '30' DAY
       END
     ORDER BY p.VIEW_COUNT DESC
)
WHERE ROWNUM <= 10

-- [MAIN : TOP 10] 숙소
SELECT *
  FROM (
          SELECT a.ACCOMMODATION_ID
         , a.DESCRIPTION
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
     WHERE p.PLACE_TYPE = 'ACC'
       AND p.created_at >= SYSTIMESTAMP -
	  CASE 
	    WHEN (
	        SELECT COUNT(*)
	        FROM PLACE
	        WHERE place_type = 'ACC'
	          AND created_at >= SYSTIMESTAMP - INTERVAL '30' DAY
	    ) < 10
      THEN INTERVAL '60' DAY
      ELSE INTERVAL '30' DAY
       END
     ORDER BY p.VIEW_COUNT DESC
)
WHERE ROWNUM <= 10

