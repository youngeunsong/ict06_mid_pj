/*최초작성자: 송영은
최초작성일: 26.03.24
최종수정일: 26.03.24
관리자 페이지에서 사용자 만족도 설문 조사 결과를 표로 열람하기 위해 작성 */

-- 시퀀스 수정: 임시 데이터 넣고 난 후 데이터 양에 맞게 시작 위치 조정
DROP SEQUENCE SEQ_SURVEY; 

SELECT max(survey_ID) FROM survey; 
CREATE SEQUENCE SEQ_SURVEY START WITH 257 INCREMENT BY 1;
