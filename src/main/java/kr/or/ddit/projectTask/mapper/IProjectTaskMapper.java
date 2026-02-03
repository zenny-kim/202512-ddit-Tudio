package kr.or.ddit.projectTask.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.dto.GanttTaskDTO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.project.ProjectTaskManagerVO;
import kr.or.ddit.vo.project.ProjectTaskSubVO;
import kr.or.ddit.vo.project.ProjectTaskVO;

/**
 * <pre>
 * PROJ : Tudio
 * Name : IProjectTaskMapper
 * DESC : 프로젝트 상위업무 생성, 수정, 삭제, 목록(list/kanban) 매퍼
 * </pre>
 * 
 * @author [대덕인재개발원] team1 PSE, KHJ
 * @version 1.0, 2025.01.02
 */
@Mapper
public interface IProjectTaskMapper {
	
	/**
	 * list 
	 */
	// 내업무 목록 조회
	public List<ProjectTaskVO> selectMyTaskList(Map<String, Object> params);
	// 상위업무 목록 조회
	public List<ProjectTaskVO> selectTaskList(Map<String, Object> params);
	// 하위업무 목록 조회
	public List<ProjectTaskSubVO> selectSubTaskList(int projectNo);
	// 업무 담당자 목록 조회 (상위&하위 범용)
	public List<ProjectTaskManagerVO> selectTaskManagerList(int projectNo);
	
	/**
	 * create 
	 */
	// 상위업무 등록
	public int insertTask(ProjectTaskVO projectTaskVO);
	// 상위업무 담당자 등록
	public void insertTaskManager(Map<String, Object> tManager);
	// 하위업무 등록
	public int insertSubTask(ProjectTaskSubVO subTaskVO);
	// 하위업무 담당자 등록
	public void insertSubManager(Map<String, Object> sManager);
	
	/**
	 * detail 
	 */
	// 상위업무 상세정보 조회
	public ProjectTaskVO selectTaskDetail(int taskId);
	// 상위업무 담당자 리스트 조회
	public List<ProjectTaskManagerVO> selectTaskManagers(int taskId);
	// 상위업무 상세정보에 표기되는 하위업무 리스트
	public List<ProjectTaskSubVO> selectSubListByTaskId(int taskId);
	// 하위업무 담당자 리스트 조회
	public List<ProjectTaskManagerVO> selectSubTaskManagers(int subId);
	// 하위업무 상세정보 조회
	public ProjectTaskSubVO selectSubTaskDetail(int subId);

	/**
	 * update
	 */
	// 상위업무 고정 업데이트
	public int setTaskPin(Map<String, Object> params);
	// 하위업무 고정 업데이트
	public int setSubTaskPin(Map<String, Object> params);
	// 상위업무 진척도 업데이트
	public int updateTaskRate(ProjectTaskVO parentTaskVO);
	// 상위업무 정보수정
	public int updateTask(ProjectTaskVO projectTaskVO);
	// 하위업무 정보수정
	public int updateSubTask(ProjectTaskSubVO subTaskVO);
	
	/**
	 * delete
	 */
	// 상위업무 삭제
	public int deleteTask(int taskId);
	// 하위업무 삭제
	public int deleteSubTask(int subId);
	// 업무 담당자 삭제
	public void deleteTaskManager(Map<String, Object> taskManagers);
	
	/**
	 * Kanban Board
	 */
	//칸반보드형 업무 조회
	public List<ProjectTaskSubVO> getKanbanTaskList(int projectNo);
	//업무 상태 변경
	public int modifySubTaskStatus(ProjectTaskSubVO subTaskVO);
	//슬라이더로 진척도 수정
	public int updateSubTaskRate(ProjectTaskSubVO subTaskVO);
	//핀 고정/해제
	public void updateSubTaskPin(ProjectTaskSubVO subTaskVO);
	//권한 가져오기
	public String getProjectRole(@Param("projectNo") int projectNo, @Param("memberNo") int memberNo);
	
	/**
	 * Gantt Chart
	 */
	public List<GanttTaskDTO> selectGanttTaskList(int projectNo);
	

}
