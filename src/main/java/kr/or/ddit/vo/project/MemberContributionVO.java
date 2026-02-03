package kr.or.ddit.vo.project;

import lombok.Data;

@Data
public class MemberContributionVO {
	private int memberNo;         // 회원 번호
    private String memberName;    // 이름
    private String memberPosition; // 직책 (또는 역할)
    
    private int totalTasks;       // 배정된 총 업무
    private int doingTasks;       // 진행 중인 업무
    private int doneTasks;        // 완료한 업무
    private int delayedTasks;     // 지연된 업무
    
    private double completionRate; // 완료율 (%)
}
