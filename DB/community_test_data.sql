-- 커뮤니티(150건) + 공지/이벤트(40건) + 각 글당 랜덤 댓글까지 모두 생성
-- 데이터 확인용 쿼리================================
-- 커뮤니티 카테고리별 30건씩 확인
SELECT category, COUNT(*) FROM COMMUNITY GROUP BY category;

-- 커뮤니티 인기글 확인 (조회수/좋아요 정렬)
SELECT post_id, category, title, view_count, like_count 
FROM COMMUNITY 
ORDER BY view_count DESC;

-- 댓글이 가장 많이 달린 게시글 찾기:
SELECT post_id, COUNT(*) as comment_cnt 
FROM COMMUNITY_COMMENT 
GROUP BY post_id 
ORDER BY comment_cnt DESC;


-- 공지 및 이벤트 수량 확인 (각 20건)
SELECT category, COUNT(*) FROM NOTICE GROUP BY category;

-- 상단 고정된 공지 확인
SELECT * FROM NOTICE WHERE is_top = 'Y';

-- 공지사항 상단 고정 및 조회수 확인
SELECT is_top, category, title, view_count 
FROM NOTICE 
ORDER BY is_top DESC, created_at DESC;

-- 사전 준비======================================
-- 1. 기존 데이터 초기화 (자식 -> 부모 순)
DELETE FROM COMMUNITY_COMMENT;
DELETE FROM COMMUNITY;
DELETE FROM NOTICE;
COMMIT;

-- 2. 시퀀스 초기화
DROP SEQUENCE SEQ_POST;
DROP SEQUENCE SEQ_COMMENT;
DROP SEQUENCE SEQ_NOTICE;
CREATE SEQUENCE SEQ_POST START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_COMMENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_NOTICE START WITH 1 INCREMENT BY 1;


-- 데이터 생성 스크립트
-- 커뮤니티 5개 카테고리 각 30개, 공지/이벤트 각 20개, 게시글당 댓글 10~40개
-- 3. 오류를 일으키는 트리거 잠시 중지
ALTER TRIGGER TRG_NOTICE_ADMIN_CHECK DISABLE;

DECLARE
    v_post_id NUMBER;
    v_admin_id VARCHAR2(50);
    v_user_id  VARCHAR2(50);
    -- 커뮤니티 카테고리 정의
    TYPE cat_array IS VARRAY(5) OF VARCHAR2(50);
    v_comm_cats cat_array := cat_array('맛집수다', '숙소수다', '축제수다', '정보공유', '동행구해요');
BEGIN
    -- 실제 존재하는 ID 추출 (MEMBER 테이블 기준)
    SELECT user_id INTO v_admin_id FROM (SELECT user_id FROM MEMBER WHERE role = 'ADMIN' ORDER BY user_id) WHERE ROWNUM = 1;
    SELECT user_id INTO v_user_id  FROM (SELECT user_id FROM MEMBER WHERE role = 'USER' ORDER BY user_id) WHERE ROWNUM = 1;

    -- [1] COMMUNITY 데이터 생성 (5개 카테고리 * 30건 = 150건)
    FOR i IN 1..v_comm_cats.COUNT LOOP
        FOR j IN 1..30 LOOP
            INSERT INTO COMMUNITY (post_id, user_id, title, content, category, status, created_at)
            VALUES (SEQ_POST.NEXTVAL, v_user_id, v_comm_cats(i) || ' 게시글 ' || j, 
                    v_comm_cats(i) || ' 카테고리 테스트 본문입니다. 번호: ' || j, 
                    v_comm_cats(i), 'DISPLAY', SYSTIMESTAMP - (DBMS_RANDOM.VALUE(0, 15)))
            RETURNING post_id INTO v_post_id;

            -- 각 글마다 댓글 10~40개 랜덤 생성
            FOR k IN 1..TRUNC(DBMS_RANDOM.VALUE(10, 41)) LOOP
                INSERT INTO COMMUNITY_COMMENT (comment_id, post_id, user_id, content, status, created_at)
                VALUES (SEQ_COMMENT.NEXTVAL, v_post_id, v_user_id, '테스트 댓글입니다 ' || k, 'DISPLAY', SYSTIMESTAMP - (DBMS_RANDOM.VALUE(0, 5)));
            END LOOP;
        END LOOP;
    END LOOP;

    -- [2] NOTICE 테이블 - 공지사항 (NOTICE) 20건 생성
    FOR i IN 1..20 LOOP
        INSERT INTO NOTICE (notice_id, admin_id, category, title, content, view_count, is_top, created_at)
        VALUES (SEQ_NOTICE.NEXTVAL, v_admin_id, 'NOTICE', '[공지] 시스템 이용 안내 ' || i, 
                '공지사항 테스트 내용입니다.', i, CASE WHEN i <= 3 THEN 'Y' ELSE 'N' END, SYSTIMESTAMP - (30 - i));
    END LOOP;

    -- [3] NOTICE 테이블 - 이벤트 (EVENT) 20건 생성
    FOR i IN 1..20 LOOP
        INSERT INTO NOTICE (notice_id, admin_id, category, title, content, view_count, is_top, created_at)
        VALUES (SEQ_NOTICE.NEXTVAL, v_admin_id, 'EVENT', '[이벤트] 시즌 특별 혜택 ' || i, 
                '이벤트 참여 안내 본문입니다.', i*2, 'N', SYSTIMESTAMP - (30 - i));
    END LOOP;

    COMMIT;
END;
/

-- 4. 중지했던 트리거 다시 활성화
ALTER TRIGGER TRG_NOTICE_ADMIN_CHECK ENABLE;