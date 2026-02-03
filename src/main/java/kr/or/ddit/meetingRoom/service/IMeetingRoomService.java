package kr.or.ddit.meetingRoom.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.meetingRoom.MeetingBranchVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.meetingRoom.MeetingRoomVO;

public interface IMeetingRoomService {
	
	// 전체 지점 목록 조회
	public List<MeetingBranchVO> selectBranchList();
	
	// 전체 회의실 목록 조회
	public List<MeetingRoomVO> selectMeetingRoomList(int branchId);
	
	// 전체 회의실 주간 예약 목록 조회
	public List<Map<String, Object>> selectWeekBookedMeetingRoomList(Map<String, Object> params);
	
	///// 개인 회의실 예약 내용 /////
	
	// 회의실 예약 목록 조회 ( 701,702 신청, 확정건)
	public List<MeetingReservationVO> selectReservationList(Map<String, Object> map);
	
	// 회의실 예약 목록 조회 ( 703, 704, 705 사용완료,취소,미방문 건 )
	public List<Map<String, Object>> selectBookedMeetingRoomList(Map<String, Object> params);
	
	// 회의실 예약 등록
	public void insertReservation(MeetingReservationVO reservationVO);

	// 회의실 예약 취소
	public void cancelReservation(MeetingReservationVO reservationVO);

	// 회의실 예약 상세정보
	public MeetingReservationVO selectReservationDetail(int reservationId);

	// 회의실 예약 수정
	public void updateReservation(MeetingReservationVO reservationVO);
	
	///// 관리자용 회의실 관리 내용 /////
	
	// [관리자] 회의실 블럭용 예약 등록
	public void insertAdminReservation(MeetingReservationVO meetingReservationVO);
	
	// [관리자] 전체 예약 내역 조회
	public List<MeetingReservationVO> selectAdminMeetingRoomReservationList();
		
	// [관리자] 예약 상태 변경 (승인/반려)
	public void updateMeetingRoomReservationStatus(MeetingReservationVO meetingReservationVO);
	
	
}
