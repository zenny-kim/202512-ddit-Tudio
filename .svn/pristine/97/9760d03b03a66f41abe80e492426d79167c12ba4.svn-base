package kr.or.ddit.vo;

import lombok.Data;

/**
 * 결재 승인 테이블용 VO
 */

@Data
public class DraftApprovalVO {
	private int approverNo;				// 결재문서 ID	
    private int documentNo;				// 문서 번호 
    private int approvalStatus; 		// 607~610
    private int memberNo; 				// 결재자(고객사) 번호
    private String approvalDate;		// 승인날짜
    private String rejectionReason;		// 반려 사유
    private int approvalStep;			// 결재라인 순서

    // 조인용 필드
    private String memberName; 			// 결재자 이름
    private String memberPosition;		// 결재자 직위
    
    // 알림용 필드
    private String documentTitle;		// 기안서 제목
    private int projectNo;				// 프로젝트 번호
    private String projectName;			// 프로젝트 이름
    private int approvalWriter;			// 기안 작성자

}
