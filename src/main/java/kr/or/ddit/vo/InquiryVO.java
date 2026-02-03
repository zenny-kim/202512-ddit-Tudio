package kr.or.ddit.vo;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class InquiryVO {
	private int inquiryNo;
    private int userNo;

    private String inquiryTitle;
    private String inquiryContent;
    private String inquiryType;

    private String inquiryRegdate;
    private String inquiryUpddate;

    private Integer inquiryHit;

    // 관리자 답변 관련
    private int replyNo;
    private int adminNo;
    private String replyContent;
    private String replyDate;
    private String replyStatus; // Y / N

    private int fileGroupNo;		//문의글 파일그룹번호
    private int replyFileGroupNo;	//답변 전용 파일그룹번호
    private List<FileDetailVO> fileList; //문의글 파일 리스트
    private List<FileDetailVO> replyFileList; //답변 전용 파일 리스트 
    
    
    // 화면에 표시할 이름
    private String userName;   
    private String adminName;  
    
    private int fileCount;
    
}
