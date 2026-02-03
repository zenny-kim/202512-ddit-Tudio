package kr.or.ddit.approval.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApprovalPaginationInfoVO;
import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectVO;

public interface IApprovalService {
	
	//권한 체크 
	String getProjectRole(int projectNo, int userNo);
	
	//결재 상태 조회
	Map<String, Object> getApprovalStats(int projectNo, int userNo, String projectRole, String userAuth);

	//결재 카운트
	int getApprovalCount(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO);

	//결재목록 조회
	List<DraftDocumentVO> getApprovalList(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO);
	
	//프로젝트 목록 조회 (페이징 기능X)
	List<ProjectVO> getMyProjectList(int memberNo);
	
	//결재 상신(등록)
	int insertDraft(DraftDocumentVO draftVO);

	//기업담당자 조회	
	List<MemberVO> getProjectClientList(int projectNo);

	//문서 상세 정보 조회
	DraftDocumentVO selectDraftDetail(int documentNo);
	
	//저장된 결재라인 가져오기
	List<DraftApprovalVO> selectApprovalList(int documentNo);
	
	//내 결재순서인지 판단
	boolean isCurrentApprover(int documentNo, int memberNo);
	
	//결재 승인
	String approveDocument(int documentNo, int memberNo);

	//결재 반려
	String rejectDocument(int documentNo, int memberNo, String rejectionReason);

	//회수
	int recallDocument(int documentNo, int memberNo);

}
