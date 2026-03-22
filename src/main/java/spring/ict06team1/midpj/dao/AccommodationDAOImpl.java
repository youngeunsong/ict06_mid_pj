package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import spring.ict06team1.midpj.dto.AccommodationDTO;

@Repository
public class AccommodationDAOImpl implements AccommodationDAO {
	
	@Autowired
    private SqlSession session;
	
	private static final String NAMESPACE = "PlaceMapper.";
	
	// 주변 숙소의 총 개수를 조회 (페이징 계산용)
	@Override
	public int selectNearbyAccommodationCount(Map<String, Object> map) {
		int totalCount = session.selectOne("PlaceMapper.selectNearbyAccommodationCount", map);
    	return totalCount;
	}
	
	// 조건에 맞는 숙소 리스트 조회 (6개씩 끊어서 가져오기)
	@Override
	public List<AccommodationDTO> selectNearbyAccommodationList(Map<String, Object> map) {
		List list = session.selectList("PlaceMapper.selectNearbyAccommodationList", map);
        return list;
	}
	
	// 조건에 맞는 숙소 마커 불러오기 (전부 가져오기)
	@Override
	public List<AccommodationDTO> selectNearbyMarkersAjaxAcc(Map<String, Object> map) {
		List list = session.selectList("PlaceMapper.selectNearbyMarkersAjaxAcc", map);
		return list;
	}

	@Override
	public int isFavorite(Map<String, Object> map) {
		return session.selectOne(NAMESPACE + "isFavorite", map);
	}

	@Override
	public int insertFavorite(Map<String, Object> map) {
		return session.insert(NAMESPACE + "insertFavorite", map);
	}

	@Override
	public int deleteFavorite(Map<String, Object> map) {
		return session.delete(NAMESPACE + "deleteFavorite", map);
	}
}
