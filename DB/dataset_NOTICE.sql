--------------------------------------------------
--NOTICE_데이터 생성
--------------------------------------------------
--=====테스트 사용자 생성=====
INSERT INTO NOTICE(user_id, password, email, name, birth_date, gender, phone, address, point_balance, role) 
VALUES ('user01', '1234', 'dskim@naver.com', '김다솜', '1994-03-02', 'F', '010-1111-2222', '서울시 서대문구', 1500, 'USER');