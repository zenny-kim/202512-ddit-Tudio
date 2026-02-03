package kr.or.ddit.project.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import kr.or.ddit.vo.project.ProjectMiniHeaderVO;
import kr.or.ddit.vo.project.ProjectVO;

@Mapper
public interface IProjectMapper {
	// 프로젝트 생성
	public int insertProject(ProjectVO projectVO);
	public int insertProjectMember(ProjectMemberVO memberVO);
	public int insertMiniHeader(ProjectMiniHeaderVO miniheaderVO);	
	
	// 검증 : 이메일로 회원 정보 조회
	public MemberVO findMemberByEmail(String memberEmail);
	public MemberVO selectMemberByEmail(Map<String, String> params);
	
	public List<MemberVO> getMemberList(List<String> emailList);
	public List<ProjectMemberVO> selectProjectMemberByEmail(int projectNo, List<String> emailList);
	
	// 비회원 프로젝트 초대
	// [초대] 1. 비회원 초대장 생성 (토큰 발급 및 저장)
	public int insertInvitations(List<ProjectMemberVO> inviteBatch);
	// [초대] 2. 토큰으로 초대장 정보 조회 (유효성 검증용)
	public ProjectMemberVO selectInvitationByToken(String token);
	// [초대] 3. 초대장 사용 처리 (회원가입 완료 시 호출 -> USED_YN = 'Y')
	public int updateInvitationUsed(String token);
	// 비회원 초대 목록 조회
	public List<ProjectMemberVO> selectProjectInvitationList(int projectNo);
	// [초대 취소] 비회원 초대장 삭제 (이메일 기준)
	public int deleteInvitation(ProjectMemberVO vo);
	// [초대 취소] 기존회원 초대 상태 삭제 (P상태인 경우만)
	public int deleteProjectMemberPending(ProjectMemberVO vo);

	// 프로젝트 구성원 참여 상태 변경
	public void updateProjectMemberStatus(ProjectMemberVO member);
	
	// 알림 정보 저장
	public int insertNotification(NotificationVO notiVO);
	
	// 프로젝트 생성 후 참여자 미등록시 자동 삭제 처리 및 관리자에게 경고 알림 발송
	public List<ProjectVO> selectProjectForDelete();	// 프로젝트 삭제 대상 조회
	public List<ProjectVO> selectProjectForWarning();	// 프로젝트 참여자 미등록 경고 대상 조회
	public void deleteProject(int projectNo);			// 프로젝트 물리 삭제
	
	// 프로젝트에 대한 권한 체크
	public int checkProjectAccess(Map<String, Object> params);
	
	// 프로젝트 상세 정보
	public ProjectVO selectProjectDetail(int projectNo);

	// 사용자 프로젝트 북마크 상태 조회
	public String selectBookmark(int projectNo, int memberNo);
	
	// 사용자 북마크 설정 토글
	public int toggleBookmark(int projectNo, int memberNo);
	
	// 프로젝트 관리자 여부 체크
	public int checkManager(Map<String, Object> params);
	
	// 프로젝트 수정
	public void updateProject(ProjectVO projectVO);
	public void updateMiniHeader(ProjectMiniHeaderVO miniHeader);
	public ProjectMemberVO selectProjectMember(Map<String, Object> map);
	public void deactivateProjectMember(Map<String, Object> deactivateParams);
	
	public void mergeProjectMember(ProjectMemberVO vo);
	public void mergeProjectMemberBatch(List<ProjectMemberVO> memberMergeBatch);
		
	// 미완료 업무 조회
	public int countUnfinishedTask(int projectNo);
	
	// 역할별 활성 멤버 수
	int countActiveProjectMember(Map<String, Object> params); 
	
	// 전체 업무 수
	int countTotalTasks(int projectNo);
	
	// 프로젝트 완료 처리
	public void updateProjectStatus(int projectNo, int projectStatus);
		
	// 프로젝트 논리 삭제 (상태 변경:2)
	public int deleteProjectLogically(ProjectVO projectVO);
	
	// 프로젝트 관리자 권한 위임
	public int updateProjectRole(Map<String, Object> newManagerParam);
	// 프로젝트 소유자 변경
	public int updateProjectManager(Map<String, Object> params);
	
	// 프로젝트 결과보고서
	public ProjectVO selectProjectDetailForReport(int projectNo);
	public List<MemberVO> selectProjectMemberListForReport(int projectNo);
	public List<Map<String, Object>> selectProjectTaskListForReport(int projectNo);
	public Map<String, Object> selectTaskComplianceStats(int projectNo);
	public List<Map<String, Object>> selectMemberContributionStats(int projectNo);	// 구성원 업무기여도
	public int updateProjectFileGroupNo(Map<String, Object> updateParam);
	public Integer selectLatestGroupNo(Map<String, Object> findGroupParam);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 프로젝트 목록 조회
	public List<ProjectVO> list(Map<String, Object> countMap);
	
	//  프로젝트 검색 + 갯수 조회
	public int listCount(Map<String, Object> countMap);
	
	// 프로젝트 리스트 북마크 상태 전환. 
	public void updateListBookmark(@Param("projectNo")int projectNo, @Param("memberNo")int memberNo, @Param("next")String next);
	
	// 프로젝트 진척률 리스트
	public List<ProjectInsightVO> selectProjectRateList(int memberNo);
	
}
