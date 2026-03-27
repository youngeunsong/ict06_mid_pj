-- 기존에 숫자로 들어간 areaCode를 단어로 변경
UPDATE accommodation
SET areacode =
    CASE areacode
        WHEN '1'  THEN '서울'
        WHEN '31' THEN '경기'
        WHEN '2'  THEN '인천'
        WHEN '6'  THEN '부산'
        WHEN '4'  THEN '대구'
        WHEN '3'  THEN '대전'
        WHEN '5'  THEN '광주'
        WHEN '7'  THEN '울산'
        WHEN '39' THEN '제주'
        ELSE '기타'
    END
WHERE areacode IN ('1','31','2','6','4','3','5','7','39');