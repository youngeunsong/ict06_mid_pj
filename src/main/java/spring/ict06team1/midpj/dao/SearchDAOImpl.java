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

    /* ==========================================
		검색 키워드 결과 가져오기
		키워드(맛집/ 숙소/ 축제) 별 리스트 | 리뷰 갯수 + 리뷰 통계 조회
	========================================== */
	//키워드(맛집) 리스트
	@Override
	public List<RestaurantDTO> getRestList(String keyword) {
		System.out.println("[SearchDAOImpl - getRestList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<RestaurantDTO> restList = dao.getRestList(keyword);
		
		return restList;
	}
	
	//키워드(숙소) 리스트
	@Override
	public List<AccommodationDTO> getAccList(String keyword) {
		System.out.println("[SearchDAOImpl - getAccList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<AccommodationDTO> accList = dao.getAccList(keyword);
		
		return accList;
	}

	//키워드(축제) 리스트
	@Override
	public List<FestivalDTO> getFestList(String keyword) {
		System.out.println("[SearchDAOImpl - getFestList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<FestivalDTO> festList = dao.getFestList(keyword);
		
		return festList;
	}

	//리뷰 갯수 + 리뷰 통계 조회
	@Override
	public List<Map<String, Object>> getPlaceReviewStats(String keyword) {
		System.out.println("[SearchDAOImpl - getPlaceReviewStats()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Map<String, Object>> reviewStatsList = dao.getPlaceReviewStats(keyword);
		
		return reviewStatsList;
	}

	/* ==========================================
		즐겨찾기(여부체크/ 삭제/ 추가/ 조회)
	========================================== */
	//즐겨찾기 여부체크
	@Override
	public int checkFavorite(Map<String, Object> checkFavorite) {
		System.out.println("[SearchDAOImpl - checkFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int exist = dao.checkFavorite(checkFavorite);
		
		return exist;
	}

	//즐겨찾기 추가
	@Override
	public int addFavorite(Map<String, Object> addFavorite) {
		System.out.println("[SearchDAOImpl - addFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int addCnt = dao.addFavorite(addFavorite);
		
		return addCnt;
	}

	//즐겨찾기 삭제
	@Override
	public int deleteFavorite(Map<String, Object> deleteFavorite) {
		System.out.println("[SearchDAOImpl - deleteFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int delectCnt = dao.deleteFavorite(deleteFavorite);
		
		return delectCnt;
	}

	//즐겨찾기 조회
	@Override
	public List<Integer> getFavoritePlaceIds(String user_id) {
		System.out.println("[SearchDAOImpl - getFavoritePlaceIds()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Integer> favoritePlaceIds = dao.getFavoritePlaceIds(user_id);
		
		return favoritePlaceIds;
	}

    /* ==========================================
		AJAX 화면
		키워드(맛집/ 숙소/ 축제) 별 리스트+페이징 | 리뷰 갯수 + 리뷰 통계 조회
	========================================== */
	//AJAX 맛집 리스트+페이징
	@Override
	public List<RestaurantDTO> getRestAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getRestAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<RestaurantDTO> restAjaxList = dao.getRestAjaxList(param);
		
		return restAjaxList;
	};
	
	//AJAX 맛집 건수
	@Override
	public int getRestAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getRestAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int restAjaxCount = dao.getRestAjaxCount(param);
		
		return restAjaxCount;
	};

	//AJAX 숙소 리스트+페이징
	@Override
	public List<AccommodationDTO> getAccAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getAccAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<AccommodationDTO> accAjaxList = dao.getAccAjaxList(param);
		
		return accAjaxList;
	};
	
	//AJAX 숙소 건수
	@Override
	public int getAccAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getAccAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int accAjaxCount = dao.getAccAjaxCount(param);
		
		return accAjaxCount;
	};

	//AJAX 축제 리스트+페이징
	@Override
	public List<FestivalDTO> getFestAjaxList(Map<String, Object> param){
		System.out.println("[SearchDAOImpl - getFestAjaxList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<FestivalDTO> festAjaxList = dao.getFestAjaxList(param);
		
		return festAjaxList;
	};
	
	//AJAX 축제 건수
	@Override
	public int getFestAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getFestAjaxCount()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int festAjaxCount = dao.getFestAjaxCount(param);
		
		return festAjaxCount;
	};
	
	// AJAX 리뷰 갯수 + 리뷰 통계 조회
	public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds){
		System.out.println("[SearchDAOImpl - getPlaceReviewStatsByIds()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);
		
		return statsList;
	};

	/* ================================================== 
	   검색바
	   자동완성 10개 + 최근 검색어 5개 조회/ 추가
	================================================== */
	// 자동완성 10개
	@Override
	public List<String> getAutoComplete(String keyword) {
		System.out.println("[SearchDAOImpl - getAutoComplete()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<String> resultList = dao.getAutoComplete(keyword);
		
		return resultList;
	}

	//최근 검색어 5개 조회
	@Override
	public List<SearchHistoryDTO> getRecentKeywords(String login_userId) {
		System.out.println("[SearchDAOImpl - getRecentKeywords()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<SearchHistoryDTO> RecentKeywordList = dao.getRecentKeywords(login_userId);
		
		return RecentKeywordList;
	}

	//중복 된다면 최근 검색어 삭제
	@Override
	public int deleteSameKeyword(Map<String, Object> searchMap) {
		System.out.println("[SearchDAOImpl - deleteSameKeyword()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int deleteCnt = dao.deleteSameKeyword(searchMap);
		
		return deleteCnt;
	}
	
	
	//최근 검색어 추가
	@Override
	public int insertSearchHistory(Map<String, Object> searchMap) {
		System.out.println("[SearchDAOImpl - insertSearchHistory()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int insertCnt = dao.insertSearchHistory(searchMap);
		
		return insertCnt;
	}


}