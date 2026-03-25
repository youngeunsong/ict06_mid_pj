package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import spring.ict06team1.midpj.dao.SupportDAO;
import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

@Service
public class SupportServiceImpl implements SupportService {

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
        // ID 파라미터 추출
        int faq_id = Integer.parseInt(request.getParameter("faq_id"));
        
        // 1. 조회수 증가
        supportDAO.updateFaqViewCount(faq_id);
        
        // 2. 상세 데이터 가져오기
        FaqDTO dto = supportDAO.getFaqDetail(faq_id);
        
        model.addAttribute("faqDetail", dto);
    }


    // ===========================================================
    // INQUIRY (1:1 문의) 관련 서비스
    // ===========================================================
    
    // 5. 1:1 문의 신규 등록 처리
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
    
    @Override
    public int inquiryInsert(InquiryDTO dto) {
        // 이미 서비스 안에 주입된 supportDAO를 사용해서 DB에 넣고 결과(1 or 0)를 리턴
        return supportDAO.insertInquiry(dto);
    }

    // 6. 나의 1:1 문의 내역 리스트 조회
    @Override
    public void getMyInquiryList(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        String user_id = request.getParameter("user_id");
        List<InquiryDTO> list = supportDAO.getMyInquiryList(user_id);
        model.addAttribute("myInquiryList", list);
    }

    // 7. 페이징 처리를 위한 전체 문의글 개수 조회 (관리자/사용자 공통)
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