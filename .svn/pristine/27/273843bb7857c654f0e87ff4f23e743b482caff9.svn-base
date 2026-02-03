package kr.or.ddit.vo;

import lombok.Data;

@Data
public class FileGroupVO {
	 private int fileGroupNo;			//파일그룹번호 - 시퀀스(SEQ_FILE_GROUP) 생성

	 /*
	 <첨부 대상>  fileGroupType
	 각 타입으로 쿼리문 생성 시 하드코딩으로 사용해주세요 -> 이해 안되면 "김수정" 부르기
	 401. 공지사항				notice
	 402. 문의사항				inquiry
	 403. 상위업무				projectTask
	 404. 하위업무				taskSub
	 405. 게시판				projectBoard
	 406. 댓글				comment
	 407. 채팅				chat
	 408. 프로필 				profile
	 409. 기업 사업자등록증		bizFileNo
	 410. 기안 				draftDocument
	 411. 자주묻는질문			faq
	*/
	 private int fileGroupType;
	 private int memberNo;
	 private String fileGroupRegdate;
	 private String fileUrl;		//알림 등 파일 위치를 확인할 게시판이나 파일 올라간 곳 url 필요
}
