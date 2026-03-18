package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdSupportDAO;
import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

@Service
public class AdSupportServiceImpl implements AdSupportService {
	
	@Autowired
	private AdSupportDAO adsupportdao;

	// ===== [1:1 문의 관리] =====
	
	// 1. 전체 사용자 문의 목록 조회 (답변 여부 상태 포함)
	// DAO의 getInquiryCount와 selectInquiryList를 모두 호출
	@Override
	public void selectInquiryList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdSupportServiceImpl - selectInquiryList()");
		
		// 1. 페이지 번호 파악: 사용자가 몇 페이지를 눌렀는지 가져옴 (처음 들어오면 null이라서 "1"로 설정)
		String pageNum = request.getParameter("pageNum");
        if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
	    
	    String category = request.getParameter("category");
	    String status = request.getParameter("status");
	    String keyword = request.getParameter("keyword");
	    
	    // 2. 계산 준비: 현재 페이지를 숫자로 바꾸고, 한 페이지에 몇 개씩 보여줄지 설정
	    int currentPage = Integer.parseInt(pageNum);
	    int pageSize = 10;
	    int pageBlock = 10;

	    // 3. DB 조회를 위한 Map 생성 및 값 세팅
	    Map<String, Object> map = new HashMap<>();
	    // 값이 "전체"이거나 null이면 MyBatis에서 걸러지도록 null 처리
	    map.put("category", (category != null && !category.isEmpty()) ? category : null);
	    map.put("status", (status != null && !status.isEmpty()) ? status : null);
	    map.put("keyword", (keyword != null && !keyword.isEmpty()) ? keyword : null);

	    // 5. 총 글 개수 조회: 필터링된 조건에 맞는 글이 총 몇 개인지 DB에서 알아옴
	    int totalCount = adsupportdao.getInquiryCount(map);

	    // 6. 페이징 계산(예: 1페이지는 1~10번글, 2페이지는 11~20번글)
	    int startRow = (currentPage - 1) * pageSize + 1;
	    int endRow = currentPage * pageSize;
	    
	    // 7. 하단 페이징 버튼 계산: 총 페이지 수, 시작 버튼 번호, 끝 버튼 번호
	    int pageCount = (totalCount / pageSize) + (totalCount % pageSize == 0 ? 0 : 1);
	    int startPage = (int)((currentPage - 1) / pageBlock) * pageBlock + 1;
	    int endPage = startPage + pageBlock - 1;
	    if (endPage > pageCount) endPage = pageCount;

	    // 8. 범위 데이터를 map에 추가해서 실제 리스트 조회
	    map.put("startRow", startRow);
	    map.put("endRow", endRow);

	    List<InquiryDTO> list = adsupportdao.selectInquiryList(map);

	    // 9. JSP에 전달할 페이징 정보 정리: pagination.jsp에서 사용
	    Map<String, Object> paging = new HashMap<>();
	    paging.put("totalCount", totalCount);
	    paging.put("currentPage", currentPage);
	    paging.put("startPage", startPage);
	    paging.put("endPage", endPage);
	    paging.put("pageCount", pageCount);
	    paging.put("pageBlock", pageBlock);
	    paging.put("prev", startPage - pageBlock);
	    paging.put("next", startPage + pageBlock);
	    
	    // 페이징 클릭 시에도 필터가 유지되게 paging 맵에도 넣어줌
	    paging.put("category", category);
	    paging.put("status", status);
	    paging.put("keyword", keyword);

	    // 7. Model에 담기
	    model.addAttribute("list", list);	// 실제 게시글 리스트
	    model.addAttribute("paging", paging);	// 페이징 버튼 정보
	    model.addAttribute("totalCount", totalCount);
	    
