package kr.or.ddit.project.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import kr.or.ddit.vo.project.ProjectVO;

public interface IProjectService {
	
	// 프로젝트 생성
	public List<String> createProject(ProjectVO projectVO);

	// 프로젝트 참여 코드 관련 로직
	public ProjectMemberVO getInvitationByToken(String token);
	
	// 이메일 목록을 받아 유효/무효 결과를 분류해 반환
	public MemberVO selectMemberByEmail(Map<String, String> params);	

	// 프로젝트 초대받은 비회원 회원가입 성공시 프로젝트 구성원 상태 변경 (P -> Y)
	public void addProjectMemberDirectly(ProjectMemberVO projectMember);
	
	// 프로젝트 참여 수락
	public String confirmProjectParticipation(int projectNo, int memberNo);
	
	// 프로젝트 참여 초대 취소
	public ServiceResult cancelInvitation(int projectNo, String email);

	// 프로젝트 미니 헤더 리스트
	List<Map<String, Object>> getProjectTabList(ProjectVO project);

	// 프로젝트 참여자 미등록으로 인한 자동 삭제 처리에 대한 메일 알림 발송
	public void sendWarningNoti(ProjectVO project, int remainDays);
	public void sendDeleteNoti(ProjectVO project);

	// 프로젝트 접근 권한 체크
	public boolean checkProjectAccess(int projectNo, int memberNo);

	// 프로젝트 상세
	public ProjectVO getProjectDetail(int projectNo);

	// 프로젝트 북마크
	public String selectBookmark(int projectNo, int memberNo);
	public String toggleBookmark(int projectNo, int memberNo);

	// 프로젝트 수정
	public List<String> updateProject(ProjectVO projectVO);

	// 프로젝트 삭제 (논리삭제)
	public int deleteProjectLogically(ProjectVO projectVO);

	// 프로젝트 완료 처리
	public int changeProjectStatus(int projectNo, int projectStatus);
	
	// 프로젝트 관리자 권한 위임
	public ServiceResult delegateProjectManager(int projectNo, int currentManagerNo, int newManagerNo);
	
	// 프로젝트 목록 - 페이징/검색/정렬용
	public List<ProjectVO> list(Map<String, Object> countMap);

	// 프로젝트 검색+갯수 조회 (페이징 totalRecord)
	public int listCount(Map<String, Object> countMap);

	//프로젝트 리스트 북마크 
	public String toggleListBookmark(int projectNo, int memberNo);
	
	// 프로젝트 진척률
	public List<ProjectInsightVO> selectProjectRateList(int memberNo);

}
