-- 사용자용 메인 메뉴 사용을 위한 쿼리 모음

-- 



-- [ BEST 추천 ] 최근 1주일 리뷰 기준 / 리뷰 1개 이상
-- 1번) 맛집/ 숙소/ 축제 통합 정렬
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
WHERE ROWNUM <= 4;

-- 2번) 맛집 추천
SELECT *
FROM (
    SELECT
        p.PLACE_ID,
        p.PLACE_TYPE,
        p.NAME,
        p.ADDRESS,
        p.VIEW_COUNT,
        p.IMAGE_URL,
        p.CREATED_AT AS placeRegDate
    FROM PLACE p
    JOIN REVIEW rv
      ON p.PLACE_ID = rv.PLACE_ID
     AND rv.STATUS = 'DISPLAY'
     AND rv.CREATED_AT >= SYSTIMESTAMP - INTERVAL '7' DAY
    WHERE p.PLACE_TYPE = 'REST'
    GROUP BY
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

-- 3번) 숙소 추천
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
WHERE ROWNUM <= 5

-- 4번) 축제 추천
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
ORDER BY AVG_RATING DESC, VIEW_COUNT DESC;

