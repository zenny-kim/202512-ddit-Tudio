package kr.or.ddit.notice.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.notice.mapper.INoticeMapper;
import kr.or.ddit.notice.service.INoticeService;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class NoticeServiceImpl implements INoticeService {
	
	@Autowired
	private INoticeMapper noticeMapper;

	// 공지사항 목록 조회
	@Override
	public void retrieveNoticeList(PaginationInfoVO<NoticeVO> pagingVO) {
		// noticeMapper.selectUserNoticeList();
		
		// 공지사항 총 개수
		int totalNotice = noticeMapper.selectNoticeCount(pagingVO);
		
		pagingVO.setTotalRecord(totalNotice);
		
		// 현재 페이지
		pagingVO.setCurrentPage(pagingVO.getCurrentPage());
		
		// 목록 조회
		List<NoticeVO> noticeList = noticeMapper.selectUserNoticeList(pagingVO);
		
		// 결과 리스트
		pagingVO.setDataList(noticeList);
	}

	// 공지사항 상세 조회
	@Override
	public NoticeVO selectNoticeDetail(int noticeNo) {
		noticeMapper.incrementNoticeHit(noticeNo);	// 조회수 증가
		return noticeMapper.selectNoticeDetail(noticeNo);
	}
	
	// 공지사항 첨부파일 다운로드 횟수 증가
	@Override
	public void incrementFileDownloadCnt(int fileNo) {
		noticeMapper.incrementFileDownloadCnt(fileNo);
	}
	
}
