package kr.or.ddit.vo.chat;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class ChatroomVO {
	private int chatroomNo;
	private String chatroomName;
	private String chatroomType;
	private String lastChat;
	private Date lastChatDate;
	
	// 각 채팅방마다 사용자가 읽지 않은 메세지 수
	private int notReadCnt;
	// 각 채팅방 인원수
	private int memCount;
	// 예쁘게 formatting 한 마지막 채팅 날짜(혹은 시간)
	private String fmtLastChatDate;
	
	private List<Integer> chatMemberNoList;
	
	private List<String> chatMemberNameList;
	
	// 채팅 멤버를 초대한 사람
	private String inviter;
	
}
