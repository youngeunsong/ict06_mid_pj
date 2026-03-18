
-- [기존 1,093건 데이터에 테스트 데이터 리뷰 4,000개 생성]
-- 실행 후 4,000건 확인 되어야함
SELECT place_type
     , COUNT(*)
FROM PLACE GROUP BY place_type;

SELECT COUNT(*) FROM REVIEW;


SELECT *
FROM "MEMBER" m 

-- 기존 1,093건 데이터에 리뷰 4,000개를 뿌리는 스크립트
-- 1. REVIEW 테이블 시퀀스 재설정 (PK 충돌 방지)
DECLARE
    v_max_id NUMBER;
BEGIN
    SELECT NVL(MAX(review_id), 0) INTO v_max_id FROM REVIEW;
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_REVIEW';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_REVIEW START WITH ' || (v_max_id + 1) || ' INCREMENT BY 1';
END;
/

-- 2. 기존 PLACE 데이터를 활용한 리뷰 4,000건 생성
DECLARE
    v_target_place_id NUMBER;
    v_random_user     VARCHAR2(50);
    v_review_content  VARCHAR2(500);
    
    -- 샘플 문구 배열
    TYPE t_msg IS TABLE OF VARCHAR2(100);
    v_msgs t_msg := t_msg(
        '정말 친절하시고 좋았어요!', '인생 맛집 등극입니다.', '시설이 깔끔해서 다시 오고 싶네요.',
        '생각보다 사람이 많았지만 만족합니다.', '분위기가 너무 좋아서 데이트 코스로 딱이에요.',
        '재방문 의사 200%입니다.', '가격 대비 훌륭한 곳입니다.', '사진 찍기 너무 예쁜 곳!',
        '직원분들이 너무 밝으셔서 기분 좋게 다녀왔어요.', '기대 이상으로 즐거웠습니다.'
    );
BEGIN
    -- 총 4,000개의 리뷰를 랜덤하게 배정
    FOR i IN 1..4000 LOOP
        
        -- 1. 기존 1,093건의 PLACE 중 랜덤으로 하나 선택
        SELECT place_id INTO v_target_place_id 
        FROM (SELECT place_id FROM PLACE ORDER BY DBMS_RANDOM.VALUE) 
        WHERE ROWNUM = 1;

        -- 2. user01 ~ user09 중 랜덤 선택
        v_random_user := 'user' || LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 10)), 2, '0');
        
        -- 3. 문구 랜덤 선택
        v_review_content := v_msgs(TRUNC(DBMS_RANDOM.VALUE(1, 11)));

        -- 4. 리뷰 인서트
        INSERT INTO REVIEW (
            review_id, 
            user_id, 
            place_id, 
            rating, 
            content, 
            status, 
            created_at
        ) VALUES (
            SEQ_REVIEW.NEXTVAL, 
            v_random_user, 
            v_target_place_id, 
            TRUNC(DBMS_RANDOM.VALUE(1, 6)), -- 별점 1~5점
            v_review_content || ' (테스트 리뷰 #' || i || ')', 
            'DISPLAY', 
            SYSTIMESTAMP - DBMS_RANDOM.VALUE(0, 30) -- 최근 30일 내 랜덤
        );
        
        -- 100건마다 한 번씩 커밋 (성능 및 안전)
        IF MOD(i, 100) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;
    
    COMMIT;
END;
/
