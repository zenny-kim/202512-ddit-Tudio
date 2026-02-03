package kr.or.ddit.project.controller;

import java.security.Principal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.code.ProjectType;
import kr.or.ddit.project.service.IProjectService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;


/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectController
 * DESC : 프로젝트 생성, 수정, 삭제 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2025.12.26
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/project")
public class ProjectController {
	
	@Autowired
	private IProjectService projectService;
	
	/**
	 * 프로젝트 생성 화면
	 * @param model
	 * @return 프로젝트 생성폼 페이지(form.jsp)
	 */
	@GetMapping("/create")
	public String projectCreateForm(Model model) {
		log.info("projectCreateForm() 메소드 실행...!");
		
		List<Map<String, Object>> tabList = projectService.getProjectTabList(null);

        model.addAttribute("tabList", tabList);
        model.addAttribute("projectType", ProjectType.values());
        model.addAttribute("status", "c");
		
		return "project/form";
	}
	
	/**
	 * 프로젝트 생성
	 * @param projectVO 프로젝트 기본정보
	 * @param loginMember
	 * @return
	 */
	@PostMapping("/create")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> projectCreate(@RequestBody ProjectVO projectVO, 
															 @SessionAttribute("loginUser") MemberVO loginMember) {		
		Map<String, Object> response = new HashMap<>();
		
		try {
			log.info("projectCreate() 메소드 실행...!");
			
			projectVO.setMemberNo(loginMember.getMemberNo());
			
			// 생성 후 실패한 이메일 목록
			List<String> failedEmail = projectService.createProject(projectVO);
			
			response.put("status", "SUCCESS");
			response.put("failedEmail", failedEmail);
			response.put("projectNo", projectVO.getProjectNo());
			
			return new ResponseEntity<>(response, HttpStatus.OK);		// 200 OK
		} catch(Exception e) {			
			e.printStackTrace();		
			response.put("status", "FAILED");
			return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
		}
	}
	
    
	/**
	 * 프로젝트 구성원 초대를 위한 사용자 검색
	 * @param email 초대하고자하는 사람의 이메일
	 * @param type 초대하고자하는 사용자의 프로젝트 내 권한(역할)
	 * @return 
	 */
    @GetMapping("/checkMember")
    @ResponseBody
    public MemberVO checkMember(@RequestParam("email") String email,
			   					@RequestParam(value = "type", defaultValue = "MEMBER") String type) {
    	log.info("checkMember() 실행... email: {}, type: {}", email, type);
    	
    	// DB 권한명("ROLE_MEMBER", "ROLE_CLIENT")으로 변환
        String auth = "ROLE_MEMBER"; // 기본값
        if ("CLIENT".equals(type)) {
            auth = "ROLE_CLIENT";
        }
        
        Map<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("auth", auth);
        
        return projectService.selectMemberByEmail(params);
    }
   
    
    /**
     * [초대 확인] 메일 링크 클릭 시 토큰 검증 및 회원가입 페이지 이동
     * URL: /tudio/project/invite/check?token=abcd...
     */
    @GetMapping("/invite/check")
    public String checkInvitation(@RequestParam("token") String token, RedirectAttributes ra, Model model) {
        
        // 토큰 조회
        ProjectMemberVO inviteInfo = projectService.getInvitationByToken(token);
        
        // 유효성 검증 (없음 / 만료 / 사용됨)
        if (inviteInfo == null) {
            ra.addFlashAttribute("message", "유효하지 않은 초대 링크입니다.");
            return "redirect:/tudio/login";
        }
        
        if (new Date().after(inviteInfo.getExpiryDate())) {
            ra.addFlashAttribute("message", "만료된 초대 링크입니다.");
            return "redirect:/tudio/login";
        }
        
        if ("Y".equals(inviteInfo.getUsedYn())) {
            ra.addFlashAttribute("message", "이미 사용된 초대 링크입니다. 로그인해 주세요.");
            return "redirect:/tudio/login";
        }
        
        // 회원가입 폼으로 정보 전달
        model.addAttribute("inviteEmail", inviteInfo.getMemberEmail()); // 이메일 자동 입력 처리
        model.addAttribute("inviteToken", token); // 가입 완료 처리를 위한 토큰       
        // model.addAttribute("inviteProjectName", inviteInfo.getProjectName());
        
        // 회원가입 폼 페이지로 이동
        return "member/memberType"; 
    }
    
    
    /**
     * 프로젝트 참여 수락 화면
     * @param projectNo 프로젝트 일련번호
     * @param code 프로젝트 인증코드(UUID)
     * @param model
     * @return 프로젝트 참여 수락 페이지 
     */
    @GetMapping("/invite/verify")
    public String verifyInvitePage(@RequestParam("projectNo") int projectNo, Model model,
						            Principal principal, HttpSession session) { 
    	log.info("inviteVerifyPage() 실행...! - projectNo: {}", projectNo);
              
        ProjectVO project = projectService.getProjectDetail(projectNo);
        model.addAttribute("project", project);
        
        // 비로그인(Guest) 사용자 체크
        if (principal == null) {
            // JSP에서 경고창을 띄우기 위한 플래그 전달
            model.addAttribute("isGuest", true);
            
            // 로그인 성공 후 다시 돌아올 주소를 세션에 저장해둠
            String returnUrl = "/tudio/project/invite/verify?projectNo=" + projectNo;
            session.setAttribute("inviteReturnUrl", returnUrl);
        }
        
        return "project/inviteVerify"; 
    }
    
