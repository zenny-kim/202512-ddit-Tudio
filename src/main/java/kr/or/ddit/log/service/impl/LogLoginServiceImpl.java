package kr.or.ddit.log.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.log.mapper.ILogMapper;
import kr.or.ddit.log.service.ILogLoginService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogLoginVO;
import kr.or.ddit.vo.log.LogSearchVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class LogLoginServiceImpl implements ILogLoginService{
	
	@Autowired
	private ILogMapper logMapper;

	@Override
	public void logLogin(HttpServletRequest request, String loginId, String status, String failReason, Integer memberNo) {
		
		log.info("로그인 로그 저장 요청 | ID: {} | Status: {} | FailReason: {}", loginId, status, failReason);
		
		LogLoginVO loginVO = new LogLoginVO();
		
		loginVO.setLoginId(loginId);
		loginVO.setLoginStatus(status);
		loginVO.setFailReason(failReason);
		loginVO.setMemberNo(memberNo); // 로그인 실패시 null
		
		String ip = request.getRemoteAddr();
		String userAgent = request.getHeader("User-Agent");
		
		loginVO.setIpAddr(ip);
		loginVO.setUserAgent(userAgent);
		
		String browser = parseBrowser(userAgent);
		loginVO.setBrowser(browser);
		
		log.debug("브라우저 파싱 상세 | IP: {} | Browser: {} | UserAgent: {}", ip, browser, userAgent);
		
		logMapper.insertLoginLog(loginVO);
	}

	private String parseBrowser(String userAgent) {
		
		if(userAgent == null || userAgent.trim().isEmpty()) {
			return "Unknown";
		}
		
		String agentLower = userAgent.toLowerCase();
		
		if(agentLower.contains("edg")) return "Edge";
		if (agentLower.contains("whale")) return "Whale";
		if (agentLower.contains("chrome")) return "Chrome";
		if (agentLower.contains("safari")) return "Safari";
		if (agentLower.contains("firefox")) return "Firefox";
		if (agentLower.contains("trident") || agentLower.contains("msie")) return "IE";
		
		return "Other";
	}

	@Override
	public PaginationInfoVO<LogLoginVO> getLoginLogList(LogSearchVO<LogLoginVO> searchVO) {
		log.info("관리자 로그인 로그 목록 조회 요청");
		
		// 1. 전체 글 개수 조회
		int totalRecord = logMapper.selectLoginLogCount(searchVO);
		
        searchVO.setTotalRecord(totalRecord);
        
        if(searchVO.getEndPage() > searchVO.getTotalPage()) {
			searchVO.setEndPage(searchVO.getTotalPage());
		}
        
    	// 2. 리스트 구하기
        List<LogLoginVO> dataList = logMapper.selectLoginLogList(searchVO);
        searchVO.setDataList(dataList);
        
        return searchVO;
	}
	
}
