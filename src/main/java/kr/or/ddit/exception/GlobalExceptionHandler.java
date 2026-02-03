package kr.or.ddit.exception;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.log.service.ILogErrorService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.log.LogErrorVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
	
	@Autowired
	private ILogErrorService logErrorService;
	
	/**
     * [1] 404 에러 (페이지 없음)
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(NoHandlerFoundException ex, HttpServletRequest request) {
        saveErrorLog(ex, request, 404);
        return "error/404";
    }
    
    /**
     * [2] 403 에러 (권한 없음)
     * 시큐리티를 사용 중이라면 AccessDeniedException을 낚아챕니다.
     */
    @ExceptionHandler(AccessDeniedException.class)
    public String handle403(AccessDeniedException ex, HttpServletRequest request) {
        saveErrorLog(ex, request, 403); // 상태 코드 403 전달
        return "error/403";
    }
    
    @ExceptionHandler(NoResourceFoundException.class)
    public void handleNoResourceFoundException(NoResourceFoundException ex) {
    }
    
    /**
     * [3] 500 에러 (서버 내부 오류)
     */
    @ExceptionHandler(Exception.class)
    public String handleAllException(Exception ex, HttpServletRequest request) {
        saveErrorLog(ex, request, 500);
        return "error/500";
    }
	
    /**
	 * [공통] 에러 로그 DB 저장 로직
	 */
	private void saveErrorLog(Exception ex, HttpServletRequest request, int statusCode) {
		// log.error("[시스템 에러 감지] 코드: {} | 요청 주소: {}", statusCode, request.getRequestURI());
		
		// 스택트레이스를 문자열로 변환
		StringWriter sw = new StringWriter();
		ex.printStackTrace(new PrintWriter(sw));
		String errorDetail = sw.toString();
		
		// 세션에서 사용자 정보 추출
		HttpSession session = request.getSession();
		MemberVO loginMember = (MemberVO) session.getAttribute("loginUser");
		
		Integer memberNo = (loginMember != null) ? loginMember.getMemberNo() : null;
		
		// 로그 객체 생성 및 값 세팅
		LogErrorVO logVO = new LogErrorVO();
		logVO.setErrorMessage(ex.getMessage());
		logVO.setErrorDetail(errorDetail);
		logVO.setRequestUri(request.getRequestURI());
		logVO.setHttpMethod(request.getMethod());
		logVO.setIpAddr(request.getRemoteAddr());
		logVO.setUserAgent(request.getHeader("User-Agent"));
		logVO.setMemberNo(memberNo);
		
		// ★ DB에 추가한 STATUS_CODE 컬럼에 숫자를 넣습니다.
		logVO.setStatusCode(statusCode);
		
		try {
			logErrorService.insertErrorLog(logVO);
			// log.info("에러 로그 DB 저장 완료(ID: {}, Code: {})", logVO.getErrorLogId(), statusCode);
		} catch(Exception e) {
			log.error("에러 로그 저장 실패", e);
		}
	}
}