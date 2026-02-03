package kr.or.ddit.vo.project;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import kr.or.ddit.common.code.ProjectType;
import kr.or.ddit.vo.MemberVO;
import lombok.Data;

@Data
public class ProjectVO {
	private int projectNo;						// 프로젝트 일련번호
	private int memberNo;						// 회원번호 (프로젝트 관리자)
	private String projectName;					// 프로젝트 이름
	private String projectDesc;					// 프로젝트 설명
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date projectStartdate;				// 프로젝트 시작일
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date projectEnddate;				// 프로젝트 종료일
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date projectFinishdate;				// 프로젝트 완료일
	
	private int projectStatus;					// 프로젝트 상태 (0:진행, 1:완료, 2:중단)
	private Date projectRegdate;				// 프로젝트 생성일
	// private String projectType;				// 프로젝트 타입 (공통코드)
	private ProjectType projectType;
	
	private List<ProjectMemberVO> memberList;	// 구성원 목록
	private List<ProjectMemberVO> clientList;	// 기업 담당자 목록
	private ProjectMiniHeaderVO miniheader;		// 미니헤더 설정
	
	// 알림 발송
	private String adminEmail;					// 프로젝트 관리자 이메일 
	private long elapsedDays;					// 프로젝트 생성 후 경과 일수
	
	// 미니위젯 (4)
	private int totalTaskCount;					// 전체 상위업무 수
	private int completedTaskCount; 			// 완료된(하위업무가 모두 완료된) 상위 업무 수
    private int projectProgress;				// 프로젝트 진척도(완료율)
    private int projectMemberCount; 			// 프로젝트 투입 인원 수 (총 구성원 수)
    private int delayedTaskCount;				// 지연업무 수
    private double overallProgress;				// 프로젝트 진행률(업무 진척도)
    
    // 프로젝트 날짜, 상태 계산
    private int dday;        					// endDate - today (일수)
    private String ddayLabel;    				// D-15 / D-DAY / D+3
    private String statusLabel; 		 		// 예정 / 진행 중 / 기한지남 / 완료
    
    // 프로젝트 북마크 
    private String projectBookmark; 
    
    private String memberName;
    private int projectRate;					// 업무 진척도
    
    // 사용자별 담당 업무 개수 조회 (상위, 하위업무 모두 포함)
    private int myTaskCount;
    private int myTotalTaskCount;
    private int myDoneTaskCount;
    
    // 프로젝트 결과보고서 작성을 위한 필드
    private String pmName;	// 프로젝트 관리자 이름
    private double completionRate;      // 완수율 (%)
    private long totalDuration;	// 프로젝트 총 진행기간
    
    // 구성원별 업무 현황을 담을 리스트
    private List<MemberVO> memberWorkList; 
    
    // 차트용 데이터 (예: 업무 상태별 카운트)
    private int todoCount;
    private int doingCount;
    private int doneCount;
    
    // 결과보고서 파일 그룹 번호
    private Integer fileGroupno; 
    // 프로젝트 결과보고서 최신 파일 번호
    private Integer latestReportfileno;
    
    // 프로젝트 타입 공통 코드 반환
    public String getProjectTypeLabel() {
        return projectType != null ? projectType.getLabel() : "";
    }
    
    // D-day (프로젝트 종료일 - 현재 날짜)
    public long getDday() {
        if (this.projectEnddate == null) {
            return 0;
        }

        LocalDate end = this.projectEnddate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate today = LocalDate.now();

        // 디데이: 날짜 차이 계산
        return ChronoUnit.DAYS.between(today, end);
    }
    
    // 프로젝트 진행률
    public int getProjectProgress() {
        if (this.totalTaskCount == 0) {
            return 0; // 분모가 0이면 0%
        }
        
        // (완료된 업무 / 전체 업무) * 100
        double percentage = (double) this.completedTaskCount / this.totalTaskCount * 100.0;
        return (int) Math.round(percentage);	// 반올림하여 정수로 반환
    }
    
    // 프로젝트 총 소요 기간 (종료일 - 시작일)
    public long getTotalDuration() {
        if (projectStartdate == null || projectEnddate == null) return 0;
        LocalDate start = projectStartdate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate end = projectEnddate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        return ChronoUnit.DAYS.between(start, end);
    }
}
