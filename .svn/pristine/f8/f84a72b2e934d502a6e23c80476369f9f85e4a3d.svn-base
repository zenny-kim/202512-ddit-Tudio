package kr.or.ddit.projectTask.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.project.ProjectTaskSubVO;
import kr.or.ddit.vo.project.ProjectTaskVO;

public interface IProjectTaskService {
	
	/**
	 * <p>내 업무 - 리스트 조회</p>
	 * @param memberNo : 로그인 유저
	 * @param type : 필터값 - 작성자/담당자
	 * @param projectStatus : 프로젝트 상태 (0:진행 | 1:완료)
	 * @return Map<Integer, List<ProjectTaskVO>> - key: 프로젝트 일련번호(PK) | value: 업무
	 */
	public Map<Integer, List<ProjectTaskVO>> getMyTaskList(int memberNo, String type, Integer projectStatus);
	
	/**
	 * <p>업무 리스트 (상위업무, 하위업무, 각 업무의 담당자)</p>
	 * @param projectNo
	 * @param sortOrder 
	 * @param sortType 
	 * @return List<ProjectTaskVO>
	 */
	public List<ProjectTaskVO> selectTaskList(int projectNo, String sortType, String sortOrder);

	/**
	 * <p>업무 생성</p>
	 * @param projectTaskVO
	 * @param writerNo
	 * @return ServiceResult
	 */
	public ServiceResult createTask(ProjectTaskVO projectTaskVO, int writerNo);

	/**
	 * <p>하위업무 생성</p>
	 * @param subVO
	 * @param writerNo
	 * @return ServiceResult
	 */
	public ServiceResult createSubTask(ProjectTaskSubVO subVO, int writerNo);

	/**
	 * <p>상위업무 상세보기</p>
	 * @param taskId
	 * @return ProjectTaskVO
	 */
	public ProjectTaskVO getTaskDetail(int taskId);
	
	/**
	 * <p>하위업무 상세보기</p>
	 * @param subId
	 * @return ProjectTaskSubVO
	 */
	public ProjectTaskSubVO getSubTaskDetail(int subId);

	/**
	 * <p>성세보기 - 하위업무 진척도 즉시 변경</p>
	 * @param subId
	 * @param subRate
	 * @return ServiceResult
	 */
	public ServiceResult updateSubTaskRate(int subId, int subRate);

	/**
	 * 업무 고정
	 * @param id
	 * @param type
	 * @param memberNo
	 * @return
	 */
	public String setTaskPin(int id, String type, int memberNo);
	
	/**
	 * 상위업무와 종속된 하위업무 수정
	 * @param taskVO
	 * @param deleteSubIds
	 * @return
	 */
	public ServiceResult updateTaskWithSubTasks(ProjectTaskVO taskVO, List<Integer> deleteSubIds);

	/**
	 * 상위업무 삭제
	 * @param taskId
	 * @param type
	 * @return
	 */
	public ServiceResult deleteTask(int taskId, String type);

	/**
     * 하위업무 단건 수정
     * @param subVO
     * @return ServiceResult
     */
	public ServiceResult updateSubTask(ProjectTaskSubVO subVO);
}
