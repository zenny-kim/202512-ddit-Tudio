package kr.or.ddit.projectBoard.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.comment.service.ICommentService;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.projectBoard.service.ITabBoardService;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.project.BoardCategoryVO;
import kr.or.ddit.vo.project.ProjectBoardVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : TabBoardController
 * DESC : 프로젝트 내부 탭 안에 있는 게시글-공지,자유,회의록 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.07
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio/project/board")
public class TabBoardController {
	
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private ITabBoardService boardService;

	@Autowired
	private IFileService fileService;
	
	@Autowired
	private ICommentService commentService;
	
	//일반 파일 경로 (C:/upload/)
	@Value("${kr.or.ddit.upload.path}")
    private String uploadPath;
	
	//이미지 파일 경로 (svn = src/main/webapp/upload/)
	@Value("${kr.or.ddit.imageUpload.path}")
    private String imageUploadPath;
	
	// 프로젝트 게시글 목록 화면
	@GetMapping
	public String TabBoardListPage(ProjectBoardVO boardVO, BoardCategoryVO categoryVO, HttpSession session, Model model) {
		log.info("TabBoardListPage() 실행, 쿼리스트링 projectNo: {}", categoryVO.getProjectNo());
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    if(loginUser == null) {
	        return "redirect:/tudio/login";
	    }
		return "project/tabs/projectBoard/projectBoardList";
	}
	
	//프로젝트 게시글 목록 (json 데이터만 보냄)
	@ResponseBody
    @GetMapping("/listData")
    public PaginationInfoVO<ProjectBoardVO> TabBoardList(
             @RequestParam(name="projectNo") int projectNo
            ,@RequestParam(name="category", required=false, defaultValue="") String category
            ,@RequestParam(name="page",required=false,defaultValue="1") int currentPage
            ,@RequestParam(required=false, defaultValue="title")String searchType
			,@RequestParam(required=false) String searchWord
			,Authentication auth, Model model) {
        
        log.info("TabBoardList() 실행, projectNo: {}, category: {}", projectNo, category);
        
        // 페이징, 검색기능 처리
        PaginationInfoVO<ProjectBoardVO> pagingVO = new PaginationInfoVO<>();
        if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchType(searchType);
			pagingVO.setSearchWord(searchWord);
			
			//검색 후 목록페이지로 이동할 때 검색된 내용을 적용시키기 위해 데이터 전달
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
		}
        pagingVO.setCurrentPage(currentPage);

		// DB 조회
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("projectNo", projectNo);
        paramMap.put("category", category);
        paramMap.put("pagingVO", pagingVO);
        
        // 총 게시글 수 조회, 페이징 계산
        int totalRecord = boardService.countProjectBoard(paramMap);
        pagingVO.setTotalRecord(totalRecord);

        // 실제 데이터 리스트 조회
        List<ProjectBoardVO> dataList = boardService.selectProjectBoardList(paramMap);
        pagingVO.setDataList(dataList);
        
