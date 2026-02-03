package kr.or.ddit.meetingRoom.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun.nio.sctp.Notification;

import kr.or.ddit.meetingRoom.mapper.IMeetingRoomMapper;
import kr.or.ddit.meetingRoom.service.IMeetingRoomService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.util.DateFormatUtil;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.meetingRoom.MeetingBranchVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.meetingRoom.MeetingRoomVO;

@Service
public class MeetingRoomServiceImpl implements IMeetingRoomService {

	@Autowired
	private IMeetingRoomMapper meetingRoomMapper;

	@Autowired
	private INotificationService notiService;

	// 전체 지점 목록 조회
	@Override
	public List<MeetingBranchVO> selectBranchList() {
		return meetingRoomMapper.selectBranchList();
	}

	// 전체 회의실 목록 조회
	@Override
	public List<MeetingRoomVO> selectMeetingRoomList(int branchId) {
		return meetingRoomMapper.selectMeetingRoomList(branchId);
	}

	// 전체 회의실 주간 예약 목록 조회
	@Override
	public List<Map<String, Object>> selectWeekBookedMeetingRoomList(Map<String, Object> params) {
		return meetingRoomMapper.selectWeekBookedMeetingRoomList(params);
	}

	///// 개인 회의실 예약 내용 /////

	// 회의실 예약 목록 조회 ( 701,702 신청, 확정건)
	@Override
	public List<MeetingReservationVO> selectReservationList(Map<String, Object> map) {
		return meetingRoomMapper.selectReservationList(map);
	}

	// 회의실 예약 목록 조회 ( 703, 704, 705 사용완료,취소,미방문 건 )
	@Override
	public List<Map<String, Object>> selectBookedMeetingRoomList(Map<String, Object> params) {
		return meetingRoomMapper.selectBookedMeetingRoomList(params);
	}

	// 회의실 예약 등록
	@Override
	@Transactional
	public void insertReservation(MeetingReservationVO reservationVO) {
		meetingRoomMapper.insertReservation(reservationVO);
		int reservationId = reservationVO.getReservationId();
		List<Integer> memberList = reservationVO.getMemberList();
		if (memberList != null && !memberList.isEmpty()) {
			for (int memberNo : memberList) {
				meetingRoomMapper.insertReservationMember(reservationId, memberNo);
			}
		}

	}

	// 회의실 예약 취소
	@Override
	@Transactional
	public void cancelReservation(MeetingReservationVO reservationVO) {
		meetingRoomMapper.cancelReservation(reservationVO);

		
		// 회의실 예약 취소 알림 
		 notiService.pushCancelMeetingRoomNoti(reservationVO.getReservationId());
		

	}

	// 회의실 예약 상세정보
	@Override
	public MeetingReservationVO selectReservationDetail(int reservationId) {
		return meetingRoomMapper.selectReservationDetail(reservationId);
	}

	// 회의실 예약 수정
	@Override
	@Transactional
	public void updateReservation(MeetingReservationVO reservationVO) {
		meetingRoomMapper.updateReservation(reservationVO);
		meetingRoomMapper.deleteReservationMemberList(reservationVO.getReservationId());
		List<Integer> memberList = reservationVO.getMemberList();
		int reservationId = reservationVO.getReservationId();
		if (memberList != null && !memberList.isEmpty()) {
			for (int memberNo : memberList) {
				meetingRoomMapper.insertReservationMember(reservationId, memberNo);
			}
		}

		// 회의실 변경 알림 시작
		String dateText = DateFormatUtil.formatKorean(reservationVO.getResStartdate());

		NotificationVO notiVO = new NotificationVO();
		notiVO.setNotiMessage("[" + dateText + "] 회의실 예약이 변경되었습니다");
		notiService.pushMeetingRoomNoti(reservationVO, notiVO);

		// 회의실 변경 알림 끝 
	}

	///// 관리자용 회의실 관리 내용 /////

	// [관리자] 회의실 블럭용 예약 등록
	@Override
	@Transactional
	public void insertAdminReservation(MeetingReservationVO meetingReservationVO) {
		// 얘약이 있는 경우 관리자 예약 차단
		meetingRoomMapper.cancelAdminReservation(meetingReservationVO);
		// 괸리자 예약등록
		meetingRoomMapper.insertAdminReservation(meetingReservationVO);
	}

	// [관리자] 전체 예약 내역 조회
	@Override
	@Transactional
	public List<MeetingReservationVO> selectAdminMeetingRoomReservationList() {
		return meetingRoomMapper.selectAdminMeetingRoomReservationList();
	}

	// [관리자] 예약 상태 변경 (승인/반려)
	@Override
	@Transactional
	public void updateMeetingRoomReservationStatus(MeetingReservationVO meetingReservationVO) {

		int result=0;
		MeetingReservationVO dbVO = meetingRoomMapper.selectReservationDetail(meetingReservationVO.getReservationId());
		
		if ("B".equals(meetingReservationVO.getResType())) {
			
 		// 회의실 반려 알림 시작
		String dateText = DateFormatUtil.formatKorean(dbVO.getResStartdate());
		NotificationVO notiVO = new NotificationVO();
		notiVO.setNotiMessage("[" + dateText + "] 회의실 예약이 반려되었습니다");
		notiService.pushMeetingRoomNoti(meetingReservationVO, notiVO);
		
		result = meetingRoomMapper.deleteReservationMemberList(meetingReservationVO.getReservationId());

		// 회의실 반려 알림 끝 
		}
		result= meetingRoomMapper.updateMeetingRoomReservationStatus(meetingReservationVO);
		
		// 회의실 확정 알림
		

		if(result > 0) {
			String dateText = DateFormatUtil.formatKorean(dbVO.getResStartdate());
			NotificationVO notiVO = new NotificationVO();
			notiVO.setNotiMessage("[" + dateText + "]"+" 회의실 예약이 확정되었습니다");
			notiService.pushMeetingRoomNoti(meetingReservationVO, notiVO);
		}
		// 회의실 확정 알림 

	}

}
