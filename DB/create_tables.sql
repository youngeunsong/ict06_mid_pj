--------------------------------------------------
--DB 테이블 생성

-- 1. 회원
CREATE TABLE MEMBER (
    user_id			VARCHAR2(50) PRIMARY KEY,
    password		VARCHAR2(255) NOT NULL,
    email			VARCHAR2(100) UNIQUE NOT NULL,
    name			VARCHAR2(50) NOT NULL,
    birth_date		DATE,
    gender			CHAR(1),
    phone			VARCHAR2(20),
    address			VARCHAR2(255),
    point_balance	NUMBER DEFAULT 0,
    role			VARCHAR2(20) DEFAULT 'USER',		--권한(일반사용자:'USER', 관리자:'ADMIN')
    status			VARCHAR2(20) DEFAULT 'ACTIVE',		--상태(active, quit 등) -> 불요시 삭제
    created_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO에서는 joinDate
    updated_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO에서는 updateDate
    CONSTRAINT CHK_MEMBER_GENDER CHECK(gender IN ('M', 'F'))
);
SELECT * FROM MEMBER;
DELETE FROM MEMBER;
COMMIT;


-- 2. 장소 통합
CREATE TABLE PLACE (
    place_id    NUMBER PRIMARY KEY,
    place_type  VARCHAR2(20) NOT NULL, -- 'REST', 'ACC', 'FEST' 값만 입력되는 제한조건
    name        VARCHAR2(100) NOT NULL,
    address     VARCHAR2(255),
	view_count  NUMBER DEFAULT 0,
    latitude    NUMBER(10, 8),
    longitude   NUMBER(11, 8),
    image_url   VARCHAR2(500),
    created_at  TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 placeRegDate
	updated_at	TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 placeupdateDate
    CONSTRAINT CHK_PLACE_PLACETYPE CHECK(place_type IN ('REST','ACC','FEST'))
);

SELECT * FROM PLACE
WHERE place_type = 'REST'; --563건
SELECT * FROM PLACE
WHERE place_type = 'ACC'; --288건
SELECT * FROM PLACE
WHERE place_type = 'FEST'; --149건

-- 3. 맛집 (PLACE 참조)
CREATE TABLE RESTAURANT (
    restaurant_id  NUMBER PRIMARY KEY REFERENCES PLACE(place_id) ON DELETE CASCADE,
    description    CLOB,
    phone          VARCHAR2(20),
    category       VARCHAR2(50),
    status         VARCHAR2(20) DEFAULT 'OPEN',
    CONSTRAINT CHK_RESTAURANT_STATUS CHECK(status IN('OPEN','CLOSED'))
);
SELECT * FROM RESTAURANT;

-- 4. 숙소 (PLACE 참조)
CREATE TABLE ACCOMMODATION (
    accommodation_id NUMBER PRIMARY KEY REFERENCES PLACE(place_id) ON DELETE CASCADE,
    description      CLOB,
    phone            VARCHAR2(20),
    price            NUMBER,
    status			VARCHAR2(20) DEFAULT 'OPEN',
    CONSTRAINT CHK_ACCOMMODATION_STATUS CHECK(status IN('OPEN','CLOSED'))
);
SELECT * FROM ACCOMMODATION;

SELECT r.*, p.name, p.address
FROM RESERVATION r
JOIN place p ON r.PLACE_ID = p.PLACE_ID
WHERE r.RESERVATION_ID = 'R20260228010';

-- 5. 축제 (PLACE 참조)
CREATE TABLE FESTIVAL (
    festival_id		NUMBER PRIMARY KEY REFERENCES PLACE(place_id) ON DELETE CASCADE,
    description		CLOB,
    start_date		DATE,					-- 축제 시작일
    end_date		DATE,					-- 축제 종료일
    status			VARCHAR2(20) DEFAULT 'UPCOMING',
	CONSTRAINT CHK_FESTIVAL_STATUS CHECK(
		status IN('UPCOMING','ONGOING','ENDED')
			  AND start_date <= end_date
		)
);
SELECT * FROM FESTIVAL;

