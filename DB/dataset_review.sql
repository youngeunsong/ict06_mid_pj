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
     
SELECT *
FROM PLACE
WHERE PLACE_ID = 487;

-- 즐겨찾기 여부 확인
SELECT COUNT(*) 
FROM FAVORITE
WHERE USER_ID = 'user01'
AND PLACE_ID = 606; -- 0 없음/ 1 있음

-- 즐겨찾기 추가
INSERT INTO FAVORITE (favorite_id, user_id, place_id)
VALUES (SEQ_FAVORITE.NEXTVAL, 'user01', '607');

-- 즐겨찾기 삭제
DELETE FROM FAVORITE
WHERE user_id = 'user01'

-- 로그인 시 즐겨찾기 정보 자동으로 끌고오기
SELECT place_id
FROM FAVORITE
WHERE user_id = 'user01'



SELECT *
FROM FAVORITE
WHERE user_id = 'user01'

SELECT *
FROM "MEMBER" m 



INSERT INTO FAVORITE (favorite_id, user_id, place_id, created_at)
VALUES (SEQ_FAVORITE.NEXTVAL, #{user_id}, #{place_id});