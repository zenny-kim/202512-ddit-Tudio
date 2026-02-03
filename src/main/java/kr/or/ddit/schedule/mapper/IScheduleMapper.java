package kr.or.ddit.schedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.project.ProjectScheduleVO;
import kr.or.ddit.vo.project.ProjectVO;

@Mapper
public interface IScheduleMapper {

	//개인 스케줄 등록
	public int insertSchedule(ProjectScheduleVO scheduleVO);
	
	//전체 스케줄 등록 - 프로젝트 조회
	public List<ProjectVO> getMyProjects(int memberNo);

	//전체 스케줄 조회 - 프로젝트 번호의 스케줄 가져오기
	public List<ProjectScheduleVO> getScheduleList(int memberNo);
	
	//개인 스케줄 삭제 전 데이터 조회
	public ProjectScheduleVO getScheduleDetail(int scheduleId);
	
	//개인 스케줄 삭제
	public int deleteSchedule(int scheduleId);
	
	//프로젝트 탭 내에 해당되는 프로젝트 스케줄 조회
	public List<ProjectScheduleVO> getProjectScheduleList(Map<String, Object> map);

	//프로젝트 탭 내에 해당되는 프로젝트 스케줄 드래그 수정
	public int updateScheduleDate(Map<String, Object> paramMap);
}
