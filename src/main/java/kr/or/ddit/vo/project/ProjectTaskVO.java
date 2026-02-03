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
public class ProjectTaskVO {
	
	private int taskId;      		                 // 상위업무 일련번호     
    private int projectNo;                           // 프로젝트 일련번호
    private int taskWriter;                          // 상위업무 작성자
    private String taskTitle;                        // 상위업무 제목
    private String taskContent;                      // 상위업무 내용
    private Date taskRegdate;                        // 상위업무 등록일
    
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date taskStartdate;                      // 상위업무 시작일
    
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date taskEnddate;                        // 상위업무 종료일
    
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date taskFinishdate;                     // 상위업무 완료일
                                                     
    private TaskStatus taskStatus;                   // 상위업무 상태
    private int taskRate;                            // 상위업무 진척도
    private TaskPriority taskPriority;               // 상위업무 우선순위
    private int fileGroupNo;                         // 파일번호
    private String taskPinYn;                        // 상위업무 고정여부
    private int taskPinOrder;                        // 상위업무 고정 순서
    private int taskPinMember;                       // 상위업무 고정자
                                                     
    // ===== 조회용 컬럼 =====                       
    private String taskPinMemberName;				 // 상위업무 고정자 이름
    private String writerName;			             // 업무 작성자 이름
    
    private String isMyTask;						 // 내 업무 여부
    
    private List<Integer> taskManagerNos;			 // 상위업무 담당자 일련번호 list (입력용)
    private List<ProjectTaskManagerVO> taskManagers; // 상위업무 담당자 list
    private String taskManagerName;
    
    private List<ProjectTaskSubVO> subTasks;		 // 종속된 하위업무 list
    
    private List<FileDetailVO> fileList;			 // 종속된 파일 list
    
    private String projectName;		                 // 프로젝트 이름
    private int taskDday;			                 // 상위업무 D-day				
    
    public void setTaskPriority(TaskPriority taskPriority) {
        this.taskPriority = taskPriority;
    }
}                                        