-- 6. 축제 티켓 종류 테이블(추가?)
CREATE TABLE FESTIVAL_TICKET (
    ticket_id    NUMBER PRIMARY KEY,
    festival_id  NUMBER REFERENCES FESTIVAL(festival_id) ON DELETE CASCADE,
    ticket_type  VARCHAR2(100) NOT NULL, -- '1일권', '2일권', '전일권' 등
    price        NUMBER DEFAULT 0,       -- 티켓별 가격
    stock        NUMBER DEFAULT 0,       -- 티켓별 재고 (선택사항)
    description  VARCHAR2(500)           -- 티켓 상세 설명
);

-- 7. 예약 테이블
CREATE TABLE RESERVATION (
    reservation_id	VARCHAR2(50) PRIMARY KEY,
    user_id			VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
	place_id		NUMBER REFERENCES PLACE(place_id),
    check_in		DATE NOT NULL,			-- 시작일 (체크인, 방문일)
    check_out		DATE,					-- 종료일 (체크아웃, 축제 종료일)
    visit_time		VARCHAR2(10),		-- 방문 시간 (식당용)
    ticket_id		NUMBER REFERENCES FESTIVAL_TICKET(ticket_id),		-- 예약한 티켓 고유번호
    guest_count		NUMBER DEFAULT 1,
    request_note	CLOB,
    status			VARCHAR2(20) DEFAULT 'PENDING',
    payment_id		VARCHAR2(50),
    created_at		TIMESTAMP DEFAULT SYSTIMESTAMP,	--DTO는 resDate
    updated_at		TIMESTAMP DEFAULT SYSTIMESTAMP,	--DTO는 resUpdateDate
    CONSTRAINT CHK_RESERVATION_STATUS CHECK(
    	STATUS IN('PENDING','RESERVED','COMPLETED','CANCELLED','NOSHOW')
    		  AND (check_out IS NULL OR check_in <= check_out)
    	)
);
SELECT * FROM RESERVATION;

-- 8. PAYMENT (결제)
CREATE TABLE PAYMENT (
    payment_id     VARCHAR2(50) PRIMARY KEY,
    user_id        VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
    reservation_id VARCHAR2(50) REFERENCES RESERVATION(reservation_id),
    amount         NUMBER NOT NULL,
    payment_method VARCHAR2(50), 
    payment_status VARCHAR2(20), 
    created_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 payDate
    updated_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 payUpdateDate
    CONSTRAINT CHK_PAYMENT_PAYMENTSTATUS CHECK(PAYMENT_STATUS IN('PENDING','COMPLETED','CANCELLED'))
);
SELECT * FROM PAYMENT;

-- 9. REVIEW (리뷰)
CREATE TABLE REVIEW (
    review_id      NUMBER PRIMARY KEY,
    user_id        VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
    place_id       NUMBER REFERENCES PLACE(place_id),
    rating         NUMBER(1) CHECK(rating BETWEEN 1 AND 5),
    content        CLOB,
    status         VARCHAR2(20) DEFAULT 'DISPLAY',
    created_at     TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 reviewDate
    updated_at     TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 reviewUpdateDate
    CONSTRAINT CHK_REVIEW_STATUS CHECK(STATUS IN('DISPLAY','HIDDEN')),
    CONSTRAINT CHK_REVIEW_RATING CHECK(RATING BETWEEN 1 AND 5)
);
SELECT * FROM REVIEW;

-- 10. COMMUNITY(커뮤니티/사용자 게시판)
CREATE TABLE COMMUNITY(
	post_id			NUMBER PRIMARY KEY,
	user_id			VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE CASCADE,
	title			VARCHAR2(200) NOT NULL,
	content			CLOB NOT NULL,
	category		VARCHAR2(50),
	view_count		NUMBER DEFAULT 0,
	like_count		NUMBER DEFAULT 0,
	status			VARCHAR2(20) DEFAULT 'DISPLAY',
	created_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 postDate
	updated_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 postUpdateDate
	CONSTRAINT CHK_POST_STATUS CHECK(status IN('DISPLAY','HIDDEN'))
);

-- 11. COMMUNITY_COMMENT(커뮤니티 댓글)
CREATE TABLE COMMUNITY_COMMENT(
	comment_id		NUMBER PRIMARY KEY,
	post_id			NUMBER REFERENCES COMMUNITY(post_id) ON DELETE CASCADE,
	user_id			VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
	content			CLOB NOT NULL,
	status			VARCHAR2(20) DEFAULT 'DISPLAY',
	created_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 commentDate
	updated_at		TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 commentUpdateDate
	CONSTRAINT CHK_COMMENT_STATUS CHECK(status IN('DISPLAY','HIDDEN'))
);

