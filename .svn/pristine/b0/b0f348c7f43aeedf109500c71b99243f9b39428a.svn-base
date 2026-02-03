package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class CommentVO {
	
	 private int cmtNo;					// pk-댓글번호
	 private int memberNo;				// 회원번호(작성자)
	 private String targetType;			// 댓글타입 T:상위, S:하위, B:게시판
	 private int targetId;				// 대상pk- TASK_ID / SUB_ID / BOARD_ID
	 private String cmtContent;			// 댓글 내용
	 private int cmtGroup;				// 댓글 그룹 번호
	 private int cmtOrd;				// 댓글 정렬 순서 - 상위댓글
	 private int cmtDepth;				// 댓글 깊이 - 하위댓글
	 private String cmtStatus;			// 댓글 상태 Y:정상, N:삭제/숨김
	 private int fileGroupNo;			// 파일그룹번호
	 
	 private String memberProfileimg;	// 프로필이미지 (MemberVO 변수 동일)
	 
	 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	 @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	 private Date cmtRegdate;					// 댓글 작성일
	 
	 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	 @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	 private Date cmtUpddate;					// 댓글 수정일
	 
	 //목록 조회용 추가 변수
	 private MemberVO memberVO;
	 private List<FileDetailVO> cmtFileDetailList;		// 조회용 - DB에서 가져온 파일 상세 정보 리스트
	 private List<MultipartFile> cmtFileList;			// 등록용 - HTML 폼에서 전송된 파일 객체 리스트
	 
	 
	 private int parentCmtNo;// 부모 댓글
	 private int boardWriter; // 게시글 작성자
	 
}
