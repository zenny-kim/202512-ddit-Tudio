package kr.or.ddit.config;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

import kr.or.ddit.chat.service.impl.ChatServiceImpl;
import kr.or.ddit.inquiry.controller.AdminInquiryController;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.chat.ChatMemberVO;
import kr.or.ddit.vo.chat.ChatVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WebSocketEventListener {

    private final AdminInquiryController adminInquiryController;
	
	// 채팅방별 접속자들을 저장하는 Map(채팅방 번호 : 접속 멤버 ID들)
	public static Map<Integer, Set<Integer>> chatroomAttendance = new ConcurrentHashMap<>();
	// 구독 번호와 구독중인 채팅방 번호 저장하는 Map (구독 ID : 채팅방 번호)
	public static Map<String, Integer> subscriptionMap = new ConcurrentHashMap<String, Integer>();
	
	@Autowired
	private SimpMessagingTemplate template;

	@Autowired
	private ChatServiceImpl chatServiceImpl;

    WebSocketEventListener(AdminInquiryController adminInquiryController) {
        this.adminInquiryController = adminInquiryController;
    }
	
	/**
	 * 사용자가 채팅방에 들어오면(sub 실행시) 실행되는 이벤트 리스너
	 * @param event
	 */
	@EventListener
	public void handleSessionSubscribeEvent(SessionSubscribeEvent event) {
		StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
		
		// subscribe(구독)하고있던 주소 가져오기 -> 어떤 채팅방인지 알아냄
		String destination = headerAccessor.getDestination();
		if(destination != null && destination.startsWith("/sub/chat/chatroom/")) {
				
			String[] destinationArray =  destination.split("/");
			int chatroomNo = Integer.parseInt(destinationArray[destinationArray.length -1]);
			
			// 각 채팅방 번호에 해당하는 구독 번호 기록해두기 (나중에 구독 끊길때 로직을 위해)
			String subscriptionId =headerAccessor.getSubscriptionId();
			subscriptionMap.put(subscriptionId, chatroomNo);
			
			// 누가 접속한건지 알아냄
			MemberVO loginUser = (MemberVO) headerAccessor.getSessionAttributes().get("loginUser");
			if(loginUser == null) return;
			
			int memberNo = loginUser.getMemberNo(); 
			
			chatroomAttendance.putIfAbsent(chatroomNo, ConcurrentHashMap.newKeySet());
			chatroomAttendance.get(chatroomNo).add(memberNo);
			
			// 입장을 알리기 위한 chatVO 생성
			ChatVO entryNotiChat = new ChatVO();
			entryNotiChat.setChatType("ENTRY");
			entryNotiChat.setChatroomNo(chatroomNo);
			entryNotiChat.setMemberNo(memberNo);
			entryNotiChat.setCurrentOnlineCnt(chatroomAttendance.get(chatroomNo).size());

			// 채팅방에 진입한 멤버의 마지막으로 읽은 채팅 번호 업데이트를 위해 chatMemberVo 생성
			ChatMemberVO chatMemberVo = new ChatMemberVO();
			chatMemberVo.setChatroomNo(chatroomNo);
			chatMemberVo.setMemberNo(memberNo);

			// 채팅방 진입 전, 마지막으로 읽은 채팅 번호 조회 
			entryNotiChat.setLastReadChatNo(chatServiceImpl.selectLastReadChatNo(chatMemberVo));
			
			// 채팅방에 진입 시, 마지막으로 읽은 채팅 번호가 변경되므로 update 해줌 
			entryNotiChat.setChatNo(chatServiceImpl.selectRoomLastChatNo(chatroomNo));
			chatServiceImpl.updateLastReadChatNo(entryNotiChat);
			
			// 채팅방 접속자에게 진입 소식을 알림
			log.info("sub 연결됨 : "+ entryNotiChat.toString());
			template.convertAndSend(destination, entryNotiChat);

		}
	}
	
	/**
	 * 사용자가 채팅방에서 나갔을 때(구독 취소할 때) 실행되는 이벤트 리스너
	 * @param event
	 */
	@EventListener
	public void handleSessionUnsubscribeEvent(SessionUnsubscribeEvent event) {
		StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
		
		String subscriptionId = headerAccessor.getSubscriptionId();
		Integer chatroomNo = subscriptionMap.get(subscriptionId);	
		
		if(chatroomNo != null) {
			MemberVO loginUser = (MemberVO) headerAccessor.getSessionAttributes().get("loginUser");
			if(loginUser == null) return;
			int memberNo = loginUser.getMemberNo();
			
			subscriptionMap.remove(subscriptionId);
			chatroomAttendance.get(chatroomNo).remove(memberNo);
			
			ChatVO exitNotiChat = new ChatVO();
			exitNotiChat.setChatType("EXIT");
			exitNotiChat.setChatroomNo(chatroomNo);
			exitNotiChat.setMemberNo(memberNo);
			exitNotiChat.setCurrentOnlineCnt(chatroomAttendance.get(chatroomNo).size());
			
			log.info("sub 연결 끊김 : "+ exitNotiChat.toString());

			template.convertAndSend("/sub/chat/chatroom/"+ chatroomNo, exitNotiChat);
		}
	}
	
	/**
	 * 사용자가 브라우저를 끄거나(F5 포함) 강제로 연결이 끊어졌을 때 실행되는 리스너
	 */
	@EventListener
	public void handleSessionDisconnectEvent(SessionDisconnectEvent event) {
	    StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());

	    // 누가 연결을 끊었는지 세션에서 찾기
	    MemberVO loginUser = (MemberVO) headerAccessor.getSessionAttributes().get("loginUser");
	    if(loginUser == null) return;
	    
	    int memberNo = loginUser.getMemberNo();

	    // 이 사람이 들어있는 채팅방을 찾기
	    for (Map.Entry<Integer, Set<Integer>> entry : chatroomAttendance.entrySet()) {
	        Integer chatroomNo = entry.getKey();
	        Set<Integer> members = entry.getValue();

	        if (members.contains(memberNo)) {
	            members.remove(memberNo);
	            
	            ChatVO exitNotiChat = new ChatVO();
	            exitNotiChat.setChatType("EXIT");
	            exitNotiChat.setChatroomNo(chatroomNo);
	            exitNotiChat.setMemberNo(memberNo);
	            exitNotiChat.setCurrentOnlineCnt(members.size()); 
	            
	            log.info("강제 연결 끊김(Disconnect) : " + exitNotiChat.toString());

	            template.convertAndSend("/sub/chat/chatroom/" + chatroomNo, exitNotiChat);
	        }
	    }
	}
	
}
