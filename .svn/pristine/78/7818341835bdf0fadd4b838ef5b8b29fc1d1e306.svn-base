package kr.or.ddit.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

/**
 * <pre>
 * PROJ : Tudio
 * Name : WebSocketStompBrokerConfig
 * DESC : STOMP를 사용하여 메시지 브로커를 설정하는 클래스. 
 *        메시지 브로커를 구성하고 STOMP 엔드포인트를 등록함.
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KJS
 * @version 1.0, 2025.12.26
 * 
 */	
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketStompBrokerConfig implements WebSocketMessageBrokerConfigurer{
	
	/**
	 *	<p>메세지 브로커 설정 메서드</p>
	 *	@date 2026.01.08
	 *	@author KJS
	 */
	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		// 클라이언트에게 메세지 보낼 때의 시작 주소 설정
		registry.enableSimpleBroker("/sub")
				.setTaskScheduler(taskScheduler()) 
				// 주기적으로 신호를 주고받기 위해 heartbeat 설정(연결 끊겼는지 확인하기위해 요청 주고받음)
				.setHeartbeatValue(new long[] {10000,10000});
		
		// 서버로 보낼 때의 시작 주소 설정
		registry.setApplicationDestinationPrefixes("/pub");
		
	}

	/**	
	 *	<p>메세지 브로커의 endPoint(끝나는 주소)를 설정</p>
	 *	@date 2026.01.08
	 *	@author KJS
	 */
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/ws-stomp")
				.setAllowedOriginPatterns("*") // 모든 도메인에서의 접속 허용 (위젯 갱신 기능시 사용)
				.addInterceptors(new HttpSessionHandshakeInterceptor())
				.withSockJS();
	}

	/**
	 * 스케줄러 객체 생성 메서드 (Heartbeat 작동시 필요함)
	 * @return 스케줄러 객체
	 */
	@Bean
	public TaskScheduler taskScheduler() {
		ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
		scheduler.setPoolSize(1);
		// 스케줄러 이름 붙이기 (에러 났을 때, 쉽게 알 수 있도록)
		scheduler.setThreadNamePrefix("wsock-scheduler-");
		scheduler.initialize();
		
		return scheduler;
	}
	
}
