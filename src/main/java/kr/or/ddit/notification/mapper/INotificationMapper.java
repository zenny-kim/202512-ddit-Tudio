package kr.or.ddit.notification.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.InquiryVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationSettingVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.project.ProjectBoardVO;

@Mapper
public interface INotificationMapper {

	// 알림 테이블에 알림정보 저장하기
	public int insertNoti(NotificationVO vo);
	
	// 프로젝트 생성/수정 시 초대 알림 일괄 등록
    public int insertNotificationsBatch(List<NotificationVO> list);

	public int selectUnreadCount(int memberNo);

	public int insertNotiEnabled(Map<String, Object> insertNotiEnabledParam);

	public List<NotificationVO> notiList(Map<String, Object> notiParam);

	public void updateRead(Map<String, Object> notiMarkReadParam);

	public int deleteNoti(Map<String, Object> notiDeleteParam);
	
	public void insertSiteNoticeNoti(Map<String, Object> siteNotiParam);

	// 멤버별 알림 설정 ON/OFF
	public NotificationSettingVO notiSettingMember(String memberNo);


	// 공지사항 알림을 킨 사람
	public NotificationSettingVO notiSiteMember(int memberNo);

	
	// 공지사항 알림 설정은 on한 회원들
	public List<MemberVO> notiSiteMember();

	public void insertSiteNoticeNoti(NotificationVO vo);

	
	// 내가 쓴 게시글의 댓글 알림
	public ProjectBoardVO notiCommentNoti(int boNo);
	
	
	// 회원의 알림 설정 조회 
	public NotificationSettingVO notiAllMember(int memberNo);
	
	// 댓글 부모, 글작성자 조회 
	public Map<String, Object> selectNotiReply(Map<String, Object> map);


	// 회원 권한 확인하기
	public String selectAuthNoti(int memberNo);

	
	// 프로젝트 공지사항 알림테이블에 일괄 등록
	public void insertProjectNoticeNoti(Map<String, Object> map);

	// 프로젝트 변경시 멤버 푸시 대상 목록 조회 (설정없음)
	 List<Integer> selectProjectUpdateNoti(Map<String, Object> param);
	 
    // 프로젝트 변경시 푸쉬 대상을 DB 일괄 insert
	 int insertProjectUpdateNoti(NotificationVO vo);
	 
	// 대시보드 알림 위젯 상태 변경
	public int toggleNotificationRead(Map<String, Object> params);

	
	// 커뮤니티 공지사항 알림(대상 조회) 
	public List<Integer> selectProjectNoticeNoti(NotificationVO vo);
	
	// 커뮤니티 공지사항 알림
	public void pushProjectNotice(NotificationVO vo, Map<String, Object> map);
	
	// 마감일일 1일 이하로 남은 스케줄 조회
	public List<NotificationVO> selectScheduleNoti();
	
	// 30일이 지난 알림메세지 자동 삭제
	public int deleteOldNoti();
	
	// 회의실 알림 발송 대상
	public List<MeetingReservationVO> selectMeetingRoomNoti(MeetingReservationVO vo);
	
	// 회의실 예약 취소
	public List<MeetingReservationVO> selectCancelMeetingRoomNoti(int reservationId);
	
	// 기안 알림 대상(첫)
	public DraftApprovalVO selectDocumentNoti(Map<String,Object> map);
	
	// 다음 기안 결재자 정보 
	public DraftApprovalVO selectDocumentNextNoti(Map<String,Object> map);
	
	// 다음 결재자 
	public Integer selectNextApprovalStep(@Param("documentNo")int documentNo, @Param("currentStep")int currentStep);
	
	// 기안서 작성자 조회
	public DraftApprovalVO selectApprovalWriterNoti(int documentNo);
	
	//내가 몇 차 결재자인지 조회
	int selectMyApprovalStep(@Param("documentNo") int documentNo, @Param("memberNo") int memberNo);
	
	// 문의사항 작성자 대상
	public InquiryVO selectInquiryNoti(int inquiryNo);
	
	// 화상채팅 알림 대상 
	public List<VideoChatVO> selectVideoInviteNotiTargets(VideoChatVO vo);
	
	public void insertTaskManagerNoti(Map<String, Object> map);
	
	public int selectTaskWriter(int taskId);
	
	public String selectProjectName(int projectNo);
	
	public Integer selectProjectNoByTaskId(int taskId);
	
	public List<Integer> selectSubManagerPmNoti(int taskId);
}
