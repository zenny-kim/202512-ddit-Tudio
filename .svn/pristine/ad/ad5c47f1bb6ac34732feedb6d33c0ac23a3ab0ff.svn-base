package kr.or.ddit.schedule.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.schedule.service.IScheduleService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectScheduleVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectScheduleController
 * DESC : 프로젝트 스케줄 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2025.12.30
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio")
public class ScheduleController {
	
	@Autowired
    private IFileMapper fileMapper;
	
	@Autowired
    private IScheduleService scheduleService;
	
	//스케줄 화면
	@GetMapping("/schedule")
	public String schedulePage() {
		log.info("schedulePage() 실행");
		return "schedule/schedule";
	}
	
	//스케줄 등록 모달 저장 기능
	@ResponseBody
    @PostMapping("/schedule")
    public int insertSchedule(ProjectScheduleVO scheduleVO, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if(loginUser != null) {
	        scheduleVO.setMemberNo(loginUser.getMemberNo());
	    }

	    // 2. 종일 여부 체크
	    if (scheduleVO.getScheduleAllday() == null) {
	        scheduleVO.setScheduleAllday("N");
	    }
	    log.info("도착데이터"+ scheduleVO.toString());

	    // 3. 서비스 호출 (VO 넘김)
	    return scheduleService.insertSchedule(scheduleVO);
    }
	
	//참여중 프로젝트 목록 가져오기
	@ResponseBody
	@GetMapping("/getMyProjects")
    public List<ProjectVO> getMyProjects(HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		log.info("로그인 유저 정보: {}", loginUser);
		if (loginUser != null) {
	        return scheduleService.getMyProjects(loginUser.getMemberNo());
	    }
        return new ArrayList<>();
	}
	
	//프로젝트 관련 전체 일정 가져오기 (프로젝트, 상위업무, 하위업무, 개인일정)
	@ResponseBody
	@GetMapping("/getScheduleList")
	public List<ProjectScheduleVO> getScheduleList(HttpSession session) {
	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    log.info("로그인 유저 정보: {}", loginUser);
	    if (loginUser != null) {
	        // 서비스에서 위 쿼리를 실행하도록 호출
	        return scheduleService.getScheduleList(loginUser.getMemberNo());
	    }
	    return new ArrayList<>();
	}
	
	//개인 일정 삭제 기능
	@PostMapping("/deleteSchedule")
	@ResponseBody // AJAX 통신이므로 JSON이나 단순 값을 반환하기 위해 필요합니다.
	public int deleteSchedule(@RequestParam("scheduleId") int scheduleId) {
	    // 성공하면 1, 실패하면 0을 반환하도록 설계합니다.
	    try {
	        return scheduleService.deleteSchedule(scheduleId);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    }
	}
	
	//일정 상세화면 파일 리스트
	@GetMapping("/getFileList")
	@ResponseBody
	public List<FileDetailVO> getFileList(int fileGroupNo) {
	    // fileMapper를 사용하여 해당 그룹번호의 파일 리스트를 반환
	    return fileMapper.selectFileDetailList(fileGroupNo);
	}
	
	
	//드래그 사용해서 일정 변경
	@PostMapping("/updateDate")
    @ResponseBody
    public String updateDate(@RequestBody Map<String, Object> paramMap, HttpSession session) {
        log.info("일정 날짜 변경 요청 데이터: {}", paramMap);
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login_required"; 
        }
        paramMap.put("memberNo", loginUser.getMemberNo());
        int result = scheduleService.updateScheduleDate(paramMap);
        if (result > 0) {
            return "success"; // 변경 성공
        } else {
            return "fail"; // 변경 실패
        }
    }
	
}
