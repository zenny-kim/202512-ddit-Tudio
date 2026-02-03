package kr.or.ddit.chat.service.impl;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.chat.mapper.IChatMapper;
import kr.or.ddit.chat.service.IChatService;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.chat.ChatMemberVO;
import kr.or.ddit.vo.chat.ChatVO;
import kr.or.ddit.vo.chat.ChatroomVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatServiceImpl implements IChatService{

	@Autowired
	private IChatMapper chatMapper;
	
	@Autowired
	private IFileMapper fileMapper;

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormat = new SimpleDateFormat("a hh:mm");
	
	/**
	 * 로그인한 멤버의 안읽은 모든 채팅 수 조회
	 */
	@Override
	public int selectNotReadChatCnt(int memberNo) {
		return chatMapper.selectNotReadChatCnt(memberNo);
	}
	
	/**
	 * 채팅방 목록 조회
	 */
	@Override
	public List<ChatroomVO> selectChatroomList(int memberNo) {
		List<ChatroomVO> chatroomList = chatMapper.selectChatroomList(memberNo);

		// 각 채팅방별 마지막 채팅 출력 날짜의 포맷을 변경
		for(ChatroomVO chatroom : chatroomList) {
			
			Date lastChatDate = chatroom.getLastChatDate();
			
			if(lastChatDate != null) {
				String today = dateFormat.format(new Date());
				String yesterday = dateFormat.format(new Date(new Date().getTime() - 60*60*24*1000*1));
				String strLastChatDate = dateFormat.format(chatroom.getLastChatDate());
			
				if(today.equals(strLastChatDate)) {
					chatroom.setFmtLastChatDate(timeFormat.format(lastChatDate));
				}else if(yesterday.equals(strLastChatDate)) {
					chatroom.setFmtLastChatDate("어제");
				}else {
					chatroom.setFmtLastChatDate(dateFormat.format(lastChatDate));
				}
			}
		}
		
		return chatroomList;
	}

	/**
	 * 특정 채팅방의 채팅 메세지 리스트 조회
	 */
	@Override
	public List<ChatVO> selectChatList(ChatVO chatVo) {
		List<ChatVO> chatList = chatMapper.selectChatList(chatVo);
		
		// 채팅방 진입시에 채팅 목록을 조회할테니, 그때 읽은 메세지 번호를 업데이트 해줌
		/*
		if(!chatList.isEmpty()) {
			chatVo.setChatNo(chatList.get(chatList.size()-1).getChatNo());
			chatMapper.updateLastReadChatNo(chatVo);
		}
		*/
		
		// 각 채팅방마다 시간 포맷팅 
		for(ChatVO chat : chatList) {
			chat.setFmtCreateDate(timeFormat.format(chat.getCreateDate()));
			if(chat.getFileAttachNo() > 0 ) {
				chat.setFile(fileMapper.selectFileDetail(chat.getFileAttachNo()));
			}
		}
		
		return chatList;
	}
	
	/**
	 * 로그인한 유저가 특정 채팅방에서 마지막으로 읽은 채팅 번호 조회  
	 * @param chatMemberVo
	 * @return 마지막으로 읽은 채팅 번호 
	 */
	@Override
	public int selectLastReadChatNo(ChatMemberVO chatMemberVo) {
		return chatMapper.selectLastReadChatNo(chatMemberVo);
	}

	/**
	 * 채팅방 내부의 header 정보 조회
	 */
	@Override
	public Map<String, Object> selectChatroomTitle(ChatVO chatVo) {
		return chatMapper.selectChatroomTitle(chatVo);
	}

	/**
	 * 로그인한 멤버가 속해있는 모든 프로젝트의 구성원 목록 조회
	 */
	@Override
	public List<MemberVO> selectProjectMemberList(ChatVO chatVo) {
		return chatMapper.selectProjectMemberList(chatVo);
	}

	/**
	 * 로그인한 멤버가 접속해있던(접속하는) 채팅방의 마지막으로 읽은 메세지 번호 업데이트 
	 */
	@Override
	public void updateLastReadChatNo(ChatVO chatVo) {
		chatMapper.updateLastReadChatNo(chatVo);
	}
	
	/**
	 * 특정 멤버와의 1대1 채팅방이 존재하는지 확인
	 * @param memberNoMap 로그인한 멤버의 memberNo와 1대1 채팅을 할 특정 멤버의 memberNo
	 * @return 1대1 채팅방이 없으면 0, 있으면 해당 chatroomNo
	 */
	@Override
	public int selectIsExistChatroom(Map<String, Integer> memberNoMap) {
		return chatMapper.selectIsExistChatroom(memberNoMap);
	}
	
	/**
	 * 새 채팅방 추가
	 */
	@Transactional
	@Override
	public ServiceResult insertChatroom(
			ChatroomVO chatroomVo, 
			Map<String, Integer> privateMemberNoMap, 
			Map<String, String> privateMemberNameMap) {
		
		ServiceResult result = null;
		
		// 채팅방 추가
		int status = chatMapper.insertChatroom(chatroomVo);
		if(status > 0) {
			List<Integer> chatMemberVoList = chatroomVo.getChatMemberNoList();
			
			// 초대 메세지 추가
			ChatVO chatVo = new ChatVO();
			if(chatroomVo.getMemCount() > 2) {
				String systemMsg = makeInviteChat(chatroomVo.getChatMemberNameList());
				
				Date now = new Date();
				chatVo.setCreateDate(now);
				chatVo.setChatroomNo(chatroomVo.getChatroomNo());
				chatVo.setChatType("SYSTEM");
				chatVo.setMessage(systemMsg);
				log.info("myLog: "+ systemMsg);
				
				chatMapper.insertSystemChat(chatVo);
			}
			
			// 채팅 멤버 추가 (방금 추가한 채팅방의 구성원들을 추가해줌)
			String chatroomName = "";
			for(Integer chatMemberNo : chatMemberVoList) {
				// 개인 채팅방인 경우,
				if(chatroomVo.getChatroomType().equals("PRIVATE")) {
					// 채팅방의 이름을 상대방의 이름으로 변경해줌 
					if(chatMemberNo == privateMemberNoMap.get("myMemNo")) {
						chatroomName =  privateMemberNameMap.get("youMemName");
					}else if(chatMemberNo == privateMemberNoMap.get("youMemNo")) {
						chatroomName = privateMemberNameMap.get("myMemName");
					}
				} else {
					chatroomName = chatroomVo.getChatroomName();
				}
				
				ChatMemberVO chatMemberVo = new ChatMemberVO();
				chatMemberVo.setChatroomNo(chatroomVo.getChatroomNo());
				chatMemberVo.setMemberNo(chatMemberNo);
				chatMemberVo.setChatroomName(chatroomName);
				chatMemberVo.setLastReadChatNo(chatVo.getChatNo());
				chatMapper.insertChatMember(chatMemberVo);
			}
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * 새 채팅 추가
	 */
	@Transactional
	@Override
	public ServiceResult insertChat(ChatVO chatVo) {
		ServiceResult result = null;
		int status = chatMapper.insertChat(chatVo);
		if(status > 0) {
			result = ServiceResult.OK;
			chatVo.setFmtCreateDate(timeFormat.format(chatVo.getCreateDate()));

			// 채팅방 목록에 띄울 마지막 메세지 update
			ChatroomVO chatroomVo = new ChatroomVO();
			chatroomVo.setLastChat(chatVo.getMessage());
			chatroomVo.setLastChatDate(chatVo.getCreateDate());
			chatroomVo.setChatroomNo(chatVo.getChatroomNo());
			chatMapper.updateLastChat(chatroomVo);
			
			// 본인의 마지막으로 읽은 채팅 번호 변경
			chatMapper.updateLastReadChatNo(chatVo);
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * 현재 접속해있는 채팅방의 모든 멤버들에게 메세지를 전송하기 위해
	 * 해당 채팅방의 멤버 목록 조회 
	 */
	@Override
	public List<Integer> selectChatroomMemList(int chatroomNo) {
		return chatMapper.selectChatroomMemList(chatroomNo);
	}

	/** 
	 * 특정 채팅방의 마지막 채팅 번호 조회
	 */
	@Override
	public int selectRoomLastChatNo(int chatroomNo) {
		return chatMapper.selectRoomLastChatNo(chatroomNo);
	}	
	
	/**
	 * 특정 채팅방에 대화상대 추가 
	 */
	@Transactional
	@Override
	public ChatVO insertChatMember(ChatroomVO chatroomVo){
		// 초대 메세지 생성
		ChatVO systemChat = new ChatVO();
		systemChat.setChatroomNo(chatroomVo.getChatroomNo());
		systemChat.setChatType("SYSTEM");
		
		int index = 0;
		String systemMassage = chatroomVo.getInviter() + "님이 ";
		for(String memName: chatroomVo.getChatMemberNameList()) {
			if(index == chatroomVo.getChatMemberNameList().size()-1) {
				systemMassage += memName + "님을 초대했습니다.";
				break;
			}else {
				systemMassage += memName + "님, ";
				index++;
			}
		}
		systemChat.setMessage(systemMassage);

		// 채팅방에 초대 메세지 추가하기
		chatMapper.insertSystemChat(systemChat);
		
		// 채팅방 인원수 및 타입 업데이트
		Map<String, Object> inviteInfo = new HashMap<>();
		inviteInfo.put("changeCount", chatroomVo.getChatMemberNoList().size());
		inviteInfo.put("chatroomNo", chatroomVo.getChatroomNo());
		inviteInfo.put("chatroomType", "GROUP");
		chatMapper.updateChatroomInfo(inviteInfo);
		
		// 채팅 멤버 추가
		for(Integer chatMemberNo : chatroomVo.getChatMemberNoList()) {
			ChatMemberVO chatMemberVo = new ChatMemberVO();
			chatMemberVo.setChatroomNo(chatroomVo.getChatroomNo());
			chatMemberVo.setMemberNo(chatMemberNo);
			chatMemberVo.setLastReadChatNo(systemChat.getChatNo());
			chatMapper.insertChatMember(chatMemberVo);
		}
		
		return systemChat;
	}
	
	/**
	 * 채팅방에서 나갈 시, 로그인한 유저를 해당 채팅방에서 삭제 처리
	 */
	@Transactional
	@Override
	public Map<String, Object> deleteChatMember(Map<String, Object> deleteInfo) {
		Map<String, Object> delResultMap = new HashMap<>();
		// 채팅방 멤버 삭제
		int status = chatMapper.deleteChatMember(deleteInfo);
		
		if(status > 0) {
			ChatVO systemChat = new ChatVO();
			systemChat.setChatroomNo((int)deleteInfo.get("chatroomNo"));
			systemChat.setChatType("SYSTEM");
			systemChat.setMessage(deleteInfo.get("memberName") + "님이 나갔습니다.");

			// 채팅방에 퇴장 메세지 추가하기
			chatMapper.insertSystemChat(systemChat);
			
			// 채팅방 인원수 및 타입 업데이트 
			// 해당 멤버가 나가면 1대1 채팅방이 되는 경우
			if((int)deleteInfo.get("memCount") <= 3) {	
				deleteInfo.put("changeCount", -1);
				deleteInfo.put("chatroomType", "PRIVATE");
				chatMapper.updateChatroomInfo(deleteInfo);
			}
			
			// 해당 멤버가 나가면 아무도 없는 채팅방이 되는 경우
			if((int)deleteInfo.get("memCount") <= 1) {
				// 모든 채팅 삭제 후, 채팅방을 삭제
				chatMapper.deleteAllChat((int)deleteInfo.get("chatroomNo"));
				chatMapper.deleteChatroom((int)deleteInfo.get("chatroomNo"));
			}
			
			delResultMap.put("result", ServiceResult.OK);
			delResultMap.put("chatVo", systemChat);
		}else {
			delResultMap.put("result", ServiceResult.FAILED);
		}
		
		return delResultMap;
	}
	
	/**
	 * 채팅방 초대 메세지 생성 메서드 
	 * @param chatMemberNameList
	 * @return 초대 메세지
	 */
	public String makeInviteChat(List<String> chatMemberNameList) {
		String myName = chatMemberNameList.get(chatMemberNameList.size()-1);
		String systemMsg = myName + "님이 ";
		
		for(int i = 0; i< chatMemberNameList.size()-1; i++) {
			systemMsg += chatMemberNameList.get(i);
			if(i == chatMemberNameList.size()-2) {
				systemMsg += "님을 초대했습니다.";
			} else {
				systemMsg += "님, ";
			}
		}
		
		return systemMsg;
	}

}
