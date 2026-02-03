package kr.or.ddit.admin.siteNotice.service;

import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PageResult;

public interface ISiteNoticeService {
	
	// 공지사항 리스트 조회
	public PageResult<NoticeVO> retrieveNoticeList(NoticeVO noticeVO);
	
	// 공지사항 등록
	public String createNotice(NoticeVO noticeVO);
	
	// 상단 고정 변경
	public String modifyPin(NoticeVO noticeVO);
	
	// 공지사항 수정
	public String modifyNotice(NoticeVO vo, java.util.List<org.springframework.web.multipart.MultipartFile> upfiles);
	
	// 공지사항 삭제
	public String removeNotice(int noticeNo);
	
	// 공지사항 상세 조회
	public NoticeVO retrieveNotice(int noticeNo, int viewerNo);
}
