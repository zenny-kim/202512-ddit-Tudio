package kr.or.ddit.projectBoard.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.project.ProjectBoardVO;

public interface ITabBoardService {
	
	// 프로젝트 게시판 카테고리 생성
	public void createDefaultCategory(int projectNo);
	
	//게시판 목록 조회
	public List<ProjectBoardVO> selectProjectBoardList(Map<String, Object> paramMap);
	
	//게시글 등록
	public ServiceResult insertProjectBoard(ProjectBoardVO boardVO);

	//프로젝트 멤버 조회
	public List<MemberVO> getProjectMemberList(int projectNo);

	//조회수 증가
	public int increaseHitProjectBoard(int boNo);

	//게시판 상세 화면
	public ProjectBoardVO detailProjectBoard(int boNo);

	//총 게시글 수
	public int countProjectBoard(Map<String, Object> paramMap);

	//게시글 수정
	public ServiceResult updateProjectBoard(ProjectBoardVO boardVO);

	//게시글 삭제
	public ServiceResult deleteProjectBoard(int boNo);

}
