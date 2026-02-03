package kr.or.ddit.notification.handshakeInterceptor;

import java.util.Map;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.vo.MemberVO;



/**
 * <pre>
 * PROJ : Tudio
 * Name : NotificationController
 * DESC : WebSocketHandshakeInterceptor 설정 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KMS
 * @version 1.0, 2025.01.14
 * 
 */
@Component 
public class NotificationHandshakeInterceptor implements HandshakeInterceptor{ 

	/*
	 * 연결 직전 
	 */
	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception {


		if(!(request instanceof ServletServerHttpRequest)) return false;
		
		HttpServletRequest servletRequest = ((ServletServerHttpRequest)request).getServletRequest();
		
		HttpSession httpSession = servletRequest.getSession(false);
		
		if(httpSession == null) return false;
		
		Object loginUser = httpSession.getAttribute("loginUser");
		if(!(loginUser instanceof MemberVO)) return false;
		
		MemberVO memberVO = (MemberVO) loginUser;
		
		attributes.put("memberNo",memberVO.getMemberNo());
		return true;
	}

	
	/*
	 * 연결 직후
	 */
	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			@Nullable Exception exception) {
	}

}
