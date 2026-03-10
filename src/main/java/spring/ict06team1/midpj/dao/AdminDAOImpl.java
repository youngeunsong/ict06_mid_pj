package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
@Repository
public class AdminDAOImpl implements AdminDAO {

	@Autowired
	private SqlSession sqlSession;
	
	//----------------------------------------------------------------
	//장소 갯수 구하기
	@Override
	public int placeCnt() {	
		System.out.println("[AdminDAOImpl - placeCnt()]");
		int total = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.placeCnt");
		return total;
	}
	
	@Override
	public int placeCntArea(String areacode) {
		System.out.println("[AdminDAOImpl - placeCntArea()]");
		int total = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.placeCntArea",areacode);
		return total;
	}
	
	//맛집 목록
	//게시글 목록
	@Override 
	public List<PlaceDTO> placeList(Map<String,Object> map) {
		System.out.println("[AdminDAOImpl - placeList()]");
		List list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdminDAO.placeList",map);
		return list;
	}
	
	@Override 
	public List<PlaceDTO>getRestaurantArea(Map<String,Object> map) {
		System.out.println("[AdminDAOImpl - getRestaurantArea()]");
		List list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantArea",map);
		return list;
	}
	
	@Override 
	public int getPlaceInsert(PlaceDTO pdto) {
		System.out.println("[AdminDAOImpl - getPlaceInsert()]");
		int insertCntP = sqlSession.insert("spring.ict06team1.midpj.dao.AdminDAO.getPlaceInsert",pdto);
		return insertCntP;
	}
	
	@Override 
	public int getRestaurantInsert(RestaurantDTO rdto) {
		System.out.println("[AdminDAOImpl - getRestaurantInsert()]");
		int insertCntR = sqlSession.insert("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantInsert",rdto);
		return insertCntR;
	}
	
	@Override
	public int testInsertRes(RestaurantDTO rdto) {
		System.out.println("[AdminDAOImpl - testInsertRes()]");
		int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdminDAO.testInsertRes",rdto);
		return insertCnt;
	}
	
	@Override
	public int testInsertPlace(PlaceDTO pdto) {
		int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdminDAO.testInsertPlace",pdto);
		return insertCnt;
	}
	
	@Override
	public int checkDuplicate(String test_id) {
		return sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.checkDuplicate", test_id);
    }

	@Override
	public RestaurantDTO getRestaurantDetail(int place_id) {
		RestaurantDTO rdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantDetail", place_id);
		return rdto;
	}

	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		PlaceDTO pdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.getPlaceDetail", place_id);
		return pdto;
	}

	@Override
	public int getRestaurantUpdateAction(RestaurantDTO rDto) {
		int updateCntR = sqlSession.update("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantUpdateAction", rDto);
		return updateCntR;
	}

	@Override
	public int getPlaceUpdateAction(PlaceDTO pDto) {
		int updateCntP = sqlSession.update("spring.ict06team1.midpj.dao.AdminDAO.getPlaceUpdateAction", pDto);
		return updateCntP;
	}
}