	    // JSP 상단 필터 버튼들의 'active' 클래스 제어용
	    model.addAttribute("category", category == null ? "" : category);
	    model.addAttribute("status", status == null ? "" : status);
	    model.addAttribute("keyword", keyword == null ? "" : keyword);
	}
	
	// 2. 문의 상세 내용 조회 (답변 작성을 위해 데이터 로드)
	@Override
    public void inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
        System.out.println("AdSupportServiceImpl - inquiryDetail()");
     
        String strId = request.getParameter("inquiry_id");
        
        // 로그로 확인 (디버깅용)
        System.out.println("넘어온 inquiry_id 문자열: " + strId);

        int inquiry_id = 0;
        
        // 값이 존재할 때만 숫자로 변환 (null 체크)
        if (strId != null && !strId.isEmpty()) {
            inquiry_id = Integer.parseInt(strId);
            
            // 데이터 조회 및 모델 담기
            InquiryDTO dto = adsupportdao.inquiryDetail(inquiry_id);
            model.addAttribute("dto", dto);
        } else {
            // 값이 없을 경우 에러 방지를 위해 처리 (로그만 찍거나 리스트로 리다이렉트 등)
            System.out.println("경고: inquiry_id가 null이거나 비어있습니다.");
        }
    }
	// 3. 1:1 문의 답변 등록 및 상태 업데이트 (알람 로직 포함 예정)
	@Override
	public void updateInquiryAnswer(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdSupportServiceImpl - updateInquiryAnswer()");
	    // 1. 답변 등록 버튼 클릭 시 호출 화면에서 넘어옴 (status 추가!)
	    String strId = request.getParameter("inquiry_id"); 
	    String admin_reply = request.getParameter("admin_reply");
	    String status = request.getParameter("status"); // <-- [추가] JS에서 보낸 'PROGRESS' 또는 'ANSWERED' 받기
	    
	    int updateCnt = 0;

	    try {
	        // 2. 유효성 검사
	        if (strId != null && !strId.isEmpty()) {
	            
	            int inquiry_id = Integer.parseInt(strId); 
	            
	            InquiryDTO dto = new InquiryDTO();
	            dto.setInquiry_id(inquiry_id);
	            dto.setAdmin_reply(admin_reply);
	            
	            // 3. 상태값 동적 할당
	            // JS에서 넘어온 값이 있으면 그 값을 쓰고, 없으면 기본값으로 ANSWERED 설정
	            if (status != null && !status.isEmpty()) {
	                dto.setStatus(status); 
	            } else {
	                dto.setStatus("ANSWERED"); 
	            }

	            // 4. DAO 호출 (Mapper의 UPDATE 문에 status도 업데이트 되도록 되어있어야 함)
	            updateCnt = adsupportdao.updateInquiryAnswer(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    // 결과값을 모델에 담음 (컨트롤러에서 이 값을 보고 success 여부를 판단할 수 있음)
	    model.addAttribute("updateCnt", updateCnt);
	}
	
	// ===== [FAQ 관리] =====
	// 4. FAQ 목록 조회 
	@Override
	public void getFaqList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdSupportServiceImpl - getFaqList()");
		// 1. 서비스 안에서 직접 파라미터 꺼내기
	    String category = request.getParameter("category");
	    String visible = request.getParameter("visible");
	    String keyword = request.getParameter("keyword");
	    System.out.println("검색 카테고리: [" + category + "]");
	    // 2. DAO에 던질 Map 생성
	    Map<String, Object> map = new HashMap<>();
	    map.put("category", category);
	    map.put("visible", visible);
	    map.put("keyword", keyword);

	    // 3. DAO 호출 (검색 조건이 담긴 map 전달)
	    List<FaqDTO> list = adsupportdao.getFaqList(map);

	    // 4. 결과 전달
	    model.addAttribute("list", list);
	    
	    // 검색어 유지를 위해 다시 담아주기
	    model.addAttribute("category", category);
	    model.addAttribute("visible", visible);
	    model.addAttribute("keyword", keyword);
	}

	// 5. 신규 FAQ 항목 등록 처리 (Action)
	@Override
	public void insertFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdSupportServiceImpl - insertFaqAction()");
	    
	    // 1. DTO 객체 생성
	    FaqDTO dto = new FaqDTO();

	    // 2. 관리자 아이디 처리 
	    // 세션에서 로그인한 아이디를 가져오되, 없으면 DB에 존재하는 'admin1'을 기본값으로 사용
	    String sessionAdminId = (String)request.getSession().getAttribute("admin_id");
	    String finalAdminId = (sessionAdminId != null && !sessionAdminId.isEmpty()) ? sessionAdminId : "admin1";
	    dto.setAdmin_id(finalAdminId);
	    
	    // 3. JSP의 <input name="..."> 값들과 1:1 매칭해서 데이터 추출
	    String category = request.getParameter("category");
	    String question = request.getParameter("question");
	    String answer = request.getParameter("answer");
	    String visible = request.getParameter("visible");   // JSP name="visible"
	    String orderStr = request.getParameter("order_no"); // JSP name="order_no"

	    // 4. 데이터 정제 및 DTO 세팅
	    dto.setCategory(category);
	    dto.setQuestion(question);
	    dto.setAnswer(answer);
	    
	    // 노출 상태 기본값 처리 (Y/N)
	    dto.setVisible(visible != null ? visible : "Y");

	    // 정렬 순서 숫자 변환 및 방어 코드
	    int orderNo = 1;
	    if (orderStr != null && !orderStr.isEmpty()) {
	        try {
	            orderNo = Integer.parseInt(orderStr);
	        } catch(NumberFormatException e) {
	            System.out.println("숫자 변환 오류 - 기본값 1 설정");
	            orderNo = 1;
	        }
	    }
	    dto.setOrder_no(orderNo);

	    // 5. DAO 호출하여 DB에 Insert
	    int result = 0;
	    try {
	        result = adsupportdao.insertFaq(dto);
	        System.out.println("DB Insert 결과: " + result + "건 성공");
	    } catch (Exception e) {
	        System.out.println("DAO 호출 중 에러 발생!");
	        e.printStackTrace();
	    }
	    
	    // 6. 결과값을 컨트롤러에서 쓸 수 있게 모델에 담기
	    model.addAttribute("insertCnt", result);
	}
	
	// 6. FAQ 수정 페이지로 이동 (기존 데이터 조회)
	@Override
	public void getFaqDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdSupportServiceImpl - getFaqDetail()");

	    // 1. JSP(목록)에서 보낸 수정할 글의 번호(faq_id)를 가져옵니다.
	    String strId = request.getParameter("faq_id");
	    
	    if (strId != null && !strId.isEmpty()) {
	        try {
	            int faq_id = Integer.parseInt(strId);
	            
	            // 2. DAO를 호출하여 DB에서 해당 ID의 데이터 한 건을 가져옵니다.
	            FaqDTO dto = adsupportdao.getFaqDetail(faq_id);
	            
	            // 3. 가져온 데이터를 Model에 담습니다. 
	            // jsp에서 ${dto.question} 사용!
	            model.addAttribute("dto", dto);
	            
	            System.out.println("조회된 FAQ ID: " + faq_id + ", 제목: " + dto.getQuestion());
	            
	        } catch (NumberFormatException e) {
	            System.out.println("FAQ ID 숫자 변환 오류!");
	            e.printStackTrace();
	        }
	    } else {
	        System.out.println("수정할 FAQ ID가 넘어오지 않았습니다.");
	    }
	}
	
	// 7. 기존 FAQ 항목 수정 처리 (Action)
	@Override
	public void updateFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		 System.out.println("AdSupportServiceImpl - updateFaqAction()");
		// 수정 페이지에서 "수정 완료" 눌렀을 때 작동
	    
	    String strId = request.getParameter("faq_id");
	    
	    // 1. ID가 정상적으로 넘어왔을 때만 수정 로직을 실행
	    if (strId != null && !strId.isEmpty()) {
	        FaqDTO dto = new FaqDTO();
	        
	        // 가져온 ID를 숫자로 변환하여 DTO에 세팅 (어떤 글을 고칠지 지정)
	        dto.setFaq_id(Integer.parseInt(strId)); 
	        
	        // 사용자가 수정한 제목, 내용, 카테고리, 노출여부를 가져와 dto에 담아
	        dto.setQuestion(request.getParameter("question"));
	        dto.setAnswer(request.getParameter("answer"));
	        dto.setCategory(request.getParameter("category"));
	        dto.setVisible(request.getParameter("visible"));
	        
	        // --- 순서번호 처리 ---
	        String orderStr = request.getParameter("order_no");
	        int orderNo;
	        
	        if (orderStr != null && !orderStr.isEmpty()) {
	            // 사용자가 순서 숫자를 입력했다면 숫자로 변환!
	            orderNo = Integer.parseInt(orderStr);
	        } else {
	            // 사용자가 입력을 안 했다면 기본값 0으로 설정!
	            orderNo = 0;
	        }
	        dto.setOrder_no(orderNo);
	        // ---------------------------------------
	        
	        // 2. DAO를 호출하여 DB 업데이트 실행
	        int updateCnt = adsupportdao.updateFaq(dto);
	        
	        // 3. 업데이트 성공 여부 모델에 담아 Action JSP로 보냅니다.
	        model.addAttribute("updateCnt", updateCnt);
	    }
	}
	// 8. FAQ 항목 삭제 처리 (Action)
	@Override
    public void deleteFaqAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		 System.out.println("AdSupportServiceImpl - deleteFaqAction()");
		// 삭제 버튼 눌렀을 때 작동
        String strId = request.getParameter("faq_id");
        int deleteCnt = 0;
        if (strId != null && !strId.isEmpty()) {
            // 글 번호로 DB에서 해당 데이터 삭제
            deleteCnt = adsupportdao.deleteFaq(Integer.parseInt(strId));
        }
        model.addAttribute("deleteCnt", deleteCnt);
    }

	

}
