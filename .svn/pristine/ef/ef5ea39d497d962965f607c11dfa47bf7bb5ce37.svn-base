package kr.or.ddit.meetingRoom.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.meetingRoom.service.IMeetingRoomService;
import kr.or.ddit.projectMember.service.IProjectMemberService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.meetingRoom.MeetingBranchVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.meetingRoom.MeetingRoomVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : MeetingRoomController
 * DESC : 회의실 지점 조회, 예약 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.17
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio/project/meetingRoom")
public class MeetingRoomController {

	@Autowired
	private IMeetingRoomService meetingRoomService;
	
	@Autowired
	private IProjectMemberService projectMemberService;
	
	@Autowired
	private IFileService fileService;
	
	// 전체 지점 목록 조회 (회의실 화면 생성)
	@GetMapping
	public String MeetingRoomPage( HttpSession session, Model model)	{
		log.info("MeetingRoomPage() 실행");
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if(loginUser == null) {
	        return "redirect:/tudio/login";
	    }
	    List<MeetingBranchVO> branchList = meetingRoomService.selectBranchList();
        model.addAttribute("branchList", branchList);
		return "project/tabs/meetingRoom/meetingRoom";
	}
	
	// 전체 회의실 사진, 주소 조회
	@GetMapping("/meetingRoomFileList")
	@ResponseBody
	public ResponseEntity<List<FileDetailVO>> getFileList(@RequestParam("fileGroupNo") int fileGroupNo) {
		log.info("getFileList() 실행");
		log.info("getFileList : fileGroupNo={}", fileGroupNo);
		List<FileDetailVO> fileList = fileService.selectFileDetailList(fileGroupNo);
		return new ResponseEntity<>(fileList, HttpStatus.OK);
	}
	
	// 전체 회의실 목록 조회
	@GetMapping("/meetingRoomList")
    public ResponseEntity<List<MeetingRoomVO>> getRooms(@RequestParam("branchId") int branchId) {
		log.info("getRooms() 실행");
        log.info("getRooms : branchId={}", branchId);
        List<MeetingRoomVO> list = meetingRoomService.selectMeetingRoomList(branchId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }
	
	// 전체 회의실 주간 예약 목록 조회
	@ResponseBody
	@GetMapping("/weekBookedTimes")
	public ResponseEntity<List<Map<String, Object>>> SelectWeekBookedMeetingRoomList(@RequestParam int roomId,
			@RequestParam String startDate, @RequestParam String endDate) {

		Map<String, Object> params = new HashMap<>();
		params.put("roomId", roomId);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		List<Map<String, Object>> list = meetingRoomService.selectWeekBookedMeetingRoomList(params);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// 회의실 예약 목록 조회 ( 703, 704, 705 사용완료,취소,미방문 건 )
	@ResponseBody
	@GetMapping("/bookedTimes")
	public ResponseEntity<List<Map<String, Object>>> SelectBookedMeetingRoomList(
	        @RequestParam int roomId, 
	        @RequestParam String date) {
	    
	    // 파라미터 맵핑
	    Map<String, Object> params = new HashMap<>();
	    params.put("roomId", roomId);
	    params.put("date", date); // YYYY-MM-DD 형식 문자열
	    
	    List<Map<String, Object>> list = meetingRoomService.selectBookedMeetingRoomList(params);
	    return new ResponseEntity<>(list, HttpStatus.OK);
	}

	
	
	
	// 회의실 예약 시 멤버 목록 조회
	@GetMapping("/projectMembers")
	public ResponseEntity<List<ProjectMemberVO>> selectProjectMemberList(@RequestParam("projectNo") int projectNo) {
		log.info("getProjectMembers : projectNo={}", projectNo);
		List<ProjectMemberVO> memberList = projectMemberService.projectMemberList(projectNo);
		return new ResponseEntity<>(memberList, HttpStatus.OK);
	}
	
	// 회의실 예약 등록
	@PostMapping("/reservation")
	@ResponseBody
	public ResponseEntity<String> insertReservation(@RequestBody MeetingReservationVO reservationVO) {
		log.info("insertReservation 실행: {}", reservationVO);
		try {
			meetingRoomService.insertReservation(reservationVO); // 서비스 호출
			return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			log.error("예약 등록 실패", e);
			return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	
	// 회의실 예약 목록 조회 ( 701,702 신청, 확정건)
	@GetMapping("/meetingReservation")
	public String selectReservationList(
	        @RequestParam(value = "filter", defaultValue = "ACTIVE") String filter, // 필터 파라미터 추가
	        Model model, HttpSession session) {
	    
	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/tudio/login";
	    }

	    // Map에 담아서 쿼리로 전달
	    Map<String, Object> map = new HashMap<>();
	    map.put("memberNo", loginUser.getMemberNo());
	    map.put("filterType", filter);

	    List<MeetingReservationVO> list = meetingRoomService.selectReservationList(map);
	    
	    model.addAttribute("reservationList", list);
	    model.addAttribute("currentFilter", filter); // 현재 탭 활성화를 위해 전달
	    
	    return "project/tabs/meetingRoom/meetingReservation";
	}
	
	
	// 회의실 예약 취소
	@PostMapping("/cancelReservation")
	@ResponseBody
	public String cancelReservation(@RequestBody MeetingReservationVO reservationVO, HttpSession session){
	    log.info("cancelReservation 실행: reservationId={}", reservationVO.getReservationId());
	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if(loginUser == null) {
	        return "FAIL";
	    }
	    reservationVO.setMemberNo(loginUser.getMemberNo());
	    try {
	        meetingRoomService.cancelReservation(reservationVO);
	        return "SUCCESS";
	    } catch (Exception e) {
	        log.error("예약 취소 실패", e);
	        return "FAIL";
	    }
	}
	
	// 회의실 예약 상세 정보
	@ResponseBody
    @GetMapping("/detailReservation")
    public ResponseEntity<MeetingReservationVO> getReservationDetail(@RequestParam int reservationId) {
        MeetingReservationVO vo = meetingRoomService.selectReservationDetail(reservationId);
        return new ResponseEntity<>(vo, HttpStatus.OK);
    }
	
	
	// 회의실 예약 수정
	@PostMapping("/updateReservation")
    @ResponseBody
    public ResponseEntity<String> updateReservation(@RequestBody MeetingReservationVO reservationVO) {
        log.info("updateReservation 실행: {}", reservationVO);
        try {
            meetingRoomService.updateReservation(reservationVO);
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } catch (Exception e) {
            log.error("예약 수정 실패", e);
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
	
}
