package kr.or.ddit.projectInsight.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.project.ProjectInsightVO;

public interface IProjectInsightService {
	/**
     * 프로젝트 대시보드 구성을 위한 모든 통계 데이터를 가져온다.
     * @param projectNo 프로젝트 번호
     * @return 요약 데이터(insight)와 팀원 목록(memberList)을 담은 Map
     */
    public Map<String, Object> getInsightDashboardData(int projectNo);
    
    // 우선순위 분포
 	public List<ProjectInsightVO> selectPriorityDistribution(int projectNo);
 	
	// 완료 누적율
	public List<ProjectInsightVO> selectProgressPct(int projectNo);
}
