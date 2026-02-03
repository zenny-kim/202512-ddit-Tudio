package kr.or.ddit.projectTask.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.code.TaskStatus;
import kr.or.ddit.projectTask.mapper.IProjectTaskMapper;
import kr.or.ddit.projectTask.service.IKanbanService;
import kr.or.ddit.vo.project.ProjectTaskSubVO;

@Service
public class KanbanServiceImpl implements IKanbanService {
	
	@Autowired
	private IProjectTaskMapper kanbanMapper;
	
	@Override
	public List<ProjectTaskSubVO> getKanbanTaskList(int projectNo) {
		return kanbanMapper.getKanbanTaskList(projectNo);
	}

	@Override
    public boolean modifySubTaskStatus(int subId, int subStatus) {
		ProjectTaskSubVO subTaskVO = new ProjectTaskSubVO();
		subTaskVO.setSubId(subId);
		subTaskVO.setSubStatus(TaskStatus.from(subStatus));
		return kanbanMapper.modifySubTaskStatus(subTaskVO) > 0;
    }

    @Override
    public int updateSubTaskRate(int subId, int subRate) {
    	ProjectTaskSubVO subTaskVO = new ProjectTaskSubVO();
    	subTaskVO.setSubId(subId);
    	subTaskVO.setSubRate(subRate);
    	
    	return kanbanMapper.updateSubTaskRate(subTaskVO);
    }

	@Override
	public void updateSubTaskPin(int subId, String pinYn, int loginMemberNo, int taskId) {
		ProjectTaskSubVO subTaskVO = new ProjectTaskSubVO();
		subTaskVO.setSubId(subId);
		subTaskVO.setSubPinYn(pinYn);
		subTaskVO.setSubPinMember(loginMemberNo);
		subTaskVO.setTaskId(taskId);
		
		kanbanMapper.updateSubTaskPin(subTaskVO);
	}

	@Override
	public String getProjectRole(int projectNo, int loginMemberNo) {
		return kanbanMapper.getProjectRole(projectNo, loginMemberNo);
	}
	
}
