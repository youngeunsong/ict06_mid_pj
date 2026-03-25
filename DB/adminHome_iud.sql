-- 관리자용 홈 메인데시보드 사용을 위한 쿼리 모음

-- 금일 KPI 카드
SELECT
    (SELECT COUNT(*) FROM MEMBER WHERE TRUNC(created_at) = TRUNC(SYSDATE)) AS newMemberCount,
    (SELECT COUNT(*) FROM PLACE WHERE place_type = 'REST' AND TRUNC(created_at) = TRUNC(SYSDATE)) AS newRestaurantCount,
    (SELECT COUNT(*) FROM RESERVATION WHERE TRUNC(created_at) = TRUNC(SYSDATE)) AS reservationCount,
    (SELECT COUNT(*) FROM COMMUNITY_COMMENT WHERE TRUNC(created_at) = TRUNC(SYSDATE)) AS commentCount,
    (SELECT COUNT(*) FROM PAYMENT WHERE payment_status = 'COMPLETED' AND TRUNC(created_at) = TRUNC(SYSDATE)) AS paymentCount,
    (SELECT COUNT(*) FROM SURVEY WHERE TRUNC(created_at) = TRUNC(SYSDATE)) AS surveyParticipantCount
FROM DUAL;

-- 기간별 KPI 카드 (:startDate, :endDate 바인딩 변수)
-- 실행 시 팝업 발생, 실제로 대입할 값 입력 (날짜 형식 : '2024-01-01')
SELECT
    (SELECT COUNT(*) FROM MEMBER WHERE created_at >= :startDate AND created_at < :endDate) AS newMemberCount,
    (SELECT COUNT(*) FROM PLACE WHERE place_type = 'REST' AND created_at >= :startDate AND created_at < :endDate) AS newRestaurantCount,
    (SELECT COUNT(*) FROM RESERVATION WHERE created_at >= :startDate AND created_at < :endDate) AS reservationCount,
    (SELECT COUNT(*) FROM COMMUNITY_COMMENT WHERE created_at >= :startDate AND created_at < :endDate) AS commentCount,
    (SELECT COUNT(*) FROM PAYMENT WHERE payment_status = 'COMPLETED' AND created_at >= :startDate AND created_at < :endDate) AS paymentCount,
    (SELECT COUNT(*) FROM SURVEY WHERE created_at >= :startDate AND created_at < :endDate) AS surveyParticipantCount
FROM DUAL;

-- 만족도 시계열
-- 실행 시 팝업 발생, 실제로 대입할 값 입력 (날짜 형식 : '2024-01-01')
SELECT
    TO_CHAR(TRUNC(created_at), 'YYYY-MM-DD') AS statDate,
    ROUND(AVG(satisfaction_score), 2)         AS satisfactionAvg,
    ROUND(AVG(info_reliability_score), 2)     AS infoReliabilityAvg,
    ROUND(AVG(nps_score), 2)                  AS npsAvg
FROM SURVEY
WHERE created_at >= :startDate
  AND created_at <  :endDate
GROUP BY TRUNC(created_at)
ORDER BY TRUNC(created_at);

SELECT *
FROM SURVEY


SELECT column_name, data_type, data_length, nullable, data_default
FROM user_tab_columns
WHERE table_name = 'SURVEY'
ORDER BY column_id;

SELECT c.constraint_name, c.constraint_type, cc.column_name
FROM user_constraints c
JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
WHERE c.table_name = 'SURVEY';









-- NPS 분포
SELECT
    bucketName,
    scoreCount,
    ROUND(scoreCount * 100 / totalCount, 2) AS ratio
FROM (
    SELECT
        CASE
            WHEN nps_score BETWEEN 0 AND 6  THEN 'Detractor'
            WHEN nps_score BETWEEN 7 AND 8  THEN 'Passive'
            WHEN nps_score BETWEEN 9 AND 10 THEN 'Promoter'
        END AS bucketName,
        COUNT(*)                       AS scoreCount,
        SUM(COUNT(*)) OVER ()          AS totalCount
    FROM SURVEY
    WHERE created_at >= :startDate
      AND created_at <  :endDate
      AND nps_score IS NOT NULL
    GROUP BY
        CASE
            WHEN nps_score BETWEEN 0 AND 6  THEN 'Detractor'
            WHEN nps_score BETWEEN 7 AND 8  THEN 'Passive'
            WHEN nps_score BETWEEN 9 AND 10 THEN 'Promoter'
        END
)
ORDER BY
    CASE bucketName
        WHEN 'Detractor' THEN 1
        WHEN 'Passive'   THEN 2
        WHEN 'Promoter'  THEN 3
    END;

-- 만족도 핵심 통계
SELECT 'SATISFACTION' AS metricName,
       ROUND(AVG(satisfaction_score), 2)   AS avgValue,
       ROUND(STDDEV(satisfaction_score), 2) AS stddevValue,
       MIN(satisfaction_score)              AS minValue,
       MAX(satisfaction_score)              AS maxValue
FROM SURVEY
WHERE created_at >= :startDate AND created_at < :endDate

UNION ALL

SELECT 'INFO_RELIABILITY' AS metricName,
       ROUND(AVG(info_reliability_score), 2)   AS avgValue,
       ROUND(STDDEV(info_reliability_score), 2) AS stddevValue,
       MIN(info_reliability_score)              AS minValue,
       MAX(info_reliability_score)              AS maxValue
FROM SURVEY
WHERE created_at >= :startDate AND created_at < :endDate

UNION ALL

SELECT 'NPS' AS metricName,
       ROUND(AVG(nps_score), 2)   AS avgValue,
       ROUND(STDDEV(nps_score), 2) AS stddevValue,
       MIN(nps_score)              AS minValue,
       MAX(nps_score)              AS maxValue
FROM SURVEY
WHERE created_at >= :startDate AND created_at < :endDate;

-- 워드클라우드용 서술형 원문
SELECT answerText
FROM (
    SELECT inconvenience AS answerText
    FROM SURVEY
    WHERE inconvenience IS NOT NULL
      AND created_at >= :startDate
      AND created_at <  :endDate

    UNION ALL

    SELECT improvements AS answerText
    FROM SURVEY
    WHERE improvements IS NOT NULL
      AND created_at >= :startDate
      AND created_at <  :endDate
)
WHERE answerText IS NOT NULL;

-- 금일 만족도 표 목록 (페이징) (:start, :end 바인딩)
SELECT *
FROM (
    SELECT inner1.*, ROWNUM AS rn
    FROM (
        SELECT
            survey_id,
            user_id,
            nps_score,
            satisfaction_score,
            inconvenience,
            info_reliability_score,
            improvements,
            created_at AS surveyDate
        FROM SURVEY
        WHERE TRUNC(created_at) = TRUNC(SYSDATE)
        ORDER BY created_at DESC, survey_id DESC
    ) inner1
    WHERE ROWNUM <= :end
)
WHERE rn >= :start;

-- 금일 만족도 표 총 개수
SELECT COUNT(*)
FROM SURVEY
WHERE TRUNC(created_at) = TRUNC(SYSDATE);



-- 미답변 문의 최근 10건
SELECT *
FROM (
    SELECT
        inquiry_id,
        user_id,
        category,
        title,
        content,
        status,
        admin_reply,
        created_at  AS inquiryDate,
        answered_at AS answerDate
    FROM INQUIRY
    WHERE status IN ('PENDING', 'PROGRESS')
    ORDER BY created_at DESC, inquiry_id DESC
)
WHERE ROWNUM <= 10;

-- 