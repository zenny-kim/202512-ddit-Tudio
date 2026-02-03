package kr.or.ddit.notice.service;

import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface INoticeService {
	// 공지사항 목록 조회
	public void retrieveNoticeList(PaginationInfoVO<NoticeVO> pagingVO);

	// 공지사항 상세 조회
	public NoticeVO selectNoticeDetail(int noticeNo);

	// 공지사항 첨부파일 다운로드 횟수 증가
	public void incrementFileDownloadCnt(int fileNo);
}
