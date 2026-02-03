package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class VideoChatVO {
	
	// videochat_room table
	private int videochatNo;			// 화상채팅번호
	private String videochatId;			// 화상채팅방 ID
	private String videochatPw;			// 화상채팅방 비밀번호
	private String videochatUrl;		// 참여링크
	private int videochatCreaterNo;		// 생성자
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date videochatRegdate;		// 생성일자
	
	private String videochatTitle;		// 화상채팅 방이름
	private int videochatStatus;		// 화상채팅방 상태 (0: 대기, 1: 진행, 2: 종료)
	private int projectNo;				// 프로젝트 일련번호
	
	private String projectName;  // 프로젝트명
    private String creatorName;  // 개설자명
    private Date createdDate;
	
	// videochat_member table
	private List<String> inviteMemberList;  // 초대 회원 번호 목록
	
	// 알림
    private int memberNo; 	    		// 알림 받을 대상	
}
