package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Repository
public class AdRestaurantDAOImpl implements AdRestaurantDAO {
	@Autowired
	private SqlSession sqlSession;
	
	//----------------------------------------------------------------
	// 장소 총 갯수 구하기
    // 페이징 처리 및 검색 결과의 총 레코드 수를 계산할 때 사용
    @Override
    public int placeCnt(Map<String, Object> map) {    
        System.out.println("[AdminDAOImpl - placeCnt()]");
        int total = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdRestaurantDAO.placeCnt",map);
        return total;
    }
    
    // 맛집 목록 조회
    // 맛집과 관련된 정보를 Map 리스트 형태로 반환 (여러 테이블 JOIN 시 유용)
    @Override 
    public List<Map<String, Object>> placeList(Map<String, Object> map) {
        System.out.println("[AdminDAOImpl - placeList()]");
        // selectList의 결과를 Map 리스트로 받습니다. (페이징 처리를 위한 start, end 값 등이 map에 포함됨)
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdRestaurantDAO.placeList", map);
        return list;
    }
    
    // 맛집 정보 검색 (검색어가 숫자형인 경우)
    // 예: ID로 검색할 때 호출
    @Override
    public List<Map<String, Object>> getRestaurantSearchInt(Map<String, Object> map) {
        System.out.println("[AdminDAOImpl - getRestaurantSearchInt()]");
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantSearchInt",map);
        return list;
    }
        
    // 맛집 정보 검색 (검색어가 문자열인 경우)
    // 예: 가게 이름, 주소 키워드 등으로 검색할 때 호출
    @Override
    public List<Map<String, Object>> getRestaurantSearchString(Map<String, Object> map) {
        System.out.println("[AdminDAOImpl - getRestaurantSearchString()]");
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantSearchString",map);
        return list;
    }
    
    // 장소(기본 정보) 등록
    // 관리자가 수동으로 새로운 장소를 등록할 때 PLACE 테이블에 insert
    @Override 
    public int getPlaceInsert(PlaceDTO pdto) {
        System.out.println("[AdminDAOImpl - getPlaceInsert()]");
        int insertCntP = sqlSession.insert("spring.ict06team1.midpj.dao.AdRestaurantDAO.getPlaceInsert",pdto);
        return insertCntP;
    }
    
    // 장소(기본 정보) 등록
    // 관리자가 수동으로 새로운 장소를 등록할 때 RESTAURANT 테이블에 insert 
    @Override 
    public int getRestaurantInsert(RestaurantDTO rdto) {
        System.out.println("[AdminDAOImpl - getRestaurantInsert()]");
        int insertCntR = sqlSession.insert("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantInsert",rdto);
        return insertCntR;
    }
    
    // 맛집 상세 정보 조회
    // 수정을 위해 PLACE 테이블의 데이터를 PlaceDTO 객체로 가져옵니다.
    @Override
    public PlaceDTO getPlaceDetail(int place_id) {
        System.out.println("[AdminDAOImpl - getPlaceDetail()]");
        PlaceDTO pdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdRestaurantDAO.getPlaceDetail", place_id);
        return pdto;
    }

    // 맛집 상세 정보 조회
    // 수정을 위해 RESTAURANT 테이블의 데이터를 RestaurantDTO 객체로 가져옵니다.
    @Override
    public RestaurantDTO getRestaurantDetail(int place_id) {
        System.out.println("[AdminDAOImpl - getRestaurantDetail()]");
        RestaurantDTO rdto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantDetail", place_id);
        return rdto;
    }
    
    // 장소 기본 정보 수정 처리
    // 화면에서 수정한 장소 정보(이름, 주소, 이미지 등)를 DB에 업데이트
    @Override
    public int getPlaceUpdateAction(PlaceDTO pDto) {
        System.out.println("[AdminDAOImpl - getPlaceUpdateAction()]");
        int updateCntP = sqlSession.update("spring.ict06team1.midpj.dao.AdRestaurantDAO.getPlaceUpdateAction", pDto);
        return updateCntP;
    }
    
    // 맛집 정보 수정 처리
    // 화면에서 수정한 맛집 상세 내용(전화번호, 휴무일 등)을 DB에 업데이트합니다.
    @Override
    public int getRestaurantUpdateAction(RestaurantDTO rDto) {
        System.out.println("[AdminDAOImpl - getRestaurantUpdateAction()]");
        int updateCntR = sqlSession.update("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantUpdateAction", rDto);
        return updateCntR;
    }
    
    // 맛집 정보 삭제
    // 특정 장소 ID를 기준으로 정보를 삭제
    @Override
    public int getRestaurantDeleteAction(int place_id) {
        System.out.println("[AdminDAOImpl - getRestaurantDeleteAction()]");
        int deleteCnt = sqlSession.delete("spring.ict06team1.midpj.dao.AdRestaurantDAO.getRestaurantDeleteAction", place_id);
        return deleteCnt;
    }
    
    // API 수집 데이터 전용 장소 삽입
    // 공공데이터 API 수집 로직(testRegister)에서 PLACE 테이블에 저장할 때 사용
    @Override
    public int testInsertPlace(PlaceDTO pdto) {
        System.out.println("[AdminDAOImpl - testInsertPlace()]");
        int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdRestaurantDAO.testInsertPlace",pdto);
        return insertCnt;
    }
    
    // API 수집 데이터 전용 맛집 삽입
    // 공공데이터 API 수집 로직(testRegister)에서 RESTAURANT 테이블에 저장할 때 사용
    @Override
    public int testInsertRes(RestaurantDTO rdto) {
        System.out.println("[AdminDAOImpl - testInsertRes()]");
        int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdRestaurantDAO.testInsertRes",rdto);
        return insertCnt;
    }
    
    // 중복 데이터 체크
    // 수집 시 contentId(test_id)가 이미 존재하는지 조회하여 0 또는 1 이상의 값을 반환
    @Override
    public int checkDuplicate(String test_id) {
        System.out.println("[AdminDAOImpl - checkDuplicate()]");
        return sqlSession.selectOne("spring.ict06team1.midpj.dao.AdRestaurantDAO.checkDuplicate", test_id);
    }
}