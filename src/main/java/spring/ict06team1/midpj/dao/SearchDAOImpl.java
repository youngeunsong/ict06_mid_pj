package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Repository
public class SearchDAOImpl implements SearchDAO{

	@Autowired
	private SqlSession sqlSession;
	
	private static final String namespace = "spring.ict06team1.midpj.dao.SearchDAO.";

	//1. 맛집, 숙소, 축제 리스트 가져오기
	@Override
	public List<PlaceDTO> getSearchList(String keyword) {
		System.out.println("[SearchDAOImpl - getSearchList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<PlaceDTO> list = dao.getSearchList(keyword);
		
		return list;
	}

	//2. 축제 상세 리스트 가져오기
	@Override
	public List<FestivalDTO> getFestList(String keyword) {
		System.out.println("[SearchDAOImpl - getFestList()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<FestivalDTO> festList = dao.getFestList(keyword);
		
		return festList;
	}

	@Override
	public List<PlaceDTO> getSearchAjax(Map<String, Object> param) {
		System.out.println("[SearchDAOImpl - getSearchAjax()]");
		
		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		List<PlaceDTO> list = dao.getSearchAjax(param);
		
		return list;
	}

	@Override
	public int getSearchAjaxCount(Map<String, Object> param) {
		
		System.out.println("[SearchDAOImpl - getSearchAjaxCount()]");

		SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
		int totalCnt = dao.getSearchAjaxCount(param);
		
		return totalCnt;
	}
}
