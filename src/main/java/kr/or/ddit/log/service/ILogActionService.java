package kr.or.ddit.log.service;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogActionVO;
import kr.or.ddit.vo.log.LogSearchVO;

public interface ILogActionService {
	/**
	 * 액션 로그 저장
	 * @param request    : 접속 IP 
	 * @param memberNo   : 행위를 수행한 관리자 번호
	 * @param menuName   : 수행한 메뉴명 
	 * @param actionType : 행위 유형 
	 * @param targetIdv  : 행위 대상의 식별 값 
	 * @param actionMsg  : 상세 수행 내용 
	 */
	public void logAction(HttpServletRequest request, int memberNo, String menuName, 
            String actionType, String targetIdv, String actionMsg);
    
    // 액션 로그 목록 조회
	public PaginationInfoVO<LogActionVO> getActionLogList(LogSearchVO<LogActionVO> searchVO);
}