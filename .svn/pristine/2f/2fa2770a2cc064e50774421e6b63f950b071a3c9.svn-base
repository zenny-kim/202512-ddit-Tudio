package kr.or.ddit.notification.service.impl;

import java.text.DateFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import kr.or.ddit.approval.mapper.IApprovalMapper;
import kr.or.ddit.approval.service.IApprovalService;
import kr.or.ddit.common.WidgetType;
import kr.or.ddit.dashboard.service.IWidgetUpdateService;
import kr.or.ddit.notification.handler.NotificationHandler;
import kr.or.ddit.notification.mapper.INotificationMapper;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.util.DateFormatUtil;
import kr.or.ddit.vo.DraftApprovalVO;
import kr.or.ddit.vo.InquiryVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationSettingVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.meetingRoom.MeetingReservationVO;
import kr.or.ddit.vo.project.ProjectBoardVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 컨트롤러에서 호출하는 알림 조회/읽음 처리/삭제를 처리한다. 알림은 DB에 쌓는 데이터이고, 웹소켓은 "실시간 갱신"을 위한 옵션이다.
 */
@Slf4j
@Service
public class NotificationServiceImpl implements INotificationService {

	// 위젯 갱신
	@Autowired
	private IWidgetUpdateService widgetUpdateService;

	@Autowired
	private INotificationMapper notiMapper;

	@Autowired
	private NotificationHandler notiHandler;

	@Autowired
	private IApprovalMapper approvalMapper;

