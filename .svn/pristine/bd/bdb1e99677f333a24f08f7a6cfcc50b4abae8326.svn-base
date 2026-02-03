package kr.or.ddit.vo.project;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import kr.or.ddit.common.code.TaskPriority;
import kr.or.ddit.common.code.TaskStatus;
import kr.or.ddit.vo.FileDetailVO;
import lombok.Data;

@Data
public class ProjectTaskSubVO {
	
	private int subId;				                 // 하위업무 일련번호
	private int taskId;                              // 상위업무 일련번호
	                                                 
	private Date subRegdate;                         // 하위업무 등록일
	private Date subUpddate;       
	// 하위업무 상태변경일
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date subStartdate;                       // 하위업무 시작일
	
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date subEnddate;                         // 하위업무 종료일
	
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date subFinishdate;                         // 하위업무 종료일
		                                             
	private int subRate;                             // 하위업무 진척도
	private TaskPriority subPriority;			     // 하위업무 중요도
	private String subTitle;                         // 하위업무 제목
	private int subWriter;                           // 하위업무 작성자
	private String subContent;                       // 하위업무 내용
	private TaskStatus subStatus;                    // 하위업무 상태
	private int fileGroupNo;                         // 파일번호
	private String subPinYn;                         // 하위업무 고정여부
	private int subPinOrder;                         // 하위업무 고정순서
	private int subPinMember;                        // 하위업무 고정자
	                                                 
    // ===== 조회용 컬럼 =====
	private String subPinMemberName;				 // 하위업무 고정자 이름
	private String writerName;			             // 하위업무 작성자 이름
	private String parentTitle;                      // 상위업무 제목 (kanban: B.TASK_TITLE)
	private int projectNo;
	private String projectName;                      // 프로젝트 이름
	
	private List<Integer> subManagerNos;			 // 하위업무 담당자 일련번호 list (입력용)
	private List<ProjectTaskManagerVO> subManagers;	 // 하위업무 담당자 list
	
	private List<FileDetailVO> fileList;			 // 종속된 파일 list
	
	//칸반보드 조회용 
	private String taskManagerName;                  // 하위업무 담당자 이름 (C.MEM_NAME)
	private String taskManagerIds;		             // 하위업무 담당자 번호 리스트
	
	// 🧪 [테스트용] 핸들러 없이 숫자 그대로 받아볼 변수
    private int testRawPriority; 

}
