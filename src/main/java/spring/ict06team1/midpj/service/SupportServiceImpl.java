package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.controller.SupportController;
import spring.ict06team1.midpj.dao.SupportDAO;
import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

@Service
public class SupportServiceImpl implements SupportService {

	private static final Logger logger = LoggerFactory.getLogger(SupportServiceImpl.class);
	
    @Autowired
    private SupportDAO supportDAO;
    
    // ===========================================================
    // FAQ (자주 묻는 질문) 관련 서비스
    // ===========================================================
    
    // 1. 카테고리 클릭 시 해당 카테고리 Top 5 로드
    @Override
    public List<FaqDTO> getFaqTop5ByCtg(String category) {
        // 빈 문자열("") 대신 null을 보내서 매퍼의 if문을 아예 안 타게 만든다!
        if(category == null || category.trim().isEmpty() || category.equals("전체")) {
            category = null; 
        }
        return supportDAO.getFaqTop5ByCtg(category);
    }

    // 2. 메인에서 보여줄 전체 인기 FAQ
    @Override
    public List<FaqDTO> getFaqTop10Global() {
        // 1. DAO에서 데이터 가저오기
        List<FaqDTO> list = supportDAO.getFaqTop10Global();
        
        // 2. 모델에 담지 말고 리턴
        return list; 
    }

    // 3. FAQ 키워드 검색 리스트 조회
    @Override
    public void searchFaqList(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<FaqDTO> list = supportDAO.searchFaqList(keyword);
        
        model.addAttribute("searchResult", list);
        model.addAttribute("keyword", keyword); // 검색창에 입력한 단어 유지용
    }
	
    // 4. 상세 보기 시 '조회수 증가 -> 데이터 조회' 흐름
    @Transactional
    @Override
    public void getFaqDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
    	// 1. 파라미터 받기 (faq_id)
        String strId = request.getParameter("faq_id");
        
        // 로그로 현재 넘어온 값 확인 (디버깅용)
        logger.info("상세조회 전달받은 ID 문자열: [" + strId + "]");

        int faq_id = 0;

        // 2. [핵심] NumberFormatException 방지 로직
        if (strId != null && !strId.trim().isEmpty()) {
            try {
                faq_id = Integer.parseInt(strId);
            } catch (NumberFormatException e) {
                logger.error("faq_id 변환 실패 (숫자가 아님): " + strId);
                // 숫자가 아닐 경우 리스트로 돌려보내거나 예외 처리
                return; 
            }
        } else {
            // faq_id가 null이거나 빈 문자열인 경우 (현재 에러 발생 지점)
            logger.warn("faq_id가 넘어오지 않았습니다. 상세 조회를 중단합니다.");
            return;
        }

        // 3. 조회수 증가 (상세 보기 시 필수)
        int updateCnt = supportDAO.updateFaqViewCount(faq_id);
        if(updateCnt > 0) {
            logger.info("조회수 증가 성공 - ID: " + faq_id);
        }

        // 4. 게시글 상세 데이터 가져오기
        FaqDTO dto = supportDAO.getFaqDetail(faq_id);

        // 5. 결과 데이터 전달
        if (dto != null) {
            model.addAttribute("faqDetail", dto);
            logger.info("상세 데이터 조회 성공: " + dto.getQuestion());
        } else {
            logger.warn("해당 ID의 게시글이 존재하지 않습니다: " + faq_id);
        }
    } 
    // 5. FAQ 전체 목록 또는 카테고리별 목록 조회
    @Override
    public void getFaqList(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        
        // 1. 카테고리 파라미터 받기 (사이드바 클릭 시 넘어옴)
        String category = request.getParameter("category");
        logger.info("조회 요청 카테고리: " + category);
        
        List<FaqDTO> list = null;
        
        // 2. 로직 분기: 카테고리가 없거나 '전체'면 전체 조회, 있으면 카테고리 조회
        if (category == null || category.trim().isEmpty() || category.equals("전체")) {
            list = supportDAO.getFaqList(); // 전체 리스트 조회 
        } else {
            list = supportDAO.getFaqListByCategory(category); // 카테고리별 조회 
        }
        
        // 3. 결과를 Model에 담아서 JSP로 전달
        model.addAttribute("faqList", list);
        logger.info("조회된 FAQ 개수: " + (list != null ? list.size() : 0));
    }
    // ===========================================================
    // INQUIRY (1:1 문의) 관련 서비스
    // ===========================================================
    
    // 6. 1:1 문의 신규 등록 처리
    @Override
    public void inquiryInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        InquiryDTO dto = new InquiryDTO();
        dto.setUser_id(request.getParameter("user_id"));
        dto.setCategory(request.getParameter("category"));
        dto.setTitle(request.getParameter("title"));
        dto.setContent(request.getParameter("content"));

        int result = supportDAO.insertInquiry(dto);
        model.addAttribute("result", result);
    }
    // 7. 1:1 문의 신규 등록 처리
    @Override
    public int inquiryInsert(InquiryDTO dto) {
        // 이미 서비스 안에 주입된 supportDAO를 사용해서 DB에 넣고 결과(1 or 0)를 리턴
        return supportDAO.insertInquiry(dto);
    }

    // 8. 페이징 처리를 위한 전체 문의글 개수 조회 (관리자/사용자 공통)
    @Override
    public void getInquiryCount(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
    	String user_id = request.getParameter("user_id");
        Map<String, Object> map = new HashMap<>();
        map.put("user_id", user_id); // 사용자의 아이디를 맵에 담음
    	
    	// 검색/필터가 필요할 경우를 대비해 기본 호출
        int total = supportDAO.getInquiryCount(map); 
        model.addAttribute("totalCount", total);
    }

}