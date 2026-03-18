-- 사용자용 메인 메뉴 사용을 위한 쿼리 모음

-- [ TOP10 ] - 맛집 숙소
-- 30일 동안 조회수가 가장 높은 10개 가져오기
-- (30일 내 10개가 안된다면 기간을 60일로 조회하여 10개 맞추기)
-- 맛집
SELECT *
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
    WHERE p.PLACE_TYPE = 'REST'
      AND p.CREATED_AT >= SYSTIMESTAMP -
          CASE
              WHEN (
                  SELECT COUNT(*)
                  FROM PLACE
                  WHERE PLACE_TYPE = 'REST'
                    AND CREATED_AT >= SYSTIMESTAMP - INTERVAL '30' DAY
              ) < 10
              THEN INTERVAL '60' DAY
              ELSE INTERVAL '30' DAY
          END
    ORDER BY p.VIEW_COUNT DESC
)
WHERE ROWNUM <= 10;

-- 숙소
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
      AND p.CREATED_AT >= SYSTIMESTAMP -
          CASE
              WHEN (
                  SELECT COUNT(*)
                  FROM PLACE
                  WHERE PLACE_TYPE = 'ACC'
                    AND CREATED_AT >= SYSTIMESTAMP - INTERVAL '30' DAY
              ) < 10
              THEN INTERVAL '60' DAY
              ELSE INTERVAL '30' DAY
          END
    ORDER BY p.VIEW_COUNT DESC
)
WHERE ROWNUM <= 10

-- [ 즐겨찾기 ] 즐겨찾기 place_id 조회
SELECT place_id
  FROM FAVORITE
 WHERE user_id = 'user03'
 
-- [ 리뷰 ]
-- 플레이스 별 리뷰 조회/ 플레이스 별 리뷰 갯수 및 평균 조회
-- 플레이스 별 리뷰 갯수 및 평균 조회 
SELECT p.PLACE_ID
     , COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
     , NVL(ROUND(AVG(rv.RATING),1),0) AS AVG_RATING
FROM PLACE p
LEFT JOIN REVIEW rv
  ON p.PLACE_ID = rv.PLACE_ID
 AND rv.STATUS = 'DISPLAY'
WHERE p.PLACE_ID IN 226
GROUP BY p.PLACE_ID

-- [ 이달의 추천 국내 축제 ]
-- 현 달의 진행하는 축제 중, 조회수 기준 상위 8개를 평점 높은 순으로 정렬
SELECT *
FROM (
    SELECT top8.*
    FROM (
        SELECT
            f.FESTIVAL_ID,
            TO_CHAR(f.DESCRIPTION) AS DESCRIPTION,
            f.START_DATE,
            f.END_DATE,
            f.STATUS AS FEST_STATUS,
            p.PLACE_ID,
            p.PLACE_TYPE,
            p.NAME,
            p.ADDRESS,
            p.VIEW_COUNT,
            p.IMAGE_URL,
            p.CREATED_AT AS PLACE_CREATED_AT,
            NVL(ROUND(AVG(rv.RATING), 1), 0) AS AVG_RATING
        FROM FESTIVAL f
        JOIN PLACE p
          ON f.FESTIVAL_ID = p.PLACE_ID
        LEFT JOIN REVIEW rv
          ON p.PLACE_ID = rv.PLACE_ID
         AND rv.STATUS = 'DISPLAY'
        WHERE p.PLACE_TYPE = 'FEST'
          AND f.START_DATE <= LAST_DAY(SYSDATE)
          AND f.END_DATE >= TRUNC(SYSDATE, 'MM')
        GROUP BY
            f.FESTIVAL_ID,
            TO_CHAR(f.DESCRIPTION),
            f.START_DATE,
            f.END_DATE,
            f.STATUS,
            p.PLACE_ID,
            p.PLACE_TYPE,
            p.NAME,
            p.ADDRESS,
            p.VIEW_COUNT,
            p.IMAGE_URL,
            p.CREATED_AT
        ORDER BY p.VIEW_COUNT DESC
    ) top8
    WHERE ROWNUM <= 8
)
ORDER BY AVG_RATING DESC, VIEW_COUNT DESC

-- [ BEST 추천 ]
-- 최근 1주일 리뷰 기준 / 리뷰 1개 이상 / 통합 정렬
--(전체 탭은 맛집/숙소/축제 통합하여 리뷰평균이 가장 높은 4개)

