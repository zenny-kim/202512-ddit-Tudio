package kr.or.ddit.log.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.log.mapper.ILogMapper;
import kr.or.ddit.log.service.ILogErrorService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogErrorVO;
import kr.or.ddit.vo.log.LogSearchVO;

@Service
public class LogErrorServiceImpl implements ILogErrorService {
	
	@Autowired
	private ILogMapper logMapper;

	@Override
	public void insertErrorLog(LogErrorVO logVO) {
		logMapper.insertErrorLog(logVO);
	}

	@Override
	public PaginationInfoVO<LogErrorVO> getErrorLogList(LogSearchVO<LogErrorVO> searchVO) {
		
		int totalRecord = logMapper.selectErrorLogCount(searchVO);
		
		searchVO.setTotalRecord(totalRecord);
		
		if(searchVO.getEndPage() > searchVO.getTotalPage()) {
            searchVO.setEndPage(searchVO.getTotalPage());
        }
		
		if(searchVO.getTotalPage() > 0 && searchVO.getCurrentPage() > searchVO.getTotalPage()) {
			searchVO.setCurrentPage(searchVO.getTotalPage());
			searchVO.setEndPage(searchVO.getTotalPage());
		}
		
		List<LogErrorVO> dataList = logMapper.selectErrorLogList(searchVO);
		
		searchVO.setDataList(dataList);
		
		return searchVO;
	}

	// 에러 로그 해결 상태 업데이트
	@Override
	public int resolveErrorLog(LogErrorVO logVO) {
		return logMapper.resolveErrorLog(logVO);
	}
	
	

}
