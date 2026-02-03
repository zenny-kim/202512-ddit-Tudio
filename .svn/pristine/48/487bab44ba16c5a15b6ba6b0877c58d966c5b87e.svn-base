package kr.or.ddit.projectBoard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.project.BoardCategoryVO;
import kr.or.ddit.vo.project.MeetingMemberVO;
import kr.or.ddit.vo.project.ProjectBoardMinutesVO;
import kr.or.ddit.vo.project.ProjectBoardVO;

@Mapper
public interface ITabBoardMapper {
	
	// 프로젝트 게시판 카테고리 생성
	public void insertCategory(BoardCategoryVO categoryVO);

	//게시글 목록 조회
	public List<ProjectBoardVO> selectProjectBoardList(Map<String, Object> paramMap);
	
	//게시글 등록
	public int insertProjectBoard(ProjectBoardVO boardVO);
	
	//회의록 참석자 목록 조회
	public List<MemberVO> getProjectMemberList(int projectNo);
	
	//게시글 등록 시 파일그룹번호 저장
	public void updateBoardFileGroupNo(ProjectBoardVO boardVO);
	
	//회의록이라면 추가 내용 등록
	public void insertBoardMinutes(ProjectBoardMinutesVO minutesVO);

	//회의록에 추가된 참석자
	public void insertMeetingMember(MeetingMemberVO meetingMember);
	
	//게시글 조회수
	public int increaseHitProjectBoard(int boNo);
	
	//게시판 상세 조회
	public ProjectBoardVO detailProjectBoard(int boNo);

	//총 게시글 수
	public int countProjectBoard(Map<String, Object> paramMap);
	
	//게시글 수정
	public int updateProjectBoard(ProjectBoardVO boardVO);

	//게시글 삭제
	public int deleteProjectBoard(int boNo);

	//게시글 삭제 - 회의록 삭제
	public void deleteBoardMinutes(int boNo);
	
	//게시글 삭제 - 회의 참석자 삭제
	public void deleteMeetingMember(int boNo);
	

	

}
