package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.PlaceDTO;

@Repository
public class SearchDAOImpl implements SearchDAO{

	@Autowired
	private SqlSession sqlSession;
	
	private static final String namespace = "spring.ict06team1.midpj.dao.SearchDAO.";

	@Override
	public List<PlaceDTO> getSearchList(Map<String, Object> map) {
		
		return sqlSession.selectList(namespace + ".getSearchList", map);
	}
}