-- BEST 추천 - 전체 탭 우측 4개 
SELECT *
FROM (
    SELECT
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.IMAGE_URL,
        ROUND(AVG(rv.RATING), 1) AS AVG_RATING,
        COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
    FROM PLACE p
    JOIN REVIEW rv
      ON p.PLACE_ID = rv.PLACE_ID
     AND rv.STATUS = 'DISPLAY'
     AND rv.CREATED_AT >= SYSTIMESTAMP - INTERVAL '7' DAY
    GROUP BY
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.IMAGE_URL
    HAVING COUNT(rv.REVIEW_ID) >= 1
    ORDER BY AVG_RATING DESC, REVIEW_COUNT DESC
)
WHERE ROWNUM <= 4

-- BEST 추천 - 맛집 5개
SELECT *
FROM (
    SELECT
        r.RESTAURANT_ID,
        TO_CHAR(r.DESCRIPTION) AS DESCRIPTION,
        r.PHONE,
        r.CATEGORY,
        r.STATUS AS REST_STATUS,
        r.RESTDATE,
        r.AREACODE,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT AS PLACE_CREATED_AT,
        ROUND(AVG(rv.RATING), 1) AS AVG_RATING,
        COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
    FROM RESTAURANT r
    JOIN PLACE p
      ON r.RESTAURANT_ID = p.PLACE_ID
    JOIN REVIEW rv
      ON p.PLACE_ID = rv.PLACE_ID
     AND rv.STATUS = 'DISPLAY'
     AND rv.CREATED_AT >= SYSTIMESTAMP - INTERVAL '7' DAY
    WHERE p.PLACE_TYPE = 'REST'
    GROUP BY
        r.RESTAURANT_ID,
        TO_CHAR(r.DESCRIPTION),
        r.PHONE,
        r.CATEGORY,
        r.STATUS,
        r.RESTDATE,
        r.AREACODE,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT
    HAVING COUNT(rv.REVIEW_ID) >= 1
    ORDER BY ROUND(AVG(rv.RATING), 1) DESC,
             COUNT(rv.REVIEW_ID) DESC
)
WHERE ROWNUM <= 5;

-- BEST 추천 - 숙소 5개
SELECT *
FROM (
    SELECT
        a.ACCOMMODATION_ID,
        TO_CHAR(a.DESCRIPTION) AS DESCRIPTION,
        a.PHONE,
        a.PRICE,
        a.STATUS AS ACC_STATUS,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT AS PLACE_CREATED_AT,
        ROUND(AVG(rv.RATING), 1) AS AVG_RATING,
        COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
    FROM ACCOMMODATION a
    JOIN PLACE p
      ON a.ACCOMMODATION_ID = p.PLACE_ID
    JOIN REVIEW rv
      ON p.PLACE_ID = rv.PLACE_ID
     AND rv.STATUS = 'DISPLAY'
     AND rv.CREATED_AT >= SYSTIMESTAMP - INTERVAL '7' DAY
    WHERE p.PLACE_TYPE = 'ACC'
    GROUP BY
        a.ACCOMMODATION_ID,
        TO_CHAR(a.DESCRIPTION),
        a.PHONE,
        a.PRICE,
        a.STATUS,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT
    HAVING COUNT(rv.REVIEW_ID) >= 1
    ORDER BY ROUND(AVG(rv.RATING), 1) DESC,
             COUNT(rv.REVIEW_ID) DESC
)
WHERE ROWNUM <= 5;

-- BEST 추천 - 축제 5개
SELECT *
FROM (
    SELECT
        f.FESTIVAL_ID,
        TO_CHAR(f.DESCRIPTION) AS DESCRIPTION,
        f.START_DATE,
        f.END_DATE,
        f.STATUS AS FEST_STATUS,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT AS PLACE_CREATED_AT,
        ROUND(AVG(rv.RATING), 1) AS AVG_RATING,
        COUNT(rv.REVIEW_ID) AS REVIEW_COUNT
    FROM FESTIVAL f
    JOIN PLACE p
      ON f.FESTIVAL_ID = p.PLACE_ID
    JOIN REVIEW rv
      ON p.PLACE_ID = rv.PLACE_ID
     AND rv.STATUS = 'DISPLAY'
     AND rv.CREATED_AT >= SYSTIMESTAMP - INTERVAL '7' DAY
    WHERE p.PLACE_TYPE = 'FEST'
    GROUP BY
        f.FESTIVAL_ID,
        TO_CHAR(f.DESCRIPTION),
        f.START_DATE,
        f.END_DATE,
        f.STATUS,
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT
    HAVING COUNT(rv.REVIEW_ID) >= 1
    ORDER BY ROUND(AVG(rv.RATING), 1) DESC,
             COUNT(rv.REVIEW_ID) DESC
)
WHERE ROWNUM <= 5