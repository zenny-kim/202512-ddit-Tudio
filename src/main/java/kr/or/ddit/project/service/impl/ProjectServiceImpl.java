package kr.or.ddit.project.service.impl;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.mail.internet.MimeMessage;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.WidgetType;
import kr.or.ddit.dashboard.service.IWidgetUpdateService;
import kr.or.ddit.drive.service.IDriveService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.project.mapper.IProjectMapper;
import kr.or.ddit.project.service.IProjectService;
import kr.or.ddit.projectBoard.service.ITabBoardService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.project.ProjectInsightVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import kr.or.ddit.vo.project.ProjectMiniHeaderVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectServiceImpl implements IProjectService {

	@Autowired
	private IProjectMapper projectMapper;
	
	@Autowired
	private JavaMailSender mailSender;
	
	// 위젯 갱신
	@Autowired
	private IWidgetUpdateService widgetUpdateService;
	
	@Autowired
    private ITabBoardService tabBoardService;
	
	// 실시간 알림
	@Autowired
	private INotificationService notiService;
	
	@Autowired
	private IDriveService driveService;
	
	// 프로젝트 권한
	private static final String ROLE_MANAGER = "MANAGER";	// 프로젝트 관리자
	private static final String ROLE_MEMBER = "MEMBER";		// 프로젝트 참여자
	private static final String ROLE_CLIENT = "CLIENT";		// 기업 담당자
	
	// 관리자 이메일
	private static final String EMAIL_ADMIN = "sujeong1246@gmail.com";
	
	// 알림 타입
	private static final String NOTI_TYPE_INVITE = "PROJECT_INVITE";
	private static final String NOTI_TYPE_WARNING = "PROJECT_WARNING";
	private static final String NOTI_TYPE_DELETE = "PROJECT_DELETE";
	
	
	/**
	 * ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	 * 	프로젝트 생성
	 * ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
	 */
	@Override
	@Transactional
	public List<String> createProject(ProjectVO projectVO) {
		List<String> failedEmailList = new ArrayList<>();
		
		// 1. [프로젝트 기본 정보] 저장
        projectVO.setMemberNo(projectVO.getMemberNo()); // 작성자
        projectMapper.insertProject(projectVO);
        int projectNo = projectVO.getProjectNo();
        
        // 2. [프로젝트 게시판 카테고리] 생성
        tabBoardService.createDefaultCategory(projectNo);
        
        // 3. [프로젝트 루트 폴더] 생성
        driveService.createProjectRootFolder(projectNo, projectVO.getProjectName(), projectVO.getMemberNo());
        
        // 4. [관리자] 등록 (본인)
        registerManager(projectNo, projectVO.getMemberNo());

        // 5. 미니헤더 + 구성원 
        processMiniHeader(projectNo, projectVO.getMiniheader());
        processProjectMember(projectNo, projectVO, failedEmailList, false); // false: 생성
        
        return failedEmailList;
	}
	
	/**
	 * ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
     * 	프로젝트 수정
     * ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
     */
    @Override
    @Transactional
    public List<String> updateProject(ProjectVO projectVO) {
    	// 관리자 권한 체크
        Map<String, Object> checkParams = new HashMap<>();
        checkParams.put("projectNo", projectVO.getProjectNo());
        checkParams.put("memberNo", projectVO.getMemberNo());
        
        int isManager = projectMapper.checkManager(checkParams);
        
        if (isManager == 0) {	// 프로젝트 관리자가 아닌 경우
            throw new RuntimeException("권한 없음: 프로젝트 관리자만 수정할 수 있습니다.");
        }
        
        List<String> failedEmailList = new ArrayList<>();
        
        // 1. 기본 정보 수정 (Update)
        projectMapper.updateProject(projectVO);
        int projectNo = projectVO.getProjectNo();
        
        
        // 프로젝트 변경 알림
    	NotificationVO notiVO = new NotificationVO();
    	
    	String notiName = projectVO.getProjectName();
    	int writerNo = projectVO.getMemberNo();
    	
    	notiVO.setNotiCategory(notiName);
    	notiVO.setNotiType("NOTI_TASK");
    	notiVO.setNotiUrl("/tudio/project/detail?projectNo="+projectNo);
    	notiVO.setTargetId(projectNo);
    	notiVO.setNotiMessage("["+notiName+"]"+"정보가 변경되었습니다.");
    	notiVO.setProjectNo(projectNo);
    	notiVO.setWriterNo(writerNo);
        
         notiService.pushProjectUpdateNoti(notiVO, projectNo, writerNo);
        // 프로젝트 변경 알림 끝
        
         
        // 2. 공통 로직: 미니헤더 + 구성원 처리
        processMiniHeader(projectNo, projectVO.getMiniheader());
        processProjectMember(projectNo, projectVO, failedEmailList, true); // true: 수정
        
        return failedEmailList;
    }
    
    // 프로젝트 관리자 등록
    private void registerManager(int projectNo, int memberNo) {
        ProjectMemberVO manager = new ProjectMemberVO();
        manager.setProjectNo(projectNo);
        manager.setMemberNo(memberNo);
        manager.setProjectRole(ROLE_MANAGER);
        manager.setProjectMemstatus("Y");
        projectMapper.mergeProjectMember(manager); 
    }
    
    // 미니헤더 (생성/수정 공통)
    // 미니헤더: 1. 요약 분석, 2. 업무, 3. 진행현황, 4. 일정, 5. 자료실, 6. 게시판, 7. 구성원, 8. 회의실 얘약 (26.01.21)
    private void processMiniHeader(int projectNo, ProjectMiniHeaderVO miniHeader) {
        if (miniHeader == null) return;

        miniHeader.setProjectNo(projectNo);
        
        if (miniHeader.getFixTab() == null || miniHeader.getFixTab().isEmpty()) {
             miniHeader.setFixTab("1,2,3,4,5,6,7,8");
        }
        
        projectMapper.updateMiniHeader(miniHeader);
    }
    
    // 구성원 (삭제 + 추가/수정 공통)
    private void processProjectMember(int projectNo, ProjectVO projectVO, List<String> failedList, boolean isUpdateMode) {
        
        // [수정 모드] 제외된 멤버 비활성화 처리
        if (isUpdateMode) {
            List<String> incomingEmails = new ArrayList<>();
            if (projectVO.getMemberList() != null) projectVO.getMemberList().forEach(m -> incomingEmails.add(m.getMemberEmail()));
            if (projectVO.getClientList() != null) projectVO.getClientList().forEach(m -> incomingEmails.add(m.getMemberEmail()));
            
            Map<String, Object> deactivateParams = new HashMap<>();
            deactivateParams.put("projectNo", projectNo);
            deactivateParams.put("emailList", incomingEmails);	// 유지할 이메일 목록
            
            projectMapper.deactivateProjectMember(deactivateParams); // 목록에 없는 사용자의 상태를 N으로 변경
        }
        
        int inviterNo = projectVO.getMemberNo();

        // 프로젝트 참여자 및 기업 담당자 등록/동기화
        collectMemberAndNotify(projectNo, projectVO.getMemberList(), ROLE_MEMBER, projectVO.getProjectName(), failedList, inviterNo);
        collectMemberAndNotify(projectNo, projectVO.getClientList(), ROLE_CLIENT, projectVO.getProjectName(), failedList, inviterNo);
    }
	
	// 프로젝트 구성원 초대 및 상태 동기화
	private void collectMemberAndNotify(int projectNo, List<ProjectMemberVO> pmList, String role, String projectName,
			List<String> failedList, int inviterNo) {
		if (pmList == null || pmList.isEmpty()) return;
		
		// 모든 이메일 정보 추출 (대량 조회)
		List<String> emailList = pmList.stream().map(ProjectMemberVO::getMemberEmail).toList();
		
		// 모든 회원 정보가 담긴 Map 생성
		List<MemberVO> memberList = projectMapper.getMemberList(emailList);
		Map<String, MemberVO> memberMap = memberList.stream().collect(Collectors.toMap(MemberVO::getMemberEmail, m -> m));
		
		// 현재 프로젝트의 기존 구성원 상태 정보가 담긴 Map 생성
		List<ProjectMemberVO> currentPMList = projectMapper.selectProjectMemberByEmail(projectNo, emailList);
		Map<Integer, ProjectMemberVO> currentPMMap = currentPMList.stream().collect(Collectors.toMap(ProjectMemberVO::getMemberNo, pm -> pm));
		
		List<NotificationVO> notiBatch = new ArrayList<>();
		List<ProjectMemberVO> inviteBatch = new ArrayList<>();
		List<ProjectMemberVO> memberMergeBatch = new ArrayList<>();
		
		for (ProjectMemberVO vo : pmList) {
			String email = vo.getMemberEmail();
			log.info(">>> 초대 프로세스 시작 | Email: {}, Role: {}", vo.getMemberEmail(), vo.getProjectRole());

			// 이메일을 이용해 회원 정보 조회
			MemberVO existMember = memberMap.get(email);

			if (existMember != null) {
				// [기존 회원] 회원이 존재하면 데이터를 세팅
				vo.setProjectNo(projectNo);
				vo.setMemberNo(existMember.getMemberNo());
				vo.setProjectRole(role);

				// DB 조회가 아닌 Map으로 구성원 상태 판별
				ProjectMemberVO currentPM = currentPMMap.get(email);
				boolean sendNotification = false;

				if (currentPM == null) {
					// CASE 1: 처음 초대되는 경우 -> 알림 발송 [상태: P]
					vo.setProjectMemstatus("P");
					sendNotification = true;
				} else {
					// CASE 2: 이미 존재하는 경우 상태 및 역할 확인
					if ("Y".equals(currentPM.getProjectMemstatus())) {
						// 이미 참여중인 경우 -> 역할만 변경해주거나 스킵
						vo.setProjectMemstatus("Y");
						// 프로젝트에 초대돼서 구성원으로 들어간 경우 초대 알림을 끔
						sendNotification = false;
						// 이미 참여중이므로 메일 발송 X
					} else {
						// CASE 3: 과거에 삭제('N')되었다가 다시 추가되는 경우 -> 알림 발송
						// 'N'(삭제됨) 이거나 'P'(이미 초대중인데 재초대)인 경우
						vo.setProjectMemstatus("P");
						// 코드를 새로 갱신해서 다시 전송
						sendNotification = true;
					}
					// CASE 4: 활성 상태이고 역할도 그대로인 경우 -> 알림 미발송 (sendNotification = false)
				}

				// 리스트에 데이터 저장
				memberMergeBatch.add(vo);
				
				// 알림 발송여부 판단 결과(sendMail)에 따라 알림 발송 (시스템 알림/메일)
				if (sendNotification) {
					NotificationVO notiVO = new NotificationVO();
					notiVO.setMemberNo(existMember.getMemberNo());
					notiVO.setNotiType("NOTI_INVITE");
					notiVO.setNotiUrl("/tudio/project/invite/verify?projectNo=" + projectNo);
					notiVO.setTargetId(projectNo);
					notiVO.setNotiMessage("[" + projectName + "]에 초대되었습니다.");
					notiVO.setNotiCategory("프로젝트");

					notiBatch.add(notiVO); // 리스트에 추가
				}
			} else {
				// 비회원 초대를 위한 토큰 생성
				String token = UUID.randomUUID().toString();
					
				// 비회원 초대 정보를 리스트에 추가
				ProjectMemberVO inviteVO = new ProjectMemberVO();
				inviteVO.setInviteToken(token);
				inviteVO.setProjectNo(projectNo);
				inviteVO.setInviterNo(inviterNo);
				inviteVO.setMemberEmail(email);
				inviteVO.setProjectRole(role);

				inviteBatch.add(inviteVO); // 리스트에 추가

				// 초대 메일 발송 메소드 실행
				sendInviteEmail(vo.getMemberEmail(), projectName, projectNo, role, inviterNo, token);
			}
		}
		
		// 배치 쿼리를 사용해 프로젝트 초대와 관련한 모든 정보 조회
		if (!memberMergeBatch.isEmpty()) {
			projectMapper.mergeProjectMemberBatch(memberMergeBatch);	// 프로젝트 구성원 매퍼 호출
		}
		if (!notiBatch.isEmpty()) {
			notiService.insertProjectInviteNotiBatch(notiBatch); 		// 알림 서비스 호출
		}
		if (!inviteBatch.isEmpty()) {
			projectMapper.insertInvitations(inviteBatch);	 			// 초대장 매퍼 호출
		}
	}
	

	@Override
	public ProjectMemberVO getInvitationByToken(String token) {
	    return projectMapper.selectInvitationByToken(token);
	}
	
	
	/**
	 * [비회원] 프로젝트 구성원 초대 메일 발송 메소드 (비동기 처리)
	 * @param email 초대받은 사용자 이메일 
	 * @param projectName 프로젝트명
	 * @param projectNo 프로젝트 일련번호
	 * @param projectRole 프로젝트 구성원 역할
	 * @param inviterNo 초대한 사용자 이메일
	 * @param token 페이지 이동 및 사용자 정보 담은 토큰
	 */
	@Async
    private void sendInviteEmail(String email, String projectName, int projectNo, String projectRole, int inviterNo, String token) {	
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			
			// 인증 링크 [수정필요 : 프로젝트 배포 환경에 맞게 도메인 수정해야 함]
			String signupLink = "http://localhost:8060/tudio/project/invite/check?token=" + token;
			
			String role = projectRole.equals(ROLE_CLIENT) ? "기업 관리자" : "프로젝트 참여자";
			helper.setFrom(EMAIL_ADMIN, "TUDIO 관리자");
			helper.setTo(email);
			helper.setSubject("[TUDIO] " + projectName + " 프로젝트 초대");
				
			// 초대 메일 본문 내용 			
			String content = String.format(
                    "<div style='border:1px solid #ddd; padding:30px; text-align:center; font-family:sans-serif; background-color:#f9f9f9;'>"
                    + "<div style='background:white; padding:20px; border-radius:10px; box-shadow:0 2px 5px rgba(0,0,0,0.05);'>"
                    + "<h2 style='color:#4e73df;'>TUDIO Project Invitation</h2>"
                    + "<p>귀하는 <strong>%s</strong> 프로젝트의 <span style='color:#1cc88a; font-weight:bold;'>%s</span>로 초대되셨습니다.</p>"
                    + "<p style='margin:20px 0;'>아래 버튼을 눌러 회원가입을 완료하면<br>즉시 프로젝트에 참여하실 수 있습니다.</p>"
                    + "<a href='%s' style='display:inline-block; padding:15px 30px; background:#4e73df; color:#fff; text-decoration:none; border-radius:50px; font-weight:bold; font-size:16px;'>초대 수락 및 가입하기</a>"
                    + "<p style='margin-top:30px; color:#aaa; font-size:12px;'>본인이 요청하지 않았다면 이 메일을 무시하세요.<br>링크는 24시간 동안 유효합니다.</p>"
                    + "</div></div>", 
                    projectName, role, signupLink 
            );
						
			helper.setText(content, true);
			mailSender.send(message);
			
			log.info("비회원 초대 메일 발송 성공: " + email);
	    } catch (Exception e) {
	        log.error("비회원 메일 발송 실패: " + email, e);
	    }
	}
    
    /**
     * [비회원] 회원가입 후 즉시 프로젝트 구성원 상태 변경 (P -> Y)
     * - 인증 절차 없이 바로 'Y' 상태로 등록
     */
    @Override
    @Transactional
    public void addProjectMemberDirectly(ProjectMemberVO projectMember) {
        projectMapper.mergeProjectMember(projectMember);       
        // 프로젝트 참여 알림 생성
        createNotification(
        	projectMember.getMemberNo(),
            NOTI_TYPE_INVITE, 
            projectMember.getProjectNo(),
            "/tudio/project/detail?projectNo=" + projectMember.getProjectNo() // 상세 페이지로 바로 이동
        );
        log.info("신규 가입자 프로젝트 자동 참여 완료: MemberNo={}, ProjectNo={}, Role={}", 
        		projectMember.getMemberNo(), projectMember.getProjectNo(), projectMember.getProjectRole());
    }
	   
    /**
     * 프로젝트 참여 수락
     */
    @Override
    @Transactional
	public String confirmProjectParticipation(int projectNo, int memberNo) {
    	Map<String, Object> params = new HashMap<>();
        params.put("projectNo", projectNo);
        params.put("memberNo", memberNo);
        
        ProjectMemberVO member = projectMapper.selectProjectMember(params);
        if (member == null) return "INVALID_MEMBER";
        
        if ("Y".equals(member.getProjectMemstatus())) {
            return "ALREADY_JOINED"; 
        }
        
        // 프로젝트 구성원의 상태가 초대중(P)인 경우 참여 승인
        if ("P".equals(member.getProjectMemstatus())) {
            member.setProjectMemstatus("Y");
            projectMapper.updateProjectMemberStatus(member); 
            return "SUCCESS";
        }
        return "FAIL";
	}

    /**
     * 시스템 알림 DB 저장 메소드
     * @param memberNo 회원번호
     * @param notiType 알림타입
     * @param targetId 알림대상 테이블의 pk
     * @param url
     */
	private void createNotification(int memberNo, String notiType, int targetId, String url) {
		try {
			NotificationVO noti = new NotificationVO();
			noti.setMemberNo(memberNo);
			noti.setNotiType(notiType);
			noti.setTargetId(targetId);
			noti.setNotiUrl(url);
			
			projectMapper.insertNotification(noti);
		} catch (Exception e) {
			log.error("시스템 알림 저장 실패");
		}
	}
	
    /**
	 * 프로젝트 팀원 초대를 위한 사용자 검색 (단건 조회)
	 */
    @Override
	public MemberVO selectMemberByEmail(Map<String, String> params) {
    	return projectMapper.selectMemberByEmail(params);
	}
    	
	/**
	 * 프로젝트 팀원 미 초대시 경고 알림 및 메일 발송
	 */
	@Override
	public void sendWarningNoti(ProjectVO project, int remainDays) {
		try {
			if(project.getAdminEmail() !=  null) {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
				helper.setFrom(EMAIL_ADMIN, "TUDIO 알림");
				helper.setTo(project.getAdminEmail());
				helper.setSubject("[경고] 프로젝트 '" + project.getProjectName() + "' 삭제 조치 예정 알림");
				String content = "<h3>팀원 미구성 경고</h3><p>팀원이 존재하지 않는 프로젝트는 프로젝트 생성일 기준 7일 후에 삭제됩니다</p>";
				content += "<h2 style='color:red;'>삭제까지 " + remainDays + "일 남았습니다</h2>";
				helper.setText(content, true);
				
				mailSender.send(message);
			}			
			// 시스템 알림
			createNotification(
				project.getMemberNo(),
				NOTI_TYPE_WARNING,
				project.getProjectNo(),
				"/tudio/project/modify?projectNo=" + project.getProjectNo()
			);			
		} catch (Exception e) {
			log.error("경고 메일 발송 실패", e);
		}
	}
		
	/**
	 * 프로젝트 자동 삭제 처리에 대한 메일 알림 발송
	 */
	@Override
	public void sendDeleteNoti(ProjectVO project) {
		try {
			if(project.getAdminEmail() != null) {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
				helper.setFrom(EMAIL_ADMIN);
				helper.setTo(project.getAdminEmail());
				helper.setSubject("[삭제] 프로젝트 '" + project.getProjectName() + "' 삭제 조치");
				String content = "<h3>자동 삭제 알림</h3><p>유예 기간(7일) 동안 팀원이 구성되지 않아 삭제되었습니다</p>";		
				helper.setText(content, true);

				mailSender.send(message);
			}			
			// 시스템 알림
			createNotification(
				project.getMemberNo(),
				NOTI_TYPE_DELETE,
				project.getProjectNo(),
				"/tudio/project/list"
			);				
		} catch (Exception e) {
			log.error("삭제 메일 발송 실패", e);
		}
	}
	
	/*
	 * 프로젝트 초대 취소
	 */
	@Override
	@Transactional
	public ServiceResult cancelInvitation(int projectNo, String email) {
	    
	    ProjectMemberVO vo = new ProjectMemberVO();
	    vo.setProjectNo(projectNo);
	    vo.setMemberEmail(email);
	    
	    int result1 = 0;
	    int result2 = 0;
	    
	    // 삭제되면 토큰이 DB에서 사라지므로, 사용자가 링크 클릭 시 유효하지 않은 링크가 뜸
	    result1 = projectMapper.deleteInvitation(vo);
	    
	    // 기존회원 멤버 테이블(PROJECT_MEMBER)에서 대기 상태(P) 삭제
	    // - 이미 가입된 회원을 초대했다가 취소하는 경우
	    result2 = projectMapper.deleteProjectMemberPending(vo);
	    
	    if (result1 > 0 || result2 > 0) {
	        log.info("초대 취소 완료: ProjectNo={}, Email={}", projectNo, email);
	        return ServiceResult.OK;
	    } else {
	        return ServiceResult.FAILED; // 삭제할 대상이 없음 (이미 가입했거나 없는 이메일)
	    }
	}
		
	
	/**
	 * 프로젝트 미니헤더 정보 리스트
	 */
	@Override
    public List<Map<String, Object>> getProjectTabList(ProjectVO project) {
        // 프로젝트 미니헤더 마스터 데이터
        List<Map<String, Object>> masterTabs = getMasterTabs();
        
        List<Integer> savedOrder = new ArrayList<>();
        
        // 저장된 순서 체크
        if(project != null && project.getMiniheader() != null) {
            savedOrder = project.getMiniheader().getTabOrderList();
        }
        
        // 미니헤더 정렬
        List<Map<String, Object>> sortedTabs = new ArrayList<>();

        // 저장된 순서대로 리스트에 추가
        if(savedOrder != null) {
            for (Integer id : savedOrder) {
                for (Map<String, Object> tab : masterTabs) {
                    if ((int)tab.get("id") == id) {
                        tab.put("checked", true);
                        sortedTabs.add(tab);
                        break;
                    }
                }
            }
        }

        // 나머지 추가
        for (Map<String, Object> tab : masterTabs) {
            boolean exists = false;
            for (Map<String, Object> sorted : sortedTabs) {
                if(sorted.get("id").equals(tab.get("id"))) exists = true;
            }
            if(!exists) {
                // 프로젝트가 null(생성 모드)이면 true, 아니면 false
                tab.put("checked", project == null); 
                sortedTabs.add(tab);
            }
        }       
        return sortedTabs;
    }
	
	/**
	 * 미니헤더 마스터 탭
	 * @return list(탭 리스트)
	 */
	private List<Map<String, Object>> getMasterTabs() {
        List<Map<String, Object>> list = new ArrayList<>();
        list.add(createTab(1, "요약·분석 (Statistics)", "bi-pie-chart-fill", "text-secondary", "프로젝트 개요 및 통계 차트"));
        list.add(createTab(2, "업무 (Tasks)", "bi-kanban", "text-primary", "프로젝트 상위/하위업무 (필수)"));
        list.add(createTab(3, "진행현황 (Gantt)", "bi-bar-chart-steps", "text-danger", "간트차트 및 진척도"));
        list.add(createTab(4, "일정 (Schedule)", "bi-calendar-date", "text-success", "캘린더 뷰 제공"));
        list.add(createTab(5, "드라이브 (Files)", "bi-folder-fill", "text-warning", "파일 저장소"));
        list.add(createTab(6, "커뮤니티 (Board)", "bi-card-list", "text-info", "공지 및 자유게시판"));
        list.add(createTab(7, "구성원 (Members)", "bi-people-fill", "text-dark", "프로젝트 전체 구성원 목록"));
        list.add(createTab(8, "회의실 예약 (Meeting)", "bi-door-open", "text-muted", "회의실 예약 서비스"));
        return list;
    }
	
	/**
	 * 프로젝트 미니헤더 탭 생성
	 * @param id 
	 * @param name 탭 이름
	 * @param icon 탭 아이콘
	 * @param color 탭 색상
	 * @param desc 탭 상세설명
	 * @return
	 */
	private Map<String, Object> createTab(int id, String name, String icon, String color, String desc) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("name", name);
        map.put("icon", icon);
        map.put("color", color);
        map.put("desc", desc);
        map.put("checked", false);
        return map;
    }
	
	/**
	 * 프로젝트 접근 권한 체크
	 * - 프로젝트 구성원에 포함되지 않은 다른 사용자의 접근 차단
	 */
	@Override
	public boolean checkProjectAccess(int projectNo, int memberNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("projectNo", projectNo);
	    params.put("memberNo", memberNo);
	    
	    int count = projectMapper.checkProjectAccess(params);
	    return count > 0;
	}
	
	/**
	 * 프로젝트 북마크 설정 정보 조회
	 */
	@Override
	public String selectBookmark(int projectNo, int memberNo) {
		return projectMapper.selectBookmark(projectNo, memberNo);
	}
	
	/**
	 * 프로젝트 북마크 상태 변경
	 */
	@Override
	public String toggleBookmark(int projectNo, int memberNo) {
		projectMapper.toggleBookmark(projectNo, memberNo);			// 상태 변경
		// 사용자 대시보드 북마크 프로젝트 위젯 갱신
	    widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.PROJECT_BOOKMARK);
		return projectMapper.selectBookmark(projectNo, memberNo);	// 변경 된 상태 조회
	}
		
	/**
	 * 프로젝트 상세
	 */
	@Override
	public ProjectVO getProjectDetail(int projectNo) {		
		// 가입 회원 초대 목록
		ProjectVO project = projectMapper.selectProjectDetail(projectNo);
		
		// 비회원 초대 목록
		List<ProjectMemberVO> inviteList = projectMapper.selectProjectInvitationList(projectNo);
		
		if (inviteList != null && !inviteList.isEmpty()) {
	        if (project.getMemberList() == null) {
	            project.setMemberList(new ArrayList<>());
	        }	        
	        // 가입된 멤버 리스트 뒤에 초대 중인 사람들을 추가
	        project.getMemberList().addAll(inviteList);
	    }	    
	    return project;	
	}
	
	/**
	 * 프로젝트 삭제 (논리삭제)
	 */
	@Override
	public int deleteProjectLogically(ProjectVO projectVO) {		
		return projectMapper.deleteProjectLogically(projectVO);
	}	
	
	/**
	 * 프로젝트 완료
	 */
	@Override
    @Transactional
    public int changeProjectStatus(int projectNo, int projectStatus) {
        
        // 미완료된 업무가 0개면 프로젝트 상태 1(완료)로 변경
        projectMapper.updateProjectStatus(projectNo, 1); // 1: 프로젝트 완료
        
        // 완료(1) 처리 요청일 때만 미완료 업무 체크
        if (projectStatus == 1) {
        	// 미완료된 업무 개수 조회 (TASK_STATUS != 203)
            int unfinishedCount = projectMapper.countUnfinishedTask(projectNo);          
            // 미완료 업무가 하나라도 있으면 개수 리턴 (완료 처리 X)
            if (unfinishedCount > 0) {
                return unfinishedCount; // return 미완료 업무 개수 
            }
        }       
        // 그 외(재진행 등)이거나 업무가 모두 완료된 경우
        projectMapper.updateProjectStatus(projectNo, projectStatus);
        
        // 완료(1) 처리 요청인 경우에만 검증 
        if (projectStatus == 1) {
            
            // [1] 참여 중(상태 'Y')인 기업 담당자(CLIENT)가 존재하는지 여부
            Map<String, Object> clientParams = new HashMap<>();
            clientParams.put("projectNo", projectNo);
            clientParams.put("role", ROLE_CLIENT);
            clientParams.put("status", "Y");
            
            int activeClientCount = projectMapper.countActiveProjectMember(clientParams);
            if (activeClientCount == 0) {
                log.warn("프로젝트 완료 실패: 참여 중인 기업 담당자가 없음 (ProjectNo: {})", projectNo);
                return -1; // 기업 담당자 부재 코드
            }

            // [2] 등록된 업무가 존재하는지 여부 (빈 프로젝트 방지)
            int totalTaskCount = projectMapper.countTotalTasks(projectNo);
            if (totalTaskCount == 0) {
                log.warn("프로젝트 완료 실패: 등록된 업무가 없음 (ProjectNo: {})", projectNo);
                return -2; // 업무 미등록 코드
            }

            // [3] 미완료된 업무 개수 조회 (TASK_STATUS != 203)
            int unfinishedCount = projectMapper.countUnfinishedTask(projectNo);
            // 미완료 업무가 하나라도 있으면 개수 리턴 (완료 처리 X)
            if (unfinishedCount > 0) {
                log.warn("프로젝트 완료 실패: 미완료 업무 {}건 존재 (ProjectNo: {})", unfinishedCount, projectNo);
                return unfinishedCount; // 미완료 업무 개수 반환
            }
        }
        
        // 모든 검증 통과 또는 상태 변경(재진행 등) 요청 시 상태 업데이트
        projectMapper.updateProjectStatus(projectNo, projectStatus);
        log.info("프로젝트 상태 변경 완료: ProjectNo={}, Status={}", projectNo, projectStatus);
        
        return 0;
    }
	
	/**
	 * 프로젝트 관리자 권한 위임
	 * - 프로젝트 관리자 -> 프로젝트 참여자
	 * - 프로젝트 참여자 -> 프로젝트 관리자
	 */
	@Override
	@Transactional
	public ServiceResult delegateProjectManager(int projectNo, int currentManagerNo, int newManagerNo) {
	    // [1] 유효성 검사 : 현재 요청자가 해당 프로젝트의 관리자인지 확인
	    ProjectMemberVO currentManager = new ProjectMemberVO();
	    currentManager.setProjectNo(projectNo);
	    currentManager.setMemberNo(currentManagerNo);
	    
	    // [2] 새로운 관리자 승격 (MEMBER -> MANAGER)
	    Map<String, Object> newManagerParam = new HashMap<>();
	    newManagerParam.put("projectNo", projectNo);
	    newManagerParam.put("memberNo", newManagerNo);
	    newManagerParam.put("role", "MANAGER");
	    
	    int result1 = projectMapper.updateProjectRole(newManagerParam);
	    
	    // [3] 기존 관리자 강등 (MANAGER -> MEMBER)
	    Map<String, Object> oldManagerParam = new HashMap<>();
	    oldManagerParam.put("projectNo", projectNo);
	    oldManagerParam.put("memberNo", currentManagerNo);
	    oldManagerParam.put("role", "MEMBER");
	    
	    int result2 = projectMapper.updateProjectRole(oldManagerParam);
	    
	    // [3] 프로젝트 관리자(MEMBER_NO) 변경
	    Map<String, Object> projectParam = new HashMap<>();
	    projectParam.put("projectNo", projectNo);
	    projectParam.put("newManagerNo", newManagerNo);
	    
	    int result3 = projectMapper.updateProjectManager(projectParam);
	    
	    if (result1 > 0 && result2 > 0 && result3 > 0) {
	        return ServiceResult.OK;
	    } else {
	        return ServiceResult.FAILED;
	    }
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 *  프로젝트 목록
	 */
	@Override
	public List<ProjectVO> list(Map<String, Object> countMap) {
		
		List<ProjectVO> list =projectMapper.list(countMap);
		LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));
		
		
		for(ProjectVO p : list) {
			
			LocalDate start = toLocalDate(p.getProjectStartdate());
			LocalDate end = toLocalDate(p.getProjectEnddate());
			
			//-- D-day계산 --//
			if(end != null) {
				long diff = ChronoUnit.DAYS.between(today, end);
				p.setDday((int) diff);
				
				if(diff >0) {
					p.setDdayLabel("D-"+diff);
				}else if(diff ==0) {
					p.setDdayLabel("D-DAY");
				}else {
					p.setDdayLabel("D+"+Math.abs(diff));
				}
							
				//-- 상태 문구. 완료는 날짜로 판단하지 않고 상태 컬럼을 우선으로 본다 --//
				if(p.getProjectStatus()==201) {
					p.setStatusLabel("요청");
				} else if(end != null && diff<0) {
					p.setStatusLabel("지연");
				}else if(p.getProjectStatus()==1) {
					p.setStatusLabel("완료");
				}
				else if(p.getProjectStatus()==2) {
					p.setStatusLabel("보류");
				}else {
					p.setStatusLabel("진행중");
				}
			}
		}
		return list;
	}
	
	// 프로젝트 날짜 계산
	private LocalDate toLocalDate(java.util.Date date) {
		return date == null ? null : date.toInstant().atZone(ZoneId.of("Asia/Seoul")).toLocalDate();
	}	
	
	/**
	 * //  프로젝트 검색 + 갯수 조회
	 */
	@Override
	public int listCount(Map<String, Object> countMap) {	
		return projectMapper.listCount(countMap);
	}

	/**
	 * 프로젝트 리스트 북마크 
	 */
	@Override
	@Transactional
	public String toggleListBookmark(int projectNo, int memberNo) {		
		projectMapper.toggleBookmark(projectNo, memberNo);
		log.info("toggleListBookmark 실행");
		// 사용자 대시보드 북마크 프로젝트 위젯 갱신
	    widgetUpdateService.sendWidgetUpdate(memberNo, WidgetType.PROJECT_BOOKMARK);
		return projectMapper.selectBookmark(projectNo, memberNo);
	}

	@Override
	public List<ProjectInsightVO> selectProjectRateList(int memberNo) {
		return projectMapper.selectProjectRateList(memberNo);
	}
	
}
