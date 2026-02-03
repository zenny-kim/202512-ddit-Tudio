package kr.or.ddit.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ApprovalPaginationInfoVO<T> extends PaginationInfoVO<T>{
	
	private int projectNo;      // 어떤 프로젝트의 결재함인지
    private int userNo;         // 현재 로그인한 사용자 번호
    private String projectRole; // MANAGER, CLIENT, MEMBER 구분
    private String tabType;     // ALL, TEMP, WAIT, REJECT, COMPLETE 등 미니탭 구분
    private String userAuth;

    public ApprovalPaginationInfoVO() {
        super(); // 부모 생성자 호출
    }

    public ApprovalPaginationInfoVO(int screenSize, int blockSize) {
        super(screenSize, blockSize);
    }
    
}
