package kr.or.ddit.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class InquiryPaginationInfoVO<T> extends PaginationInfoVO<T> {
    private int userNo;
    private String searchStatus; // 필터링 상태값 (Y, N)을 담을 변수
    
    private String searchType;  // T: 제목, C: 내용, W: 작성자, TC: 제목+내용
    private String searchWord;  // 검색어
    private String inquiryType; // 문의글 타입 (문의/신고)
    
    private int completedCount;	// 답변 완료 건수 
    
 // 부모의 Getter를 강제로 오버라이딩해서 호출해줍니다.
    @Override
    public int getStartRow() {
        return super.getStartRow();
    }

    @Override
    public int getEndRow() {
        return super.getEndRow();
    }
}