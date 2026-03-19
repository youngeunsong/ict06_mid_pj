package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdCommunityDAO;
import spring.ict06team1.midpj.dao.AdMemberDAO;
import spring.ict06team1.midpj.dto.CommunityDTO;
import spring.ict06team1.midpj.dto.MemberDTO;

@Service
public class AdCommunityServiceImpl implements AdCommunityService {

	@Autowired
	private AdCommunityDAO adComDao;
	@Autowired
	private AdMemberDAO adMemDao;

	//1. 전체 게시글 목록(숨김 포함)
	@Override
	public void getAdPostList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - getAdPostList()]");
		
		List<CommunityDTO> postList = adComDao.getAdPostList();
		model.addAttribute("postList", postList);
	}

	//2. 게시글 상세보기
	@Override
	public void getAdPostDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - getAdPostDetail()]");
		
		int post_id = Integer.parseInt(request.getParameter("post_id"));
		CommunityDTO dto = adComDao.getAdPostDetail(post_id);
		
		//작성자 상태 조회
		MemberDTO member = adMemDao.getUserStatus(dto.getUser_id());
		model.addAttribute("dto", dto);
		model.addAttribute("member", member);
	}

	//3. 게시글 숨김/제재(status='BANNED')
	@Override
	public void hidePost(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - hidePost()]");
		
		int post_id = Integer.parseInt(request.getParameter("post_id"));
		int result = adComDao.hidePost(post_id);
		request.setAttribute("result", result);
	}

	//4. 게시글 숨김 해제(status='DISPLAY')
	@Override
	public void showPost(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - showPost()]");
		
		int post_id = Integer.parseInt(request.getParameter("post_id"));
		int result = adComDao.showPost(post_id);
		request.setAttribute("result", result);
	}

	//5. 게시글 삭제(status='HIDDEN')
	@Override
	public void deletePost(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - deletePost()]");
		
		int post_id = Integer.parseInt(request.getParameter("post_id"));
		int result = adComDao.deletePost(post_id);
		request.setAttribute("result", result);
	}

	//6. 일괄 처리(체크박스)
	@Override
	public void bulkAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommunityServiceImpl - bulkAction()]");
		
		String action = request.getParameter("action");
		String[] post_ids = request.getParameterValues("post_ids");
		
		int successCount = 0;
		int totalCount = post_ids != null ? post_ids.length : 0;
		if(post_ids != null) {
			for(String id : post_ids) {
				int post_id = Integer.parseInt(id);
				int result = 0;
				if("hide".equals(action)) {
					result = adComDao.hidePost(post_id);
				} else if("show".equals(action)) {
					result = adComDao.showPost(post_id);
				} else if("delete".equals(action)) {
					result = adComDao.deletePost(post_id);
				}
				if(result > 0) successCount++;
			}
		}
		request.setAttribute("successCount", successCount);
		request.setAttribute("totalCount", totalCount);
	}
}
