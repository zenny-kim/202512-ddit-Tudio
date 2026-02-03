package kr.or.ddit.common.code;

/**
 * Tudio 통계 분류 공통코드 (501~519)
 */


public enum ExcelCategory implements CodeEnum {

	// --- Member 계정 통계 ---
	PROJECT_TASK_STAT(501, "프로젝트 상·하위 업무 통계 보고서", "프로젝트업무통계"), 
	TASK_STATUS_STAT(502, "업무 상태별 분포 통계 보고서", "업무상태분포"),
	MEMBER_TASK_RATIO(503, "팀원별 업무 담당 비율 조회", "팀원업무비율"),
	PROJECT_PROGRESS_STAT(504, "프로젝트 기간 대비 진행률 보고서", "프로젝트진행률"),
	TOTAL_TASK_COMPLETE(505, "프로젝트 전체 업무 완료 현황", "전체업무완료현황"), 
	MY_WORKLOAD_STAT(506, "개인 작업량 통계 보고서", "개인작업량통계"),
	WORK_COMPLETE_TREND(507, "주간/월간 작업 완료 추이 보고서", "작업완료추이"),
	URGENT_DELAY_STAT(508, "마감 임박 및 지연 업무 통계", "마감임박지연통계"),
	PRIORITY_IMPORTANCE(509, "업무 우선순위 및 중요도 분포 통계", "업무우선순위분포"),

	// --- Admin 계정 통계 ---
	USER_ANALYSIS_STAT(510, "사용자 분석 통계 기초 자료", "사용자분석통계"), 
	CORP_EMAIL_STAT(511, "기업 이메일 인증 기준 통계 보고서", "기업인증통계"),
	PROJECT_USAGE_STAT(512, "프로젝트 수 및 이용 현황 통계", "프로젝트이용현황"), 
	LOG_INFO_STAT(513, "시스템 로그 정보 분석 통계", "로그정보통계"),
	SALES_PERIOD_STAT(514, "기간별 매출 실적 통계 보고서", "기간별매출통계"),
	USER_JOIN_EXIT_TREND(515, "기간별 회원 가입 및 탈퇴 추이", "회원가입탈퇴추이"),
	CLIENT_APPROVAL_STAT(516, "고객사 가입/승인/반려 통계", "고객사승인통계"),
	PROJ_APPROVAL_STAT(517, "프로젝트 승인/반려 처리 통계", "프로젝트승인통계"), 
	VISITOR_SESSION_STAT(518, "접속자(방문/세션) 분석 통계", "접속자통계"),
	SURVEY_RESULT_STAT(519, "설문 완료 결과 분석 통계", "설문결과통계");

	private final int code;        // 인터페이스에 맞춰 int로 변경
    private final String title;     // 엑셀 상단 제목
    private final String fileKeyword; // 파일명용 키워드

    ExcelCategory(int code, String title, String fileKeyword) {
        this.code = code;
        this.title = title;
        this.fileKeyword = fileKeyword;
    }

    // --- CodeEnum 인터페이스 구현 부분 ---
    @Override
    public int getCode() {
        return this.code;
    }

    @Override
    public String getLabel() {
        return this.title; // 화면(라벨)에 보여줄 이름으로 title을 사용
    }

    // --- 기존 엑셀 서비스에서 쓰던 메서드 ---
    public String getTitle() { return title; }
    public String getFileKeyword() { return fileKeyword; }
}