package spring.ict06team1.midpj.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.SearchCriteria.SearchFilter;
import spring.ict06team1.midpj.dao.AdNoticeDAOImpl;
import spring.ict06team1.midpj.dto.NoticeDTO;

@Service
public class AdNoticeServiceImpl implements AdNoticeService {

	@Autowired
	private AdNoticeDAOImpl adNoDao;

	// 1. 공지/이벤트 목록 전체 조회, 검색/필터
	@Override
	public void getNoticeList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - getNoticeList()]");
		
		//1. 검색/수집 데이터
		SearchFilter sc = new SearchFilter();
		sc.setCategory(request.getParameter("category"));
		sc.setStatus(request.getParameter("status"));
		sc.setImportance(request.getParameter("importance"));
		sc.setKeyword(request.getParameter("keyword"));
		
		//2. Paging 데이터
		String pageNum = request.getParameter("pageNum");
		Paging paging = new Paging(pageNum);
		
		//3. map으로 데이터 전달		
		Map<String, Object> map = new HashMap<>();
		map.put("sc", sc);
		map.put("paging", paging);

		//4. 전체 개수 조회(필터 포함)
		int totalCount = adNoDao.getNoticeCount(map);
		paging.setTotalCount(totalCount);
		
		//5. 목록 조회
		List<NoticeDTO> list = adNoDao.getNoticeList(map);
		
		//6. 결과 전달
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("sc", sc);
		model.addAttribute("totalCount", totalCount);
	}
	
	// 2. 상세 조회
	@Override
	public void getNoticeDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - getNoticeDetail()]");
		
		//1. 조회수 증가
		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		adNoDao.increaseViewCount(noticeId);
		
		//2. 조회수 증가 완료 후 상세 정보 조회
		NoticeDTO dto = adNoDao.getNoticeDetail(noticeId);
		
		//3. view로 전달
		model.addAttribute("dto", dto);
	}

	// 3. 글 등록 처리
	@Override
	public void insertNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - insertNotice()]");
		
		MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) request;
		
		NoticeDTO dto = new NoticeDTO();
		String userId = (String)request.getSession().getAttribute("sessionID");
		
		System.out.println("디버깅-관리자 세션ID: " + userId);
		dto.setAdmin_id(userId);
		dto.setCategory(mpr.getParameter("category"));
		dto.setTitle(mpr.getParameter("title"));
		dto.setContent(mpr.getParameter("content"));
		dto.setIs_top(mpr.getParameter("isTop") != null ? "Y" : "N");
		
		MultipartFile file = mpr.getFile("uploadFile");
		if(file != null && !file.isEmpty()) {
			String savedPath = fileSaveService(file, request);
			dto.setImage_url(savedPath);
		}
		else {
			dto.setImage_url("");
		}
		
		int result = adNoDao.insertNotice(dto);
		
		if(result > 0) {
			model.addAttribute("msg", "등록 성공");
		}
	}
	
	//파일 저장용 메서드
	private String fileSaveService(MultipartFile file, HttpServletRequest request) {
		//파일 없으면 NULL 반환
		if(file == null || file.isEmpty())
			return null;

		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/upload/");

		String originalFileName = file.getOriginalFilename();
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
		String savedFileName = java.util.UUID.randomUUID().toString() + extension;

		//프로젝트 내 저장 경로 지정
		java.io.File folder = new java.io.File(uploadPath);
		if(!folder.exists())
			folder.mkdirs();
		
		//파일 이름 중복 방지
		java.io.File target = new java.io.File(uploadPath, savedFileName);
		try {
			file.transferTo(target);
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	
		//DB에 들어갈 파일명
		return savedFileName;
	}
	

	// 4. 수정 처리
	@Override
	public void updateNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - updateNotice()]");
		
	}

	// 5. 삭제 처리
	@Override
	public void deleteNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - deleteNotice()]");
		
	}

	// 6. 이미지 업로드
	@Override
	public void uploadImage(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - uploadImage()]");
		
		MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) request;
		
		//1. 파일 데이터 가져오기
		MultipartFile file = mpr.getFile("uploadFile");
		
		if(file != null && !file.isEmpty()) {
			String fileName = file.getOriginalFilename();
			//2. 저장 경로 설정
			String uploadPath = request.getSession().getServletContext().getRealPath("/resources/upload/");
			File target = new File(uploadPath, fileName);
			
			try {
				//3. 파일 저장
				file.transferTo(target);
				model.addAttribute("fileName", fileName);
				model.addAttribute("msg", "파일 업로드 성공");
			} catch(Exception e) {
				e.printStackTrace();
				model.addAttribute("msg", "파일 업로드 실패");
			}
		}
	}

}
