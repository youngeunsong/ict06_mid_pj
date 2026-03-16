package spring.ict06team1.midpj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import spring.ict06team1.midpj.service.AdReservationService;

@Component
public class AdminInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private AdReservationService resService;
	
	//관리자 페이지 접근 제어 위해 Spring Interceptor 사용
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		throws Exception {
		//관리자 url 판별
		String uri = request.getRequestURI();
		
		boolean isAdminPage = uri.contains(".ad");
		
		//관리자 페이지 아니면 통과
		if(!isAdminPage) return true;
		
		//세션 없으면 null 반환
		HttpSession session = request.getSession(false);
		
		//세션 검사(userRole값 확인해 관리자 권한 여부 판단)
		String userRole = null;
		String sessionID = null;
		
		//session값 없는 경우: userRole과 sessionID 설정
		if(session != null) {
			userRole = (String)session.getAttribute("userRole");
			sessionID = (String)session.getAttribute("sessionID");
		}
		
		//로그인 안했거나 관리자 아닌 경우
		if(userRole == null || sessionID == null || !"ADMIN".equals(userRole)) {
			HttpSession alertSession = request.getSession();
			alertSession.setAttribute("alertMsg", "관리자 권한이 없습니다.");
			
		    System.out.println("=== alertMsg 세션 저장 완료: " + alertSession.getAttribute("alertMsg"));
		    System.out.println("=== 세션ID: " + alertSession.getId());
			response.sendRedirect(request.getContextPath() + "/main.do");
			
			return false;
		}
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView mav)
			throws Exception {
		if(mav != null) {
			int pendingCount = resService.getPendingCount();
			mav.addObject("pendingCount", pendingCount);
		}
	}
}
