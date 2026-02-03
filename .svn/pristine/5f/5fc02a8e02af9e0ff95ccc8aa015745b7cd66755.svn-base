package kr.or.ddit.approval.controller;

import java.io.File;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.approval.service.IApprovalService;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.vo.ApprovalPaginationInfoVO;
import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;


/**
 * <pre>
 * PROJ : Tudio
 * Name : class
 * DESC : 결재 기능 관련 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KHJ
 * @version 1.0, 2026.01.17
 */
@Slf4j
@Controller
@RequestMapping("/tudio/approval")
public class ApprovalController {
	
	@Autowired
	private IMemberService memberService;
	
	@Autowired
	private IApprovalService approvalService;
	
	@Autowired
	private IFileService fileService;
	
	@Value("${kr.or.ddit.upload.path}")
    private String uploadPath;
	
	@Value("${kr.or.ddit.imageUpload.path}")
    private String imageUploadPath;
	
	@Autowired
    private ServletContext servletContext;
	
	
	/**
	 * 선택한 프로젝트 관련 결재 목록조회
	 */
	
	@GetMapping("/list")
	public String approvalList(
	        @RequestParam(name="projectNo", required=false, defaultValue="0") int projectNo, // 어떤 프로젝트의 결재함인지 필수
	        @RequestParam(name="page", required=false, defaultValue="1") int currentPage,
	        @RequestParam(value="tabType", required=false, defaultValue="ALL") String tabType, // 미니탭
	        @RequestParam(value="searchType", required=false) String searchType,
	        @RequestParam(value="searchWord", required=false) String searchWord,	        
	        Principal principal, Model model, HttpSession session) {
		
	    if (principal == null) {
	        return "redirect:/tudio/login";
	    }

	    String memberId = principal.getName();
	    MemberVO member = memberService.findByMemberId(memberId);
	    if (member == null) return "redirect:/tudio/login";
	    
	    session.setAttribute("loginUser", member);
	    int memberNo = member.getMemberNo();
	    
	    List<ProjectVO> myProjectList = approvalService.getMyProjectList(memberNo);
	    model.addAttribute("myProjectList", myProjectList);
	    
	    String userAuth = "";
	    if (member.getMemberAuthVOList() != null && !member.getMemberAuthVOList().isEmpty()) {
	    	userAuth = member.getMemberAuthVOList().get(0).getAuth(); 
	    }

	   
	    String projectRole = "";
	    if (projectNo > 0) {
	        projectRole = approvalService.getProjectRole(projectNo, memberNo);
	    }
	    model.addAttribute("projectRole", projectRole);

	    
	    Map<String, Object> stats = approvalService.getApprovalStats(projectNo, memberNo, projectRole, userAuth);
	    model.addAttribute("stats", stats);
	    
	    ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO = new ApprovalPaginationInfoVO<>();
	    pagingVO.setCurrentPage(currentPage);
	    pagingVO.setUserNo(memberNo);
	    pagingVO.setProjectNo(projectNo);
	    pagingVO.setProjectRole(projectRole); // 쿼리 분기용
	    pagingVO.setTabType(tabType);
	    pagingVO.setSearchType(searchType);
	    pagingVO.setSearchWord(searchWord);
	    pagingVO.setUserAuth(userAuth);
	    	    
	    int totalRecord = approvalService.getApprovalCount(pagingVO);
	    pagingVO.setTotalRecord(totalRecord);

	    List<DraftDocumentVO> approvalList = approvalService.getApprovalList(pagingVO);
	    pagingVO.setDataList(approvalList);

	    model.addAttribute("pagingVO", pagingVO);
	    model.addAttribute("projectNo", projectNo); 
	    model.addAttribute("menu", "approval");
	    model.addAttribute("userAuth", userAuth);
	    
	    
	    return "approval/list"; 
	}
	
	/**
	 * 결재문서 작성 화면 
	 */
	@GetMapping("/form")
	public String approvalForm(@RequestParam(value="projectNo", defaultValue="0") int projectNo, 
	                           HttpSession session, Model model) {
	    MemberVO member = (MemberVO) session.getAttribute("loginUser");
	    
	    if (member == null) {
	        return "redirect:/login"; 
	    }
	    
	    int memberNo = member.getMemberNo();
	    
	    List<ProjectVO> myProjectList = approvalService.getMyProjectList(memberNo);
	    
	    String projectRole = "";
	    if (projectNo > 0) {
	        projectRole = approvalService.getProjectRole(projectNo, memberNo);
	    }

	    model.addAttribute("myProjectList", myProjectList);
	    model.addAttribute("projectNo", projectNo); 
	    model.addAttribute("projectRole", projectRole);
	    
	    model.addAttribute("loginUser", member); 

	    return "approval/form";
	}
	
	/**
	 * 결재선 지정을 위한 해당 프로젝트의 CLIENT 목록 조회
	 */
	@ResponseBody
	@GetMapping("/getApproverList")
	public List<MemberVO> getApproverList(@RequestParam("projectNo") int projectNo) {
	    List<MemberVO> clientList = approvalService.getProjectClientList(projectNo);
	    
	    return clientList;
	}
	
	/**
	 * 결재 상신 (등록) 
	 */
	@ResponseBody
	@PostMapping("/insert")
	public String insertDraft(
	    @RequestPart(value = "approvalListJson") String approvalListJson, 
	    @RequestPart(value = "upfile", required = false) MultipartFile[] upfile, 
	    DraftDocumentVO draftVO, 
	    HttpSession session
	) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if (loginUser == null) return "login_required";

