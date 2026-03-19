package spring.ict06team1.midpj.controller;


import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.service.CommunityService;
import spring.ict06team1.midpj.service.NoticeService;

@Controller
public class CommunityController {

    private static final Logger logger = LoggerFactory.getLogger(CommunityController.class);

    @Autowired
    private CommunityService communityService;

    @Autowired
    private NoticeService noticeService;

	// ==================================================
	// 자유게시판
	// ==================================================
    // 커뮤니티 홈 + 자유게시판
    @GetMapping("/community_free.co")
    public String freeBoard(HttpServletRequest request, Model model) {
        logger.info("<<< url => /community_free.co >>>");
        model.addAttribute("tab", "free");

        communityService.getFreeBoardList(request, model);

        return "user/community/community";
    }

    // 자유게시판 상세
    @GetMapping("/community_detail.co")
    public String communityDetail(HttpServletRequest request, Model model) {
        logger.info("<<< url => /community_detail.co >>>");

        communityService.getBoardDetail(request, model);

        return "user/community/community_detail";
    }
    
    // 댓글 등록
    @PostMapping("/comment_insert.co")
    public String insertComment(HttpServletRequest request) {
        logger.info("<<< url => /comment_insert.co >>>");

        String sessionID = (String) request.getSession().getAttribute("sessionID");

        if (sessionID == null) {
            return "redirect:/login.do";
        }

        communityService.insertComment(request);

        int post_id = Integer.parseInt(request.getParameter("post_id"));
        return "redirect:/community_detail.co?post_id=" + post_id;
    }
	
	// 댓글 삭제 
    @PostMapping("/comment_delete.co")
    public String deleteComment(HttpServletRequest request) {
        logger.info("<<< url => /comment_delete.co >>>");

        String sessionID = (String) request.getSession().getAttribute("sessionID");

        if (sessionID == null) {
            return "redirect:/login.do";
        }

        communityService.deleteComment(request);

        int post_id = Integer.parseInt(request.getParameter("post_id"));
        return "redirect:/community_detail.co?post_id=" + post_id;
    }
    
	// 자유게시판 게시글 작성(화면)
	@GetMapping("/community_create.co")
	public String createBoard(HttpServletRequest request) {
	    logger.info("<<< url => /community_create.co >>>");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }

	    return "user/community/community_insert";
	}
	
	// 자유게시판 게시글 작성(등록)
	@PostMapping("/community_insert.co")
	public String insertBoard(MultipartHttpServletRequest request) {
	    logger.info("<<< url => /community_insert.co >>>");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }

	    communityService.insertBoard(request);

	    return "redirect:/community_free.co?msg=write";
	}
	
	// 자유게시판 게시글 작성 > 이미지 업로드 API(SUMMERNOTE)
	@PostMapping("/uploadImage.co")
	@ResponseBody
	public String uploadImage(MultipartFile file, HttpServletRequest request) throws Exception {

	    String uploadPath =
	        request.getSession().getServletContext().getRealPath("/resources/upload/");

	    File dir = new File(uploadPath);

	    if (!dir.exists()) {
	        dir.mkdirs();
	    }

	    String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

	    File dest = new File(uploadPath, fileName);

	    file.transferTo(dest);

	    return request.getContextPath() + "/resources/upload/" + fileName;
	}
	
	// 자유게시판 게시글 삭제
	@PostMapping("/community_delete.co")
	public String deleteBoard(HttpServletRequest request) {
	    logger.info("<<< url => /community_delete.co >>>");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }

	    communityService.deleteBoard(request);

	    return "redirect:/community_free.co?msg=delete";
	}

	// 자유게시판 게시글 수정(화면)
	@GetMapping("/community_modify.co")
	public String modifyBoard(HttpServletRequest request, Model model) {
	    logger.info("<<< url => /community_modify.co >>>");
	    
	    //로그인 체크
	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }
	    
	    communityService.getBoardDetail(request, model);
	    return "user/community/community_modify";
	}
    
	// 자유게시판 게시글 수정(등록)
	@PostMapping("/community_modifyAction.co")
	public String updateBoard(MultipartHttpServletRequest request) {
	    logger.info("<<< url => /community_modifyAction.co >>>");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }

	    communityService.updateBoard(request);

	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    return "redirect:/community_detail.co?msg=update&post_id=" + post_id;
	}
	
	// 자유게시판 게시글 좋아요
	@PostMapping("/community_likeToggle.co")
	@ResponseBody
	public String toggleLike(HttpServletRequest request) {
	    logger.info("<<< url => /community_likeToggle.co >>>");
	    return communityService.toggleLike(request);
	}

	// ==================================================
	// 공지사항 => 상단 고정 공지 | 일반 공지 | 페이징
	// ==================================================
    // 공지사항 홈
	@GetMapping("/community_notice.co")
	public String notice(HttpServletRequest request, Model model) {
		logger.info("<<< url => /community_notice.co >>>");
		
	    model.addAttribute("tab", "notice");
	    noticeService.getNoticeList(request, model);
	    
	    return "user/community/notice";
	}
	
	// 공지사항 게시글 상세 페이지
	@GetMapping("/community_notice_detail.co")
	public String noticeDetail(HttpServletRequest request, Model model) {
		logger.info("<<< url => /community_notice_detail.co >>>");
		
	    model.addAttribute("tab", "notice");
	    noticeService.getNoticeDetail(request, model);
	    
	    return "user/community/notice_detail";
	}

	// ==================================================
	// 이벤트 => 진행중인 이벤트 | 종류 이벤트 | 페이징
	// ==================================================
    // 이벤트 홈
	@GetMapping("/community_event.co")
	public String event(HttpServletRequest request, Model model) {
		logger.info("<<< url => /community_event.co >>>");
		
	    model.addAttribute("tab", "event");
	    noticeService.getEventList(request, model);
	    
	    return "user/community/event";
	}

	// 이벤트 게시글 상세 페이지
	@GetMapping("/community_event_detail.co")
	public String eventDetail(HttpServletRequest request, Model model) {
		logger.info("<<< url => /community_event_detail.co >>>");
		
	    model.addAttribute("tab", "event");
	    noticeService.getNoticeDetail(request, model);
	    
	    return "user/community/event_detail";
	}
    
    
}