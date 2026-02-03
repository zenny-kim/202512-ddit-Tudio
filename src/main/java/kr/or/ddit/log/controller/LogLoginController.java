package kr.or.ddit.log.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.log.service.ILogLoginService;
import kr.or.ddit.vo.PageResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogLoginVO;
import kr.or.ddit.vo.log.LogSearchVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/log/login")
public class LogLoginController {
	
	@Autowired
	private ILogLoginService logLoginService;
	
	/**
	 * 로그인 로그 목록 조회
	 */
	@GetMapping("/list")
	public PageResult<LogLoginVO> loginLogList(@RequestParam(name="page", defaultValue = "1") int currentPage,
			@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate){
		
		log.info("[API] 로그인 로그 목록 요청 - page: {}, type: {}, word: {}", currentPage, searchType, searchWord);
		
		LogSearchVO<LogLoginVO> searchVO = new LogSearchVO<>();
		
		searchVO.setScreenSize(10);
        searchVO.setBlockSize(5);
        
        searchVO.setCurrentPage(currentPage); 
		searchVO.setSearchType(searchType);
		searchVO.setSearchWord(searchWord);
		
		searchVO.setStatus(status);
        searchVO.setStartDate(startDate);
        searchVO.setEndDate(endDate);
		
        PaginationInfoVO<LogLoginVO> resultVO = logLoginService.getLoginLogList(searchVO);
		
        return new PageResult<>(resultVO.getDataList(), resultVO);
	}
	
	@GetMapping("/test/error")
    public String errorTest() {
        log.info("💀 [테스트] 고의로 에러를 발생시킵니다!");
        
        int result = 1 / 0; // 여기서 빵! 터짐 (ArithmeticException)
        
        return "이 문장은 안 보일 겁니다."; 
    }
}
