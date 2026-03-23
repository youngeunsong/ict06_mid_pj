package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.NoticeDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Repository
public class MainDAOImpl implements MainDAO {

    @Autowired
    private SqlSession sqlSession;

    //맛집 TOP10
    @Override
    public List<RestaurantDTO> top10ByREST() {
        System.out.println("[MainDAOImpl - top10ByREST()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<RestaurantDTO> getTop10RESTlist = dao.top10ByREST();
        
        return getTop10RESTlist;
    }
    
    //숙소 TOP10
    @Override
    public List<AccommodationDTO> top10ByACC() {
        System.out.println("[MainDAOImpl - top10ByACC()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<AccommodationDTO> getTop10ACClist = dao.top10ByACC();
        
        return getTop10ACClist;
    }
    
    //플레이스 별 리뷰 갯수(getReviewCountMap) + 평균 조회(getAvgRatingMap)
    @Override
    public List<Map<String, Object>> placeReviewStatsByIds(List<Integer> placeIds) {
    	System.out.println("[MainDAOImpl - placeReviewStatsByIds()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<Map<String, Object>> statsList = dao.placeReviewStatsByIds(placeIds);
        
        return statsList;
    }

    //로그인된 id의 즐겨찾기 조회
    @Override
    public List<Integer> favoritePlaceIds(String user_id) {
    	System.out.println("[MainDAOImpl - favoritePlaceIds()]");

        MainDAO dao = sqlSession.getMapper(MainDAO.class);
        List<Integer> favoriteList = dao.favoritePlaceIds(user_id);

        return favoriteList;
    }

    //이달의 추천 국내 축제
	@Override
	public List<FestivalDTO> top8ThisMonthFestival() {
		System.out.println("[MainDAOImpl - top8ThisMonthFestival()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<FestivalDTO> Top8ThisMonthFestival = dao.top8ThisMonthFestival();
		
		return Top8ThisMonthFestival;
	}

	//BEST 추천 - 전체 탭 우측 4개
	@Override
	public List<Map<String, Object>> bestAllTop4() {
		System.out.println("[MainDAOImpl - bestAllTop4()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<Map<String, Object>> BestAllTop4 = dao.bestAllTop4();
		
		return BestAllTop4;
	}

	//BEST 추천 - 맛집 5개
	@Override
	public List<RestaurantDTO> bestRestTop5() {
		System.out.println("[MainDAOImpl - bestRestTop5()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<RestaurantDTO> BestRestTop5 = dao.bestRestTop5();
		
		return BestRestTop5;
	}

	//BEST 추천 - 숙소 5개
	@Override
	public List<AccommodationDTO> bestAccTop5() {
		System.out.println("[MainDAOImpl - bestAccTop5()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<AccommodationDTO> BestAccTop5 = dao.bestAccTop5();
		
		return BestAccTop5;
	}

	//BEST 추천 - 축제 5개
	@Override
	public List<FestivalDTO> bestFestTop5() {
		System.out.println("[MainDAOImpl - bestFestTop5()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<FestivalDTO> BestFestTop5 = dao.bestFestTop5();
		
		return BestFestTop5;
	}
	
	//최하단 공지 리스트
	public List<NoticeDTO> getMainNoticeList(){
		System.out.println("[MainDAOImpl - getMainNoticeList()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<NoticeDTO> mainNoticeList = dao.getMainNoticeList();
		
		return mainNoticeList;
	}
	
	//최하단 이벤트 리스트
	public List<NoticeDTO> getMainEventList(){
		System.out.println("[MainDAOImpl - getMainEventList()]");
		
		MainDAO dao = sqlSession.getMapper(MainDAO.class);
		List<NoticeDTO> mainEventList = dao.getMainEventList();
		
		return mainEventList;
	}
	
}