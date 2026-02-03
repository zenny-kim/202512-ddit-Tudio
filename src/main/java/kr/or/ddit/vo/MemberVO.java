package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.project.ProjectVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MemberVO extends PaginationInfoVO<MemberVO> {
	
	//유효성 검사용 비밀번호 확인
	private String memberPwConfirm;
		
	 private int memberNo;				//회원고유번호
	 private String memberId;			//회원아이디
	 private String memberPw;			//비밀번호
	 private String memberName;			//회원이름
	 
	 //0으로 시작하는 전화번호이기때문에 String 으로 변경
	 private String memberTel;			//연락처
	 private String companyNo;			//사업자등록번호
	 private String companyNoStatus;	//사업자등록증 인증상태
	 private String memberEmail;		//이메일
	 private String emailStatus;		//이메일인증상태
	 private String memberDepartment;	//부서
	 private String memberPosition;		//직책
	 private String selectiveConsent;	//선택약관 동의
	 private String memberJoinDate;		//가입일
	 private String memberLeaveDate;	//탈퇴일
	 private String leaveStatus;		//탈퇴상태
	 private String leaveReason;		//탈퇴사유
	 
	 // 생년월일도 0 으로 시작할 수 있어 String 으로 변경
	 private String memberRegno;		//주민번호
	 private String memberProfileimg;	//프로필이미지
	 // 파일 업로드를 위해 추가
	 private MultipartFile profileImageFile;
	 
	 private List<MemberAuthVO> memberAuthVOList;
	 
	 //회원정보 수정 시 회사명 담기. 쿼리 작성 시 join 필요
	 private String companyName;

	 //알림설정 관련
	 private NotificationSettingVO notificationSettingVO;
	 
	 // 프로젝트 내 Role
	 private String memberRole;
	 
	 // 채팅에서 구성원 초대 시, 프로젝트별로 회원을 분류하기 위한 프로젝트 List
	 private List<ProjectVO> projectList;
	 
	 // 비회원 회원가입 후 프로젝트 자동 초대를 위한 토큰 정보
	 private String token;
	 
	 private int projectCount;      // 참여 프로젝트 수
	 private String lastLoginDate;  // 최근 접속일
	 private int daysSinceLogin;    // 오늘 기준 미접속 일수
	 
	 private String type;            // 검색 유형 
	 private String searchKeyword;   // 검색어
}