-- 12. IMAGE_STORE (다중 이미지 관리)
CREATE TABLE IMAGE_STORE (
    image_id           NUMBER PRIMARY KEY,
    target_id          NUMBER NOT NULL,
    target_type        VARCHAR2(20) NOT NULL, -- 'PLACE', 'REVIEW'
    image_url          VARCHAR2(500) NOT NULL,
    is_representative  CHAR(1) DEFAULT 'N', 
    sort_order         NUMBER DEFAULT 0,
    created_at         TIMESTAMP DEFAULT SYSTIMESTAMP,	--DTO는 imgUploadDate
    CONSTRAINT CHK_IMG_TARGETTYPE CHECK(TARGET_TYPE IN('PLACE','REVIEW')),
    CONSTRAINT CHK_IMG_ISREPRESENTATIVE CHECK(IS_REPRESENTATIVE IN('Y','N'))
);
SELECT * FROM IMAGE_STORE;

-- 13. FAQ (자주 묻는 질문)
CREATE TABLE FAQ (
    faq_id      NUMBER PRIMARY KEY,
	admin_id    VARCHAR2(50) REFERENCES MEMBER(user_id), -- 관리자 user_id
    question    VARCHAR2(500) NOT NULL,
    answer      CLOB NOT NULL,
    category    VARCHAR2(50), --분류에 따라 제약조건 추가 CHECK(CATEGORY IN ('분류1','분류2'))
    order_no    NUMBER DEFAULT 0,
    visible     CHAR(1) DEFAULT 'Y',
    created_at  TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 faqRegDate
    updated_at  TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 faqUpdateDate
    CONSTRAINT CHK_FAQ_VISIBLE CHECK(VISIBLE IN('Y','N'))
);
SELECT * FROM FAQ;

-- 14. SURVEY (설문조사)
CREATE TABLE SURVEY (
    survey_id       NUMBER PRIMARY KEY,
    user_id         VARCHAR2(50) REFERENCES MEMBER(user_id), -- 자료형 수정
    nps_score       NUMBER(2),
    satisfaction_score NUMBER(2),
    inconvenience	CLOB,
    info_reliability_score	NUMBER(2),
    improvements	CLOB,
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP		--DTO는 surveyDate
);
SELECT * FROM SURVEY;

-- 15. POINT_POLICY (포인트 지급 기준)
CREATE TABLE POINT_POLICY (
	POLICY_KEY VARCHAR2(50) PRIMARY KEY,
	AMOUNT NUMBER NOT NULL,
	DESCRIPTION VARCHAR2(100),
	CONSTRAINT CHK_POINTPOLICY_POLICYKEY CHECK(POLICY_KEY IN('EARN_REVIEW','EARN_LOGIN','USE_BOOKING'))
);
SELECT * FROM POINT_POLICY;

-- 16. POINT (포인트 내역)
CREATE TABLE POINT (
    point_id    NUMBER PRIMARY KEY,
    user_id     VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
    policy_key	VARCHAR2(50) REFERENCES POINT_POLICY(policy_key),
    amount      NUMBER NOT NULL,
    type        VARCHAR2(10) NOT NULL, -- EARN, USE
    description VARCHAR2(255),
    created_at  TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 pointLogDate
    CONSTRAINT CHK_POINT_TYPE CHECK(TYPE IN('EARN','USE'))
);
SELECT * FROM POINT;

-- 17. INQUIRY (1:1 문의)
CREATE TABLE INQUIRY (
    inquiry_id   NUMBER PRIMARY KEY,
    user_id      VARCHAR2(50) REFERENCES MEMBER(user_id) ON DELETE SET NULL,
    title        VARCHAR2(200) NOT NULL,
    content      CLOB NOT NULL,
    status       VARCHAR2(20) DEFAULT 'PENDING', -- PENDING, ANSWERED
    admin_reply  CLOB, -- 관리자 답변 내용
    created_at	TIMESTAMP DEFAULT SYSTIMESTAMP, -- 문의 일시		--DTO는 inquiryDate
    answered_at   TIMESTAMP, 					-- 답변 일시		--DTO는 answerDate
    CONSTRAINT CHK_INQUIRY_STATUS CHECK(status IN('PENDING', 'ANSWERED'))
);
SELECT * FROM INQUIRY;

