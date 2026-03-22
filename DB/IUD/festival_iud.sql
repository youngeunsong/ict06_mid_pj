-- 축제 상세 페이지 필요 쿼리 ---------------------------------------
-- 축제 상세 조회
SELECT * 
  FROM FESTIVAL
 WHERE FESTIVAL_ID = 523;

SELECT * 
  FROM PLACE 
 WHERE PLACE_ID = 523;

-- 축제 랭킹 페이지 필요 쿼리 ---------------------------------------
-- 축제 전체 갯수 조회
SELECT count(*)
  FROM FESTIVAL
 WHERE status != 'ENDED';

-- 축제 평점 내림차순으로 조회
SELECT 
    p.place_id,
    p.place_type,
    p.name,
    p.address,
    p.view_count,
    p.latitude,
    p.longitude,
    p.image_url,
    p.created_at,

    f.festival_id,
    f.description,
    f.start_date,
    f.end_date,
    f.status,

    NVL(r.avg_rating, 0) AS avg_rating,
    NVL(r.review_count, 0) AS review_count

FROM PLACE p
JOIN FESTIVAL f
  ON p.place_id = f.festival_id
LEFT JOIN (
    SELECT 
        place_id,
        ROUND(AVG(rating), 1) AS avg_rating,
        COUNT(review_id) AS review_count
    FROM REVIEW
    WHERE status = 'DISPLAY'
    GROUP BY place_id
) r
  ON p.place_id = r.place_id
WHERE p.place_type = 'FEST'
  AND f.status != 'ENDED'
ORDER BY avg_rating DESC;

-- 축제 랭킹 목록 조회 : 특정 행번호 범위내의 목록만 조회
SELECT *
FROM (
    SELECT 
        p.place_id, p.place_type, p.name, p.address, p.view_count,
        p.latitude, p.longitude, p.image_url, p.created_at,
        f.festival_id, f.description, f.start_date, f.end_date, f.status,
        NVL(r.avg_rating, 0) AS avg_rating,
        NVL(r.review_count, 0) AS review_count,
        ROW_NUMBER() OVER (ORDER BY NVL(r.avg_rating, 0) DESC) AS rn
    FROM PLACE p
    JOIN FESTIVAL f ON p.place_id = f.festival_id
    LEFT JOIN (
        SELECT place_id,
               ROUND(AVG(rating), 1) AS avg_rating,
               COUNT(review_id) AS review_count
        FROM REVIEW
        WHERE status = 'DISPLAY'
        GROUP BY place_id
    ) r ON p.place_id = r.place_id
    WHERE p.place_type = 'FEST'
      AND f.status != 'ENDED'
)
WHERE rn BETWEEN 10 AND 50;

-- 평점 상위 5개 축제만 조회
SELECT *
FROM (
    SELECT 
        p.place_id, p.place_type, p.name, p.address, p.view_count,
        p.latitude, p.longitude, p.image_url, p.created_at,
        f.festival_id, f.description, f.start_date, f.end_date, f.status,
        NVL(r.avg_rating, 0) AS avg_rating,
        NVL(r.review_count, 0) AS review_count
    FROM PLACE p
    JOIN FESTIVAL f ON p.place_id = f.festival_id
    LEFT JOIN (
        SELECT place_id,
               ROUND(AVG(rating), 1) AS avg_rating,
               COUNT(review_id) AS review_count
        FROM REVIEW
        WHERE status = 'DISPLAY'
        GROUP BY place_id
    ) r ON p.place_id = r.place_id
    WHERE p.place_type = 'FEST'
      AND f.status != 'ENDED'
    ORDER BY avg_rating DESC
)
WHERE ROWNUM <= 5;

-- 상위 5개 제외 조회
SELECT *
FROM (
    SELECT 
        p.place_id, p.place_type, p.name, p.address, p.view_count,
        p.latitude, p.longitude, p.image_url, p.created_at,
        f.festival_id, f.description, f.start_date, f.end_date, f.status,
        NVL(r.avg_rating, 0) AS avg_rating,
        NVL(r.review_count, 0) AS review_count,
        ROW_NUMBER() OVER (ORDER BY NVL(r.avg_rating, 0) DESC) AS rn
    FROM PLACE p
    JOIN FESTIVAL f ON p.place_id = f.festival_id
    LEFT JOIN (
        SELECT place_id,
               ROUND(AVG(rating), 1) AS avg_rating,
               COUNT(review_id) AS review_count
        FROM REVIEW
        WHERE status = 'DISPLAY'
        GROUP BY place_id
    ) r ON p.place_id = r.place_id
    WHERE p.place_type = 'FEST'
      AND f.status != 'ENDED'
)
WHERE rn > 5;

-- 축제 지도 페이지 사용 ---------------------------------------------------------------
-- 특정 축제와 내 위치 사이 거리 계산 : SDO_GEOM.SDO_DISTANCE 함수 이용
SELECT
    p.*,
    SDO_GEOM.SDO_DISTANCE(
        SDO_GEOMETRY(
            2001,
            8307,
            SDO_POINT_TYPE(p.longitude, p.latitude, NULL),
            NULL,
            NULL
        ),
        SDO_GEOMETRY(
            2001,
            8307,
            SDO_POINT_TYPE(:my_lo, :my_la, NULL),
            NULL,
            NULL
        ),
        0.05,
        'unit=KM'
    ) AS distance
FROM place p
WHERE
    p.latitude IS NOT NULL
    AND p.longitude IS NOT NULL
    AND SDO_GEOM.SDO_DISTANCE(
        SDO_GEOMETRY(
            2001,
            8307,
            SDO_POINT_TYPE(p.longitude, p.latitude, NULL),
            NULL,
            NULL
        ),
        SDO_GEOMETRY(
            2001,
            8307,
            SDO_POINT_TYPE(:my_lo, :my_la, NULL),
            NULL,
            NULL
        ),
        0.05,
        'unit=KM'
    ) <= :n
ORDER BY distance;


-- 축제 필터 적용: 평점 n점 이상, 나로부터의 거리 n km 이내, 검색어 포함(축제 제목, 설명, 리뷰 내용 중), 상태(ENDED 제외)
SELECT 
    p.place_id,
    p.place_type,
    p.name,
    p.address,
    p.view_count,
    p.latitude,
    p.longitude,
    p.image_url,
    p.created_at,

    f.festival_id,
    f.description,
    f.start_date,
    f.end_date,
    f.status,

    NVL(r.avg_rating, 0) AS avg_rating,
    NVL(r.review_count, 0) AS review_count

FROM PLACE p
JOIN FESTIVAL f
  ON p.place_id = f.festival_id
LEFT JOIN (
    SELECT 
        place_id,
        ROUND(AVG(rating), 1) AS avg_rating,
        COUNT(review_id) AS review_count
    FROM REVIEW
    WHERE status = 'DISPLAY'
    GROUP BY place_id
) r
  ON p.place_id = r.place_id
WHERE p.place_type = 'FEST'
  AND f.status != 'ENDED'
  AND r.avg_rating >= 1
ORDER BY avg_rating DESC;



 
  