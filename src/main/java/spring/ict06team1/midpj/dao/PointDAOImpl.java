package spring.ict06team1.midpj.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.PointDTO;

@Repository
public class PointDAOImpl implements PointDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public int getPointBalance(String user_id) {
        System.out.println("PointDAOImpl - getPointBalance()");
        return sqlSession.selectOne("spring.ict06team1.midpj.dao.PointDAO.getPointBalance", user_id);
    }

    @Override
    public int usePoint(Map<String, Object> map) {
        System.out.println("PointDAOImpl - usePoint()");
        return sqlSession.update("spring.ict06team1.midpj.dao.PointDAO.usePoint", map);
    }

    @Override
    public int insertPointLog(PointDTO dto) {
        System.out.println("PointDAOImpl - insertPointLog()");
        return sqlSession.insert("spring.ict06team1.midpj.dao.PointDAO.insertPointLog", dto);
    }
}