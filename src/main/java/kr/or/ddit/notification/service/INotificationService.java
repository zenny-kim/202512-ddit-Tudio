package kr.or.ddit.notification.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationSettingVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.project.ProjectBoardVO;

public interface INotificationService {

	/**
	 * 안읽은 알림 개수
	 *
	 * @param memberNo 수신자
	 * @return 안읽음 알림 개수
	 */
	public int notiUnreadCount(int memberNo);

	/**
	 * 특정 알림 삭제(물리)
	 *
	 * @param memberNo 수신자
	 * @param notiNo   삭제할 알림 번호
	 */
	public void notiDelete(int memberNo, long notiNo);

	/**
	 * 특정 알림 1건 읽음 처리
	 *
	 * @param memberNo 수신자
	 * @param notiNo   읽음처리할 알림 번호
	 */
	public void notiMarkRead(int memberNo, long notiNo);

	/**
	 * 알림 목록 조회 (전체 / 안읽음만)
	 *
	 * @param memberNo    
	 * @param unreadOnly  
	 * @return 알림 리스트
	 */
	public List<NotificationVO> notiList(int memberNo, boolean unreadOnly);

	
	/**
	 *  사이트 공지사항 DB저장 
	 * @param siteNotiParam
	 */
	public void insertSiteNoticeNoti(NotificationVO vo);
	

	/**
	 *  프로젝트 초대 (전체알림) 
	 * @param siteNotiParam
	 */
	public int insertProjectInviteNoti(NotificationVO vo);
	
	/**
	 * 프로젝트 초대 알림 일괄 처리
	 * @author YHB
	 * @param notiList
	 * @return
	 */
	public int insertProjectInviteNotiBatch(List<NotificationVO> notiList);

	 
	 /**
	  * 읽음 탭과 안읽음 탭 구분
	  * @param memberNo
	  * @param tab
	  * @return
	  */
	public List<NotificationVO> notiListByTab(int memberNo, String tab);
	

	// 공지사항 on한 모든 회원들
	public List<MemberVO> notiSiteMember();
	
	/**
	 * 공지사항 알림 발송 
	 * @return
	 */
	public void pushSiteNotice(int targetId, String notiUrl, String notiMessage);


	/**
	 * 내가 쓴 게시글에 댓글이 달렸을 때 알림 
	 * @param boNo
	 * @return
	 */
	public ProjectBoardVO notiCommentNoti(int boNo);
	
	
	
	// 회원의 알림 설정 조회 
	public NotificationSettingVO notiAllMember(int memberNo);
	
	
	// 회원의 알림 설정 조회 memberNo, notiType,targetId,notiUrl,notiMessage
	public int insertNotification(NotificationVO vo);
	
	
	// 댓글 부모, 글작성자 조회 
	public Map<String, Object> selectNotiReply(Map<String, Object> map);
	
	
	// 회원 권한 확인하기
	public String selectAuthNoti(int memberNo);
	
	
	// 프로젝트 내 공지사항 알림 일괄 등록
	public void insertProjectNoticeNoti(Map<String, Object> map);
	
	
	// 프로젝트 멤버 푸시 대상 조회
	public List<Integer> selectProjectNoticeNoti(int projectNo, int writerNo);
	 
	// 프로젝트 변경시 멤버 푸시 대상 목록 조회 (설정없음)
	List<Integer> selectProjectUpdateNoti(Map<String, Object> param);
	 
    // 프로젝트 변경시 푸쉬 대상을 DB 일괄 insert
	int insertProjectUpdateNoti(NotificationVO vo); 
	 
	// 프로젝트 변경시 호출 메서드
	public void pushProjectUpdateNoti(NotificationVO vo, int projectNo, int writerNo);
	
	// 대시보드 알림 위젯 상태 변경 토글
	public void toggleNotificationRead(int memberNo, long notiNo);

	
	// 커뮤니티 공지사항 알림 발송 
	public void pushProjectNotice(NotificationVO notiVO, Map<String, Object> notiMap);
	
	// 스케줄러
	public void pushScheduleNoti();
	
	// 30일이 지난 알림메세지 자동 삭제
	public int deleteOldNoti();
	
	
	// 회의실 예약 알림 발송
	public void pushMeetingRoomNoti(MeetingReservationVO meetingVO, NotificationVO notiVO);

	// 회의실 예약 취소 정보 조회
	public List<MeetingReservationVO> selectCancleMeetingRoomNoti(int reservationId); 
	
	// 회의실 예약 취소 알림 발송
    public void pushCancelMeetingRoomNoti(int reservationId);
    
    // 기안서 결제 승인 알림 발송
    public void pushInsertApprovalNoti(Map<String, Object>map);
    
    //남은 기안 결재자들에게 알림 발송
    public void pushinsertNextApprovalNoti(Map<String, Object> map);
    

	//기안 작성자에게 알림 발송
	public void pushApprovalWriterNoti(DraftApprovalVO vo, int step,NotificationVO notiVO);
	
	// 문의사항 답변 알림 발송
	public void pushInquiryNoti(NotificationVO notiVO,int inquiryNo);

	// 화상채팅 알림 발송 
	public void pushVideoInviteNoti(VideoChatVO vo);
	
	public void pushManagerNoti(int projectNo, int taskId,
            List<Integer> taskManagerNos,NotificationVO notiVO);
	
	public Integer selectProjectNoByTaskId(int taskId);
	
	public List<Integer> selectSubManagerPmNoti(int taskId);
}
