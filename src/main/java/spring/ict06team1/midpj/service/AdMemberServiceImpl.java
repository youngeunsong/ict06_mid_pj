package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.SearchCriteria.MemberSearchFilter;
import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.AdMemberDAO;
import spring.ict06team1.midpj.dto.MemberDTO;

@Service
public class AdMemberServiceImpl implements AdMemberService {

	@Autowired
	private AdMemberDAO adMemDao;

	//1. 전체 회원 목록
	@Override
	public void getMemberList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - getMemberList()]");
		
		//검색 필터
		MemberSearchFilter sf = new MemberSearchFilter();
		sf.setSearchType(request.getParameter("searchType"));
		sf.setKeyword(request.getParameter("keyword"));
		sf.setStatus(request.getParameter("status"));
		sf.setRole(request.getParameter("role"));
		
		//페이징
		String pageNum = request.getParameter("pageNum");
		Paging paging = new Paging(pageNum);
		
		//map으로 전달
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sf", sf);
		map.put("paging", paging);
		
		//전체 건수
		int totalCount = adMemDao.getMemberCount(map);
		paging.setTotalCount(totalCount);
		
		//목록
		List<MemberDTO> memberList = adMemDao.getMemberList(map);
		model.addAttribute("memberList", memberList);
		model.addAttribute("paging", paging);
		model.addAttribute("sf", sf);
		model.addAttribute("totalCount", totalCount);
	}

	//2. 제재 회원 목록
	@Override
	public void getBannedList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - getBannedList()]");
		
		//검색 필터
		MemberSearchFilter sf = new MemberSearchFilter();
		sf.setSearchType(request.getParameter("searchType"));
		sf.setKeyword(request.getParameter("keyword"));
		sf.setRole(request.getParameter("role"));
		
		//페이징
		String pageNum = request.getParameter("pageNum");
		Paging paging = new Paging(pageNum);
		
		//map으로 전달
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sf", sf);
		map.put("paging", paging);
		
		//전체 건수
		int totalCount = adMemDao.getBannedCount(map);
		paging.setTotalCount(totalCount);
		
		//목록
		List<MemberDTO> bannedList = adMemDao.getBannedList(map);
		model.addAttribute("bannedList", bannedList);
		model.addAttribute("paging", paging);
		model.addAttribute("sf", sf);
		model.addAttribute("totalCount", totalCount);
	}
	
	//3. 작성자 제재(status='BANNED')
	@Override
	public void banUser(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - banUser()]");
		
		String user_id = request.getParameter("user_id");
		int result = adMemDao.banUser(user_id);
		request.setAttribute("result", result);
	}

	//4. 작성자 제재 해제(status='ACTIVE')
	@Override
	public void unbanUser(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - unbanUser()]");
		
		String user_id = request.getParameter("user_id");
		int result = adMemDao.unbanUser(user_id);
		request.setAttribute("result", result);
	}

	//5. 전체 제재
	@Override
	public void bulkBan(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - bulkBan()]");
		
		String[] user_ids = request.getParameterValues("user_ids");
		int successCount = 0;
		int totalCount = user_ids != null ? user_ids.length : 0;
		
		if(user_ids != null) {
			for(String user_id : user_ids) {
				int result = adMemDao.banUser(user_id);
				if(result > 0) successCount++;
			}
		}
		request.setAttribute("successCount", successCount);
		request.setAttribute("totalCount", totalCount);
	}

	//6. 전체 제재해제
	@Override
	public void bulkUnban(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdMemberServiceImpl - bulkUnban()]");
		
		String[] user_ids = request.getParameterValues("user_ids");
		int successCount = 0;
		int totalCount = user_ids != null ? user_ids.length : 0;
		
		if(user_ids != null) {
			for(String user_id : user_ids) {
				int result = adMemDao.unbanUser(user_id);
				if(result > 0) successCount++;
			}
		}
		request.setAttribute("successCount", successCount);
		request.setAttribute("totalCount", totalCount);
	}

}
