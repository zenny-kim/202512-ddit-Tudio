package kr.or.ddit.vo.log;

import java.util.Date;

import lombok.Data;

/**
 * 배치 로그 (자동화 작업 기록)
 */
@Data
public class LogBatchVO {
	
	// 배치로그 ID
    private int batchLogId;

    // 작업명
    private String jobName;

    // 작업 상태 
    private String batchStatus;

    // 결과 메시지 
    private String resultMsg;
    
    // 실행 파라미터 
    private String batchParams;
    
    // 소요 시간 
    private long duration;

    // 에러 로그 ID 
    private Integer errorLogId;

    // 시작 일시
    private Date startDate;

    // 종료 일시
    private Date regDate;
    
    // 배치가 종료될 때 상태 업데이트 후 소요시간 자동 계산 메서드
    public void complete(String status, String message) {
        this.batchStatus = status;
        this.resultMsg = message;
        this.regDate = new Date(); // 현재 시점을 종료 시간으로 설정
        
        if (this.startDate != null) {
            // 종료 시간 - 시작 시간 계산 (초 단위 변환)
            this.duration = (this.regDate.getTime() - this.startDate.getTime()) / 1000;
        }
    }
}
