package kr.or.ddit.vo.meetingRoom;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class MeetingBranchVO {
	
	private int branchId;           		// 지점일련번호
    private String branchName;      		// 지점명
    private String branchAddr;      		// 지점 주소
    private int fileGroupNo;       		 	// 지점사진
    private String branchStatus;    		// 운영 여부
    private int memberNo;           		// 지점담당자
    
    @JsonFormat(pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date branchRegdate; 	// 지점등록일
    
    @JsonFormat(pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date branchUpddate; 	// 지점수정일
    
}
