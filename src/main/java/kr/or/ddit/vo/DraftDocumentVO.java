package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class DraftDocumentVO {
	private int documentNo;
    private int projectNo;
    private int memberNo; 				// PM 번호
    private int documentType; 			// 601~606
    private int documentStatus; 		// 611~616
    private String documentTitle;
    private String documentContent;
    private String documentRegdate;
    private String documentApprovaldate;
    private Integer fileGroupNo; 		// null 허용을 위해 Integer 사용
    private Integer parentDocNo; 		// null 허용

    // 화면 출력을 위해 JOIN으로 가져올 정보들 (DB 컬럼엔 없지만 필드엔 추가)
    private String projectName;
    private String drafterName; 
    private String drafterDept;     // 부서
    private String drafterPos;		// 직책
    private String isPublic; 		// 보안여부
    
    // 결재선 리스트 (1:N 관계)
    private List<DraftApprovalVO> approvalList;
    
    // 상태 라벨
    private String statusLabel;
        
    private int fileCount;			//파일갯수
}