-- 18. NOTICE (공지사항 및 이벤트)
CREATE TABLE NOTICE (
    notice_id    NUMBER PRIMARY KEY,
    admin_id	VARCHAR2(50) REFERENCES MEMBER(user_id), -- 관리자 user_id
    category	VARCHAR2(50),
    title        VARCHAR2(200) NOT NULL,
    content      CLOB NOT NULL,
    image_url	VARCHAR2(500),
    view_count   NUMBER DEFAULT 0,
    is_top       CHAR(1) DEFAULT 'N', -- 상단 고정 여부
    created_at  TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 regDate
    CONSTRAINT CHK_NOTICE_ISTOP CHECK(IS_TOP IN('Y','N')),
    CONSTRAINT CHK_NOTICE_CATEGORY CHECK(CATEGORY IN('NOTICE','EVENT'))
);
SELECT * FROM NOTICE;

-- 19. FAVORITE (즐겨찾기 / 북마크)
CREATE TABLE FAVORITE (
    favorite_id  NUMBER PRIMARY KEY,
    user_id      VARCHAR2(50) REFERENCES MEMBER(user_id),
    place_id     NUMBER REFERENCES PLACE(place_id),
    created_at   TIMESTAMP DEFAULT SYSTIMESTAMP,		--DTO는 favRegDate
    updated_at   TIMESTAMP DEFAULT SYSTIMESTAMP,			--DTO는 favUpdateDate
    UNIQUE(user_id, place_id) -- 중복 북마크 방지
);
SELECT * FROM FAVORITE;

-- 20. SEARCH_HISTORY(최근 검색어)
CREATE TABLE SEARCH_HISTORY (
    history_id   NUMBER PRIMARY KEY,
    user_id      VARCHAR2(50) REFERENCES MEMBER(user_id),
    keyword      VARCHAR2(100) NOT NULL,
    created_at   TIMESTAMP DEFAULT SYSTIMESTAMP		--DTO는 searchDate
);
SELECT * FROM SEARCH_HISTORY;

--------------------------------------------------
-- 시퀀스/트리거 생성
--------------------------------------------------
--1) 시퀀스 생성
CREATE SEQUENCE SEQ_PLACE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TICKET START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_REVIEW START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_IMAGE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_FAQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_INQUIRY START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_NOTICE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_POST START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_COMMENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_SURVEY START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_POINT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_FAVORITE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_SEARCH START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_RES START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PAY START WITH 1 INCREMENT BY 1;

--=====프로시저 및 트리거 생성=====
--프로시저, 트리거 생성 시에는 '/' 단위로 끊어서 한번에 실행해야 함

--2) 예약/결제번호 생성용 트리거(RYYMMDDXXX)
CREATE OR REPLACE TRIGGER TRG_RESERVATION_ID
BEFORE INSERT ON RESERVATION FOR EACH ROW
BEGIN
  SELECT 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD') || LPAD(SEQ_RES.NEXTVAL, 3, '0')
  INTO :NEW.reservation_id FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER TRG_PAYMENT_ID
BEFORE INSERT ON PAYMENT FOR EACH ROW
BEGIN
  SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || LPAD(SEQ_PAY.NEXTVAL, 3, '0')
  INTO :NEW.payment_id FROM DUAL;
END;
/

--3) 축제 status 자동계산 트리거
CREATE OR REPLACE TRIGGER TRG_FESTIVAL_STATUS
BEFORE INSERT OR UPDATE ON FESTIVAL
FOR EACH ROW
BEGIN
    IF :NEW.end_date < TRUNC(SYSDATE) THEN
        :NEW.status := 'ENDED';
    ELSIF :NEW.start_date > TRUNC(SYSDATE) THEN
        :NEW.status := 'UPCOMING';
    ELSE
        :NEW.status := 'ONGOING';
    END IF;
END;
/

--4) FAQ, NOTICE 데이터 수정 시 admin 계정인지 검사하는 프로시저, 트리거
--ADMIN AUTHORIZATION 트리거 생성(/ 이전까지 한번에 실행)
CREATE OR REPLACE PROCEDURE PROC_CHECK_ADMIN_AUTH (
    p_admin_id IN VARCHAR2
) IS
    v_role VARCHAR2(20);
