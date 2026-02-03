package kr.or.ddit.config;

import java.io.IOException;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.log.service.ILogLoginService;

@Component
public class CustomAuthFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	
	@Autowired
	private ILogLoginService loginLogService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		String errorMessage;
		if (exception instanceof InternalAuthenticationServiceException
				|| exception instanceof org.springframework.security.core.userdetails.UsernameNotFoundException) {
			errorMessage = "가입된 회원이 아닙니다.";

		} else if (exception instanceof BadCredentialsException) {
			errorMessage = "비밀번호가 일치하지 않습니다.";
		} else {
			// 여기로 빠진다면 알 수 없는 오류로 표시됨
			errorMessage = "로그인 처리 중 오류가 발생했습니다. (사유: " + exception.getMessage() + ")";
		}
		
		String loginId = request.getParameter("username");
		
		loginLogService.logLogin(
				request, 
				loginId, 
				"FAIL", 
				errorMessage,
				null
		);
		
		errorMessage = URLEncoder.encode(errorMessage, "UTF-8");
		setDefaultFailureUrl("/tudio/login?error=true&message=" + errorMessage);

		super.onAuthenticationFailure(request, response, exception);
	}
}
