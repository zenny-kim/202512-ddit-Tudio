package kr.or.ddit.projectTask.service;

import java.util.List;

import kr.or.ddit.dto.GanttTaskDTO;

public interface IProjectGanttService {
	
	List<GanttTaskDTO> getGanttTaskList(int projectNo);
}
