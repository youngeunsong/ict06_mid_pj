package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Repository
public class AdAccommodationDAOImpl implements AdAccommodationDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	// 장소 총 갯수 구하기
    // 페이징 처리 및 검색 결과의 총 레코드 수를 계산할 때 사용
	@Override
	public int placeCnt(Map<String, Object> map) {
		System.out.println("[AdAccommodationDAOImpl - placeCnt()]");
        int total = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdAccommodationDAO.placeCnt",map);
        return total;
	}
	
	// 숙소 목록 조회
    // 숙소와 관련된 정보를 Map 리스트 형태로 반환 (여러 테이블 JOIN 시 유용)
	@Override
	public List<Map<String, Object>> placeList(Map<String, Object> map) {
		System.out.println("[AdAccommodationDAOImpl - placeList()]");
        // selectList의 결과를 Map 리스트로 받습니다. (페이징 처리를 위한 start, end 값 등이 map에 포함됨)
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdAccommodationDAO.placeList", map);
        return list;
	}
	
	// 숙소 정보 검색 (검색어가 숫자형인 경우)
    // 예: ID로 검색할 때 호출
	@Override
	public List<Map<String, Object>> getAccommodationSearchInt(Map<String, Object> map) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationSearchInt()]");
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationSearchInt",map);
        return list;
    }
	
	// 숙소 정보 검색 (검색어가 문자열인 경우)
    // 예: 숙소 이름으로 검색할 때 호출
	@Override
	public List<Map<String, Object>> getAccommodationSearchString(Map<String, Object> map) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationSearchString()]");
        List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationSearchString",map);
        return list;
    }
	
	// 숙소(기본 정보) 등록
    // 관리자가 수동으로 새로운 숙소를 등록할 때 PLACE 테이블에 insert
	@Override
	public int getPlaceInsert(PlaceDTO pDto) {
		System.out.println("[AdAccommodationDAOImpl - getPlaceInsert()]");
        int insertCntP = sqlSession.insert("spring.ict06team1.midpj.dao.AdAccommodationDAO.getPlaceInsert",pDto);
        return insertCntP;
    }
	
	// 숙소(기본 정보) 등록
    // 관리자가 수동으로 새로운 장소를 등록할 때 ACCOMMODATION 테이블에 insert
	@Override
	public int getAccommodationInsert(AccommodationDTO aDto) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationInsert()]");
        int insertCntR = sqlSession.insert("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationInsert",aDto);
        return insertCntR;
    }
	
	// 숙소 상세 정보 조회
    // 수정을 위해 PLACE 테이블의 데이터를 PlaceDTO 객체로 가져옵니다.
	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		System.out.println("[AdAccommodationDAOImpl - getPlaceDetail()]");
        PlaceDTO pDto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdAccommodationDAO.getPlaceDetail", place_id);
        return pDto;
    }

	// 숙소 상세 정보 조회
    // 수정을 위해 ACCOMMODATION 테이블의 데이터를 AccommodationDTO 객체로 가져옵니다.
	@Override
	public AccommodationDTO getAccommodationDetail(int place_id) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationDetail()]");
        AccommodationDTO aDto = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationDetail", place_id);
        return aDto;
	}
	// 숙소 기본 정보 수정 처리
    // 화면에서 수정한 숙소 정보(이름, 주소, 이미지 등)를 DB에 업데이트
	@Override
	public int getPlaceUpdateAction(PlaceDTO pDto) {
		System.out.println("[AdAccommodationDAOImpl - getPlaceUpdateAction()]");
        int updateCntP = sqlSession.update("spring.ict06team1.midpj.dao.AdAccommodationDAO.getPlaceUpdateAction", pDto);
        return updateCntP;
    }

	// 숙소 정보 수정 처리
    // 화면에서 수정한 숙소 상세 내용(전화번호, 가격등)을 DB에 업데이트
	@Override
	public int getAccommodationUpdateAction(AccommodationDTO aDto) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationUpdateAction()]");
        int updateCntR = sqlSession.update("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationUpdateAction", aDto);
        return updateCntR;
    }
	
	// 숙소 정보 삭제
    // 특정 장소 ID를 기준으로 정보를 삭제
	@Override
	public int getAccommodationDeleteAction(int place_id) {
		System.out.println("[AdAccommodationDAOImpl - getAccommodationDeleteAction()]");
        int deleteCnt = sqlSession.delete("spring.ict06team1.midpj.dao.AdAccommodationDAO.getAccommodationDeleteAction", place_id);
        return deleteCnt;
    }
	
	// API 수집 데이터 전용 장소 삽입
    // 공공데이터 API 수집 로직에서 PLACE 테이블에 저장할 때 사용
	@Override
	public int insertPlace(PlaceDTO pDto) {
		System.out.println("[AdAccommodationDAOImpl - insertPlace()]");
        int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdAccommodationDAO.insertPlace",pDto);
        return insertCnt;
    }
	
	// 공공데이터 API 수집 로직에서 ACCOMMODATION 테이블에 저장할 때 사용
	@Override
	public int insertAcc(AccommodationDTO aDto) {
		System.out.println("[AdAccommodationDAOImpl - insertAcc()]");
        int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdAccommodationDAO.insertAcc",aDto);
        return insertCnt;
	}
	
	// 중복 데이터 체크
	@Override
	public int checkDuplicate(String place_id) {
		System.out.println("[AdminDAOImpl - checkDuplicate()]");
        int checkCount = sqlSession.selectOne("spring.ict06team1.midpj.dao.AdAccommodationDAO.checkDuplicate", place_id);
		return checkCount;
	}
	
	// 다수 이미지 저장하기
	@Override
	public int insertImageStore(Map<String, Object> imgMap) {
		System.out.println("[AdminDAOImpl - insertImageStore()]");
		int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.AdAccommodationDAO.insertImageStore", imgMap);
		return insertCnt;
	}
}