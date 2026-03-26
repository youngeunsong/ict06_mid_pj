-- 내 주변 축제 조회 페이지 필요 쿼리
SELECT 
    p.place_id,
    p.name,
    f.status,
    p.latitude,
    p.longitude,
    6371 * acos(
        cos(37.5665 * 3.14159 / 180)
        * cos(p.latitude * 3.14159 / 180)
        * cos((p.longitude * 3.14159 / 180) - (126.9780 * 3.14159 / 180))
        + sin(37.5665 * 3.14159 / 180)
        * sin(p.latitude * 3.14159 / 180)
    ) AS distance
FROM festival f
JOIN place p ON f.festival_id = p.place_id
WHERE f.status != 'ENDED'
ORDER BY distance;


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
-- 특정 축제와 내 위치 사이 거리 계산 : SDO_GEOM.SDO_DISTANCE 함수 이용 (아래 주석 코드는 거리가 정상적으로 계산되는 지 확인용)
/*SELECT
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
ORDER BY distance;*/

-- (1) 나와의 거리 계산 함수 생성 : /까지 한 블록으로 잡고 실행
-- 참고 : https://junhyeokkk.tistory.com/32#1.%20SDO_GEOMETRY%20%EC%BB%AC%EB%9F%BC%EC%9D%B4%20%ED%8F%AC%ED%95%A8%EB%90%9C%20%ED%85%8C%EC%9D%B4%EB%B8%94%20%EC%83%9D%EC%84%B1-1-3
CREATE OR REPLACE FUNCTION FN_DISTANCE_KM(
    p_longitude NUMBER,
    p_latitude NUMBER,
    my_longitude NUMBER,
    my_latitude NUMBER
)
RETURN NUMBER
IS
    v_distance NUMBER;
BEGIN
    v_distance := SDO_GEOM.SDO_DISTANCE(
        SDO_GEOMETRY(
            2001, -- 공간 타입 (2001 = Point)
            8307, -- SRID (8307 = WGS84, GPS에서 사용)
            SDO_POINT_TYPE(p_longitude, p_latitude, NULL),
            NULL,
            NULL
        ),
        SDO_GEOMETRY(
            2001,
            8307,
            SDO_POINT_TYPE(my_longitude, my_latitude, NULL),
            NULL,
            NULL
        ),
        0.05,
        'unit=KM'
    );

    RETURN v_distance;
END;
/

-- SELECT FN_DISTANCE_KM(126.890776, 37.561931, 126.893114, 37.563955) from dual; -- 함수 정상 작동 여부 체크용. 구글 지도와 대조한 결과 이상 없음. 

-- (2) 특정 반경 내 있는 지 여부 체크 함수 생성 : /전까지 블록 잡고 실행
CREATE OR REPLACE FUNCTION FN_IS_NEAR(
    p_longitude NUMBER,
    p_latitude NUMBER,
    my_longitude NUMBER,
    my_latitude NUMBER,
    max_distance NUMBER
)
RETURN NUMBER
IS
    v_distance NUMBER;
BEGIN
    v_distance := FN_DISTANCE_KM(
        p_longitude,
        p_latitude,
        my_longitude,
        my_latitude
    );

    IF v_distance <= max_distance THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;

-- SELECT FN_IS_NEAR(126.890776, 37.561931, 126.893114, 37.563955, 0.4) FROM dual; -- 함수 정상 작동 여부 테스트 (예측 결과: 1)
/

-- (3) 축제 필터 적용: 평점 n점 이상, 나로부터의 거리 n km 이내, 검색어 포함(축제 제목, 설명, 리뷰 내용 중), 상태(ENDED 제외)
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
    NVL(r.review_count, 0) AS review_count,

    FN_DISTANCE_KM(
        p.longitude,
        p.latitude,
        :my_lo,
        :my_la
    ) AS distance

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

  AND NVL(r.avg_rating, 0) >= :min_rating

  AND FN_IS_NEAR(
        p.longitude,
        p.latitude,
        :my_lo,
        :my_la,
        :max_distance
      ) = 1

  AND (
        LOWER(p.name) LIKE '%' || LOWER(:keyword) || '%'
     OR LOWER(f.description) LIKE '%' || LOWER(:keyword) || '%'
     OR EXISTS (
            SELECT 1
            FROM REVIEW rv
            WHERE rv.place_id = p.place_id
              AND rv.status = 'DISPLAY'
              AND LOWER(rv.content) LIKE '%' || LOWER(:keyword) || '%'
        )
    )

ORDER BY avg_rating DESC, distance;



---------------------------------------------
-- 아래 코드: 일부 필터 조건만 작동하는 코드 
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



 
  