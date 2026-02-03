package kr.or.ddit.vo.project;

import java.util.Date;

import lombok.Data;

@Data
public class ProjectTaskManagerVO {
	 private int taskManagerId;                // 업무 담당자 일련번호
	 private String workType;                  // 업무 타입 (T:상위업무 / S:하위업무)
	 private int workId;                       // 업무 일련번호 (TASK_ID / SUB_ID)
	 private int memberNo;                     // 업무 담당자
	 private Date workManagerRegdate;          // 담당자 등록일
	 
	 // === SELECT 전용 (JOIN 결과) ===
	 private String memberName;				   // 담당자 이름
	 private String memberProfileimg;		   // 담당자 프로필 이미지
}
