package spring.ict06team1.midpj.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.AccommodationDAO;
import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: FestivalService
 * ----------------------------------
 * v260324
 * ----------------------------------
 */
@Service
public class AccommodationServiceImpl implements AccommodationService {

	@Autowired
	private AccommodationDAO accDao;

	// 숙소 상세
	@Override
	public AccommodationDTO getAccommodationDetail(int place_id) {
		System.out.println("[AccommodationServiceImpl-getAccommodationDetail()]");
		
		accDao.increaseViewCount(place_id);
		
		PlaceDTO place = accDao.selectPlaceDetail(place_id);
		AccommodationDTO accDto = accDao.getAccommodationDetail(place_id);
		
		accDto.setPlaceDTO(place);
		return accDto;
	}

	// 리뷰 페이징
	@Override
	public List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit) {
		System.out.println("[AccommodationServiceImpl-getAccommodationDetail()]");
		return null;
	}

	// 리뷰 총 개수
	@Override
	public int getReviewCount(int place_id) {
		System.out.println("[AccommodationServiceImpl-getReviewCount()]");
		return 0;
	}

	// 즐겨찾기 여부 확인
	@Override
	public boolean isFavorite(String userId, int place_id) {
		System.out.println("[AccommodationServiceImpl-isFavorite()]");
		return false;
	}

	// 즐겨찾기 토글
	@Override
	public boolean toggleFavorite(String userId, int place_id) {
		System.out.println("[AccommodationServiceImpl-toggleFavorite()]");
		return false;
	}

	// 숙소 총 갯수
	@Override
	public int getAccommodationCount() {
		System.out.println("[AccommodationServiceImpl-getAccommodationCount()]");
		return 0;
	}

}
