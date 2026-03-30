package spring.ict06team1.midpj.dao;

import java.util.Map;

import spring.ict06team1.midpj.dto.PointDTO;

public interface PointDAO {

    // 현재 보유 포인트 조회
    public int getPointBalance(String user_id);

    // 포인트 차감
    public int usePoint(Map<String, Object> map);

    // 포인트 사용 로그 저장
    public int insertPointLog(PointDTO dto);
}