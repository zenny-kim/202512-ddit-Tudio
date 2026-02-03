package kr.or.ddit.projectMember.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.project.ProjectMemberVO;

@Mapper
public interface IProjectMemberMapper {

	
	/**
	 * 구성뭔 목록 조회
	 * @param projectNoprojectNo
	 * @return
	 */
	public List<ProjectMemberVO> projectMemberList(@Param("projectNo")int projectNo);

	
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
	public int projectMemberCount(@Param("projectNo")int projectNo);
	
	
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
	public List<ProjectMemberVO> projectMemberDetailTaskCountChart(@Param("projectNo")int projectNo);


	
	 public List<ProjectMemberVO> projectMemberListSearch(Map<String, Object> param);

}
