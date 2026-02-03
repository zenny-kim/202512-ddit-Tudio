package kr.or.ddit.projectMember.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.project.ProjectMemberVO;

public interface IProjectMemberService {

	
	/**
	 * 구성원 목록 조회
	 * @param projectNoprojectNo
	 * @return
	 */
	public List<ProjectMemberVO> projectMemberList(int projectNo);
	
	
	/**
	 * 구성원 정보 조회 
	 * @param vo
	 * @return
	 */
	public ProjectMemberVO projectMemberDetail(ProjectMemberVO vo);

	
	/**
	 * 프로젝트 내 구성원 수
	 * @param projectNo
	 * @return
	 */
	public int projectMemberCount(int projectNo);
	
	/**
	 * 개인별 업무 갯수
	 * @param vo
	 * @return
	 */
	public ProjectMemberVO projectMemberDetailTaskCount(ProjectMemberVO vo);


	 /**
	  * 차트 데이터 반환  
	  * @param projectNo
	  * @return
	  */
	public List<ProjectMemberVO> projectMemberDetailTaskCountChart(int projectNo);


	 public List<ProjectMemberVO> projectMemberListSearch(Map<String, Object> param);
	
	

}
