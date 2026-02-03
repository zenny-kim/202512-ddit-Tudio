package kr.or.ddit.comment.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.comment.service.ICommentService;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.schedule.controller.ScheduleController;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : CommentController
 * DESC : 게시판, 업무 등 댓글 기능 공통 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.14
 * 
 */

@Slf4j
@Controller
@RequestMapping("/comment")
public class CommentController {

	@Autowired
	private IFileService fileService;
	
	@Autowired
	private ICommentService commentService;
	
	@Autowired
	private ServletContext servletContext;
	
	// 일반 파일 경로 (C:/upload/)
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	// 이미지 파일 경로 (svn = src/main/webapp/upload/)
	@Value("${kr.or.ddit.imageUpload.path}")
	private String imageUploadPath;

	// 댓글 목록
	@GetMapping("/list")
	public String getCommentList(@RequestParam("targetType") String targetType, @RequestParam("targetId") int targetId,
			Model model) {

		CommentVO commentVO = new CommentVO();
		commentVO.setTargetType(targetType);
		commentVO.setTargetId(targetId);

		// 서비스에서 댓글 목록 조회
		List<CommentVO> commentList = commentService.selectCommentList(commentVO);
		model.addAttribute("commentList", commentList);

		// 댓글 목록만 있는 JSP 리턴
		return "comment";
	}

	// 댓글 등록
	@PostMapping("/insert")
	public ResponseEntity<String> insertComment(HttpSession session, CommentVO commentVO) {
		log.info("insertComment() 실행");

		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return new ResponseEntity<String>("LOGIN_REQUIRED", HttpStatus.OK);
		}
		commentVO.setMemberNo(loginUser.getMemberNo());
		ServiceResult result = commentService.insertComment(commentVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);

	}

	// 댓글 수정 ( 대댓글 수정 포함 )
	@PostMapping("/update")
	public ResponseEntity<String> updateComment(HttpSession session, @RequestBody CommentVO commentVO) {
		log.info("updateComment() 실행");
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return new ResponseEntity<String>("LOGIN_REQUIRED", HttpStatus.OK);
		}
		commentVO.setMemberNo(loginUser.getMemberNo());
		ServiceResult result = commentService.updateComment(commentVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);

	}

	// 댓글 삭제 ( 대댓글 삭제 포함 )
	@PostMapping("/delete")
	public ResponseEntity<String> deleteComment(HttpSession session, @RequestBody CommentVO commentVO) {
		log.info("deleteComment() 실행");
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return new ResponseEntity<String>("LOGIN_REQUIRED", HttpStatus.OK);
		}
		commentVO.setMemberNo(loginUser.getMemberNo());
		ServiceResult result = commentService.deleteComment(commentVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}

	// 대댓글 등록
	@PostMapping("/insertReplyComment")
	public ResponseEntity<String> insertReplyComment(HttpSession session, CommentVO commentVO) {
		log.info("insertSubComment() 실행");
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return new ResponseEntity<String>("LOGIN_REQUIRED", HttpStatus.OK);
		}
		commentVO.setMemberNo(loginUser.getMemberNo());
		if (commentVO.getCmtFileList() != null) {
			log.info("대댓글 파일 개수: " + commentVO.getCmtFileList().size());
		}
		ServiceResult result = commentService.insertReplyComment(commentVO);
		return new ResponseEntity<String>(result.toString(), HttpStatus.OK);

	}

	// 댓글 내부 파일 다운로드
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

		// 다운로드 헤더 설정
		String encodedName = URLEncoder.encode(fileVO.getFileOriginalName(), "UTF-8").replaceAll("\\+", "%20"); // 공백 처리

		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
		response.setContentLengthLong(file.length());

		// 사용자에게 파일 데이터 전송
		FileUtils.copyFile(file, response.getOutputStream());
	}

}
