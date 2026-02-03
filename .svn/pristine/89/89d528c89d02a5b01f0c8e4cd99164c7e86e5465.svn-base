package kr.or.ddit.vo.project;

import java.util.Date;

import lombok.Data;

@Data
public class ProjectMemberVO {
	private int projectNo;					// 프로젝트 일련번호
	private int memberNo;					// 회원번호
	private String projectMemregdate;		// 구성원 등록일시
	private String projectMemstatus;		// 구성원 사용여부 (Y:활성 / N:비활성 / P:초대중)
	private String projectRole;				// 프로젝트 권한 (PROJECT_MANAGER, PROJECT_MEMBER, PROJECT_CLIENT)
	private String projectBookmark;			// 프로젝트 북마크 여부 (Y:북마크 설정)
	
	// 구성원 조회 정보
	private int companyNo;
	private String companyName;
	private String memberId;
	private String memberName;		
	private String memberTel;
	private String memberProfileImg;
	private String memberDepartment;
	private String memberPosition;
	private int doneSubCnt;
	private int totalCnt;
	private int doneCnt;
	private int ingCnt;
	private int totalTaskCnt; // 구성원 업무수 갯수
	private int taskCnt;
	private int taskSubCnt;
	private int ingSubCnt;
	private int delayCnt;
	private int holdCnt;
	private String memberAuth;
	
	// 구성원 초대를 위한 정보
	private String projectName;     // 프로젝트 이름

	private String inviteToken;     // 초대 토큰
	private int inviterNo;          // 초대한 회원의 회원번호(프로젝트 관리자)
	private String memberEmail;		// 초대받은 이메일(invitee_email)
	private Date expiryDate;  		// 만료시간
	private String usedYn;    		// 사용여부
	private Date regDate;			// 발송일
	
	// 프로잭트 결과보고서 작성을 위한 정보
	private int memberTotalTaskCount; // 해당 멤버의 총 배정 업무
    private int memberDoneTaskCount;  // 해당 멤버의 완료 업무
    private double contributionRate;  // 기여도 (전체 완료 업무 중 본인 비중)
}
