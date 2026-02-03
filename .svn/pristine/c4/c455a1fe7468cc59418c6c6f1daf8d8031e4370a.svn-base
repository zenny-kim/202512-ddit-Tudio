package kr.or.ddit.projectTask.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.projectTask.service.IKanbanService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectTaskSubVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : KanbanController
 * DESC : 칸반보드 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KHJ
 * @version 1.0, 2026.01.06
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio/project/task")
public class KanbanController {

	@Autowired
	private IKanbanService kanbanService;

	@Autowired
	private IMemberService memberService;

	/**
	 * 칸반 보드 메인 페이지 이동
	 */
	@GetMapping("/kanban")
	public String kanbanMain(@RequestParam(name = "projectNo") Integer projectNo, Principal principal,
			HttpSession session, Model model) {

		if (principal == null)
			return "redirect:/tudio/login";

		MemberVO member = (MemberVO) session.getAttribute("loginUser");
		if (member == null) {
			member = memberService.findByMemberId(principal.getName());
			session.setAttribute("loginUser", member);
		}

		int loginMemberNo = member.getMemberNo();
		boolean isAdmin = member.getMemberAuthVOList().stream().anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuth()));

		String projectRole = null;
		if (!isAdmin) {
			projectRole = kanbanService.getProjectRole(projectNo, loginMemberNo);
		}

		model.addAttribute("projectNo", projectNo);
		model.addAttribute("loginMemberNo", loginMemberNo);
		model.addAttribute("projectRole", projectRole);

		return "kanban/kanban";
	}

	/**
	 * 업무 리스트 조회
	 */
	@GetMapping("/getTaskList")
	@ResponseBody
	public List<ProjectTaskSubVO> kanbanList(@RequestParam(name = "projectNo", required = false) Integer projectNo,
			HttpSession session) {

		MemberVO member = (MemberVO) session.getAttribute("loginUser");
		if (member == null || projectNo == null)
			return new ArrayList<>();

		log.info("로그인 유저: {}, 권한리스트: {}", member.getMemberId(), member.getMemberAuthVOList());

		// 1. 시스템 권한 확인 (관리자나 클라이언트는 제외)
		// ※ 주의: auth.getAuth()가 실제 DB의 'ROLE_MEMBER' 등을 가져오는지 확인 필요
		boolean isRestricted = false;
		if (member.getMemberAuthVOList() != null) {
			isRestricted = member.getMemberAuthVOList().stream()
					.anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuth()) || "ROLE_CLIENT".equals(auth.getAuth()));
		}

		// 2. 프로젝트 멤버 여부 확인
		String projectRole = kanbanService.getProjectRole(projectNo, member.getMemberNo());
		log.info("프로젝트 번호: {}, 조회된 프로젝트 역할: {}", projectNo, projectRole);

		// [체크포인트] 만약 projectRole이 null이거나 관리자/클라이언트라면 빈 리스트 반환
		if (isRestricted || projectRole == null || "CUSTOMER".equals(projectRole)) {
			log.warn("권한 부족으로 데이터 반환 거부 - isRestricted: {}, projectRole: {}", isRestricted, projectRole);
			return new ArrayList<>();
		}

		List<ProjectTaskSubVO> taskList = kanbanService.getKanbanTaskList(projectNo);
		log.info("조회된 업무 개수: {}", taskList.size());

		return taskList;
	}
	
	//상태 업데이트 (드래그 앤 드롭 결과 수신)
	@PostMapping("/modifyStatus")
    @ResponseBody
    public String updateStatus(@RequestParam int subId, @RequestParam int subStatus) {
        try {
            boolean result = kanbanService.modifySubTaskStatus(subId, subStatus);
            return result ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

	// 진척률 업데이트 (슬라이더 조작 결과 수신)
	@PostMapping("/updateRate")
	@ResponseBody
	public String updateRate(@RequestParam int subId, @RequestParam int subRate) {
		try {
			int result = kanbanService.updateSubTaskRate(subId, subRate);
			return (result > 0) ? "success" : "fail";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}

	@PostMapping("/updatePin")
	@ResponseBody
	public String updatePin(@RequestParam("subId") int subId,
            				@RequestParam("subPinYn") String subPinYn,
            				@RequestParam("taskId") int taskId, HttpSession session) {
		
		MemberVO member = (MemberVO) session.getAttribute("loginUser");
		if (member == null) {
	        return "fail";
	    }
		
		int loginMemberNo = member.getMemberNo();
		kanbanService.updateSubTaskPin(subId, subPinYn, loginMemberNo, taskId);
		return "success";
	}
}