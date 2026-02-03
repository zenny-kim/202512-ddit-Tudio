package kr.or.ddit.projectInsight.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;

@Mapper
public interface IProjectInsightMapper {
	
	// 프로젝트 요약 정보
	public ProjectInsightVO getProjectInsight(int projectNo);
	
	// 팀원별 기여도 목록 조회
	public List<ProjectMemberVO> getMemberContributionList(int projectNo);
	
	// 우선순위 분포
	public List<ProjectInsightVO> selectPriorityDistribution(int projectNo);
	
	// 완료 누적율
	public List<ProjectInsightVO> selectProgressPct(int projectNo);
}
