package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeVO {
	private int noticeNo;			// 공지사항 번호
	private int memberNo;			// 시스템 관리자 회원번호
	private String noticeTitle;		// 공지사항 제목
	private String noticeContent;	// 공지사항 내용
	private Date noticeRegdate;		// 공지사항 등록일
	private Date noticeUpdate;		// 공지사항 수정일
	private int noticeHit;			// 공지사항 조회수
	private int noticeFileNo;		// 공지사항 파일번호
	private String noticePinStatus;	// 공지사항 고정핀 사용여부
	
	private String writer;			// 공지사항 작성자 이름
	
	private int currentPage = 1;    // 현재 페이지 (기본값 1)
    private int rowSize = 10;       // 한 페이지당 보여줄 글 수 (기본값 10)
    private int pageSize = 10;      // 페이지네이션 바의 크기 (1~10페이지)
    
    private int totalRecordCount;   // 전체 글 개수
    
    private int totalPage;          // 전체 페이지 수
    private int startRow;           // 쿼리용: 시작 번호
    private int endRow;             // 쿼리용: 끝 번호
    private int startPage;          // 화면용: 하단 페이지 시작
    private int endPage;            // 화면용: 하단 페이지 끝
    
    private int fileGroupNo;		// 파일 그룹 번호
    
    private int fileCount;        	// 파일 개수
    private int totalDownloadHit; 	// 총 다운로드 횟수
    
    private int modMemberNo;        // 수정자 회원번호 
    private String modifierName;    // 수정자 이름 
    
    private java.util.List<FileDetailVO> fileList;	// 리액트로 파일 정보 리스트 전송용
    
    public void setTotalRecordCount(int totalRecordCount) {
    	this.totalRecordCount = totalRecordCount;
    	
    	if(totalRecordCount > 0) {
    		this.totalPage = (totalRecordCount + rowSize - 1) / rowSize;
    	}else {
    		this.totalPage = 0;
    	}
    	
    	this.startRow = (currentPage - 1) * rowSize + 1;
        this.endRow = currentPage * rowSize;
        
        this.startPage = ((currentPage - 1) / pageSize) * pageSize + 1;
        this.endPage = startPage + pageSize - 1;
        
        if (this.endPage > this.totalPage) {
            this.endPage = this.totalPage;
        }
    }
}
