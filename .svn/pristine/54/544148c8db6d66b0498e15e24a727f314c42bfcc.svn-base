package kr.or.ddit.log.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.log.LogActionVO;
import kr.or.ddit.vo.log.LogBatchVO;
import kr.or.ddit.vo.log.LogErrorVO;
import kr.or.ddit.vo.log.LogLoginVO;
import kr.or.ddit.vo.log.LogSearchVO;

@Mapper
public interface ILogMapper {

	// 로그인 로그 저장
	public int insertLoginLog(LogLoginVO logVO);
	
	// 로그인 로그 글 개수 조회
	public int selectLoginLogCount(LogSearchVO<?> searchVO);
	
	// 로그인 로그 전체 조회
	public List<LogLoginVO> selectLoginLogList(LogSearchVO<?> searchVO);
	
	// 에러 로그 저장
	public int insertErrorLog(LogErrorVO logVO);
	
	// 에러 로그 글 개수 조회
	public int selectErrorLogCount(LogSearchVO<?> searchVO);
	
	// 에러 로그 목록 조회
	public List<LogErrorVO> selectErrorLogList(LogSearchVO<?> searchVO);
	
	// 에러 로그 해결 상태 및 조치 정보 업데이트
    public int resolveErrorLog(LogErrorVO logVO);
    
    // 액션 로그 저장
    public int insertActionLog(LogActionVO logVO);
    
    // 액션 로그 글 개수 조회
    public int selectActionLogCount(LogSearchVO<?> searchVO);
    
    // 액션 로그 목록 조회
    public List<LogActionVO> selectActionLogList(LogSearchVO<?> searchVO);
    
    // 배치 로그 저장
    public int insertBatchLog(LogBatchVO logVO);
    
    // 배치 로그 글 개수 조회
    public int selectBatchLogCount(LogSearchVO<?> searchVO);
    
    // 배치 로그 목록 조회
    public List<LogBatchVO> selectBatchLogList(LogSearchVO<?> searchVO);
}
