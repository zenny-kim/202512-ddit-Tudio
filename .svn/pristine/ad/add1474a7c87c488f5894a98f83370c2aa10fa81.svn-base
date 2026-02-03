package kr.or.ddit.admin.siteNotice.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MemberAuthVO;
import kr.or.ddit.vo.NoticeVO;

@Mapper
public interface ISiteNoticeMapper {
	
	// 목록 조회
	public List<NoticeVO> selectNoticeList(NoticeVO noticeVO); 
	
	// 글 등록
	public int insertNotice(NoticeVO noticeVO);

	// 상단 고정
	public int updateNoticePin(NoticeVO noticeVO);
	
	// 페이징 처리
	public int selectNoticeCount(NoticeVO noticeVO);
	
	// 상세 조회 
    public NoticeVO selectNoticeDetail(int noticeNo);

    // 글 수정 
    public int updateNotice(NoticeVO noticeVO);

    // 글 삭제 
    public int deleteNotice(int noticeNo);

    // 조회수 증가
    public int incrementHit(int noticeNo);
    
    // 권한 확인용 
    public List<MemberAuthVO> selectMemberAuthList(int memberNo);
}
