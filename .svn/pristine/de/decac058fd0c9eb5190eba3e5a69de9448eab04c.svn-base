package kr.or.ddit.projectInsight.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.projectInsight.mapper.IProjectInsightMapper;
import kr.or.ddit.projectInsight.service.IProjectInsightService;
import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;

@Service
public class ProjectInsightServiceImpl implements IProjectInsightService {
	
	@Autowired
	private IProjectInsightMapper insightMapper;

	@Override
	public Map<String, Object> getInsightDashboardData(int projectNo) {
		
		Map<String, Object> dataMap = new HashMap<>();
		
		// 프로젝트 전체 요약 및 차트 수치 조회
		ProjectInsightVO insightVO = insightMapper.getProjectInsight(projectNo);
		
		// 팀원별 업무 현황 및 기여도 리스트 조회
		List<ProjectMemberVO> memberList = insightMapper.getMemberContributionList(projectNo);
		
		// 결과 데이터를 하나의 Map에 담아 반환
		dataMap.put("insight", insightVO);
		dataMap.put("memberList", memberList);
		
		return dataMap;
	}
	
	// 우선순위 분포
	public List<ProjectInsightVO> selectPriorityDistribution(int projectNo){
		return insightMapper.selectPriorityDistribution(projectNo);
	}

	
	// 완료 누적율
	@Override
	public List<ProjectInsightVO> selectProgressPct(int projectNo) {
		return insightMapper.selectProgressPct(projectNo);
	}

}
