package kr.or.ddit.approval.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.ApprovalPaginationInfoVO;
import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectVO;

@Mapper
public interface IApprovalMapper {

	String getProjectRole(int projectNo, int userNo);

	Map<String, Object> getApprovalStats(int projectNo, int userNo, String projectRole, String userAuth);

	int getApprovalCount(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO);

	List<DraftDocumentVO> getApprovalList(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO);

	List<ProjectVO> getMyProjectList(int memberNo);

	int insertDraftDocument(DraftDocumentVO draftVO);

	void insertDraftApproval(DraftApprovalVO appVO);

	List<MemberVO> getProjectClientList(int projectNo);

	DraftDocumentVO selectDraftDetail(int documentNo);

	List<DraftApprovalVO> selectApprovalList(int documentNo);

	// 내 뒤에 남은 결재자 수 조회
	int countRemainingApprovers(@Param("documentNo") int documentNo);

	// 결재자 개인 상태 업데이트 (607/608 -> 609)
	int updateApproverStatus(@Param("documentNo") int documentNo, 
	                         @Param("memberNo") int memberNo, 
	                         @Param("status") int status);

	// 문서 전체 상태 업데이트 (611 -> 612 또는 613)
	int updateDocumentStatus(@Param("documentNo") int documentNo, 
	                         @Param("status") int status);	
	
	// 반려 처리
	int updateApproverReject(
	    @Param("documentNo") int documentNo, 
	    @Param("memberNo") int memberNo, 
	    @Param("status") int status, 
	    @Param("rejectionReason") String rejectionReason
	);
	
	//회수
	int recallDocument(@Param("documentNo") int documentNo, @Param("memberNo") int memberNo);


}
