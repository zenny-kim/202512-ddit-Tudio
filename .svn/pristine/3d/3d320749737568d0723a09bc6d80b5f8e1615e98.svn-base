package kr.or.ddit.schedule.controller;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.schedule.service.IScheduleService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectScheduleVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : TabScheduleController
 * DESC : 프로젝트 내부 탭 안에 있는 일정 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.08
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/project/schedule")
public class TabScheduleController {

	@Autowired
	private IScheduleService scheduleService;
	
	

	// 프로젝트 스케줄 조회 화면
	@GetMapping
	public String TabScheduleList(@RequestParam("projectNo") int projectNo, Model model) {
		log.info("TabScheduleList() 실행 - 화면 로딩용 번호: {}", projectNo);
		model.addAttribute("projectNo", projectNo);

		return "project/tabs/schedule/schedule";
	}

	// 프로젝트 스케줄 조회 기능
	@ResponseBody
	@GetMapping("/getProjectScheduleList/{projectNo}")
	public List<ProjectScheduleVO> getProjectScheduleList(HttpSession session, @PathVariable("projectNo") int projectNo) {
		log.info("getProjectScheduleList() 실행 - 데이터 조회용 번호: {}", projectNo);
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return new ArrayList<>();
	    }
		Map<String, Object> map = new HashMap<>();
		map.put("projectNo", projectNo);
		map.put("memberNo", loginUser.getMemberNo()); // 로그인한 사람 번호 필수!

		return scheduleService.getProjectScheduleList(map);
	}
	
	//  프로젝트 스케줄 등록
	@ResponseBody
    @PostMapping("/insert")
    public String insertProjectSchedule(@RequestBody ProjectScheduleVO scheduleVO, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "login_required";
	    }
		scheduleVO.setMemberNo(loginUser.getMemberNo());
        int result = scheduleService.insertSchedule(scheduleVO);
        return result > 0 ? "success" : "fail";
    }

    //  프로젝트 스케줄  삭제
	@ResponseBody
    @PostMapping("/delete")
    public String deleteProjectSchedule(int scheduleId) {
        int result = scheduleService.deleteSchedule(scheduleId);
        return result > 0 ? "success" : "fail";
    }
	
	// 프로젝트 스케줄 드래그 일정 변경
	@PostMapping("/updateDate")
    @ResponseBody
    public String updateDate(@RequestBody Map<String, Object> paramMap, HttpSession session) {
        log.info("일정 날짜 변경 요청: {}", paramMap);

        // 1. 세션에서 로그인한 사용자 정보 가져오기
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "login_required"; // 로그인이 안 되어 있다면 처리
        }

        // 2. Map에 로그인한 사람의 번호(memberNo) 추가
        // 이 값이 있어야 SQL의 WHERE 절에서 권한 체크가 가능함
        paramMap.put("memberNo", loginUser.getMemberNo());

        // 3. 서비스 호출
        int result = scheduleService.updateScheduleDate(paramMap);
        if (result > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
	

}
