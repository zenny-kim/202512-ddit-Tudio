package kr.or.ddit.log.service;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogLoginVO;
import kr.or.ddit.vo.log.LogSearchVO;

public interface ILogLoginService {

	/**
	 * 로그인 로그 저장
	 * @param request : IP / User-Agent
	 * @param loginId : ID
	 * @param status  : SUCCESS / FAIL	
	 * @param failReason : 실패 사유
	 * @param memberNo : 회원 번호
	 */
	public void logLogin(HttpServletRequest request, String loginId, String status, String failReason, Integer memberNo);
	
	// 로그인 목록 조회
	public PaginationInfoVO<LogLoginVO> getLoginLogList(LogSearchVO<LogLoginVO> searchVO);
}