    /**
     * 프로젝트 참여 수락
     * @param params
     * @param loginMember
     * @return
     */
    @PostMapping("/invite/accept")
    @ResponseBody
    public Map<String, Object> acceptInvite(@RequestBody Map<String, Object> params,
    										@SessionAttribute("loginUser") MemberVO loginMember) {
    	log.info("acceptInvite() 실행...!");
    	
    	int memberNo = loginMember.getMemberNo();
    	int projectNo = Integer.parseInt(String.valueOf(params.get("projectNo")));
    	
    	// 상태 변경 (초대중[P] -> 참여[Y])
    	String resultStatus = projectService.confirmProjectParticipation(projectNo, memberNo);
    	
    	Map<String, Object> resp = new HashMap<>();
    	resp.put("status", resultStatus); // SUCCESS, ALREADY_JOINED, FAIL
        
        if("SUCCESS".equals(resultStatus) || "ALREADY_JOINED".equals(resultStatus)) {
        	resp.put("redirectUrl", "/tudio/project/detail?projectNo=" + projectNo);
        }
        
        return resp;
    }
    
    /**
     * [초대 취소] 보낸 초대 메일/알림 회수
     * @param params
     * @return
     */
    @PostMapping("/invite/cancel")
    @ResponseBody
    public Map<String, String> cancelInvite(@RequestBody Map<String, Object> params) {
        log.info("cancleInvite() 실행...!");
        
        int projectNo = Integer.parseInt(String.valueOf(params.get("projectNo")));
        String email = (String) params.get("email"); // 취소할 대상 이메일
        
        Map<String, String> response = new HashMap<>();
        
        ServiceResult result = projectService.cancelInvitation(projectNo, email);      
        
        if (result == ServiceResult.OK) {
            response.put("status", "SUCCESS");
            response.put("message", "초대가 성공적으로 취소되었습니다.");
        } else {
            response.put("status", "FAIL");
            response.put("message", "취소할 초대가 없거나 이미 가입된 사용자입니다.");
        }
        
        return response;
    }
    
		
	/**
	 * 프로젝트 상세 화면
	 * @param projectNo 프로젝트 일련번호
	 * @param model
	 * @param loginMember 로그인 사용자 정보
	 * @param ra 
	 * @return 프로젝트 메인 페이지
	 */
	@GetMapping("/detail")
	public String projectDetail(@RequestParam("projectNo") int projectNo, Model model, 
								@SessionAttribute("loginUser") MemberVO loginMember, 
								RedirectAttributes ra) {
		log.info("projectDetail() 실행...!");
		
		//  로그인한 사용자 정보
        int memberNo = loginMember.getMemberNo();
		
        // 접근 권한 체크
        boolean hasAccess = projectService.checkProjectAccess(projectNo, memberNo);
        
        if (!hasAccess) {
            // (권한 X) 목록으로 리다이렉트 및 경고 메시지 출력
            ra.addFlashAttribute("message", "해당 프로젝트에 접근 권한이 없습니다.");
            return "redirect:/tudio/project/list";
        }
        
        // (권한 O) 프로젝트 정보 조회
        ProjectVO project = projectService.getProjectDetail(projectNo);
      
        // 프로젝트 북마크 설정 정보
        String bookmark = projectService.selectBookmark(projectNo, memberNo);
        
        model.addAttribute("project", project);
        model.addAttribute("loginMember", memberNo);
        model.addAttribute("bookmark", bookmark);
        
        return "project/projectMain";
	}

	
	/**
	 * 프로젝트 북마크 상태 변경
	 * @param params
	 * @param loginMember 로그인한 사용자 정보
	 * @return
	 */
	@PostMapping("/bookmark")
	@ResponseBody
	public ResponseEntity<Map<String, String>> toggleBookmark(
			@RequestBody Map<String, Object> params,
			@SessionAttribute("loginUser") MemberVO loginMember) {
		log.info("toggleBookmark() 실행...!");
		
		Map<String, String> resp = new HashMap<>();
		
	    int memberNo = loginMember.getMemberNo();
	    int projectNo = Integer.parseInt(String.valueOf(params.get("projectNo")));
	    	    
	    try {
	    	String status = projectService.toggleBookmark(projectNo, memberNo);
	    	resp.put("status", "SUCCESS");
	    	resp.put("bookmark", status);
	        return new ResponseEntity<>(resp, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resp.put("status", "FAILED");
	        return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
	    }
	}

	/**
	 * 프로젝트 수정 화면
	 * @param projectNo 프로젝트 일련번호
	 * @param model
	 * @return 프로젝트 수정폼 페이지
	 */
	@GetMapping("/update")
	public String projectModifyForm(int projectNo, Model model) {
		log.info("projectModifyForm() 실행...!");
		
		ProjectVO project = projectService.getProjectDetail(projectNo);
		List<Map<String, Object>> tabList = projectService.getProjectTabList(project);
		
		model.addAttribute("project", project);
		model.addAttribute("tabList", tabList);
		model.addAttribute("projectType", ProjectType.values());
		model.addAttribute("status", "u");
		
		return "project/form";
	}
	
	/**
	 * 프로젝트 수정
	 * @param projectVO 프로젝트 기본 정보
	 * @param loginMember 로그인한 사용자 정보
	 * @return
	 */
	@PostMapping("/update")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> projectModify(
			@RequestBody ProjectVO projectVO,
			@SessionAttribute("loginUser") MemberVO loginMember) {
        Map<String, Object> resp = new HashMap<>();

		try {
			projectVO.setMemberNo(loginMember.getMemberNo());
			
            log.info("projectModify() 실행... projectNo: {}", projectVO.getProjectNo());
            
            List<String> failedEmail = projectService.updateProject(projectVO);
            
            resp.put("status", "SUCCESS");
            resp.put("failedEmail", failedEmail);
            resp.put("projectNo", projectVO.getProjectNo());
            
            return new ResponseEntity<>(resp, HttpStatus.OK);		 // 200 OK
        } catch (RuntimeException ex) {
			log.warn("프로젝트 수정 권한 오류: {}", ex.getMessage());
			resp.put("status", "ACCESS_DENIED");
			resp.put("message", ex.getMessage());
            return new ResponseEntity<>(resp, HttpStatus.FORBIDDEN); // 403 Forbidden
		} catch(Exception e) {          
            e.printStackTrace();        
            resp.put("status", "FAILED");
            return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
        }
	}
	
	/**
	 * 프로젝트 관리자 권한 위임
	 * @param params
	 * @param loginMember 현재 프로젝트 관리자 회원정보
	 * @return
	 */
	@PostMapping("/delegate")
	@ResponseBody
	public Map<String, String> delegateProjectManager(@RequestBody Map<String, Integer> params, 
	        										  @SessionAttribute("loginUser") MemberVO loginMember) {	  
		log.info("delegateProjectManager() 실행...!");
		
	    Map<String, String> response = new HashMap<>();
	    int currentManagerNo = loginMember.getMemberNo();	    
	    int projectNo = params.get("projectNo");
	    int newManagerNo = params.get("newManagerNo");
	    log.info("현재 관리자 회원번호 : {}, 프로젝트 번호 : {}, 새 관리자 회원번호 : {}", currentManagerNo, projectNo, newManagerNo);
	    
	    ServiceResult result = projectService.delegateProjectManager(projectNo, currentManagerNo, newManagerNo);	    
	    if (result == ServiceResult.OK) {
	        response.put("status", "SUCCESS");
	        response.put("message", "관리자 권한이 성공적으로 위임되었습니다.");
	    } else {
	        response.put("status", "FAIL");
	        response.put("message", "권한 위임 중 오류가 발생했습니다.");
	    }
	    
	    return response;
	}
	
	/**
	 * 프로젝트 삭제 (논리 삭제로 상태값을 변경)
	 * @param projectVO 프로젝트 일련 번호
	 * @param loginMember 로그인한 사용자 정보
	 * @return 
	 */
	@PostMapping("/delete")
	@ResponseBody
	public Map<String, String> projectDelete(@RequestBody Map<String, Integer> params,
											 @SessionAttribute("loginUser") MemberVO loginMember) {
		log.info("projectDelete() 실행...!");
		
		int projectNo = Integer.parseInt(String.valueOf(params.get("projectNo")));
		
		ProjectVO projectVO = new ProjectVO();
		projectVO.setProjectNo(projectNo);
		projectVO.setMemberNo(loginMember.getMemberNo());
		
		int result = projectService.deleteProjectLogically(projectVO);

		Map<String, String> resp = new HashMap<>();
		if (result > 0) {
			resp.put("status", "SUCCESS");			
		} else {
			resp.put("status", "FAIL");
			resp.put("message", "삭제 권한이 없거나 처리에 실패했습니다.");
		}
		return resp;
	}
	
	/**
	 * 프로젝트 상태 변경 (완료/재진행)
	 * @param params
	 * @return
	 */
    @PostMapping("/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changeProjectStatus(@RequestBody Map<String, Object> params) {
    	log.info("changeProjectStatus() 실행...!");
    	
    	int projectNo = Integer.parseInt(String.valueOf(params.get("projectNo")));
    	int projectStatus = Integer.parseInt(String.valueOf(params.get("status")));
        Map<String, Object> resp = new HashMap<>();
        
        try {
            int result = projectService.changeProjectStatus(projectNo, projectStatus);
            
            if (result == 0) {
            	resp.put("status", "SUCCESS");
            } else if (result == -1) {
                resp.put("status", "NO_CLIENT_Y"); 
            } else if (result == -2) {
                resp.put("status", "NO_TASKS");    
            } else {
            	resp.put("status", "UNFINISHED_TASKS");
            	resp.put("count", result); // 미완료 업무 개수
            }
            return new ResponseEntity<>(resp, HttpStatus.OK);          
        } catch (Exception e) {
            e.printStackTrace();
            resp.put("status", "ERROR");
            resp.put("message", e.getMessage());
            return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
	 * 프로젝트 목록 (페이징 + 검색 + 정렬)
	 */
	@GetMapping("/list")
	public String projectList(
			@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "title") String searchType,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate,
			@RequestParam(defaultValue = "latest") String sort,
			Model model, HttpSession session) {

		log.info("projectList() 실행...!");

		// 로그인 체크
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/tudio/login";
		}
		int memberNo = loginUser.getMemberNo();

		PaginationInfoVO<ProjectVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setScreenSize(8);

		// 검색 상태(pagingVO)에 반영 (기간 검색도 searchType은 유지돼야 함)
		if ("title".equals(searchType) && StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType("title");
			pagingVO.setSearchWord(searchWord);
		} else if ("projectDuration".equals(searchType)
				&& StringUtils.isNotBlank(startDate)
				&& StringUtils.isNotBlank(endDate)) {
			pagingVO.setSearchType("projectDuration");
			// pagingVO에 startDate/endDate 필드가 없으니 map/model로만 유지
		} else if (!"title".equals(searchType) && !"projectDuration".equals(searchType)) {
			// 이상한 값이 들어오면 기본값으로 정리
			searchType = "title";
			searchWord = null;
			startDate = null;
			endDate = null;
		}

		// start/endRow, start/endPage 설정
		pagingVO.setCurrentPage(currentPage);

		// 파라미터 Map (count/list 공용)
		Map<String, Object> countMap = new HashMap<>();
		countMap.put("memberNo", memberNo);
		countMap.put("sort", sort);
		countMap.put("startRow", pagingVO.getStartRow());
		countMap.put("endRow", pagingVO.getEndRow());

		// 검색 설정
		if ("title".equals(searchType) && StringUtils.isNotBlank(searchWord)) {
			countMap.put("searchType", "title");
			countMap.put("searchWord", searchWord);
		} else if ("projectDuration".equals(searchType)
				&& StringUtils.isNotBlank(startDate)
				&& StringUtils.isNotBlank(endDate)) {
			countMap.put("searchType", "projectDuration");
			countMap.put("startDate", startDate);
			countMap.put("endDate", endDate);
		}

		// 총 게시글 수
		int totalRecord = projectService.listCount(countMap);

		// 총 게시글 수 전달 후, 총 페이지 수 설정
		pagingVO.setTotalRecord(totalRecord);

		// 목록 조회
		List<ProjectVO> projectList = projectService.list(countMap);
		
		// 프로젝트 진척률
		 List<ProjectInsightVO> projectRateList= projectService.selectProjectRateList(memberNo);
		 
		// projectNo => rate 매핑
		 Map<Integer, Double> projectRateMap = new HashMap<>();
		 for(ProjectInsightVO r : projectRateList) {
			  projectRateMap.put(r.getProjectNo(), r.getOverallProgress());

		 }

		// 결과 세팅
		pagingVO.setDataList(projectList);

		// 화면 전달
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("projectRateMap", projectRateMap);
		
		
		
		// 화면 유지용(셀렉트/인풋 값 유지)
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("sort", sort);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		return "project/projectList";
	}
	
	/**
	 *  프로젝트 리스트 북마크 
	 * @param vo
	 * @param session
	 * @return
	 */
	@PostMapping("/list/bookmark")
	@ResponseBody
	public Map<String, String> toggleListBookmark(ProjectVO vo, HttpSession session){
		log.info("toggleListBookmark() 실행...!");
		MemberVO memVO = (MemberVO) session.getAttribute("loginUser");		
		/*
		 * if(memVO == null) { return "redirect:/tudio/login"; }
		 */		
		vo.setMemberNo(memVO.getMemberNo());
		
		String bookmark = projectService.toggleListBookmark(vo.getProjectNo(), vo.getMemberNo());
		
		Map<String, String> result = new HashMap<>();
		result.put("bookmark", bookmark); // 'Y' or 'N'
		return result;
	}
	
}
