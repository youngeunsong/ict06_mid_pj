package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Repository
public class MainDAOImpl implements MainDAO {

    @Autowired
    private SqlSession sqlSession;

    //맛집 TOP10
    @Override
    public List<PlaceDTO> getTop10ByREST() {
        System.out.println("[MainDAOImpl - getTop10ByREST()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<PlaceDTO> getTop10RESTlist = dao.getTop10ByREST();
        
        return getTop10RESTlist;
    }
    
    //숙소 TOP10
    @Override
    public List<AccommodationDTO> getTop10ByACC() {
        System.out.println("[MainDAOImpl - getTop10ByACC()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<AccommodationDTO> getTop10ACClist = dao.getTop10ByACC();
        
        return getTop10ACClist;
    }
    
    //각 플레이스 별 리뷰
    @Override
    public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds) {
    	System.out.println("[MainDAOImpl - getPlaceReviewStatsByIds()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);
        
        return statsList;
    }

    //즐겨찾기
    @Override
    public List<Integer> getFavoritePlaceIds(String user_id) {
    	System.out.println("[MainDAOImpl - getFavoritePlaceIds()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<Integer> favoriteList = dao.getFavoritePlaceIds(user_id);

        return favoriteList;
    }
}