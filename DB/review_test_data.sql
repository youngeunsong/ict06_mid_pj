
-- [리뷰 테스트 데이터 생성 (100건 + 리뷰 4,000건)]
-- 실행 후 4,000건 확인 되어야함
SELECT place_type, COUNT(*) FROM PLACE GROUP BY place_type;
SELECT COUNT(*) FROM REVIEW;

-- 1. PLACE 테이블 시퀀스 재설정
DECLARE
    v_max_id NUMBER;
BEGIN
    -- 현재 PLACE 테이블의 최대 ID 값을 가져옴
    SELECT NVL(MAX(place_id), 0) INTO v_max_id FROM PLACE;
    
    -- 시퀀스를 삭제하고 다시 생성 (가장 확실한 방법)
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_PLACE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_PLACE START WITH ' || (v_max_id + 1) || ' INCREMENT BY 1';
    
    -- 2. REVIEW 테이블 시퀀스 재설정
    SELECT NVL(MAX(review_id), 0) INTO v_max_id FROM REVIEW;
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_REVIEW';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_REVIEW START WITH ' || (v_max_id + 1) || ' INCREMENT BY 1';
END;
/

-- 2. 스크립트 실행 (100건 + 리뷰 4,000건)
DECLARE
    v_place_id NUMBER;
BEGIN
    -- 1. 맛집(REST) 50건 생성
    FOR i IN 1..50 LOOP
        INSERT INTO PLACE (place_id, place_type, name, address, view_count, image_url, created_at)
        VALUES (SEQ_PLACE.NEXTVAL, 'REST', '추천맛집_' || i, '서울시 강남구 역삼동 ' || i, MOD(i, 100), 'https://picsum.photos/400/300?random=' || i, SYSTIMESTAMP)
        RETURNING place_id INTO v_place_id;

        INSERT INTO RESTAURANT (restaurant_id, description, phone, category, status)
        VALUES (v_place_id, '맛있는 테스트 맛집입니다.', '02-123-' || LPAD(i, 4, '0'), '한식', 'OPEN');

        -- 맛집당 리뷰 40개 생성
        FOR j IN 1..40 LOOP
            INSERT INTO REVIEW (review_id, user_id, place_id, rating, content, status, created_at)
            VALUES (SEQ_REVIEW.NEXTVAL, 'user01', v_place_id, MOD(j, 5) + 1, '정말 맛있어요! 추천합니다.', 'DISPLAY', SYSTIMESTAMP - DBMS_RANDOM.VALUE(0, 6));
        END LOOP;
    END LOOP;

    -- 2. 숙소(ACC) 30건 생성
    FOR i IN 1..30 LOOP
        INSERT INTO PLACE (place_id, place_type, name, address, view_count, image_url, created_at)
        VALUES (SEQ_PLACE.NEXTVAL, 'ACC', '인기숙소_' || i, '제주도 서귀포시 ' || i, MOD(i, 200), 'https://picsum.photos/400/300?random=' || (i+50), SYSTIMESTAMP)
        RETURNING place_id INTO v_place_id;

        INSERT INTO ACCOMMODATION (accommodation_id, description, phone, price, status)
        VALUES (v_place_id, '편안한 테스트 숙소입니다.', '064-987-' || LPAD(i, 4, '0'), 100000 + (i * 1000), 'OPEN');

        -- 숙소당 리뷰 40개 생성
        FOR j IN 1..40 LOOP
            INSERT INTO REVIEW (review_id, user_id, place_id, rating, content, status, created_at)
            VALUES (SEQ_REVIEW.NEXTVAL, 'user02', v_place_id, MOD(j, 5) + 1, '시설이 깨끗하고 좋네요.', 'DISPLAY', SYSTIMESTAMP - DBMS_RANDOM.VALUE(0, 6));
        END LOOP;
    END LOOP;

    -- 3. 축제(FEST) 20건 생성
    FOR i IN 1..20 LOOP
        INSERT INTO PLACE (place_id, place_type, name, address, view_count, image_url, created_at)
        VALUES (SEQ_PLACE.NEXTVAL, 'FEST', '신나는축제_' || i, '강원도 강릉시 ' || i, MOD(i, 300), 'https://picsum.photos/400/300?random=' || (i+80), SYSTIMESTAMP)
        RETURNING place_id INTO v_place_id;

        INSERT INTO FESTIVAL (festival_id, description, start_date, end_date)
        VALUES (v_place_id, '즐거운 테스트 축제입니다.', SYSDATE - 5, SYSDATE + 10);

        -- 축제당 리뷰 40개 생성
        FOR j IN 1..40 LOOP
            INSERT INTO REVIEW (review_id, user_id, place_id, rating, content, status, created_at)
            VALUES (SEQ_REVIEW.NEXTVAL, 'user03', v_place_id, MOD(j, 5) + 1, '볼거리가 정말 많아요.', 'DISPLAY', SYSTIMESTAMP - DBMS_RANDOM.VALUE(0, 6));
        END LOOP;
    END LOOP;

    COMMIT;
END;
/



