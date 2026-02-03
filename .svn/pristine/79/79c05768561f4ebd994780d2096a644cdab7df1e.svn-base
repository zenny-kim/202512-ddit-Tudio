package kr.or.ddit.log.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.log.service.ILogErrorService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PageResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogErrorVO;
import kr.or.ddit.vo.log.LogSearchVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/log/error")
public class LogErrorController {

	@Autowired
	private ILogErrorService logErrorService;
	
	// 에러 로그 목록 조회
	@GetMapping("/list")
	public PageResult<LogErrorVO> errorLogList(
			@RequestParam(name="page", defaultValue = "1") int currentPage,
			@RequestParam(required = false) String searchType,  // 404, 500 등
			@RequestParam(required = false) String searchWord,  // 검색어
			@RequestParam(required = false) String startDate,   // 시작일
			@RequestParam(required = false) String endDate      // 종료일
			){
		
		log.info("[API] 에러 로그 조회 - page: {}, type: {}", currentPage, searchType);
		
		LogSearchVO<LogErrorVO> searchVO = new LogSearchVO<>();
		
		searchVO.setCurrentPage(currentPage);
		searchVO.setScreenSize(10);
		searchVO.setBlockSize(5);
		
		searchVO.setSearchType(searchType);
		searchVO.setSearchWord(searchWord);
		searchVO.setStartDate(startDate);
		searchVO.setEndDate(endDate);
		
		PaginationInfoVO<LogErrorVO> resultVO = logErrorService.getErrorLogList(searchVO);
		
		return new PageResult<>(resultVO.getDataList(), resultVO);
	}
	
	// 에러로그 해결 상태 업데이트
	@PutMapping("/resolve/{errorLogId}")
	public ResponseEntity<String> resolveError(@PathVariable int errorLogId, HttpSession session){
		
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		
		if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
		
		LogErrorVO logVO = new LogErrorVO();
        logVO.setErrorLogId(errorLogId);
        logVO.setResolvedMemberNo(loginUser.getMemberNo());
        
        int result = logErrorService.resolveErrorLog(logVO);

        if (result > 0) {
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        }
	}
}
