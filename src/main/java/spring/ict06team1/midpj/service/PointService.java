package spring.ict06team1.midpj.service;

public interface PointService {

    // 현재 보유 포인트 조회
    int getPointBalance(String user_id);

    // 포인트 사용 처리
    boolean usePoint(String user_id, int usedPoint, String reservation_id);
}