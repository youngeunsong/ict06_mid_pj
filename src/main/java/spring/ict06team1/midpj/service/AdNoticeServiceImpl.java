package spring.ict06team1.midpj.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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

		// 1. 검색/수집 데이터
		SearchFilter sc = new SearchFilter();
		sc.setCategory(request.getParameter("category"));
		sc.setStatus(request.getParameter("status"));
		sc.setImportance(request.getParameter("importance"));
		sc.setKeyword(request.getParameter("keyword"));

		// 2. Paging 데이터
		String pageNum = request.getParameter("pageNum");
		Paging paging = new Paging(pageNum);

		// 3. map으로 데이터 전달
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sc", sc);
		map.put("paging", paging);

		// 4. 전체 개수 조회(필터 포함)
		int totalCount = adNoDao.getNoticeCount(map);
		paging.setTotalCount(totalCount);

		// 5. 목록 조회
		List<NoticeDTO> list = adNoDao.getNoticeList(map);

		// 6. 결과 전달
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("sc", sc);
		model.addAttribute("totalCount", totalCount);
	}

	// 2. 상세 조회
	@Override
	public void getNoticeDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - getNoticeDetail()]");

		// 1. 조회수 증가
		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		adNoDao.increaseViewCount(noticeId);

		// 2. 조회수 증가 완료 후 상세 정보 조회
		NoticeDTO dto = adNoDao.getNoticeDetail(noticeId);

		// 3. view로 전달
		model.addAttribute("dto", dto);
	}

	// 3. 글 등록 처리
	@Override
	public void insertNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - insertNotice()]");

		MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) request;

		NoticeDTO dto = new NoticeDTO();
		String userId = (String) request.getSession().getAttribute("sessionID");

		System.out.println("디버깅-관리자 세션ID: " + userId);
		dto.setAdmin_id(userId);
		dto.setCategory(mpr.getParameter("category"));
		dto.setTitle(mpr.getParameter("title"));
		dto.setContent(mpr.getParameter("content"));
		dto.setIs_top(mpr.getParameter("isTop") != null ? "Y" : "N");

		// 파일 여러개 가져오기
		List<MultipartFile> files = mpr.getFiles("uploadFile");
		StringBuilder sb = new StringBuilder();

		if (files != null && !files.isEmpty()) {
			for (MultipartFile file : files) {
				if (!file.isEmpty()) {
					String savedPath = fileSaveService(file, request);
					if (sb.length() > 0)
						sb.append(",");
					sb.append(savedPath);
				}
			}
		}
		dto.setImage_url(sb.toString());

		int result = adNoDao.insertNotice(dto);
		if (result > 0) {
			model.addAttribute("msg", "등록 성공");
		}
	}

	//3. 이미지 파일 저장
	private String fileSaveService(MultipartFile file, HttpServletRequest request) {
		if (file == null || file.isEmpty())
			return null;

		try {
			String uploadPath = request.getSession().getServletContext().getRealPath("/resources/upload/notice/");

			File folder = new File(uploadPath);
			if (!folder.exists())
				folder.mkdirs();

			String originalFileName = file.getOriginalFilename();
			String extension = "";
			if (originalFileName != null && originalFileName.contains(".")) {
				extension = originalFileName.substring(originalFileName.lastIndexOf("."));
			}

			String savedFileName = UUID.randomUUID().toString() + extension;
			File target = new File(uploadPath, savedFileName);
			file.transferTo(target);

			System.out.println("uploadPath = " + uploadPath);
			System.out.println("파일 저장 완료 = " + target.exists());

			return request.getContextPath() + "/resources/upload/notice/" + savedFileName;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// 4. 수정 처리
	@Override
	public void updateNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - updateNotice()]");

		MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) request;

		String[] existingFiles = mpr.getParameterValues("existingFiles");
		StringBuilder sb = new StringBuilder();

		if (existingFiles != null) {
			for (String file : existingFiles) {
				if (sb.length() > 0)
					sb.append(",");
				sb.append(file);
			}
		}

		// 새로 업로드된 파일 처리
		List<MultipartFile> newFiles = mpr.getFiles("uploadFile");
		for (MultipartFile file : newFiles) {
			if (!file.isEmpty()) {
				String savedName = fileSaveService(file, request);
				if (sb.length() > 0)
					sb.append(",");
				sb.append(savedName);
			}
		}

		NoticeDTO dto = new NoticeDTO();

		int noticeId = Integer.parseInt(mpr.getParameter("noticeId"));
		dto.setNotice_id(noticeId);

		String adminId = (String) request.getSession().getAttribute("sessionID");
		dto.setAdmin_id(adminId);

		dto.setCategory(mpr.getParameter("category"));
		dto.setTitle(mpr.getParameter("title"));
		dto.setContent(mpr.getParameter("content"));

		String isTop = mpr.getParameter("isTop") != null ? "Y" : "N";
		dto.setIs_top(isTop);

		// 최종 합쳐진 이미지 경로 저장
		dto.setImage_url(sb.toString());

		int result = adNoDao.updateNotice(dto);

		if (result > 0) {
			model.addAttribute("msg", "수정 성공");
		} else {
			model.addAttribute("msg", "수정 실패");
		}
	}

	// 5. 삭제 처리
	@Override
	public void deleteNotice(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - deleteNotice()]");

		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		int result = adNoDao.deleteNotice(noticeId);
		request.setAttribute("result", result);
	}

	// 6. 이미지 업로드
	@Override
	public void uploadImage(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminNoticeImpl - uploadImage()]");

		MultipartHttpServletRequest mpr = (MultipartHttpServletRequest) request;

		// 1. 파일 데이터 가져오기
		MultipartFile file = mpr.getFile("file");

		if (file == null) {
			System.out.println("[에러] 파일 객체가 null입니다. (Resolver 설정 확인 필요)");
		} else if (file.isEmpty()) {
			System.out.println("[에러] 파일이 비어있습니다. (JS formData 확인 필요)");
		} else {
			String savedFileName = fileSaveService(file, request);
			System.out.println("[성공] 저장된 파일명: " + savedFileName);

			String imagePath = request.getContextPath() + "/resources/upload/" + savedFileName;
			request.setAttribute("imageUrl", imagePath);
		}
		/*
		 * if(file != null && !file.isEmpty()) { String savedFileName =
		 * fileSaveService(file, request); System.out.println("[성공] 저장된 파일명: " +
		 * savedFileName); //2. 저장 경로 설정 String imagePath = request.getContextPath() +
		 * "/resources/upload/" + savedFileName;
		 * 
		 * request.setAttribute("imageUrl", imagePath); }
		 */
	}

}
