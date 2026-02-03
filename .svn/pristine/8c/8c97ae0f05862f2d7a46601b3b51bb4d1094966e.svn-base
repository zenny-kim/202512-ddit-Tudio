package kr.or.ddit.vo.chat;

import java.util.Date;

import kr.or.ddit.vo.FileDetailVO;
import lombok.Data;

@Data
public class ChatVO {
	private int chatNo;
	private int chatroomNo;
	private int memberNo;
	private String memberName;
	private String memberProfileimg;
	private String message;
	private Date createDate;
	private int fileAttachNo;
	private String chatType;	
	private int notReadCnt;
	
	// 예쁘게 formatting 한 채팅 생성 시간
	private String fmtCreateDate;
	
	// 메세지 전송시 필요한 prefix(채팅방 타입에 따라 달라짐)
	private String subPrefix;
	
	private FileDetailVO file;

	// 현재 채팅방 접속자 인원수
	private int currentOnlineCnt;
	
	// 특정 멤버의 마지막으로 읽은 채팅 번호 (이벤트 리스너에서의 편의를 위해 추가)
	private int lastReadChatNo;
}
