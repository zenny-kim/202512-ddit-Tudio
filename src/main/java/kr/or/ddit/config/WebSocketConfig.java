package kr.or.ddit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import kr.or.ddit.notification.handler.NotificationHandler;
import kr.or.ddit.notification.handshakeInterceptor.NotificationHandshakeInterceptor;


/**
 * <pre>
 * PROJ : Tudio
 * Name : WebSocketConfig
 * DESC : 실시간 알림 기능을 위한 WebSocket 핸들러 및 인터셉터 설정 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KJS
 * @version 1.0, 2025.01.14
 * 
 */	
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

	private final NotificationHandler notificationHandler;
	private final NotificationHandshakeInterceptor notificationHandshakeInterceptor; 
	
	

	public WebSocketConfig(NotificationHandler notificationHandler, NotificationHandshakeInterceptor notificationHandshakeInterceptor) {
		this.notificationHandler = notificationHandler;
		this.notificationHandshakeInterceptor = notificationHandshakeInterceptor; 
	}
	
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {

		registry.addHandler(notificationHandler, "/ws/noti")
				.addInterceptors(notificationHandshakeInterceptor)
				.setAllowedOrigins("*");
	}
}
