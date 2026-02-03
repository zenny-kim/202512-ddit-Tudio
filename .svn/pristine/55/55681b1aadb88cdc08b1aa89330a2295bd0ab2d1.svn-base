package kr.or.ddit.projectTask.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.code.TaskPriority;
import kr.or.ddit.common.code.TaskStatus;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.projectMember.service.IProjectMemberService;
import kr.or.ddit.projectTask.service.IProjectTaskService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import kr.or.ddit.vo.project.ProjectTaskSubVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectTaskController
 * DESC : 프로젝트 상위업무 생성, 수정, 삭제, 목록 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 PSE
 * @version 1.0, 2025.01.02
 * 
 */
@Controller
@Slf4j
@RequestMapping("/tudio")
public class ProjectTaskController {
	
	@Autowired
	private IProjectTaskService projectTaskService;
	
	@Autowired
	private IProjectMemberService projectMemberService;
	
	@Autowired
	private IFileService fileService;
	
	/**
	 * 프로젝트 멤버 목록 조회 (JSON) - 내 업무 수정 시 담당자 선택용
	 * @param projectNo
	 * @return
	 */
    @GetMapping("project/member/list/json/{projectNo}")
    @ResponseBody
    public ResponseEntity<List<ProjectMemberVO>> getProjectMemberListJson(@PathVariable int projectNo) {
        // 고객사를 제외한 프로젝트 멤버 목록 조회
        List<ProjectMemberVO> allMembers = projectMemberService.projectMemberList(projectNo);
        List<ProjectMemberVO> members = allMembers.stream()
                .filter(m -> !"CLIENT".equals(m.getProjectRole()))
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(members);
    }
	
	@GetMapping("/myTask")
	public String myTaskList(
						@RequestParam(required = false) String type,	
						@RequestParam(required = false) Integer projectStatus,	
						HttpSession session, 
						Model model) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		int memberNo = loginUser.getMemberNo();
		log.info("myTaskList() 실행~ | loginUser memberNo={}", memberNo);
		
		Map<Integer, List<ProjectTaskVO>> myTaskMap = projectTaskService.getMyTaskList(memberNo, type, projectStatus);
		
		model.addAttribute("myTaskMap", myTaskMap);
		model.addAttribute("type", type);
		model.addAttribute("projectStatus", projectStatus);
		model.addAttribute("memberNo", memberNo);
		