        return pagingVO;
    }
	

	// 프로젝트 게시글 등록 화면
	@GetMapping("/insert")
	public String TabBoardInsertPage(@RequestParam("projectNo") int projectNo, Model model) {
		log.info("TabBoardPage() 실행 - projectNo: {}", projectNo);
		model.addAttribute("projectNo", projectNo);
		List<MemberVO> memberList = boardService.getProjectMemberList(projectNo);
	    model.addAttribute("memberList", memberList);
		return "project/tabs/projectBoard/projectBoardForm";
	}
	
	//프로젝트 게시글 등록 기능
	@ResponseBody
	@PostMapping("/insert")
	public Map<String, Object> TabBoardInsert(@RequestParam("projectNo") int projectNo
			, ProjectBoardVO boardVO, Model model
			,HttpSession session, RedirectAttributes ra) {
		log.info("insertTabBoard() 실행");
		Map<String, Object> response = new HashMap<>();
		if(StringUtils.isBlank(boardVO.getBoTitle()) || StringUtils.isBlank(boardVO.getBoContent())) {
	        response.put("status", "fail");
	        response.put("message", "제목이나 내용이 비어있습니다.");
	        return response;
	    }
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
	        response.put("status", "error");
	        response.put("message", "로그인이 필요합니다.");
	        return response;
	    }
		boardVO.setMemberNo(loginUser.getMemberNo());
	    ServiceResult result = boardService.insertProjectBoard(boardVO);
	    if (result.equals(ServiceResult.OK)) {
	        response.put("status", "success");
	        response.put("boNo", boardVO.getBoNo()); 
	        response.put("projectNo", boardVO.getProjectNo());
	    } else {
	        response.put("status", "error");
	        response.put("message", "서버 에러가 발생했습니다.");
	    }
		return response;	
	}
	
	//프로젝트 게시글 상세 화면
	@GetMapping("/detail")
	public String TabBoardDetail(@RequestParam("projectNo") int projectNo
			, @RequestParam("boNo") int boNo, Model model , HttpSession session) {
		log.info("tabBoardDetail() 실행  projectNo: {}, boNo: {}", projectNo, boNo);
	    
		// 게시글 상세 조회
	    ProjectBoardVO boardVO = boardService.detailProjectBoard(boNo);
	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
	    model.addAttribute("loginUser", loginUser);
	    model.addAttribute("board", boardVO);
	    model.addAttribute("projectNo", projectNo);
	    
	    // 회의록이라면 회의멤버
	    List<MemberVO> memberList = boardService.getProjectMemberList(projectNo);
	    model.addAttribute("memberList", memberList);
	    
	    //댓글 목록 조회
	    CommentVO commentVO = new CommentVO();
        commentVO.setTargetType("B");  // 게시판이니까 "B"
        commentVO.setTargetId(boNo);   // 현재 게시글 번호
        List<CommentVO> commentList = commentService.selectCommentList(commentVO);
        model.addAttribute("commentList", commentList);
        
	    return "project/tabs/projectBoard/projectBoardDetail";
	}
	
	//게시글 상세화면 조회수 증가
	@PostMapping("/hit")
	@ResponseBody
	public void TabBoardincreaseHit(@RequestParam int boNo) {
	    boardService.increaseHitProjectBoard(boNo);
	}
	
	//게시글 수정 화면
	@GetMapping("/update")
	public String TabBoardUpdatePage(@RequestParam("projectNo") int projectNo, 
	                              @RequestParam("boNo") int boNo, Model model) {
	    log.info("boardUpdatePage() 실행  projectNo: {}, boNo: {}", projectNo, boNo);
		ProjectBoardVO boardVO = boardService.detailProjectBoard(boNo);
	    model.addAttribute("board", boardVO);
	    model.addAttribute("status", "u");
	    List<MemberVO> memberList = boardService.getProjectMemberList(projectNo);
	    model.addAttribute("memberList", memberList);
	    model.addAttribute("projectNo", projectNo);

	    return "project/tabs/projectBoard/projectBoardForm"; 
	}
	
	//게시글 수정 기능
	@PostMapping("/update")
	@ResponseBody
	public Map<String, Object> TabBoardUpdate(@RequestParam("projectNo") int projectNo, ProjectBoardVO boardVO,
			Model model, HttpSession session, RedirectAttributes ra) {
		Map<String, Object> response = new HashMap<>();
		log.info("boardUpdate() 실행 : projectNo: {}", projectNo);
		log.info("update boNo = {}", boardVO.getBoNo());
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			response.put("status", "error");
			response.put("message", "로그인이 필요합니다.");
			return response;
		}
		boardVO.setProjectNo(projectNo);
		boardVO.setMemberNo(loginUser.getMemberNo());

		ServiceResult result = boardService.updateProjectBoard(boardVO);
		if (ServiceResult.OK.equals(result)) {
			response.put("status", "success");
			response.put("message", "게시글이 성공적으로 수정되었습니다.");
			response.put("boNo", boardVO.getBoNo());
		} else {
			response.put("status", "fail");
			response.put("message", "게시글 수정에 실패했습니다. 다시 시도해주세요.");
		}
		return response;
	}
	
	//게시글 삭제 기능
	@PostMapping("/delete")
	@ResponseBody
	public ServiceResult TabBoardDelete(@RequestParam("boNo") int boNo) {
		log.info("deleteBoard() 실행");
		return boardService.deleteProjectBoard(boNo);
		
	}
	
	//게시글 내부 파일 다운로드
	@GetMapping("/download")
	public void fileDownload(@RequestParam("fileNo") int fileNo, HttpServletResponse response) throws Exception {
	    // DB에서 파일 정보 조회
	    FileDetailVO fileVO = fileService.selectFileDetail(fileNo);
	    if (fileVO == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "DB 파일 정보 없음");
            return;
        }
	    // 실제 물리 파일 찾기
	    String dbPath = fileVO.getFilePath();
        File file = null;
	    
        // DB 경로 /local/ 들어가는 파일 : C드라이브 파일
        if (dbPath != null && dbPath.startsWith("/local/")) {
            String realFileName = dbPath.replace("/local/", "");
            file = new File(uploadPath + realFileName);
        } else {
            // DB 경로 /upload/ 시작 파일 : svn 내부 저장 이미지
            String realPath = servletContext.getRealPath(dbPath);
            file = new File(realPath);
        }

        // 파일 여부 확인
        if (!file.exists()) {
            log.error("파일이 존재하지 않습니다. 경로: {}", file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
            return;
        }

        // 다운로드
        String encodedName = URLEncoder.encode(
            fileVO.getFileOriginalName(), "UTF-8"
        ).replaceAll("\\+", "%20"); // 공백 처리

        response.setContentType("application/octet-stream");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"" + encodedName + "\""
        );
        response.setContentLengthLong(file.length());

        // 사용자에게 파일 데이터 전송
        FileUtils.copyFile(file, response.getOutputStream());
    }
	
}
