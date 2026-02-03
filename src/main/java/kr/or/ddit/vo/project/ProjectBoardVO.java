package kr.or.ddit.vo.project;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import lombok.Data;


@Data
public class ProjectBoardVO {
	
	private int boNo;				// 게시글 일련 번호 
	private int categoryNo;			// 카테고리 번호
	private int memberNo;			// 작성자
	private String boTitle;			// 제목 (=회의 주제)
	private String boContent;		// 내용 (=회의 내용)
	
	private String boRegdate;		// 작성일
	private String boUpddate;		// 수정일
	
	private int boHit;				// 조회수
	private int fileGroupNo; 		// 파일그룹번호 
	private String boPinYn;	 		// 게시글 고정 여부. Y/N (default : N)
	private int boPinOrder;	  		// 게시글 고정 순서  
	private int boPinMember;  		// 고정자 memberNo

	private String categoryName;    // 카테고리명
	private int commentCnt;			// 댓글 수 	
	
	// 목록 조회용
	private MemberVO memberVO;
	
	// 회의록 등록용
	private ProjectBoardMinutesVO boardMinutesVO;
	private List<MeetingMemberVO> meetingMemberList;
	private int projectNo;
	private List<FileDetailVO> boFileDetailList; 		// file 조회용
	private List<MultipartFile> boFileList;				// file 업로드용
	private int fileCount;								// file 개수 조회용
	
	//알림 
	private int writerNo; 		// 글 작성자
	private String projectName; // 프로젝트이름

	
	
}
