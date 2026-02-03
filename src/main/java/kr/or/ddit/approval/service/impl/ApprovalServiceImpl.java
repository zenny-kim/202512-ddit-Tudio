package kr.or.ddit.approval.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import kr.or.ddit.approval.mapper.IApprovalMapper;
import kr.or.ddit.approval.service.IApprovalService;
import kr.or.ddit.notification.mapper.INotificationMapper;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.vo.ApprovalPaginationInfoVO;
import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.project.ProjectVO;

@Service
public class ApprovalServiceImpl implements IApprovalService {

	@Autowired
	private IApprovalMapper approvalMapper;

	@Autowired
	private INotificationService notiService;

	@Autowired
	private INotificationMapper notiMapper;

	// 권한 체크
	@Override
	public String getProjectRole(int projectNo, int userNo) {
		return approvalMapper.getProjectRole(projectNo, userNo);
	}

	// 결재 상태 조회
	@Override
	public Map<String, Object> getApprovalStats(int projectNo, int userNo, String projectRole, String userAuth) {
		return approvalMapper.getApprovalStats(projectNo, userNo, projectRole, userAuth);
	}

	// 결재 카운트
	@Override
	public int getApprovalCount(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO) {
		return approvalMapper.getApprovalCount(pagingVO);
	}

	// 결재목록 조회
	@Override
	public List<DraftDocumentVO> getApprovalList(ApprovalPaginationInfoVO<DraftDocumentVO> pagingVO) {
		return approvalMapper.getApprovalList(pagingVO);
	}

	// 프로젝트 목록 조회(페이징X)
	@Override
	public List<ProjectVO> getMyProjectList(int memberNo) {
		return approvalMapper.getMyProjectList(memberNo);
	}

	// 결재상신(등록)
	@Transactional
	@Override
	public int insertDraft(DraftDocumentVO draftVO) {
		// 문서 저장
		int result = approvalMapper.insertDraftDocument(draftVO);

		// 결재선 저장
		if (result > 0 && draftVO.getApprovalList() != null) {
			for (DraftApprovalVO appVO : draftVO.getApprovalList()) {
				// 문서 번호를 결재선에 연결해줍니다.
				appVO.setDocumentNo(draftVO.getDocumentNo());
				approvalMapper.insertDraftApproval(appVO);
			}

			// 승인 알림 발송 시작
			Map<String, Object> map = new HashMap<>();
			map.put("documentNo", draftVO.getDocumentNo());
			map.put("approvalStep", 1);
			notiService.pushInsertApprovalNoti(map);
			// 승인 알림 발송 끝

		}

		return result;
	}

	// 기업담당자 조회
	@Override
	public List<MemberVO> getProjectClientList(int projectNo) {
		if (projectNo <= 0) {
			return new ArrayList<>();
		}

		List<MemberVO> clientList = approvalMapper.getProjectClientList(projectNo);

		if (clientList == null) {
			return new ArrayList<>();
		}

		return clientList;
	}

	// 문서 상세 정보 조회
	@Override
	public DraftDocumentVO selectDraftDetail(int documentNo) {
		return approvalMapper.selectDraftDetail(documentNo);
	}

	// 저장된 결재라인 가져오기
	@Override
	public List<DraftApprovalVO> selectApprovalList(int documentNo) {
		return approvalMapper.selectApprovalList(documentNo);
	}

	// 내 결재순서인지 판단
	@Override
	public boolean isCurrentApprover(int documentNo, int memberNo) {
		List<DraftApprovalVO> list = approvalMapper.selectApprovalList(documentNo);

		for (DraftApprovalVO app : list) {
			if (app.getApprovalStatus() == 607 || app.getApprovalStatus() == 608) {
				return app.getMemberNo() == memberNo;
			}
		}
		return false;
	}

	// 문서 승인 상태변경
	@Transactional
	@Override
	public String approveDocument(int documentNo, int memberNo) {
		int result = approvalMapper.updateApproverStatus(documentNo, memberNo, 609);

		// 문서 승인 알림 시작
		// 내가 몇차인지
		int currentStep = notiMapper.selectMyApprovalStep(documentNo, memberNo);

		// 다음 step(min)
		Integer nextStep = notiMapper.selectNextApprovalStep(documentNo, currentStep);

		// 기안자에게 "n차 승인" 또는 최종 승인 알림

		DraftApprovalVO writerVo = notiMapper.selectApprovalWriterNoti(documentNo);
		String title = writerVo.getDocumentTitle();

		if (nextStep != null) {
			// 다음 결재자가 있을 때 진행중으로
			approvalMapper.updateDocumentStatus(documentNo, 612);

			// 다음 결재자에게 결재요청 알림 (딱 1명)
			Map<String, Object> map = new HashMap<>();
			map.put("documentNo", documentNo);
			map.put("approvalStep", nextStep);
			notiService.pushinsertNextApprovalNoti(map);

			// 기안자에게 "currentStep차 승인"
			NotificationVO writerNoti = new NotificationVO();
			writerNoti.setNotiMessage("[" + title + "] " + currentStep + "차 승인 되었습니다.");
			notiService.pushApprovalWriterNoti(writerVo, currentStep, writerNoti);

		} else {
			// 다음 결재자 없음 -> 최종승인(613)
			approvalMapper.updateDocumentStatus(documentNo, 613);

			NotificationVO writerNoti = new NotificationVO();
			writerNoti.setNotiMessage("[" + title + "] 최종 승인 되었습니다.");
			notiService.pushApprovalWriterNoti(writerVo, currentStep, writerNoti);
		}
		// 문서 승인 알림 끝
		return "success";
	}

	// 반려 처리
	@Transactional
	@Override
	public String rejectDocument(int documentNo, int memberNo, String rejectionReason) {
		int result = approvalMapper.updateApproverReject(documentNo, memberNo, 610, rejectionReason);

		if (result > 0) {
			approvalMapper.updateDocumentStatus(documentNo, 614);
			
			
		// 기안 작성자에게 반려 처리 알림 시작
			DraftApprovalVO writerVO = notiMapper.selectApprovalWriterNoti(documentNo);
			
			
			if(writerVO != null) {
				String title = writerVO.getDocumentTitle();
				
			
				NotificationVO notiVO = new NotificationVO();
				notiVO.setNotiMessage("["+title+"]"+" 기안서가 반려되었습니다");
				
				notiService.pushApprovalWriterNoti(writerVO,0,notiVO);
			}
			
		// 기안 작성자에게 반려 처리 알림 끝	
			return "success";
		}
		return "fail";
	}

	@Override
	public int recallDocument(int documentNo, int memberNo) {
		return approvalMapper.recallDocument(documentNo, memberNo);
	}

}
