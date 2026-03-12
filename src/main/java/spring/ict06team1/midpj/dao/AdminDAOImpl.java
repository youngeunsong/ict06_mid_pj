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
	public int placeCnt(Map<String, Object> map) {	
		System.out.println("[AdminDAOImpl - placeCnt()]");
		int total = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.placeCnt",map);
		return total;
	}
	
	/*
	 * @Override public int placeCntArea(String areaCode) {
	 * System.out.println("[AdminDAOImpl - placeCntArea()]"); int total =
	 * sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.placeCntArea",
	 * areaode); return total; }
	 */
	
	//맛집 목록
	@Override 
	public List<Map<String, Object>> placeList(Map<String, Object> map) {
	    System.out.println("[AdminDAOImpl - placeList()]");
	    // selectList의 결과를 Map 리스트로 받습니다.
	    List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdminDAO.placeList", map);
	    return list;
	}
	
	/*
	 * @Override public List<PlaceDTO>getRestaurantArea(Map<String,Object> map) {
	 * System.out.println("[AdminDAOImpl - getRestaurantArea()]"); List list =
	 * sqlSession.selectList(
	 * "spring.ict06team1.midpj.dao.AdminDAO.getRestaurantArea",map); return list; }
	 */
	
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
		System.out.println("[AdminDAOImpl - testInsertPlace()]");
		int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdminDAO.testInsertPlace",pdto);
		return insertCnt;
	}
	
	@Override
	public int checkDuplicate(String test_id) {
		System.out.println("[AdminDAOImpl - checkDuplicate()]");
		return sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.checkDuplicate", test_id);
    }

	@Override
	public RestaurantDTO getRestaurantDetail(int place_id) {
		System.out.println("[AdminDAOImpl - getRestaurantDetail()]");
		RestaurantDTO rdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantDetail", place_id);
		return rdto;
	}

	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		System.out.println("[AdminDAOImpl - getPlaceDetail()]");
		PlaceDTO pdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdminDAO.getPlaceDetail", place_id);
		return pdto;
	}

	@Override
	public int getRestaurantUpdateAction(RestaurantDTO rDto) {
		System.out.println("[AdminDAOImpl - getRestaurantUpdateAction()]");
		int updateCntR = sqlSession.update("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantUpdateAction", rDto);
		return updateCntR;
	}

	@Override
	public int getPlaceUpdateAction(PlaceDTO pDto) {
		System.out.println("[AdminDAOImpl - getPlaceUpdateAction()]");
		int updateCntP = sqlSession.update("spring.ict06team1.midpj.dao.AdminDAO.getPlaceUpdateAction", pDto);
		return updateCntP;
	}
	
	//맛집 정보 삭제
	@Override
	public int getRestaurantDeleteAction(int place_id) {
		System.out.println("[AdminDAOImpl - getRestaurantDeleteAction()]");
		int deleteCnt = sqlSession.delete("spring.ict06team1.midpj.dao.AdminDAO.getRestaurantDeleteAction", place_id);
		return deleteCnt;
		
	}
}
