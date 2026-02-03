package kr.or.ddit.vo.log;

import java.util.Date;

import lombok.Data;

/**
 * 접속 로그 (사용자 로그인 시도 및 이력 관리)
 */
@Data
public class LogLoginVO {

	// 로그인 로그 ID 
    private int loginLogId;

    // 로그인 시도 아이디
    private String loginId;

    // 로그인 상태
    private String loginStatus;

    // 접속 IP 주소
    private String ipAddr;

    // 브라우저 및 기기 정보 
    private String userAgent;

    // 사용자 번호
    private Integer memberNo;

    // 로그인 일시 
    private Date regDate;
    
    // 브라우저명 (통계용)
    private String browser;

    // 실패 사유
    private String failReason;
}
