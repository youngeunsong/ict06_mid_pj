package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import spring.ict06team1.midpj.dao.PointDAO;
import spring.ict06team1.midpj.dto.PointDTO;

@Service
public class PointServiceImpl implements PointService {

    @Autowired
    private PointDAO pointDao;

    @Override
    public int getPointBalance(String user_id) {
        return pointDao.getPointBalance(user_id);
    }

    @Override
    @Transactional
    public boolean usePoint(String user_id, int usedPoint, String reservation_id) {

        System.out.println("=== PointServiceImpl.usePoint 시작 ===");
        System.out.println("user_id = " + user_id);
        System.out.println("usedPoint = " + usedPoint);
        System.out.println("reservation_id = " + reservation_id);

        if (usedPoint <= 0) {
            return true;
        }

        int currentPoint = pointDao.getPointBalance(user_id);
        System.out.println("currentPoint = " + currentPoint);

        if (currentPoint < usedPoint) {
            System.out.println("포인트 부족");
            return false;
        }

        PointDTO pointDto = new PointDTO();
        pointDto.setUser_id(user_id);
        pointDto.setPolicy_key("USE_BOOKING");
        pointDto.setAmount(-usedPoint);   // 로그에는 음수
        pointDto.setType("USE");
        pointDto.setDescription("예약 결제 포인트 사용");

        int logCnt = pointDao.insertPointLog(pointDto);
        System.out.println("logCnt = " + logCnt);

        int finalPoint = pointDao.getPointBalance(user_id);
        System.out.println("finalPoint = " + finalPoint);

        return logCnt > 0;
    }
}