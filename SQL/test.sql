-------------------------------------------------
-- 아래부터 ict06_team1_midpj 계정에서 작업
-- mvc_user_tbl : mvc_address_tbl => 1 : 1
-- mvc_user_tbl : mvc_board_tbl => 1 : N

-- 1) 지금 접속한 스키마 확인
SELECT USER FROM dual;

-- 2) 실제 컬럼 타입 재확인 (OWNER 포함해서 보려면 ALL_TAB_COLUMNS)
SELECT owner, table_name, column_name, data_type
FROM all_tab_columns
WHERE table_name = 'MVC_USER_TBL'
  AND column_name = 'USER_ID';



--1) [mvc_user_tbl] 테이블 생성 =================================
DROP TABLE mvc_user_tbl CASCADE CONSTRAINTS;
CREATE TABLE mvc_user_tbl (
    user_id        VARCHAR2(20) 	PRIMARY KEY,
    password       VARCHAR2(100) 	NOT NULL,
    name           VARCHAR2(20) 	NOT NULL,
    birth_date     DATE,
    email          VARCHAR2(50),
    phone          VARCHAR2(20),
    address        VARCHAR2(200),
    gender         CHAR(1),
    point_balance  NUMBER 			DEFAULT 0,
    role           VARCHAR2(20) 	DEFAULT 'ROLE_USER', -- 유저: ROLE_USER/ 관리자: admin
    status         VARCHAR2(20) 	DEFAULT 'ACTIVE',
    joinDate       DATE 			DEFAULT SYSDATE
);

-- 테이블 조회하기
SELECT * FROM mvc_user_tbl;

-- [UserMapper] 1. 아이디 중복 체크
SELECT COUNT(*)
FROM mvc_user_tbl
WHERE user_id = 'test1';

-- [UserMapper] 2. 회원 정보 삽입 (회원가입)
INSERT INTO mvc_user_tbl
(user_id, password, name, birth_date, email, phone, address, gender)
	VALUES ('test1', 'test1212', '김테스트', TO_DATE('20260226','YYYYMMDD'), 'test@email.com', '01011112222', '서울시 금천구 가산동', 'M');

-- [UserMapper] 3. 로그인 체크 / 회원정보 인증(수정, 탈퇴)
SELECT count(*) FROM mvc_user_tbl
 WHERE user_id = 'test2'
   AND password = 'test2'
   
-- [header.jsp]
UPDATE mvc_user_tbl
   SET ROLE = 'admin'
 WHERE USER_ID = 'test1'
 
-- 2) SEARCH_HISTORY 생성 : 최근 검색어 자동 완성 및 기록용 =================================
DROP TABLE SEARCH_HISTORY CASCADE CONSTRAINTS;
CREATE TABLE SEARCH_HISTORY(
	history_id  NUMBER      PRIMARY KEY, -- 검색 기록 번호 (PK, 시퀀스)
    user_id VARCHAR2(50),                -- 사용자 ID (FK)
    keyword    VARCHAR2(100),            -- 검색한 키워드
    searchDate TIMESTAMP,                -- 검색 일시 (DTO: searchDate)
    CONSTRAINT search_history_user_id_fk FOREIGN KEY(user_id) REFERENCES mvc_user_tbl(user_id)
);

-- [searchMapper] 1. 가장 최근에 
SELECT keyword
  FROM SEARCH_HISTORY
 WHERE user_id = '1'
AND searchDate >= TO_DATE();

-- 3) 

   
   
-- 2) mvc_address_tbl 생성 =================================
DROP TABLE mvc_address_tbl CASCADE CONSTRAINTS;
CREATE TABLE mvc_address_tbl(
	user_id 	 NUMBER(2),
	user_address VARCHAR2(50),
	CONSTRAINT mvc_address_tbl_user_id_fk FOREIGN KEY(user_id) REFERENCES mvc_user_tbl(user_id)
);

INSERT INTO mvc_address_tbl(user_id, user_address)
 VALUES(1, '서울시 금천구 가산동');

INSERT INTO mvc_address_tbl(user_id, user_address)
 VALUES(2, '서울시 강남구 대치동');

COMMIT;

SELECT * FROM mvc_address_tbl;
--1	서울시 금천구 가산동
--2	서울시 강남구 대치동

-- 3) mvc_board_tbl 생성
DROP TABLE mvc_board_tbl CASCADE CONSTRAINTS;
CREATE TABLE mvc_board_tbl(
	board_num    NUMBER(3) PRIMARY KEY,
	board_title  VARCHAR2(50),
	board_content VARCHAR2(100),
	user_id 	 NUMBER(2),
	CONSTRAINT mvc_board_tbl_user_id_fk FOREIGN KEY(user_id) REFERENCES mvc_user_tbl(user_id)
);

INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(100, '자바', '반복문', 1);

INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(101, 'JSP', 'mvc 기본', 1);
 
INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(102, '스프링', 'mybatis 기본', 1);
 
INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(103, 'JSP 응용', 'mvc 활용', 2);
 
INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(104, '스프링', 'mybatis 활용', 2);

INSERT INTO mvc_board_tbl(board_num, board_title, board_content, user_id)
 VALUES(105, '플젝', '성취감', 2);
 
COMMIT;

SELECT * FROM mvc_board_tbl;


--100	자바	반복문	1
--101	JSP	mvc 기본	1
--102	스프링	mybatis 기본	1
--103	JSP 응용	mvc 활용	2
--104	스프링	mybatis 활용	2
--105	플젝	성취감	2