BEGIN
    -- 1. 아이디 형식 체크 (admin+숫자)
    IF NOT REGEXP_LIKE(p_admin_id, '^admin[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20001, '오류: 관리자 아이디 형식이 올바르지 않습니다. (예: admin01)');
    END IF;

    -- 2. 역할(role) 체크
    SELECT role INTO v_role FROM MEMBER WHERE user_id = p_admin_id;
    IF v_role != 'ADMIN' THEN
        RAISE_APPLICATION_ERROR(-20002, '오류: 관리자 권한이 없는 사용자입니다.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, '오류: 등록되지 않은 사용자입니다.');
END;
/

-- F&Q용 트리거
CREATE OR REPLACE TRIGGER TRG_FAQ_ADMIN_CHECK
BEFORE INSERT OR UPDATE ON FAQ FOR EACH ROW
BEGIN
    PROC_CHECK_ADMIN_AUTH(:NEW.admin_id);
END;
/

-- NOTICE용 트리거
CREATE OR REPLACE TRIGGER TRG_NOTICE_ADMIN_CHECK
BEFORE INSERT OR UPDATE ON NOTICE FOR EACH ROW
BEGIN
    PROC_CHECK_ADMIN_AUTH(:NEW.admin_id);
END;
/

--5) FAQ_ID 자동생성 트리거
CREATE OR REPLACE TRIGGER TRG_FAQ_ID
BEFORE INSERT ON FAQ
FOR EACH ROW
BEGIN
  IF :NEW.faq_id IS NULL THEN
    SELECT SEQ_FAQ.NEXTVAL INTO :NEW.faq_id FROM DUAL;
  END IF;
END;

--6) 1:1문의 답변 등록 시 answered_at(답변등록일자) 자동 세팅
CREATE OR REPLACE TRIGGER TRG_INQUIRY_ANSWERED_AT
BEFORE UPDATE ON INQUIRY FOR EACH ROW
BEGIN
    IF :NEW.status = 'ANSWERED' AND :OLD.status = 'PENDING' THEN
        :NEW.answered_at := SYSTIMESTAMP;
    END IF;
END;
/

--7) 포인트 log 생성 + 사용자 잔액 업데이트(트랜잭션;PL/SQL 사용)
-- 트리거 1: type 자동 세팅
CREATE OR REPLACE TRIGGER TRG_POINT_TYPE
BEFORE INSERT ON POINT FOR EACH ROW
BEGIN
    IF :NEW.type IS NULL THEN
        IF :NEW.policy_key LIKE 'EARN%' THEN
            :NEW.type := 'EARN';
        ELSIF :NEW.policy_key LIKE 'USE%' THEN
            :NEW.type := 'USE';
        END IF;
    END IF;
END;
/

-- 트리거 2: 잔액 자동 계산
CREATE OR REPLACE TRIGGER TRG_POINT_BALANCE
AFTER INSERT ON POINT FOR EACH ROW
BEGIN
    UPDATE MEMBER
    SET POINT_BALANCE = POINT_BALANCE + :NEW.amount
    WHERE USER_ID = :NEW.user_id;
END;
/

--------------------------------------------------
-- 테이블 삭제 (참조 관계 역순)
--------------------------------------------------
-- 1. 자식 테이블
DROP TABLE SEARCH_HISTORY;
DROP TABLE FAVORITE;
DROP TABLE NOTICE;
DROP TABLE INQUIRY;
DROP TABLE POINT;
DROP TABLE POINT_POLICY;
DROP TABLE SURVEY;
DROP TABLE FAQ;
DROP TABLE IMAGE_STORE;
DROP TABLE REVIEW;
DROP TABLE FESTIVAL_TICKET;


-- 2. 거래 관련 테이블 (결제는 예약을 참조하므로 결제 먼저 삭제)
DROP TABLE PAYMENT;
DROP TABLE RESERVATION;

-- 3. 장소 상세 테이블 (부모인 PLACE를 참조하므로 먼저 삭제)
DROP TABLE RESTAURANT;
DROP TABLE ACCOMMODATION;
DROP TABLE FESTIVAL;

-- 4. 최상위 부모 테이블
DROP TABLE PLACE;
DROP TABLE MEMBER;

-- 5. 시퀀스 삭제
DROP SEQUENCE SEQ_PLACE;
--이하 동일

-- (참고) 만약 순서 상관없이 강제로 다 지우고 싶을 때만 아래 방식 사용
-- DROP TABLE MEMBER CASCADE CONSTRAINTS;
-- DROP TABLE PLACE CASCADE CONSTRAINTS;