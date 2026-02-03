package kr.or.ddit.schedule.service;

import java.util.List;
import java.util.Map;
import kr.or.ddit.vo.project.ProjectScheduleVO;
import kr.or.ddit.vo.project.ProjectVO;


public interface IScheduleService {

	//개인 스케줄 등록
	public int insertSchedule(ProjectScheduleVO scheduleVO);

	//스케줄 등록 시 사용할 프로젝트 목록
	public List<ProjectVO> getMyProjects(int memberNo);

	//스케줄 전체 조회(프로젝트 스케줄)
	public List<ProjectScheduleVO> getScheduleList(int memberNo);

	//개인 스케줄 삭제
	public int deleteSchedule(int scheduleId);

	//프로젝트 탭 내에 해당되는 프로젝트 스케줄 조회
	public List<ProjectScheduleVO> getProjectScheduleList(Map<String, Object> map);

	//캘린더에서 드래그로 날짜 변경
	public int updateScheduleDate(Map<String, Object> paramMap);
	
}
