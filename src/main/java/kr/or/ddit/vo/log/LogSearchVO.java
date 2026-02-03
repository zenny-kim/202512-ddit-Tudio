package kr.or.ddit.vo.log; // 위치: kr.or.ddit.vo.log

import kr.or.ddit.vo.PaginationInfoVO; // 부모 클래스 임포트
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LogSearchVO<T> extends PaginationInfoVO<T> {

    private String status;      // 로그인 상태 (SUCCESS, FAIL)
    private String startDate;   // 시작일
    private String endDate;     // 종료일

}