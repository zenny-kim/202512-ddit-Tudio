package kr.or.ddit.notification.handler;

import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;


/*
 *  이 세션이 누구인지 (memberNo), 세션 등록 (CLIENTS.put(memberNo, session)), 안읽음 카운트 전송
 */

/**
 * <pre>
 * PROJ : Tudio
 * Name : NotificationHandler
 * DESC : 실시간 알림 핸들러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KMS
 * @version 1.0, 2025.01.09
 * 
 */
@Slf4j
@Component
public class NotificationHandler extends TextWebSocketHandler {
	
	// 회원별 연결 상태를 서버 메모리에 저장
	private static final ConcurrentHashMap<Integer, WebSocketSession> CLIENTS = new ConcurrentHashMap<>();
	private static final Gson gson = new Gson();
	
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.info("Notification Socket 연결");
		
		// 누가 접속했는지
		Object value = session.getAttributes().get("memberNo");
		
		if(value ==  null) {  
			session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Unauthenticated"));
			return;
		}
			
		Integer  memberNo = null;
 
		if(value instanceof Integer) {
			memberNo = (Integer) value;
		} else if(value instanceof String) {
			try {
				memberNo = Integer.parseInt((String)value);
			}catch(NumberFormatException e) {
				e.printStackTrace();
			}	
		}

		if(memberNo == null) {
			session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Unauthenticated"));
			return;
		}
		
		// 접속 중인 회원으로 등록
		CLIENTS.put(memberNo, session); // put => 무조건 put
		log.info("알림 WebSocket 연결됨 memberNo={}, sessionId={}", memberNo, session.getId());
		
		 log.info("NOTI WS connected, memberNo={}", memberNo);
		

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		
		Object value= session.getAttributes().get("memberNo"); 
		Integer memberNo = null; 
		
		if(value instanceof Integer) {
			memberNo = (Integer) value;
		} else if(value instanceof String) {
			try {
				memberNo = Integer.parseInt((String) value);
			}catch(NumberFormatException e) {
				 log.warn("memberNo parse fail: {}", value);
			}
			
		}
		
		log.info("sendToMember memberNo={}, sessionExists={}", memberNo, (session != null));
			if(memberNo != null) {
				CLIENTS.remove(memberNo,session);

				log.info("알림 WebSocket 종료, memberNo={},sessionId={},status={}", memberNo, session.getId(),status);
				
			}else {
				log.info("알림 WebSocket 종료(회원 식별 불가) sessionId={},status={}", session.getId(),status);
				
			}
		
	}
	

	// 알림 전송
	public void sendToMember(int memberNo, Object payload) {
		WebSocketSession s = CLIENTS.get(memberNo);
		
		if( s ==null || !s.isOpen()) return; 
		
		try {
			String json = gson.toJson(payload); 
			s.sendMessage(new TextMessage(json));
		} catch(Exception e) {
			log.warn("알림 전송 실패 memberNo={}", memberNo, e); 
		}
	}
	
	
	/**
	 * 사이트 공지용
	 */
	public void broadcast(Object payload) {
		String json = gson.toJson(payload); 
											
		
		CLIENTS.forEach((memberNo, s) ->{
			if( s== null || !s.isOpen()) return; 
			try {
				s.sendMessage(new TextMessage(json));
			}catch(Exception e) {
				log.warn("공지 브로드캐스트 실패 memberNo={}", memberNo,e);
			}
		});
	}
		
	
	
	
	
	 
}
