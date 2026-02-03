package kr.or.ddit.schedule.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;
import kr.or.ddit.schedule.mapper.IScheduleMapper;
import kr.or.ddit.schedule.service.IScheduleService;
import kr.or.ddit.vo.project.ProjectScheduleVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ScheduleServiceImpl implements IScheduleService {

	@Autowired
	private IScheduleMapper scheduleMapper;

	@Transactional
	@Override
	public int insertSchedule(ProjectScheduleVO scheduleVO) {
		log.info("insertSchedule()실행~", scheduleVO);
		return scheduleMapper.insertSchedule(scheduleVO);
	}

	// 프로젝트 기간 조회
	@Override
	public List<ProjectVO> getMyProjects(int memberNo) {
		return scheduleMapper.getMyProjects(memberNo);
	}

	// 스케줄 목록 조회
	@Override
	public List<ProjectScheduleVO> getScheduleList(int memberNo) {
		return scheduleMapper.getScheduleList(memberNo);
	}

	// 개인 스케줄 삭제
	@Transactional
	@Override
	public int deleteSchedule(int scheduleId) {
		ProjectScheduleVO scheduleVO = scheduleMapper.getScheduleDetail(scheduleId);
		if (scheduleVO == null) {
			log.warn("삭제하려는 일정을 찾을 수 없음: ID {}", scheduleId);
			return 0;
		}
		return scheduleMapper.deleteSchedule(scheduleId);
	}
	
	//프로젝트 탭 내의 프로젝트 스케줄 목록 조회
	@Override
	public List<ProjectScheduleVO> getProjectScheduleList(Map<String, Object> map) {
		return scheduleMapper.getProjectScheduleList(map);
	}

	//드래그로 일정 변경
	@Override
	public int updateScheduleDate(Map<String, Object> paramMap) {
		return scheduleMapper.updateScheduleDate(paramMap);
	}

	

}