		return "myTask/myTask";
	}
	
	/**
	 * <p>업무 목록 가져오기</p>
	 * @auther PSE
	 * @param session 로그인 사용자 정보
	 * @param model
	 * @return project/tabs/tab_tasks.jsp
	 */
	@GetMapping("project/task/list")
	public String projectTaskList(
									@RequestParam int projectNo, 
									@RequestParam(required = false, defaultValue = "REGDATE") String sortType, // 정렬 기준
									@RequestParam(required = false, defaultValue = "DESC") String sortOrder,   // 정렬 순서
									HttpSession session, 
									Model model) {
		log.info("projectTaskList() 실행~ | projectNo={}", projectNo);
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		log.info("loginUser: " + loginUser);
		
		// 로그인 체크
		if(loginUser == null) {
			return "redirect:/tudio/login";
		}
		// 사이트 관리자 접근 차단
		boolean isAdmin = loginUser.getMemberAuthVOList()
									.stream()
									.anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuth()));
		if(isAdmin) {
			model.addAttribute("errorMsg", "사이트 관리자는 프로젝트 업무에 접근할 수 없습니다.");
			return "error/403";
		}
		
		

		// 업무 목록 조회
		List<ProjectTaskVO> projectTaskList = projectTaskService.selectTaskList(projectNo, sortType, sortOrder);
		
		model.addAttribute("taskList", projectTaskList);
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortOrder", sortOrder);
		
		
		return "project/tabs/projectTask/taskList";
	}
	
	/**
	 * 업무 목록에서 고정여부 설정하기
	 * @param id
	 * @param type
	 * @param session
	 * @return
	 */
	@PostMapping("/project/task/setPin")
	@ResponseBody
	public String setPin(
	        @RequestParam int id, 
	        @RequestParam String type, // 'T':상위, 'S':하위
	        HttpSession session) {
	    
	    MemberVO user = (MemberVO) session.getAttribute("loginUser");
	    if(user == null) return "LOGIN_REQUIRED";
	    
	    return projectTaskService.setTaskPin(id, type, user.getMemberNo());
	}
	
	/**
	 * <p>업무 생성&수정 폼 불러오기</p>
	 * @auther PSE
	 * @param session 로그인 사용자 정보
	 * @param model
	 * @return taskCreate.jsp
	 */
	@GetMapping(value = {"project/task/create", "project/task/edit"})
	public String createProjectTaskForm(
									@RequestParam int projectNo,
									@RequestParam(required = false) Integer taskId, // 수정용
									HttpSession session, 
									Model model) {
		log.info("createProjectTaskForm() 실행~ | projectNo={}, taskId={}", projectNo, taskId);
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		// 로그인 체크
		if(loginUser == null) {
			return "redirect:/tudio/login";
		}
		
		model.addAttribute("projectNo", projectNo);
		model.addAttribute("taskStatusList", TaskStatus.values());
	    model.addAttribute("taskPriorityList", TaskPriority.values());
		
		// 프로젝트 멤버 목록
	    List<ProjectMemberVO> allMemberList = projectMemberService.projectMemberList(projectNo);
	    
	    // 프로젝트 멤버 목록에서 고객사 제거
	    List<ProjectMemberVO> memberList = allMemberList.stream()
	    												.filter(member -> !"CLIENT".equals(member.getProjectRole()))
	    												.collect(Collectors.toList()); // 고객사 회원을 목록에서 제거하고 다시 리스트로 생성
	    model.addAttribute("memberList", memberList);
	    
		// 수정 기능
	    if(taskId != null) {
	    	ProjectTaskVO task = projectTaskService.getTaskDetail(taskId);
	    	
	    	// 권한을 여기서도 할지 고민
	    	model.addAttribute("task", task);
	    	model.addAttribute("isEdit", true);		// 수정모드 플래그
	    } else {
	    	model.addAttribute("isEdit", false);	// 생성모드 플래그
	    }
	    
		return "project/tabs/projectTask/taskCreate";
	}
	
	/**
	 * <p>하위업무 생성 폼</p>
	 * @param projectNo
	 * @param model
	 * @return taskSubCreate.jsp
	 */
	@GetMapping("project/task/view/sub/create")
	public String getSubTaskCreateView(@RequestParam int projectNo, Model model) {
		// 프로젝트 멤버 목록
	    List<ProjectMemberVO> allMemberList = projectMemberService.projectMemberList(projectNo);
	    
	    // 프로젝트 멤버 목록에서 고객사 제거
	    List<ProjectMemberVO> memberList = allMemberList.stream()
	    												.filter(member -> !"CLIENT".equals(member.getProjectRole()))
	    												.collect(Collectors.toList()); // 고객사 회원을 목록에서 제거하고 다시 리스트로 생성
	    
	    model.addAttribute("subStatusList", TaskStatus.values());
	    model.addAttribute("subPriorityList", TaskPriority.values());
	    model.addAttribute("memberList", memberList);
		
		return "project/tabs/projectTask/taskSubCreate";
	}
	
	/**
	 * <p>상위업무 생성하기 & 종속되는 하위업무 생성하기(간략)<p>
	 * @param projectNo
	 * @param projectTaskVO
	 * @param session
	 * @param List<MultipartFile> files
	 * @return ResponseEntity 상태
	 */
	@PostMapping("project/task/create")
	public ResponseEntity<String> createProjectTask(
									@RequestParam int projectNo,
									ProjectTaskVO projectTaskVO,
									@RequestParam(value = "files", required = false) List<MultipartFile> files,
									HttpSession session
									) {
		log.info("createProjectTaskForm() 실행~ | projectNo={}", projectNo);
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		// 로그인 체크
		if(loginUser == null) {
			return ResponseEntity.status(401).body("LOGIN_REQUIRED");
		}
		
		try {
			// projectNo & 작성자 설정
			projectTaskVO.setProjectNo(projectNo);
			projectTaskVO.setTaskWriter(loginUser.getMemberNo());

			// 파일 업로드
			if(files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
				int fileGroupNo = fileService.uploadFiles(files, loginUser.getMemberNo(), 403);
				// 생성한 파일 그룹 번호를 VO에 세팅
				projectTaskVO.setFileGroupNo(fileGroupNo);
			}
			
			// 상위 업무 단건 생성
			ServiceResult result = projectTaskService.createTask(projectTaskVO, loginUser.getMemberNo());
			
			if(result.equals(ServiceResult.OK)) {
				return ResponseEntity.ok("SUCCESS");
			} else {
				return ResponseEntity.status(500).body("FAILED");
			}
		}catch(Exception e) {
			log.error("업무 생성 중 에러 발생!", e);
			return ResponseEntity.status(500).body("SERVER_ERROR");
		}
	}
	
	/**
	 * <p>하위업무 생성하기(상세)<p>
	 * @param projectNo
	 * @param projectTaskVO
	 * @param session
	 * @param List<MultipartFile> files
	 * @return ResponseEntity 상태
	 */
	@PostMapping("project/task/sub/create")
	public ResponseEntity<String> createsubTask(
										ProjectTaskSubVO subVO,
										@RequestParam(value = "files", required = false) List<MultipartFile> files,
										HttpSession session
										){
		log.info("createsubTask() 실행~ | parentTaskId={}", subVO.getTaskId());
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if(loginUser == null) {
			return ResponseEntity.status(401).body("LOGIN_REQUIRED");
		}
		
		try {
			// 작성자 설정
			subVO.setSubWriter(loginUser.getMemberNo());
			
			// 파일 업로드
			if(files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
				int fileGroupNo = fileService.uploadFiles(files, loginUser.getMemberNo(), 404);
				// 생성한 파일 그룹 번호를 VO에 세팅
				subVO.setFileGroupNo(fileGroupNo);
			}
			
			ServiceResult result = projectTaskService.createSubTask(subVO, loginUser.getMemberNo());
			
			if(result.equals(ServiceResult.OK)) {
				return ResponseEntity.ok("SUCCESS");
			} else {
				return ResponseEntity.status(500).body("FAILED");
			}
		}catch(Exception e) {
			log.error("하위 업무 생성 중 에러 발생!", e);
			return ResponseEntity.status(500).body("SERVER_ERROR");
		}
	}
	
	/**
	 * <p>업무 수정하기</p>
	 * @param projectTaskVO
	 * @param files
	 * @param session
	 * @return
	 */
	@PostMapping("project/task/update")
	public ResponseEntity<String> updateProjectTask(
										ProjectTaskVO projectTaskVO,
										@RequestParam(required = false) String deleteSubIds,
										@RequestParam(value = "files", required = false) List<MultipartFile> files,
										HttpSession session){
		log.info("updateProjectTask() 실행 | taskId={}", projectTaskVO.getTaskId());
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if(loginUser == null) {
			return ResponseEntity.status(401).body("LOGIN_REQUIRED");
		}
		
		try {
			projectTaskVO.setTaskWriter(loginUser.getMemberNo());
			
			// 뷁 일단은 추가만... 유지 삭제 등 고려해서 수정 필요
			if(files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
				int fileGroupNo = projectTaskVO.getFileGroupNo();
				int newFileGroupNo = fileService.uploadFiles(files, loginUser.getMemberNo(), 403); // 뷁 수정 필요: 기존 그룹에 추가하는 로직 확인 필요
				
				// 업로드된 파일이 없을시 새로운 newFileGroupNo 세팅
				if (fileGroupNo == 0) projectTaskVO.setFileGroupNo(newFileGroupNo);
			}
			
			// 삭제
			List<Integer> deleteList = new ArrayList<>();
            if(deleteSubIds != null && !deleteSubIds.trim().isEmpty()) {
                String[] split = deleteSubIds.split(",");
                for(String s : split) {
                    if(!s.trim().isEmpty()) {
                        try {
                            deleteList.add(Integer.parseInt(s.trim()));
                        } catch (NumberFormatException e) {
                            log.warn("Invalid subId format: {}", s);
                        }
                    }
                }
            }
			ServiceResult result = projectTaskService.updateTaskWithSubTasks(projectTaskVO, deleteList);
				
			return result.equals(ServiceResult.OK) ? ResponseEntity.ok("SUCCESS") : ResponseEntity.status(500).body("FAILED");
			
		}catch(Exception e) {
			log.error("업무 수정 중 에러 발생: ", e);
			return ResponseEntity.status(500).body("SERVER_ERROR");
		}
	}
	
	/**
     * <p>하위업무 단건 수정 (내 업무 페이지 등에서 사용)</p>
     * @param subVO
     * @param session
     * @return
     */
    @PostMapping("project/task/sub/update")
    public ResponseEntity<String> updateSubTask(
            ProjectTaskSubVO subVO,
            HttpSession session) {
        
        log.info("updateSubTask() 실행 | subId={}", subVO.getSubId());
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if(loginUser == null) {
            return ResponseEntity.status(401).body("LOGIN_REQUIRED");
        }
        
        try {
            // 수정 서비스 호출
            ServiceResult result = projectTaskService.updateSubTask(subVO);
            
            return result.equals(ServiceResult.OK) ? ResponseEntity.ok("SUCCESS") : ResponseEntity.status(500).body("FAILED");
            
        } catch(Exception e) {
            log.error("하위업무 수정 중 에러 발생: ", e);
            return ResponseEntity.status(500).body("SERVER_ERROR");
        }
    }
	
	/**
	 * <p>업무 상세 모달 반환</p>
	 * @return taskDetail.jsp
	 */
	@GetMapping("project/task/view/detail")
	public String getTaskDetailView() {
		return "project/tabs/projectTask/taskDetail";
	}
	
	/**
	 * <p>상위업무 상세정보 조회</p>
	 * @param taskId
	 * @return ResponseEntity<ProjectTaskVO>
	 */
	@GetMapping("project/task/detail/{taskId}")
	@ResponseBody
	public ResponseEntity<ProjectTaskVO> getTaskDetail(@PathVariable int taskId){
		log.info("getTaskDetail() 실행~ | taskId={}", taskId);
		
		ProjectTaskVO taskVO = projectTaskService.getTaskDetail(taskId);
		
		if(taskVO != null) {
			return ResponseEntity.ok(taskVO);
		} else {
			return ResponseEntity.notFound().build();
		}
	}
	
	/**
	 * <p>하위업무 상제정보 조회</p>
	 * @param subId
	 * @return ResponseEntity<ProjectTaskSubVO>
	 */
	@GetMapping("project/task/sub/detail/{subId}")
	@ResponseBody 
	public ResponseEntity<ProjectTaskSubVO> getSubTaskDetail(@PathVariable int subId){
		log.info("getSubTaskDetail() 실행~ | subId={}", subId);
		
		ProjectTaskSubVO subVO = projectTaskService.getSubTaskDetail(subId);
		
		if(subVO != null) {
			return ResponseEntity.ok(subVO);
		} else {
			return ResponseEntity.notFound().build();
		}
	}
	
	/**
	 * <p>하위업무 진척도 변경</p>
	 * @param subId
	 * @param subRate
	 * @return res 값
	 */
	@PostMapping("project/task/sub/updateRate")
	@ResponseBody
	public String updateSubRate(@RequestParam("subId") int subId, 
								@RequestParam("subRate") int subRate) {
		try {
			ServiceResult result = projectTaskService.updateSubTaskRate(subId, subRate);
			return ServiceResult.OK.equals(result) ? "success" : "fail";
		}catch(Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
	
	/**
	 * 업무 삭제
	 * @param taskId
	 * @param type
	 * @param session
	 * @return
	 */
	@PostMapping("project/task/delete")
	@ResponseBody
	public String deleteTask(
	        @RequestParam int workId,
	        @RequestParam String type, // 'T': 상위, 'S': 하위
	        HttpSession session) {
	    
	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if(loginUser == null) return "LOGIN_REQUIRED";
	    
	    log.info("deleteTask 실행 | id={}, type={}", workId, type);
	    
	    try {
	        ServiceResult result = projectTaskService.deleteTask(workId, type);
	        return result.equals(ServiceResult.OK) ? "SUCCESS" : "FAILED";
	    } catch(Exception e) {
	        log.error("업무 삭제 중 에러 발생", e);
	        return "SERVER_ERROR";
	    }
	}
}

