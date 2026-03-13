package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.SearchHistoryDTO;

@Repository
public class SearchDAOImpl implements SearchDAO {

	@Autowired
	private SqlSession sqlSession;

	// [검색 결과] -----------------------------------------------------------
	// 1. 검색어 기준 장소 목록
	@Override
	public List<PlaceDTO> getSearchList(String keyword) {
		System.out.println("[SearchDAOImpl - getSearchList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getSearchList(keyword);
	}

	// 2. 검색어 기준 축제 목록
	@Override
	public List<FestivalDTO> getFestList(String keyword) {
		System.out.println("[SearchDAOImpl - getFestList()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getFestList(keyword);
	}

	// 3. 검색어 기준 장소별 리뷰 통계
	@Override
	public List<Map<String, Object>> getPlaceReviewStats(String keyword) {
		System.out.println("[SearchDAOImpl - getPlaceReviewStats()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getPlaceReviewStats(keyword);
	}

	// [즐겨찾기] -----------------------------------------------------------
	// 1. 즐겨찾기 여부 확인
	@Override
	public int checkFavorite(Map<String, Object> checkFavorite) {
		System.out.println("[SearchDAOImpl - checkFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.checkFavorite(checkFavorite);
	}

	// 2. 즐겨찾기 추가
	@Override
	public int addFavorite(Map<String, Object> addFavorite) {
		System.out.println("[SearchDAOImpl - addFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.addFavorite(addFavorite);
	}

	// 3. 즐겨찾기 삭제
	@Override
	public int deleteFavorite(Map<String, Object> deleteFavorite) {
		System.out.println("[SearchDAOImpl - deleteFavorite()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.deleteFavorite(deleteFavorite);
	}

	// 4. 즐겨찾기 한 정보 끌고오기
	@Override
	public List<Integer> getFavoritePlaceIds(String user_id) {
		System.out.println("[SearchDAOImpl - getFavoritePlaceIds()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getFavoritePlaceIds(user_id);
	}

	// [AJAX] -----------------------------------------------------------
	// 1. AJAX 카드 목록
	@Override
	public List<PlaceDTO> getSearchAjax(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getSearchAjax()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getSearchAjax(param);
	}

	// 2. AJAX 전체 건수
	@Override
	public int getSearchAjaxCount(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getSearchAjaxCount()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getSearchAjaxCount(param);
	}

	// 3. AJAX 목록 대상 장소들의 리뷰 통계
	@Override
	public List<Map<String, Object>> getSearchAjaxReviewStats(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getSearchAjaxReviewStats()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		return dao.getSearchAjaxReviewStats(param);
	}

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