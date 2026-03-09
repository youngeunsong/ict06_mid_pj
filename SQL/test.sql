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

-- 참고) 플레이스
SELECT PLACE_ID   -- 장소 고유 번호 (PK, 부모)
     , place_type -- 구분 (REST: 맛집, ACC: 숙소, FEST: 축제)
     , name       -- 장소/업체 이름
     , address    -- 지번/도로명 주소
     , view_count -- 조회수 (인기순 정렬용)
     , image_url  -- 대표 이미지 경로
     , created_at -- 등록일 (DTO: placeRegDate)
FROM PLACE

-- 참고) 맛집
SELECT RESTAURANT_ID -- 장소 번호 (PK, FK: PLACE 참조)
     , CATEGORY      -- 음식 종류 (한식, 일식 등)
     , DESCRIPTION   -- 맛집 소개 및 상세 설명
     , PHONE         -- 식당 전화번호
     , STATUS        -- 영업 상태 (OPEN, CLOSED)
FROM RESTAURANT

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
SELECT COUNT (*)
FROM REVIEW
WHERE PLACE_ID = '2'

-- 3-3. (실사용) 검색명에 따른 플레이스 검색 + 리뷰 수 카운트 맛집/숙소
SELECT p.PLACE_TYPE,
       p.NAME,
       p.ADDRESS,
       p.VIEW_COUNT,
       p.IMAGE_URL,
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

-- 3-4. (추가) 축제 진행상황 체크
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







SELECT FESTIVAL_ID -- 장소 번호 (PK, FK: PLACE 참조)
     , DESCRIPTION -- 축제 개요 및 행사 내용
     , START_DATE  -- 축제 시작 날짜
     , END_DATE    -- 축제 종료 날짜
     , STATUS      -- 진행 상태 (예정 UPCOMING, 진행중ONGOING, 종료ENDED)
FROM FESTIVAL

