package kr.or.ddit.dto;

import lombok.Data;

/**
 * 관리자 페이지 - 회원 상세 모달용 통합 DTO
 */
@Data
public class AdminUserDTO {

    // --- [1. MEMBER 테이블 컬럼] ---
    private int memberNo;            // MEMBER_NO (PK)
    private String memberId;         // MEMBER_ID
    private String memberName;       // MEMBER_NAME
    private String memberTel;        // MEMBER_TEL
    private String memberEmail;      // MEMBER_EMAIL
    private String emailStatus;      // EMAIL_STATUS (이메일 인증 여부)
    private String memberDepartment; // MEMBER_DEPARTMENT (소속 부서)
    private String memberPosition;   // MEMBER_POSITION (직함/직책)
    private String memberRegno;      // MEMBER_REGNO (주민등록번호/생년월일 대용)
    private String memberProfileimg; // MEMBER_PROFILEIMG (프로필 경로)
    private String selectiveConsent; // SELECTIVE_CONSENT (선택 약관 동의 여부)
    
    // 계정 상태 관련
    private String memberJoinDate;   // MEMBER_JOIN_DATE (가입일)
    private String memberLeaveDate;  // MEMBER_LEAVE_DATE (탈퇴일)
    private String leaveStatus;      // LEAVE_STATUS (탈퇴 여부: Y/N)
    private String leaveReason;      // LEAVE_REASON (탈퇴 사유)
    private String companyNoStatus;  // COMPANY_NO_STATUS (기업 연동 상태)

    // --- [2. MEMBER_AUTH 테이블 컬럼 (JOIN)] ---
    private String auth;             // AUTH (회원 권한: ROLE_USER, ROLE_ADMIN 등)

    // --- [3. CLIENT_COMPANY 테이블 컬럼 (JOIN)] ---
    private Integer companyNo;       // COMPANY_NO (FK, 일반회원은 null 가능하므로 Integer)
    private String companyName;      // COMPANY_NAME (기업명)
    private String companyCeoName;   // COMPANY_CEO_NAME (대표자명)
    private String companyAddr1;     // COMPANY_ADDR1 (기본 주소)
    private String companyAddr2;     // COMPANY_ADDR2 (상세 주소)
    private String companyPostcode;  // COMPANY_POSTCODE (우편번호)
    private String companyAuthStatus; // COMPANY_AUTH_STATUS (기업 인증 상태)
    private String bizFileNo;        // BIZ_FILE_NO (사업자 등록증 파일 번호)

    // --- [4. 추가 활동 통계 (통계 테이블 JOIN 혹은 서브쿼리용)] ---
    // 이미지에서 확인된 LOG_LOGIN, INQUIRY 테이블 참고
    private String lastLoginAt;      // 최근 접속 일시 (LOG_LOGIN 테이블 활용)
    private int inquiryCount;        // 총 문의 건수 (INQUIRY 테이블 활용)
    private int postCount;           // 총 게시글 수 (PROJECT_BOARD 등 활용)
}