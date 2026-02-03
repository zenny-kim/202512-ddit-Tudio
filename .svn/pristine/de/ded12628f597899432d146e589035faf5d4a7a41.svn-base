package kr.or.ddit.config;

import java.io.IOException;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.log.service.ILogLoginService;
import kr.or.ddit.member.service.impl.CustomUser;
import kr.or.ddit.vo.MemberVO;

@Component
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	
	@Autowired
	private ILogLoginService loginLogService;
	
	@Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws ServletException, IOException {
		
        // 1. 시큐리티가 인증한 유저 정보 꺼내기
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
        
		// 2. CustomUser 안에 들어있는 진짜 알맹이(MemberVO) 꺼내기
        MemberVO memberVO = customUser.getMemberVO();
        
        loginLogService.logLogin(
        		request,
        		memberVO.getMemberId(),
        		"SUCCESS",
        		null,
        		memberVO.getMemberNo()
        );
		
        // 3. 세션에 "loginUser"라는 이름으로 담기
        HttpSession session = request.getSession();
        session.setAttribute("loginUser", memberVO);
        
        // 4. 초대 링크에서 리다이렉트되어 왔는지 확인
        String inviteReturnUrl = (String) session.getAttribute("inviteReturnUrl");
        
        if (inviteReturnUrl != null && !inviteReturnUrl.isEmpty()) {
            // 세션에서 url 제거
            session.removeAttribute("inviteReturnUrl");          
            // 해당 초대 인증 페이지로 이동
            response.sendRedirect(request.getContextPath() + inviteReturnUrl);
            return; 
        }
        
        // 5. 로그인이 끝나고 어디로 보낼지 결정 (예: 메인 페이지)
        boolean isAdmin = false;
        
        // 시큐리티가 관리하는 권한 목록을 순회하며 'ROLE_ADMIN'이 있는지 확인
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (GrantedAuthority auth : authorities) {
            if ("ROLE_ADMIN".equals(auth.getAuthority())) {
                isAdmin = true;
                break;
            }
        }

        // 6. 페이지 이동 (Redirect)
        if (isAdmin) {
            response.sendRedirect("http://localhost:5173/admin/user/list");
        } else {
            String ctx = request.getContextPath();
            response.sendRedirect(ctx + "/tudio/dashboard");
        }
    }

}
