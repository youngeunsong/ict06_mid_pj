/*최초작성자: 송영은
최초작성일: 26.03.24
최종수정일: 26.03.24
관리자 페이지에서 사용자 만족도 설문 조사 결과를 표로 열람하기 위해 작성 */

-- 시퀀스 수정: 임시 데이터 넣고 난 후 데이터 양에 맞게 시작 위치 조정
DROP SEQUENCE SEQ_SURVEY; 

SELECT max(survey_ID) FROM survey; 
CREATE SEQUENCE SEQ_SURVEY START WITH 257 INCREMENT BY 1;

-- 특정 기간 내 사용자 만족도 조사 결과 갯수 
SELECT COUNT(*)
  FROM SURVEY
 WHERE CREATED_AT >= '2026-03-01 00:00:00'
   AND CREATED_AT < '2026-03-24 23:59:59'; 

-- 특정 기간 내의 survey 데이터 표로 열람 (페이징 처리)
 SELECT  	survey_id, 
 			user_id, 
	       reservation_id, 
	       nps_score, 
	       satisfaction_score, 
	       inconvenience, 
	       info_reliability_score, 
	       improvements, 
	       created_at
  FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CREATED_AT, survey_id DESC) AS rn,
               survey_id,
               user_id, 
               reservation_id, 
               nps_score, 
               satisfaction_score, 
               inconvenience, 
               info_reliability_score, 
               improvements, 
               created_at      
		  FROM SURVEY
		 WHERE CREATED_AT >= '2026-03-01 00:00:00' -- 당일 데이터 조회 : TRUNC(SYSDATE), TRUNC(SYSDATE) + 1
		   AND CREATED_AT < '2026-03-24 23:59:59' 
		 ORDER BY CREATED_AT DESC
		 )
 WHERE rn BETWEEN 1 AND 10
 ORDER BY CREATED_AT DESC;


-- 금일 설문 응답 결과 표로 열람
SELECT * 
  FROM SURVEY
 WHERE CREATED_AT >= TRUNC(SYSDATE) 
   AND CREATED_AT < TRUNC(SYSDATE) + 1
 ORDER BY CREATED_AT, survey_id;

-- 특정 기간 내의 survey 데이터 표로 열람
SELECT * 
  FROM SURVEY
 WHERE CREATED_AT >= '2026-03-01 00:00:00' 
   AND CREATED_AT < '2026-03-24 23:59:59'
 ORDER BY CREATED_AT, survey_id;
