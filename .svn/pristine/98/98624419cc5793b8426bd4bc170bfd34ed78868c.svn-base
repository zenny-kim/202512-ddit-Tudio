package kr.or.ddit.vo.project;

import lombok.Data;

@Data
public class ProjectInsightVO {
	// 1. 상단 요약 카드
    private int totalTaskCount;    // 총 업무 수
    private double overallProgress; // 전체 진행률
    private int delayedTaskCount;  // 지연 업무 수
    private String projectDday;    // 프로젝트 남은 기간 (D-14 등)

    // 2. 업무 상태 분포 (파이 차트)
    private int todoCount;
    private int inProgressCount;
    private int reviewCount;
    private int doneCount;

    // 3. 일정 준수 현황 (바 차트)
    private int earlyDoneCount;   // 조기 완료
    private int onTimeDoneCount;  // 정시 완료
    private int lateDoneCount;    // 지연 완료
    
    // 프로젝트 설명 
    private String projectDesc;

    private int projectNo; 		    // 프로젝트 번호
    
    // 업무중요도 분포
    private int priorityCnt;	 	// 우선순위 갯수
    private double priorityPct;     // 백분율
    private String priorityLabel;	// 우선순위 라벨표시
    private int priorityCode;		// 우선순위 코드
    
    // 프로젝트 완료 누적율
    private Double progressPct;     // 완료퍼센트 
    private String progressLabel;   // 날짜표시
    
    private int parentTaskCount; // 상위 업무 수
    private int subTaskCount;    // 단위 업무 수
}