	/**
	 * 프로젝트 초대
	 *
	 * @param vo
	 * @return
	 */
	@Transactional
	public int insertProjectInviteNoti(NotificationVO vo) {
		int cnt = 0;

		String auth = selectAuthNoti(vo.getMemberNo());
		if (!"ROLE_ADMIN".equalsIgnoreCase(auth)) {
			cnt = notiMapper.insertNoti(vo);

			TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
				@Override
				public void afterCommit() {
					int unread = notiMapper.selectUnreadCount(vo.getMemberNo());

					Map<String, Object> notiPayload = new HashMap<>();
					notiPayload.put("type", "NOTI_NEW");
					notiPayload.put("unreadCount", unread);
					notiPayload.put("noti", vo);

					// 대상이 1명이라.. 효비님이 반복문 돌려주셔서 1ㄷ1로 쓰면 되니까
					notiPayload.put("notiCategory", "프로젝트");

					notiHandler.sendToMember(vo.getMemberNo(), notiPayload);
				}
			});
		}

		return cnt;
	}
	
	/**
	 * 프로젝트 초대 알림 일괄 처리
	 * @author YHB
	 */
	@Override
	@Transactional
	public int insertProjectInviteNotiBatch(List<NotificationVO> notiList) {
	    if (notiList == null || notiList.isEmpty()) return 0;

	    int result = notiMapper.insertNotificationsBatch(notiList);

	    // 트랜잭션 커밋 후 모든 대상에게 실시간 알림 전송
	    TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
	        @Override
	        public void afterCommit() {
	            for (NotificationVO vo : notiList) {
	                int unread = notiMapper.selectUnreadCount(vo.getMemberNo());

	                Map<String, Object> notiPayload = new HashMap<>();
	                notiPayload.put("type", "NOTI_NEW");
	                notiPayload.put("unreadCount", unread);
	                notiPayload.put("noti", vo);
	                notiPayload.put("notiCategory", "프로젝트");

	                // 각 회원별로 소켓 전송
	                notiHandler.sendToMember(vo.getMemberNo(), notiPayload);
	                // 대시보드 위젯 갱신
	                widgetUpdateService.sendWidgetUpdate(vo.getMemberNo(), WidgetType.ALARM);
	            }
	        }
	    });
	    
	    return result; // 저장된 총 건수 반환
	}

	/*
	 * 부모 댓글 작성자, 게시글 작성자 조회
	 */
	@Override
	public Map<String, Object> selectNotiReply(Map<String, Object> map) {
		return notiMapper.selectNotiReply(map);
	}

	/**
	 * 프로젝트 변경시 멤버 푸시 대상 목록 조회 (설정없음)
	 */
	@Override
	public List<Integer> selectProjectUpdateNoti(Map<String, Object> param) {
		return notiMapper.selectProjectUpdateNoti(param);
	}

	/**
	 * 프로젝트 변경시 푸쉬 대상을 DB 일괄 insert
	 */
	@Override
	public int insertProjectUpdateNoti(NotificationVO vo) {
		return notiMapper.insertProjectUpdateNoti(vo);
	}

	/**
	 * 프로젝트 변경 알림
	 *
	 * @param vo(notiType,targetId,notiUrl,notiMessage,notiCategory,projectNo,writerNo)
	 * @param projectNo
	 * @param writerNo
	 */
	@Transactional
	public void pushProjectUpdateNoti(NotificationVO vo, int projectNo, int writerNo) {

		// 1) 푸시 대상 미리 조회
		Map<String, Object> p = new HashMap<>();
		p.put("projectNo", projectNo);
		p.put("writerNo", writerNo);

		List<Integer> targets = notiMapper.selectProjectUpdateNoti(p);

		// 2) DB 일괄 INSERT
		notiMapper.insertProjectUpdateNoti(vo);

		// 3) 커밋 후 푸시
		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCommit() {
				for (int memberNo : targets) {
					int unread = notiMapper.selectUnreadCount(memberNo);

					Map<String, Object> payload = new HashMap<>();
					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);

					// 프론트에서 리스트 다시 당겨오게 하는 방식이면 이것만 있어도 됨
					notiHandler.sendToMember(memberNo, payload);

					// 위젯 갱신
					widgetUpdateService.sendWidgetUpdate(vo.getMemberNo(), WidgetType.ALARM);
				}
			}
		});
	}

	/**
	 * 사이트 공지사항 알림 발송
	 *
	 * @return
	 */
	@Transactional
	@Override
	public void pushSiteNotice(int targetId, String notiUrl, String notiMessage) {

		// db에 공지 알림이 y인 회원들에게 일괄 insert
		Map<String, Object> p = new HashMap<>();
		p.put("targetId", targetId);
		p.put("notiUrl", notiUrl);
		p.put("notiMessage", notiMessage);
		p.put("notiCategory", "공지사항");

		notiMapper.insertSiteNoticeNoti(p);

		// 푸시 대상 목록 미리 조회
		List<MemberVO> targets = notiMapper.notiSiteMember();

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCommit() {
				for (MemberVO m : targets) {
					int memberNo = m.getMemberNo();
					int unread = notiMapper.selectUnreadCount(memberNo);

					Map<String, Object> payload = new HashMap<>();
					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);
					payload.put("notiCategory", "공지사항");

					// 즉시 렌더링 정보
					Map<String, Object> noti = new HashMap<>();
					noti.put("notiType", "NOTI_SYSTEM");

					notiHandler.sendToMember(memberNo, payload);

					// 위젯 갱신
					widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
				}
			}
		});
	}

	/**
	 * 마감일이 임박한 상하위 업무와 스케줄 알림(배치)
	 * 
	 * @param vo memberNo,notiType,targetId,notiUrl,notiMessage,notiCategory
	 * 
	 *           전제: * 1) notiMapper.selectScheduleNotiAll() (또는 Batch용 쿼리) 가 *
	 *           memberNo, projectNo, projectName, scheduleType, scheduleId,
	 *           scheduleTitle, scheduleDday 를 채워서 내려준다. * 2) insertNoti는
	 *           NOTIFICATION 테이블 스키마( NOTI_NO, MEMBER_NO, NOTI_TYPE, * TARGET_ID,
	 *           NOTI_URL, IS_READ, NOTICE_REGDATE, NOTI_MESSAGE, NOTI_CATEGORY )에
	 *           맞춰 insert 한다.
	 */
	@Transactional
	public void pushScheduleNoti() {

		// 1) 오늘/내일 마감 전체 대상 조회 (memberNo + projectNo + item 정보 포함)
		List<NotificationVO> targets = notiMapper.selectScheduleNoti(); // 파라미터 없음

		if (targets == null || targets.isEmpty())
			return;

		// 2) DB 저장 (대상별 insert)
		for (NotificationVO n : targets) {
			n.setNotiType("NOTI_SCHEDULE");
			n.getMemberNo();
			n.getTargetId();
			n.getProjectNo();
			n.setNotiUrl("/tudio/project/detail?projectNo=" + n.getProjectNo() + "&tab=calendar");

			if (n.getScheduleDday() == 1) {

				n.setNotiMessage("[" + n.getScheduleTitle() + "]" + " 마감 1일전입니다.");
			} else {
				n.setNotiMessage("[" + n.getScheduleTitle() + "]" + " 마감일입니다.");
			}

			String projectName = n.getProjectName();
			n.setNotiCategory(projectName);
			// n에 memberNo/notiType/targetId/notiUrl/notiMessage/notiCategory 세팅돼있어야 함
			notiMapper.insertNoti(n);
		}

		// 3) 커밋 후 푸시
		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCommit() {

				// 같은 회원이 여러 건이면 unreadCount 조회/푸시를 줄이기 위해 묶기
				Map<Integer, Integer> lastUnreadByMember = new HashMap<>();

				for (NotificationVO n : targets) {
					int memberNo = n.getMemberNo();

					Integer unread = lastUnreadByMember.get(memberNo);
					if (unread == null) {
						unread = notiMapper.selectUnreadCount(memberNo);
						lastUnreadByMember.put(memberNo, unread);
					}

					Map<String, Object> payload = new HashMap<>();
					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);

					notiHandler.sendToMember(memberNo, payload);
					widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
				}
			}
		});
	}

	/*
	 * 회의실 알림 발송 대상
	 * 
	 * @param vo reservationId, memberNo
	 */
	@Transactional
	public void pushMeetingRoomNoti(MeetingReservationVO meetingVO, NotificationVO notiVO) {

		// 알림 대상 조회
		List<MeetingReservationVO> meetingList = notiMapper.selectMeetingRoomNoti(meetingVO);

		if (meetingList == null || meetingList.isEmpty())
			return;

		for (MeetingReservationVO a : meetingList) {

			notiVO.setNotiType("NOTI_SCHEDULE");
			notiVO.setNotiCategory(a.getProjectName());
			notiVO.setMemberNo(a.getReciverMember());
			notiVO.setTargetId(a.getReservationId());
			notiVO.setNotiUrl("/tudio/project/detail?projectNo=" + a.getProjectNo() + "&tab=meetingRoom");

			// 알림 DB 저장
			notiMapper.insertNoti(notiVO);
		}

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {
				for (MeetingReservationVO b : meetingList) {
					int memberNo = b.getReciverMember();

					int unread = notiMapper.selectUnreadCount(memberNo);

					Map<String, Object> payload = new HashMap<>();

					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);

					notiHandler.sendToMember(memberNo, payload);
				}

			}

		});

	}

	/*
	 * 회의실 취소 알림 발송
	 * 
	 * @param vo reservationId, memberNo
	 */
	@Transactional
	public void pushCancelMeetingRoomNoti(int reservationId) {
		List<MeetingReservationVO> meetingList = notiMapper.selectCancelMeetingRoomNoti(reservationId);

		if (meetingList == null || meetingList.isEmpty())
			return;

		NotificationVO notiVO = new NotificationVO();
		String dateText = "";
		for (MeetingReservationVO a : meetingList) {

			notiVO.setNotiType("NOTI_SCHEDULE");
			notiVO.setNotiCategory(a.getProjectName());
			notiVO.setMemberNo(a.getReciverMember());
			notiVO.setTargetId(a.getReservationId());
			notiVO.setNotiUrl("/tudio/project/detail?projectNo=" + a.getProjectNo() + "&tab=meetingRoom");

			dateText = DateFormatUtil.formatKorean(a.getResStartdate());
			notiVO.setNotiMessage("[" + dateText + "] 회의실 예약이 취소되었습니다");
			// 알림 DB 저장
			notiMapper.insertNoti(notiVO);
		}

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {
				for (MeetingReservationVO b : meetingList) {
					int memberNo = b.getReciverMember();

					int unread = notiMapper.selectUnreadCount(memberNo);

					Map<String, Object> payload = new HashMap<>();

					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);

					notiHandler.sendToMember(memberNo, payload);
				}

			}

		});

	}

	/**
	 * 기안서 결재 승인 알림 (첫)
	 */
	@Transactional
	public void pushInsertApprovalNoti(Map<String, Object> map) {

		// 알림 발송 대상 조회
		DraftApprovalVO vo = notiMapper.selectDocumentNoti(map);

		if (vo == null)
			return;

		NotificationVO notiVO = new NotificationVO();
		notiVO.setMemberNo(vo.getMemberNo());
		notiVO.setNotiType("NOTI_APPROVAL");
		notiVO.setTargetId(vo.getApproverNo());
		notiVO.setNotiUrl("/tudio/approval/list");
		notiVO.setNotiMessage("[" + vo.getDocumentTitle() + "]" + " 결재 요청을 확인하세요.");
		notiVO.setNotiCategory(vo.getProjectName());

		notiMapper.insertNoti(notiVO);

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {

				int memberNo = vo.getMemberNo();

				int unread = notiMapper.selectUnreadCount(memberNo);

				Map<String, Object> payload = new HashMap<>();
				payload.put("type", "NOTI_NEW");
				payload.put("unreadCount", unread);

				notiHandler.sendToMember(memberNo, payload);

			}

		});

	}

	/**
	 * 남은 기안 결재자들에게 알림 푸쉬
	 * 
	 * @param map
	 */
	@Transactional
	public void pushinsertNextApprovalNoti(Map<String, Object> map) {

		// 알림 발송 대상 조회
		DraftApprovalVO vo = notiMapper.selectDocumentNextNoti(map);

		if (vo == null)
			return;

		NotificationVO notiVO = new NotificationVO();
		notiVO.setMemberNo(vo.getMemberNo());
		notiVO.setNotiType("NOTI_APPROVAL");
		notiVO.setTargetId(vo.getApproverNo());
		notiVO.setNotiUrl("/tudio/approval/list");
		notiVO.setNotiMessage("[" + vo.getDocumentTitle() + "]" + " 결재 요청을 확인하세요.");
		notiVO.setNotiCategory(vo.getProjectName());

		notiMapper.insertNoti(notiVO);

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
			@Override
			public void afterCommit() {
				int memberNo = vo.getMemberNo();

				int unread = notiMapper.selectUnreadCount(memberNo);

				Map<String, Object> payload = new HashMap<>();
				payload.put("type", "NOTI_NEW");
				payload.put("unreadCount", unread);

				notiHandler.sendToMember(memberNo, payload);
			}

		});
	}

	/*
	 * 기안 작성자에게 알림 발송
	 */
	@Transactional
	public void pushApprovalWriterNoti(DraftApprovalVO vo, int step, NotificationVO notiVO) {

		if (vo == null)
			return;

		notiVO.setMemberNo(vo.getApprovalWriter());
		notiVO.setNotiType("NOTI_APPROVAL");
		notiVO.setTargetId(vo.getDocumentNo());
		notiVO.setNotiUrl("/tudio/approval/list");
		// notiVO.setNotiMessage("[" + vo.getDocumentTitle() + "]" + step+"차 결재가 승인
		// 되었습니다.");
		notiVO.setNotiCategory(vo.getProjectName());

		notiMapper.insertNoti(notiVO);

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {
				int memberNo = vo.getApprovalWriter(); // 기안자에게 푸시

				int unread = notiMapper.selectUnreadCount(memberNo);

				Map<String, Object> payload = new HashMap<>();
				payload.put("type", "NOTI_NEW");
				payload.put("unreadCount", unread);

				notiHandler.sendToMember(memberNo, payload);
			}

		});

	}
	
	
	/**
	 * 화상채팅 초대 알림 발송
	 * videochatNo,videochatCreaterNo,inviteMemberList
	 */
	@Transactional
	public void pushVideoInviteNoti(VideoChatVO vo) {
		
		List<VideoChatVO> target = notiMapper.selectVideoInviteNotiTargets(vo);
	
		 if (target == null || target.isEmpty()) return;
		 
		 
		   //DB INSERT (대상별로 1건씩)
		    for (VideoChatVO t : target) {
		    	String videochatId = t.getVideochatId();
		        NotificationVO notiVO = new NotificationVO();
		        notiVO.setMemberNo(t.getMemberNo());
		        notiVO.setNotiType("NOTI_INVITE"); 
		        notiVO.setTargetId(t.getVideochatNo());
		        notiVO.setNotiUrl("/tudio/videoChat/waitingRoom?roomId="+videochatId);
		        
		        // 메시지/카테고리
		        notiVO.setNotiMessage("[" + t.getVideochatTitle()+ "] 화상회의에 초대되었습니다.");
		        notiVO.setNotiCategory(t.getProjectName());

		        notiMapper.insertNoti(notiVO);
		    }

		 
		    // 3) 커밋 후 푸시 (중복 unread 조회 줄이기)
		    TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
		        @Override
		        public void afterCommit() {

		            Set<Integer> uniqueMembers = new HashSet<>();
		            for (VideoChatVO t : target) uniqueMembers.add(t.getMemberNo());

		            for (int memberNo : uniqueMembers) {
		                int unread = notiMapper.selectUnreadCount(memberNo);

		                Map<String, Object> payload = new HashMap<>();
		                payload.put("type", "NOTI_NEW");
		                payload.put("unreadCount", unread);
		                payload.put("notiCategory", "화상채팅");

		                notiHandler.sendToMember(memberNo, payload);

		                // 위젯 갱신
		                widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
		            }
		        }
		
		});
		
	}
	


	/**
	 * 문의사항 등록한 사람에게 답변 등록됐다는 알림 보내기
	 */
	@Transactional
	public void pushInquiryNoti(NotificationVO notiVO,int inquiryNo) {

		InquiryVO vo = notiMapper.selectInquiryNoti(inquiryNo);
		
		if (vo == null) {
		    log.warn("pushInquiryNoti: inquiry not found. map={}", inquiryNo);
		    return;
		}
		
		notiVO.setMemberNo(vo.getUserNo());
		notiVO.setNotiType("NOTI_SYSTEM");
		notiVO.setTargetId(vo.getInquiryNo());
		notiVO.setNotiUrl("/admin/board/inquiry/"+vo.getInquiryNo());
		notiVO.setNotiMessage("["+vo.getInquiryTitle()+"]"+"에 답변이 달렸습니다.");
		// 되었습니다.");
		notiVO.setNotiCategory("문의사항");
		
		notiMapper.insertNoti(notiVO);

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {
				
				
				int unread = notiMapper.selectUnreadCount(vo.getUserNo());

				Map<String, Object> payload = new HashMap<>();
				payload.put("type", "NOTI_NEW");
				payload.put("unreadCount", unread);

				notiHandler.sendToMember(vo.getUserNo(), payload);

			}

		});

	} 
	

	@Transactional
	public void pushManagerNoti(int projectNo, int taskId,
          List<Integer> taskManagerNos,NotificationVO notiVO) {
		
		  String projectName = notiMapper.selectProjectName(projectNo);
		 
		  List<Integer> targets = taskManagerNos.stream()
		            .filter(no -> no != null && no > 0)
		            .distinct()
		            .toList();
		
		
		Map<String, Object> p = new HashMap<>();
		p.put("memberNos", targets);
	    p.put("notiType", "NOTI_TASK");
	    p.put("targetId", taskId);
	    p.put("notiUrl","/tudio/myTask");
	    p.put("notiMessage", notiVO.getNotiMessage());
	    p.put("notiCategory", projectName);
	    p.put("projectNo", projectNo);
	    notiMapper.insertTaskManagerNoti(p);

		TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {

			@Override
			public void afterCommit() {
				for (int memberNo : targets) {

					int unread = notiMapper.selectUnreadCount(memberNo);

					Map<String, Object> payload = new HashMap<>();

					payload.put("type", "NOTI_NEW");
					payload.put("unreadCount", unread);

					notiHandler.sendToMember(memberNo, payload);
				}

			}

		});

	}
	
	
	
	
	
	
	

	/**
	 * 라우팅에 맞게 URL 만들기 - 프로젝트 탭 이동이 필요하면 projectNo 포함 - TASK/SUB/SCHEDULE 별 상세로 보내고
	 * 싶으면 scheduleId 포함
	 */
	private String buildScheduleNotiUrl(NotificationVO n) {
		int projectNo = n.getProjectNo();
		int id = n.getScheduleId();
		String t = (n.getScheduleType() == null ? "" : n.getScheduleType().toUpperCase());

		// 아래는 예시. 너희 실제 URL 규칙으로 교체.
		if ("TASK".equals(t)) {
			return "/tudio/project/" + projectNo + "/task/" + id;
		}
		if ("SUB".equals(t)) {
			return "/tudio/project/" + projectNo + "/task/sub/" + id;
		}
		// SCHEDULE
		return "/tudio/project/" + projectNo + "/schedule?focus=" + id;
	}

	/**
	 * 알림 목록 조회 (전체 / 안읽음만)
	 *
	 * @param memberNo
	 * @param unreadOnly
	 * @return 알림 리스트
	 */
	@Override
	public List<NotificationVO> notiList(int memberNo, boolean unreadOnly) {
		Map<String, Object> notiParam = new HashMap<>();
		notiParam.put("memberNo", memberNo);
		notiParam.put("unreadOnly", unreadOnly);

		return notiMapper.notiList(notiParam);
	}

	/**
	 * 안읽은 알림 개수
	 *
	 * @param memberNo
	 * @return
	 */
	@Override
	public int notiUnreadCount(int memberNo) {
		return notiMapper.selectUnreadCount(memberNo);
	}

	/**
	 * 특정 알림 1건 읽음 처리
	 *
	 * @param memberNo
	 * @param notiNo
	 */
	@Override
	public void notiMarkRead(int memberNo, long notiNo) {
		Map<String, Object> notiMarkReadParam = new HashMap<>();
		notiMarkReadParam.put("memberNo", memberNo);
		notiMarkReadParam.put("notiNo", notiNo);

		notiMapper.updateRead(notiMarkReadParam);

		// 위젯 갱신
		widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
	}

	/**
	 * 특정 알림 삭제(물리)
	 *
	 * @param memberNo
	 * @param notiNo
	 */
	@Override
	public void notiDelete(int memberNo, long notiNo) {
		Map<String, Object> notiDeleteParam = new HashMap<>();
		notiDeleteParam.put("memberNo", memberNo);
		notiDeleteParam.put("notiNo", notiNo);

		int result = notiMapper.deleteNoti(notiDeleteParam);
		if (result > 0) {
			widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
		}
	}

	/**
	 * 내가 쓴 게시글에 댓글이 달렸을 때 알림
	 *
	 * @param boNo
	 * @return
	 */
	@Override
	public ProjectBoardVO notiCommentNoti(int boNo) {
		return notiMapper.notiCommentNoti(boNo);
	}

	/**
	 * 회원의 알림 설정 조회
	 */
	@Override
	public NotificationSettingVO notiAllMember(int memberNo) {
		return notiMapper.notiAllMember(memberNo);
	}

	@Transactional
	// 30일이 지난 알림메세지 자동 삭제
	public int deleteOldNoti() {
		return notiMapper.deleteOldNoti();
	}

	/**
	 * 대시보드 알림 위젯 상태 변경
	 */
	@Override
	public void toggleNotificationRead(int memberNo, long notiNo) {
		Map<String, Object> params = new HashMap<>();
		params.put("memberNo", memberNo);
		params.put("notiNo", notiNo);

		int result = notiMapper.toggleNotificationRead(params);
		if (result > 0) {
			widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.ALARM);
		}
		return;
	}

	/**
	 * 커뮤니티 공지사항 발송
	 */
	@Transactional
	public void pushProjectNotice(NotificationVO vo, Map<String, Object> map) {

		String auth = selectAuthNoti(vo.getMemberNo());

			// 알림 DB 저장 대상 조회
			List<Integer> notiList = notiMapper.selectProjectNoticeNoti(vo);

			map.put("projectNo", vo.getProjectNo());
			map.put("writerNo", vo.getWriterNo());

			// DB에 대상 저장
			notiMapper.insertProjectNoticeNoti(map);

			TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
				@Override
				public void afterCommit() {
					for (Integer i : notiList) {
						int memberNo = i;
						int unread = notiMapper.selectUnreadCount(memberNo);

						Map<String, Object> payload = new HashMap<>();
						payload.put("type", "NOTI_NEW");
						payload.put("unreadCount", unread);

						notiHandler.sendToMember(memberNo, payload);
					}
				}
			});

		
	}

	/**
	 * 프로젝트 공지사항 알림 insert
	 */
	@Override
	public void insertProjectNoticeNoti(Map<String, Object> map) {
		notiMapper.insertProjectNoticeNoti(map);
	}

	@Override
	public List<NotificationVO> notiListByTab(int memberNo, String tab) {
		boolean unreadOnly = "unread".equalsIgnoreCase(tab);
		boolean readOnly = "read".equalsIgnoreCase(tab);

		Map<String, Object> notiParam = new HashMap<>();
		notiParam.put("memberNo", memberNo);
		notiParam.put("unreadOnly", unreadOnly);
		notiParam.put("readOnly", readOnly);

		return notiMapper.notiList(notiParam);
	}

	/**
	 * Db에 알림 저장 + 푸쉬 (개인)
	 *
	 * @param vo memberNo, notiType,targetId,notiUrl,notiMessage,notiCategory
	 * @return
	 */
	@Transactional
	public int insertNotification(NotificationVO vo) {
		int cnt = 0;

		String auth = selectAuthNoti(vo.getMemberNo());
		if (!"ROLE_ADMIN".equalsIgnoreCase(auth) && !"ROLE_CLIENT".equalsIgnoreCase(auth)) {
			cnt = notiMapper.insertNoti(vo);

			TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
				@Override
				public void afterCommit() {
					int unread = notiMapper.selectUnreadCount(vo.getMemberNo());

					Map<String, Object> notiPayload = new HashMap<>();
					notiPayload.put("type", "NOTI_NEW");
					notiPayload.put("unreadCount", unread);
					notiPayload.put("noti", vo);
					notiPayload.put("notiCategory", vo.getNotiCategory());

					notiHandler.sendToMember(vo.getMemberNo(), notiPayload);

					// 위젯 갱신
					widgetUpdateService.sendWidgetUpdate(vo.getMemberNo(), WidgetType.ALARM);
				}
			});
		}

		return cnt;
	}

	/**
	 * 설정이 ON일 때만 알림 저장
	 *
	 * @param vo
	 * @param settingKey
	 * @return insert 결과
	 */
	public int insertNotiEnabled(NotificationVO vo, String settingKey) {
		Map<String, Object> insertNotiEnabledParam = new HashMap<>();
		insertNotiEnabledParam.put("vo", vo);
		insertNotiEnabledParam.put("settingKey", settingKey);

		return notiMapper.insertNotiEnabled(insertNotiEnabledParam);
	}

	/**
	 * 공지사항 on한 멤버
	 */
	@Override
	public List<MemberVO> notiSiteMember() {
		return notiMapper.notiSiteMember();
	}

	@Override
	public void insertSiteNoticeNoti(NotificationVO vo) {
		// TODO Auto-generated method stub
	}

	/**
	 * 권한 설정 정보
	 */
	@Override
	public String selectAuthNoti(int memberNo) {
		return notiMapper.selectAuthNoti(memberNo);
	}

	@Override
	public List<Integer> selectProjectNoticeNoti(int projectNo, int writerNo) {
		// TODO Auto-generated method stub
		return null;
	}

	// 마감일일 1일 이하로 남은 스케줄 조회
	public List<NotificationVO> selectScheduleNoti() {
		return notiMapper.selectScheduleNoti();
	}

	// 회의실 알림 발송 대상
	public List<MeetingReservationVO> selectMeetingRoomNoti(MeetingReservationVO vo) {
		return notiMapper.selectMeetingRoomNoti(vo);
	}

	// 회의실 예약 취소
	public List<MeetingReservationVO> selectCancelMeetingRoomNoti(int reservationId) {
		return notiMapper.selectCancelMeetingRoomNoti(reservationId);
	}

	@Override
	public List<MeetingReservationVO> selectCancleMeetingRoomNoti(int reservationId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Integer selectProjectNoByTaskId(int taskId) {
		
		return notiMapper.selectProjectNoByTaskId(taskId);
	}

	@Override
	public List<Integer> selectSubManagerPmNoti(int taskId) {
		
		return notiMapper.selectSubManagerPmNoti(taskId);
	}


}
