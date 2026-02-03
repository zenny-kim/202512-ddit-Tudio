package kr.or.ddit.admin.meetingRoom.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.meetingRoom.service.IMeetingRoomService;
import kr.or.ddit.vo.meetingRoom.MeetingBranchVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.meetingRoom.MeetingRoomVO;
import lombok.extern.slf4j.Slf4j;


/**
 * <pre>
 * PROJ : Tudio
 * Name : AdminMeetingRoomController
 * DESC : 지점, 회의실 조회 및 관리. 예약 관리 관리자용 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.20
 * 
 */


@Slf4j
@RestController
@RequestMapping("/admin/meetingRoom")
public class AdminMeetingRoomController {
	
	@Autowired
    private IMeetingRoomService meetingRoomService;
	
	//관리자 - 전체 지점 목록 조회
	@GetMapping("/branchList")
    public ResponseEntity<List<MeetingBranchVO>> BranchList() {
        // 기존 Service 메서드 재활용
        List<MeetingBranchVO> branchList = meetingRoomService.selectBranchList();
        return new ResponseEntity<>(branchList, HttpStatus.OK);
    }
	
	// 관리자 - 전체 회의실 목록 조회
	@ResponseBody
	@GetMapping("/meetingRoomList")
    public ResponseEntity<List<MeetingRoomVO>> MeetingRoomList(@RequestParam("branchId") int branchId) {
        // 기존 Service 메서드 재활용
        List<MeetingRoomVO> list = meetingRoomService.selectMeetingRoomList(branchId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }
	
	// 관리자 - 주간 예약 일정 조회
	@GetMapping("/weekSchedule")
    public ResponseEntity<List<Map<String, Object>>> weekSchedule(@RequestParam Map<String, Object> params) {
        log.info("[Admin] 주간 스케줄 조회: {}", params);
        // Service의 selectWeekBookedMeetingRoomList 메서드 활용
        List<Map<String, Object>> list = meetingRoomService.selectWeekBookedMeetingRoomList(params);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }
	
	
	// 관리자 - 회의실 예약 추가 ( 관리가 들어갈 경우 )
	@PostMapping("/block")
    public ResponseEntity<String> blockMeetingRoom(@RequestBody MeetingReservationVO meetingReservationVO) {
        log.info("[Admin] 회의실 예약 막기 요청: {}", meetingReservationVO);
        
        try {
            meetingRoomService.insertAdminReservation(meetingReservationVO); 
            
            return new ResponseEntity<>("BLOCKED", HttpStatus.OK);
        } catch (Exception e) {
            log.error("예약 막기 실패", e);
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
	// 관리자 - 회의실 예약 내역 조회
	@GetMapping("/reservationList")
    public ResponseEntity<List<MeetingReservationVO>> SelectAdminMeetingRoomReservationList() {
        log.info("[Admin] 예약 전체 목록 조회 요청");
        // 관리자용 메서드 호출 (조건 없이 전체 조회)
        List<MeetingReservationVO> list = meetingRoomService.selectAdminMeetingRoomReservationList();
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    // 관리자 - 회의실 예약 내역 승인 / 반려
    @PostMapping("/updateStatus")
    public ResponseEntity<String> updateMeetingRoomReservationStatus(@RequestBody MeetingReservationVO vo) {
        log.info("[Admin] 상태 변경 요청: ID={}, Status={}, Content={}", 
                 vo.getReservationId(), vo.getResStatus(), vo.getResContent());
        
        try {
            // 상태 업데이트 (702:확정, 703:반려)
            meetingRoomService.updateMeetingRoomReservationStatus(vo);
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } catch (Exception e) {
            log.error("상태 변경 실패", e);
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
}
