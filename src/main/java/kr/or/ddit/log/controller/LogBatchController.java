package kr.or.ddit.log.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.log.service.ILogBatchService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogBatchVO;
import kr.or.ddit.vo.log.LogSearchVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/log/batch")
public class LogBatchController {
	
	@Autowired
	private ILogBatchService batchService;
	
	@GetMapping("/list")
	public PaginationInfoVO<LogBatchVO> getBatchLogList(LogSearchVO<LogBatchVO> searchVO) {
		
		log.info("[API] 배치 로그 조회 요청 - Page: {}, Search: {}", searchVO.getCurrentPage(), searchVO.getSearchWord());
		
		PaginationInfoVO<LogBatchVO> result = batchService.getBatchLogList(searchVO);
		
		return result;
	}
}