	    draftVO.setMemberNo(loginUser.getMemberNo());

	    try {
	        if (upfile != null && upfile.length > 0 && !upfile[0].isEmpty()) {
	            int fileGroupNo = fileService.uploadFiles(Arrays.asList(upfile), loginUser.getMemberNo(), 410);
	            draftVO.setFileGroupNo(fileGroupNo); 
	        }

	        ObjectMapper mapper = new ObjectMapper();
	        List<DraftApprovalVO> approvalList = mapper.readValue(approvalListJson, 
	            new TypeReference<List<DraftApprovalVO>>(){});
	        
	        draftVO.setApprovalList(approvalList);

	        int result = approvalService.insertDraft(draftVO);
	        return result > 0 ? "success" : "fail";

	    } catch (Exception e) {
	        log.error("결재 상신 에러 발생: ", e);
	        return "error";
	    }
	}
	
	/**
	 * 결재 문서 상세 조회 (detail)
	 */
	@GetMapping("/detail")
	public String draftDetail(@RequestParam("no") int documentNo, Principal principal, Model model, HttpSession session) {
		
		String memberId = principal.getName();
	    MemberVO member = memberService.findByMemberId(memberId);	    
	    
	    String userAuth = "";
	    if (member.getMemberAuthVOList() != null && !member.getMemberAuthVOList().isEmpty()) {
	        userAuth = member.getMemberAuthVOList().get(0).getAuth(); 
	    }
	    model.addAttribute("userAuth", userAuth);
						
	    DraftDocumentVO draft = approvalService.selectDraftDetail(documentNo);
	    List<DraftApprovalVO> approvalList = approvalService.selectApprovalList(documentNo);
	    
	    if (draft.getFileGroupNo() != null && draft.getFileGroupNo() > 0) {
	        List<FileDetailVO> fileList = fileService.selectFileDetailList(draft.getFileGroupNo());
	        model.addAttribute("fileList", fileList); 
	    }
	    
	    String projectRole = approvalService.getProjectRole(draft.getProjectNo(), member.getMemberNo());
	    boolean isCurrentApprover = approvalService.isCurrentApprover(documentNo, member.getMemberNo());
	    
	    model.addAttribute("draft", draft);
	    model.addAttribute("approvalList", approvalList);
	    model.addAttribute("userAuth", userAuth);
	    model.addAttribute("isCurrentApprover", isCurrentApprover);
	    model.addAttribute("projectRole", projectRole);
	    model.addAttribute("loginUser", member);
	    
	    return "approval/detail"; 
	}
	
	/**
	 * 결재 승인
	 */
    @PostMapping("/approve")
    @ResponseBody 
    public String approveDocument(@RequestParam int documentNo, @RequestParam int memberNo) {
        String result = approvalService.approveDocument(documentNo, memberNo);
        return result; 
    }

    /**
	 * 결재 반려
	 */
    @PostMapping("/reject")
    @ResponseBody
    public String rejectDocument(@RequestParam int documentNo, 
                                 @RequestParam int memberNo, 
                                 @RequestParam String rejectionReason) {
        String result = approvalService.rejectDocument(documentNo, memberNo, rejectionReason);
        return result;
    }
    
    /**
     * 문서 회수
     */
    @PostMapping("/recall")
    public String recallDocument(@RequestParam("documentNo") int documentNo, HttpSession session, RedirectAttributes ra) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        int result = approvalService.recallDocument(documentNo, loginUser.getMemberNo());
        
        if (result > 0) {
            ra.addFlashAttribute("message", "임시보관함에 저장되었습니다.");
        } else {
            ra.addFlashAttribute("error", "회수할 수 없는 상태입니다.");
        }
        
        return "redirect:/tudio/approval/detail?no=" + documentNo;
    }
    
    /**
     * 다운로드
     */
  	@GetMapping("/download")
  	public void fileDownload(@RequestParam("fileNo") int fileNo, HttpServletResponse response) throws Exception {
  	    FileDetailVO fileVO = fileService.selectFileDetail(fileNo);
  	    if (fileVO == null) {
  	    	  log.error("DB에 파일 정보가 없습니다! fileNo: {}", fileNo);
              response.sendError(HttpServletResponse.SC_NOT_FOUND, "DB 파일 정보 없음");
              return;
          }

  	    String dbPath = fileVO.getFilePath();
  	    log.info("조회된 파일 경로: {}", dbPath);
        File file = null;
  	    
        if (dbPath != null && dbPath.startsWith("/local/")) {
        	String realFileName = dbPath.replace("/local/", "");
        	file = new File(uploadPath + realFileName);
    	} else {
        	String realPath = servletContext.getRealPath(dbPath);
        	file = new File(realPath);
        }

          
        if (!file.exists()) {
        	log.error("파일이 존재하지 않습니다. 경로: {}", file.getAbsolutePath());
        	response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
         	return;
        }

          
        String encodedName = URLEncoder.encode(
        		fileVO.getFileOriginalName(), "UTF-8"
        ).replaceAll("\\+", "%20"); 

        response.setContentType("application/octet-stream");
        response.setHeader(
        	"Content-Disposition",
        	"attachment; filename=\"" + encodedName + "\""
        );
        response.setContentLengthLong(file.length());
          
        FileUtils.copyFile(file, response.getOutputStream());
      }

}