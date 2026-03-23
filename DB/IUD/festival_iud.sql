-- 축제 상세 조회
SELECT * 
  FROM FESTIVAL
 WHERE FESTIVAL_ID = 523;

SELECT * 
  FROM PLACE 
 WHERE PLACE_ID = 523;

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


 
  