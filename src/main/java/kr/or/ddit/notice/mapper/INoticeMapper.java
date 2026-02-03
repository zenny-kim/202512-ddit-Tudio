package kr.or.ddit.notice.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Mapper
public interface INoticeMapper {
	
	// 공지사항 목록 조회
	public List<NoticeVO> selectUserNoticeList(PaginationInfoVO<NoticeVO> pagingVO);
	
	// 공지사항 조회수 증가
	public int incrementNoticeHit();

	// 공지사항 상세
	public NoticeVO selectNoticeDetail(int noticeNo);
	
	// 공지사항 조회수 증가
	public void incrementNoticeHit(int noticeNo);
	
	// 공지사항 개수
	public int selectNoticeCount(PaginationInfoVO<NoticeVO> pagingVO);

	// 공지사항 첨부파일 다운로드 횟수 증가
	public void incrementFileDownloadCnt(int fileNo);
}
