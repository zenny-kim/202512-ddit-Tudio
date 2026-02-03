package kr.or.ddit.log.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.log.service.ILogActionService;
import kr.or.ddit.vo.PageResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogActionVO;
import kr.or.ddit.vo.log.LogSearchVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/log/action")
public class LogActionController {
	
	@Autowired
	private ILogActionService logActionService;
	
	@GetMapping("/list")
	public PageResult<LogActionVO> actionLogList(
				@RequestParam(name="page", defaultValue = "1") int currentPage,
				@RequestParam(required = false) String searchType,
				@RequestParam(required = false) String searchWord,
				@RequestParam(required = false) String startDate,
				@RequestParam(required = false) String endDate) {
		
		log.info("[API] 액션 로그 목록 요청 - page: {}, type: {}, word: {}", currentPage, searchType, searchWord);
		
		LogSearchVO<LogActionVO> searchVO = new LogSearchVO<>();
		
		searchVO.setScreenSize(10);
		searchVO.setBlockSize(5);
		
		searchVO.setCurrentPage(currentPage); 
		searchVO.setSearchType(searchType);
		searchVO.setSearchWord(searchWord);
		
		searchVO.setStartDate(startDate);
		searchVO.setEndDate(endDate);
		
		PaginationInfoVO<LogActionVO> resultVO = logActionService.getActionLogList(searchVO);
		
		return new PageResult<>(resultVO.getDataList(), resultVO);
	}
}
