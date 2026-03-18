package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.SearchHistoryDTO;

@Repository
public class SearchDAOImpl implements SearchDAO {

	@Autowired
	private SqlSession sqlSession;

	// [검색 결과] -----------------------------------------------------------
	// 1. 검색어 기준 식당 목록
	@Override
	public List<RestaurantDTO> getRestList(String keyword) {
		System.out.println("[SearchDAOImpl - getRestList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<RestaurantDTO> restList = dao.getRestList(keyword);
		
		return restList;
	}
	
	// 1. 검색어 기준 숙소 목록
	@Override
	public List<AccommodationDTO> getAccList(String keyword) {
		System.out.println("[SearchDAOImpl - getAccList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<AccommodationDTO> accList = dao.getAccList(keyword);
		
		return accList;
	}

	// 3. 검색어 기준 축제 목록
	@Override
	public List<FestivalDTO> getFestList(String keyword) {
		System.out.println("[SearchDAOImpl - getFestList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<FestivalDTO> festList = dao.getFestList(keyword);
		
		return festList;
	}

	// 4. 검색어 기준 장소별 리뷰 통계
	@Override
	public List<Map<String, Object>> getPlaceReviewStats(String keyword) {
		System.out.println("[SearchDAOImpl - getPlaceReviewStats()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Map<String, Object>> reviewStatsList = dao.getPlaceReviewStats(keyword);
		
		return reviewStatsList;
	}

	// [즐겨찾기] -----------------------------------------------------------
	// 1. 즐겨찾기 여부 확인
	@Override
	public int checkFavorite(Map<String, Object> checkFavorite) {
		System.out.println("[SearchDAOImpl - checkFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int exist = dao.checkFavorite(checkFavorite);
		
		return exist;
	}

	// 2. 즐겨찾기 추가
	@Override
	public int addFavorite(Map<String, Object> addFavorite) {
		System.out.println("[SearchDAOImpl - addFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int addCnt = dao.addFavorite(addFavorite);
		
		return addCnt;
	}

	// 3. 즐겨찾기 삭제
	@Override
	public int deleteFavorite(Map<String, Object> deleteFavorite) {
		System.out.println("[SearchDAOImpl - deleteFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int delectCnt = dao.deleteFavorite(deleteFavorite);
		
		return delectCnt;
	}

	// 4. 즐겨찾기 한 정보 끌고오기
	@Override
	public List<Integer> getFavoritePlaceIds(String user_id) {
		System.out.println("[SearchDAOImpl - getFavoritePlaceIds()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Integer> favoritePlaceIds = dao.getFavoritePlaceIds(user_id);
		
		return favoritePlaceIds;
	}

	// [AJAX] -----------------------------------------------------------
	// AJAX맛집 카드 목록 + 카드 건수
	@Override
	public List<RestaurantDTO> getRestAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getRestAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<RestaurantDTO> restAjaxList = dao.getRestAjaxList(param);
		
		return restAjaxList;
	};
	
	@Override
	public int getRestAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getRestAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int restAjaxCount = dao.getRestAjaxCount(param);
		
		return restAjaxCount;
	};

	// AJAX숙소 카드 목록 + 카드 건수
	@Override
	public List<AccommodationDTO> getAccAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getAccAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<AccommodationDTO> accAjaxList = dao.getAccAjaxList(param);
		
		return accAjaxList;
	};
	
	@Override
	public int getAccAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getAccAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int accAjaxCount = dao.getAccAjaxCount(param);
		
		return accAjaxCount;
	};

	// AJAX축제 카드 목록 + 카드 건수
	@Override
	public List<FestivalDTO> getFestAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getFestAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<FestivalDTO> festAjaxList = dao.getFestAjaxList(param);
		
		return festAjaxList;
	};
	
	@Override
	public int getFestAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getFestAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int festAjaxCount = dao.getFestAjaxCount(param);
		
		return festAjaxCount;
	};
	
	// AJAX리뷰 통계
	public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds){
		System.out.println("[SearchDAOImpl - getPlaceReviewStatsByIds()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);
		
		return statsList;
	};

	// 자동완성 10개
	@Override
	public List<String> getAutoComplete(String keyword) {
		System.out.println("[SearchDAOImpl - getAutoComplete()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<String> resultList = dao.getAutoComplete(keyword);
		
		return resultList;
	}

	//1. 최근 검색어 5~10개 조회
	@Override
	public List<SearchHistoryDTO> getRecentKeywords(String login_userId) {
		System.out.println("[SearchDAOImpl - getRecentKeywords()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<SearchHistoryDTO> RecentKeywordList = dao.getRecentKeywords(login_userId);
		
		return RecentKeywordList;
	}

	//2. 최근 검색어 추가 전, 이미 db에 있다면 중복 방지를 위한 삭제
	@Override
	public int deleteSameKeyword(Map<String, Object> searchMap) {
		System.out.println("[SearchDAOImpl - deleteSameKeyword()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int deleteCnt = dao.deleteSameKeyword(searchMap);
		
		return deleteCnt;
	}
	
	
	//3. 최근 검색어 추가
	@Override
	public int insertSearchHistory(Map<String, Object> searchMap) {
		System.out.println("[SearchDAOImpl - insertSearchHistory()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int insertCnt = dao.insertSearchHistory(searchMap);
		
		return insertCnt;
	}


}