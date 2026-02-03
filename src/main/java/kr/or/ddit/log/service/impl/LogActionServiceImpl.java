package kr.or.ddit.log.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.log.mapper.ILogMapper;
import kr.or.ddit.log.service.ILogActionService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogActionVO;
import kr.or.ddit.vo.log.LogSearchVO;

@Service
public class LogActionServiceImpl implements ILogActionService {
	
	@Autowired
	private ILogMapper logMapper;

	// 액션 로그 저장
	@Override
	public void logAction(HttpServletRequest request, int memberNo, String menuName, String actionType,
			String targetIdv, String actionMsg) {
		
		LogActionVO logVO = new LogActionVO();
		logVO.setMemberNo(memberNo);
		logVO.setMenuName(menuName);
		logVO.setActionType(actionType);
		logVO.setTargetIdv(targetIdv);
		logVO.setActionMsg(actionMsg);
		
		String ip = request.getRemoteAddr();
		if ("0:0:0:0:0:0:0:1".equals(ip)) {
			ip = "127.0.0.1";
		}
		logVO.setIpAddr(ip);
		
		logMapper.insertActionLog(logVO);
	}

	@Override
	public PaginationInfoVO<LogActionVO> getActionLogList(LogSearchVO<LogActionVO> searchVO) {
		
		int totalRecord = logMapper.selectActionLogCount(searchVO);
		searchVO.setTotalRecord(totalRecord);
		
		if(searchVO.getEndPage() > searchVO.getTotalPage()) {
	        searchVO.setEndPage(searchVO.getTotalPage());
	    }
		
		if(searchVO.getTotalPage() > 0 && searchVO.getCurrentPage() > searchVO.getTotalPage()) {
	        searchVO.setCurrentPage(searchVO.getTotalPage());
	        searchVO.setEndPage(searchVO.getTotalPage());
	    }
		
		List<LogActionVO> dataList = logMapper.selectActionLogList(searchVO);
		
		searchVO.setDataList(dataList);
		
		return searchVO;
	}

}
