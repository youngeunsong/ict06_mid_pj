package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdSupportDAO;

@Service
public class AdSupportServiceImpl implements AdSupportService {
	
	@Autowired
	private AdSupportDAO adsupportDAO;

	// ===== [1:1 문의 관리] =====
	
	// 1. 전체 사용자 문의 목록 조회 (답변 여부 상태 포함)
	// 내부적으로 DAO의 getInquiryCount와 selectInquiryList를 모두 호출합니다.
	@Override
	public void selectInquiryList(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

	// 2. 문의 상세 내용 조회 (답변 작성을 위해 데이터 로드)
	@Override
	public void inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

	// 3. 1:1 문의 답변 등록 및 상태 업데이트 (알람 로직 포함 예정)
	@Override
	public void updateInquiryAnswer(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}
	
	// ===== [FAQ 관리] =====

	// 4. FAQ 관리 목록 조회 (수정/삭제 버튼이 포함된 리스트)
	@Override
	public void getFaqList(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

	// 5. 신규 FAQ 항목 등록 처리 (Action)
	@Override
	public void insertFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

	// 6. 기존 FAQ 항목 수정 처리 (Action)
	@Override
	public void updateFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

	// 7. FAQ 항목 삭제 처리 (Action)
	@Override
	public void deleteFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		// TODO Auto-generated method stub
		
	}

}
