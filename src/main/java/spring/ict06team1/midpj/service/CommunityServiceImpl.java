package spring.ict06team1.midpj.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.CommunityCommentDAO;
import spring.ict06team1.midpj.dao.CommunityDAO;
import spring.ict06team1.midpj.dto.CommunityCommentDTO;
import spring.ict06team1.midpj.dto.CommunityDTO;
import spring.ict06team1.midpj.dto.ImageStoreDTO;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	private CommunityDAO dao;
	
	@Autowired
	private CommunityCommentDAO commentDao;

    /* ==========================================
    	자유게시판 목록(자유게시판 목록 or 자유게시판 검색 목록)
    ========================================== */
	@Override
	public void getFreeBoardList(HttpServletRequest request, Model model) {
	    System.out.println("[CommunityServiceImpl - getFreeBoardList()]");

	    String category = request.getParameter("category");           // 맛집수다 | 숙소수다 | 축제수다 | 정보공유 | 동행구해요
	    String searchType = request.getParameter("searchType");       // 제목 | 내용 | 제목+내용 | 작성자
	    String searchKeyword = request.getParameter("searchKeyword"); // 검색 키워드
	    String pageNum = request.getParameter("pageNum");             // 페이징
	    
	    // 목록 카테고리 + 검색 타입 + 검색 키워드
	    Map<String, Object> map = new HashMap<>();
	    map.put("category", category);
	    map.put("searchType", searchType);
	    map.put("searchKeyword", searchKeyword);

	    // 페이징
	    int count;
	    Paging paging = new Paging(pageNum);

	    // 자유게시판 목록을 담기 위한 list 선언
	    List<CommunityDTO> freeBoardList; 

	    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) { 
	    	// 검색 키워드가 있을 시, 자유게시판 검색 목록(카테고리 필터 + 페이징)
	    	count = dao.searchFreeBoardCount(map);
	        paging.setTotalCount(count);

	        map.put("startRow", paging.getStartRow());
	        map.put("endRow", paging.getEndRow());

	        freeBoardList = count > 0 ? dao.searchFreeBoardPage(map) : new ArrayList<>();
	    } else {
	    	// 검색 키워드가 없을 시, 자유게시판 목록(카테고리 필터 + 페이징)
	        count = dao.freeBoardCount(category);
	        paging.setTotalCount(count);

	        map.put("startRow", paging.getStartRow());
	        map.put("endRow", paging.getEndRow());

	        freeBoardList = count > 0 ? dao.freeBoardPage(map) : new ArrayList<>();
	    }

	    // 인기글 TOP3
	    List<CommunityDTO> popularList = dao.popularList();

	    model.addAttribute("freeBoardList", freeBoardList); // 자유게시판 목록
	    model.addAttribute("popularList", popularList); // 인기글 TOP3
	    model.addAttribute("paging", paging);
	    model.addAttribute("category", category);
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("searchKeyword", searchKeyword);
	}

    /* ==========================================
    	게시글 1건 조회(조회 + 조회수 증가 + 댓글 정보)
    ========================================== */
	@Override
	public void getBoardDetail(HttpServletRequest request, Model model) {
	    System.out.println("[CommunityServiceImpl - getBoardDetail()]");
	    
	    // 포스트 번호 가져오기
	    int post_id = Integer.parseInt(request.getParameter("post_id"));

	    // 게시글 1건 조회
	    CommunityDTO dto = dao.boardDetail(post_id);

	    // 숨김/차단/없는 게시글 접근 차단
	    if (dto == null || "HIDDEN".equals(dto.getStatus()) || "BANNED".equals(dto.getStatus())) {
	        model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
	        return;
	    }

	    // 정상 게시글만 조회수 증가
	    dao.increaseViewCount(post_id);

	    // 증가된 조회수 반영 다시 조회
	    dto = dao.boardDetail(post_id);

	    // 댓글 목록 조회
	    List<CommunityCommentDTO> commentList = commentDao.getCommentList(post_id);

	    model.addAttribute("dto", dto); //게시글 1건
	    model.addAttribute("commentList", commentList); //댓글 목록
	}

    /* ==========================================
    	댓글 등록
    ========================================== */
	@Override
	public void insertComment(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - insertComment()]");
	    
	    // 포스터 번호 가져오기(midpj/community_detail.co?post_id=[  ])
	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    
	    // 댓글
	    String content = request.getParameter("content");
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityCommentDTO dto = new CommunityCommentDTO();
	    dto.setPost_id(post_id);
	    dto.setUser_id(sessionID);
	    dto.setContent(content);

	    commentDao.insertComment(dto);
	}
	
    /* ==========================================
    	댓글 삭제
    ========================================== */
	@Override
	public void deleteComment(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - deleteComment()]");

	    int comment_id = Integer.parseInt(request.getParameter("comment_id"));
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityCommentDTO comment = commentDao.getCommentDetail(comment_id);

	    if (comment != null && sessionID != null && sessionID.equals(comment.getUser_id())) {
	        commentDao.deleteComment(comment_id);
	    }
	}
	
	/* ==========================================
		좋아요(좋아요 여부 체크 + 게시글 좋아요/COMMUNITY_LIKE 테이블 +1 or -1)
	========================================== */
	@Override
	public String toggleLike(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - toggleLike()]");

	    // 로그인 체크 : 비로그인 시 로그인 페이지로 이동
	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    if (sessionID == null) {
	        return "logout";
	    }

	    int post_id = Integer.parseInt(request.getParameter("post_id"));

	    Map<String, Object> map = new HashMap<>();
	    map.put("user_id", sessionID);
	    map.put("post_id", post_id);
	    
	    // 좋아요 여부 체크 (0 좋아요 클릭 상태/ 1 좋아요 미클릭 상태)
	    int checkCnt = dao.checkCommunityLike(map);

	    // 좋아요 여부에 따라, 게시글 좋아요/COMMUNITY_LIKE 테이블 +1 or -1
	    if (checkCnt > 0) {
	        dao.deleteCommunityLike(map);
	        dao.decreaseLikeCount(post_id);
	        return "delete";
	    } else {
	        dao.insertCommunityLike(map);
	        dao.increaseLikeCount(post_id);
	        return "insert";
	    }
	}
	
    /* ==========================================
		게시글 작성(등록)(게시글 내 내용 + 대표 이미지 등록)
	========================================== */
	@Override
	public void insertBoard(MultipartHttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - insertBoard()]");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    /* [ 게시글 내 내용 등록 ] ------------------------------------------------------------------ */
	    String title = request.getParameter("title");
	    String content = request.getParameter("content");
	    String category = request.getParameter("category");

	    CommunityDTO dto = new CommunityDTO();
	    dto.setUser_id(sessionID);
	    dto.setTitle(title);
	    dto.setContent(content);
	    dto.setCategory(category);

	    dao.insertBoard(dto);

	    /* [ 대표 이미지 등록 ] ------------------------------------------------------------------ */
	    List<MultipartFile> files = request.getFiles("files");

	    if (files != null && !files.isEmpty()) {
	        ServletContext context = request.getSession().getServletContext();
	        String uploadPath = context.getRealPath("/resources/upload/community/");
	        
	        //커뮤니티 자유게시판 이미지 저장 경록 확인용
	        System.out.println("==================================================");
	        System.out.println("[Community Image Upload]"); //커뮤니티 대표 이미지 경로
	        System.out.println("uploadPath = " + uploadPath);

	        File uploadDir = new File(uploadPath);
	        if (!uploadDir.exists()) {
	            boolean made = uploadDir.mkdirs();
	            System.out.println("uploadDir 생성 여부 = " + made);
	        } else {
	            System.out.println("uploadDir 이미 존재함");
	        }

	        int sortOrder = 1;

	        for (MultipartFile file : files) {
	            if (file == null || file.isEmpty()) {
	                continue;
	            }

	            String contentType = file.getContentType();
	            long fileSize = file.getSize();

	            System.out.println("----------------------------------");
	            System.out.println("originalFileName = " + file.getOriginalFilename());
	            System.out.println("contentType      = " + contentType);
	            System.out.println("fileSize         = " + fileSize);

	            if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)) {
	                System.out.println("허용되지 않은 파일 형식이라 저장 건너뜀");
	                continue;
	            }

	            if (fileSize > 10 * 1024 * 1024) {
	                System.out.println("10MB 초과 파일이라 저장 건너뜀");
	                continue;
	            }

	            String originalFileName = file.getOriginalFilename();
	            String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	            File dest = new File(uploadDir, saveFileName);
	            System.out.println("dest 절대경로 = " + dest.getAbsolutePath());

	            try {
	                file.transferTo(dest);
	                System.out.println("파일 저장 성공");
	                System.out.println("dest.exists() = " + dest.exists());
	                System.out.println("dest.length() = " + dest.length());
	            } catch (Exception e) {
	                System.out.println("파일 저장 실패");
	                e.printStackTrace();
	                continue;
	            }

	            String imageUrl = request.getContextPath() + "/resources/upload/community/" + saveFileName;
	            System.out.println("DB 저장 imageUrl = " + imageUrl);

	            ImageStoreDTO imageDto = new ImageStoreDTO();
	            imageDto.setTarget_id(dto.getPost_id());
	            imageDto.setTarget_type("COMMUNITY");
	            imageDto.setImage_url(imageUrl);
	            imageDto.setIs_representative(sortOrder == 1 ? "Y" : "N");
	            imageDto.setSort_order(sortOrder);

	            dao.insertCommunityImage(imageDto);
	            System.out.println("IMAGE_STORE insert 완료 / sortOrder = " + sortOrder);

	            sortOrder++;
	        }

	        System.out.println("==================================================");
	    }
	}
	
	// 게시글 삭제
	@Override
	public void deleteBoard(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - deleteBoard()]");

	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityDTO dto = dao.boardDetail(post_id);

	    if (dto != null && sessionID != null && sessionID.equals(dto.getUser_id())) {
	        dao.deleteBoard(post_id);
	    }
	}

	// 게시글 수정(등록)
	@Override
	public void updateBoard(MultipartHttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - updateBoard()]");

	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityDTO originDto = dao.boardDetail(post_id);

	    // 작성자 본인만 수정 가능
	    if (originDto == null || sessionID == null || !sessionID.equals(originDto.getUser_id())) {
	        return;
	    }

	    String title = request.getParameter("title");
	    String content = request.getParameter("content");
	    String category = request.getParameter("category");

	    CommunityDTO dto = new CommunityDTO();
	    dto.setPost_id(post_id);
	    dto.setTitle(title);
	    dto.setContent(content);
	    dto.setCategory(category);

	    // 1. COMMUNITY 본문 수정
	    dao.updateBoard(dto);

	    // 2. 새 대표 이미지가 있으면 기존 이미지 전체 교체
	    List<MultipartFile> files = request.getFiles("files");

	    boolean hasNewFile = false;
	    if (files != null) {
	        for (MultipartFile file : files) {
	            if (file != null && !file.isEmpty()) {
	                hasNewFile = true;
	                break;
	            }
	        }
	    }

	    if (!hasNewFile) {
	        return; // 새 이미지 없으면 기존 이미지 유지
	    }

	    // 기존 이미지 삭제
	    dao.deleteCommunityImagesByPostId(post_id);

	    // 새 이미지 저장
	    ServletContext context = request.getSession().getServletContext();
	    String uploadPath = context.getRealPath("/resources/upload/community/");

	    File uploadDir = new File(uploadPath);
	    if (!uploadDir.exists()) {
	        uploadDir.mkdirs();
	    }

	    int sortOrder = 1;

	    for (MultipartFile file : files) {
	        if (file == null || file.isEmpty()) {
	            continue;
	        }

	        String contentType = file.getContentType();
	        long fileSize = file.getSize();

	        if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)) {
	            continue;
	        }

	        if (fileSize > 10 * 1024 * 1024) {
	            continue;
	        }

	        String originalFileName = file.getOriginalFilename();
	        String saveFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	        File dest = new File(uploadDir, saveFileName);

	        try {
	            file.transferTo(dest);
	        } catch (Exception e) {
	            e.printStackTrace();
	            continue;
	        }

	        String imageUrl = request.getContextPath() + "/resources/upload/community/" + saveFileName;

	        ImageStoreDTO imageDto = new ImageStoreDTO();
	        imageDto.setTarget_id(post_id);
	        imageDto.setTarget_type("COMMUNITY");
	        imageDto.setImage_url(imageUrl);
	        imageDto.setIs_representative(sortOrder == 1 ? "Y" : "N");
	        imageDto.setSort_order(sortOrder);

	        dao.insertCommunityImage(imageDto);

	        sortOrder++;
	    }
	}
	

	
}