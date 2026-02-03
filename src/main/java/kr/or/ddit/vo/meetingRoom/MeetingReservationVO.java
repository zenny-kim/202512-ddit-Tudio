package kr.or.ddit.vo.meetingRoom;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class MeetingReservationVO  {
	
	private int reservationId;      	// 예약 일련번호
    private int roomId;             	// 회의실 일련번호
    private int projectNo;         	 	// 프로젝트 번호
    private int memberNo;           	// 예약자
    private String resMeetingTitle; 	// 예약 제목
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime resStartdate;	//예약 시작시간
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime resEnddate;   // 예약 종료시간
    private int resStatus;          	// 예약 상태코드  (701 : 예약 신청 702 : 예약 확정 703 : 예약 취소 704 : 이용 완료 705 : 미방문)
    private String resMemo;         	// 취소/반려 사유
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime resRegdate;   // 예약 신청일
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime resUpddate;   // 예약 수정일

    private int resUpdmember;   		// 예약 수정자
    private String resType;         	// 예약 구분코드 ( P : 프로젝트 참여자 예약 / B : 관리자 블럭 )
    private String resContent;      	// 예약 불가 사유
	
    //예약 시 참여 회원
    private List<Integer> memberList;
    private String memberListName;
    
    //예약 목록 관련
    private String branchName; 			// 지점명
    private String roomName;   			// 회의실명
    private String memberName;			// 예약자명
    
    // 알림 대상 관련 
    private int reciverMember; 			// 회의실 알림 저장 대상
    private String projectName;			// 프로젝트제목
    
}
