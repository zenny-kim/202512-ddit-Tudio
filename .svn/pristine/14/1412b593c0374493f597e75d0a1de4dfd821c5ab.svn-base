package kr.or.ddit.log.service;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogErrorVO;
import kr.or.ddit.vo.log.LogSearchVO;

public interface ILogErrorService {
	// 에러 로그 저장
	public void insertErrorLog(LogErrorVO logVO);
	
	// 에러 로그 목록 조회
	public PaginationInfoVO<LogErrorVO> getErrorLogList(LogSearchVO<LogErrorVO> searchVO);

	// 에러 로그 해결 상태 업데이트
	public int resolveErrorLog(LogErrorVO logVO);
}
