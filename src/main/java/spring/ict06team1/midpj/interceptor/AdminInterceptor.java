package spring.ict06team1.midpj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		throws Exception {
		String uri = request.getRequestURI();
		
		String extension = "";
		int lastDotIndex = uri.lastIndexOf(".");
		if(lastDotIndex != -1) {
			extension = uri.substring(lastDotIndex);
		}

		//브라우저 확장자가 ".ad"로 시작하는지 확인(admin 관련 페이지)
		boolean isAdminPage = extension.startsWith(".ad");
		
		//관리자 페이지 아니면 통과
		if(!isAdminPage) return true;
		
		HttpSession session = request.getSession();
		
		//세션에서 userRole 가져오기
		String userRole = (String)session.getAttribute("userRole");
		String sessionID = (String)session.getAttribute("sessionID");
		
		//로그인상태가 아니거나 관리자 아닌 경우 차단
		if(userRole == null || !"ADMIN".equals(userRole) || sessionID == null) {
			response.reset();
			response.setStatus(HttpServletResponse.SC_OK);
			response.setContentType("text/html; charset=UTF-8");
			
			java.io.PrintWriter out = response.getWriter();
			out.println("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body>");
			out.println("<script>");
			out.println("alert('관리자 권한이 없습니다.');");
			out.println("location.href='" + request.getContextPath() + "/main.do';");
			//out.println("setTimeout(function() {location.href='" + request.getContextPath() + "/main.do';}, 500);");
			out.println("</script>");
			out.println("</body></html>");
			
			out.flush();
			out.close();
			
			return false;
		}
		System.out.println("추출된 확장자:" + extension);
		return true;
	}
}
