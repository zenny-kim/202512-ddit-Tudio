package kr.or.ddit.projectTask.service;

import java.util.List;

import kr.or.ddit.vo.project.ProjectTaskSubVO;

public interface IKanbanService {
	
	public List<ProjectTaskSubVO> getKanbanTaskList(int projectNo);
    public boolean modifySubTaskStatus(int subId, int subStatus);
    public int updateSubTaskRate(int subId, int subRate);
	public void updateSubTaskPin(int subId, String pinYn, int loginMemberNo, int taskId);
	public String getProjectRole(int projectNo, int loginMemberNo);
	
}
