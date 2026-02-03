package kr.or.ddit.log.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.log.mapper.ILogMapper;
import kr.or.ddit.log.service.ILogBatchService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.log.LogBatchVO;
import kr.or.ddit.vo.log.LogSearchVO;

@Service
public class LogBatchServiceImpl implements ILogBatchService {
	
	@Autowired
	private ILogMapper logMapper;

	@Override
	public void insertBatchLog(LogBatchVO logVO) {
		logMapper.insertBatchLog(logVO);
	}

	@Override
	public PaginationInfoVO<LogBatchVO> getBatchLogList(LogSearchVO<LogBatchVO> searchVO) {
		
        int totalRecord = logMapper.selectBatchLogCount(searchVO);
        searchVO.setTotalRecord(totalRecord);
        
       
        if(searchVO.getEndPage() > searchVO.getTotalPage()) {
            searchVO.setEndPage(searchVO.getTotalPage());
        }
        
      
        if(searchVO.getTotalPage() > 0 && searchVO.getCurrentPage() > searchVO.getTotalPage()) {
            searchVO.setCurrentPage(searchVO.getTotalPage());
            searchVO.setEndPage(searchVO.getTotalPage());
        }
        
      
        List<LogBatchVO> dataList = logMapper.selectBatchLogList(searchVO);
        
      
        searchVO.setDataList(dataList);
        
        return searchVO;
	}

}
