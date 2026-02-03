package kr.or.ddit.log.service;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogBatchVO;
import kr.or.ddit.vo.log.LogSearchVO;

public interface ILogBatchService {
	
	// 배치 로그 등록
	public void insertBatchLog(LogBatchVO logVO);
	
	// 배치 로그 목록 조회
	public PaginationInfoVO<LogBatchVO> getBatchLogList(LogSearchVO<LogBatchVO> searchVO);
}