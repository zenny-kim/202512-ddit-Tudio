package kr.or.ddit.dashboard.controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.or.ddit.dashboard.service.ITodoService;
import kr.or.ddit.dashboard.service.IWidgetService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.TodoVO;
import kr.or.ddit.vo.WidgetVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import kr.or.ddit.vo.project.ProjectVO;
import kr.or.ddit.vo.survey.SurveyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/tudio/dashboard")
public class WidgetController {
	
	@Autowired
	private IWidgetService widgetService;
	
	@Autowired
	private ITodoService todoService;
	
	/**
	 * [레이아웃] 위젯 목록 및 배치 정보 조회
	 * @param memberNo
	 * @return
	 */
    @GetMapping("/layout")
    public ResponseEntity<List<WidgetVO>> getWidgetLayout(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
        if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); 		// 401

        log.info("getWidgetLayout 실행 : memberNo={}", loginMember.getMemberNo());
     
        List<WidgetVO> list = widgetService.selectWidgetList(loginMember.getMemberNo());
        return ResponseEntity.ok(list);
    }

    /**
     * [레이아웃] 위젯 위치 및 크기 저장
     * @param widgetList 위젯 목록
     * @param memberNo 회원 번호
     * @return
     */
    @PostMapping("/layout/save")
    public ResponseEntity<String> saveWidgetLayout(@RequestBody List<WidgetVO> widgetList, 
    											   @SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {            
        if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
        
        if (widgetList == null || widgetList.isEmpty()) {
            return new ResponseEntity<>("EMPTY_LIST", HttpStatus.BAD_REQUEST);
        }

        log.info("saveWidgetLayout 실행");

        try {
            for(WidgetVO widget : widgetList) {
                widget.setMemberNo(loginMember.getMemberNo());
            }
            widgetService.updateWidgetLayout(widgetList);
            return new ResponseEntity<>("OK", HttpStatus.OK);
        } catch(Exception e) {
            log.error("위젯 저장 실패", e);
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
	
    /**
     * [레이아웃] 위젯 사용 여부 상태 변경 (ON/OFF)
     * @param params
     * @return
     */
    @PostMapping("/widget/status")
    public ResponseEntity<String> updateWidgetStatus(@RequestBody Map<String, Object> params,
    												 @SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {     
        if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
        
        log.info("updateWidgetStatus() 실행...!");
        
        try {        	
            int cnt = widgetService.updateWidgetStatus(params);
            return cnt > 0 ? ResponseEntity.ok("OK") : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("FAIL");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("ERROR");
        }
    }
	
	
    /*
     * ===================================================== [개별 위젯 호출] =====================================================
     */

	/**
	 * [위젯 1] 프로젝트 요약 (마감 임박 업무)
	 * @param memberNo 회원 번호
	 * @return
	 */
    @GetMapping("/deadlineWork")
    public ResponseEntity<List<ProjectTaskVO>> getProjectSummary(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
    	log.info("projectSummary() 실행...!");
        return ResponseEntity.ok(widgetService.selectDeadlineTask(loginMember.getMemberNo()));
    }
	

    /**
     * [위젯 2] 개인 업무 (주간 스케줄)
     * @param memberNo
     * @return
     */
    @GetMapping("/personalWork")
    public ResponseEntity<Map<String, Object>> getPersonalWork(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
    	
    	log.info("getPersonalWork() 실행...!");
    	
    	// 날짜 계산 (이번 주 일요일 ~ 토요일)
        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));

        Map<String, Object> params = new HashMap<>();
        params.put("memberNo", loginMember.getMemberNo());
        params.put("startDate", startOfWeek.toString());
        params.put("endDate", endOfWeek.toString());
        
        List<Map<String, Object>> list = widgetService.selectWeeklyWorkList(params);
        
        // 타이틀용 문자열 (예: 01/11 ~ 01/17)
        String titleRange = String.format("%02d/%02d ~ %02d/%02d",
                				startOfWeek.getMonthValue(), startOfWeek.getDayOfMonth(),
                				endOfWeek.getMonthValue(), endOfWeek.getDayOfMonth());
        
        Map<String, Object> resp = new HashMap<>();
        resp.put("list", list);
        resp.put("titleRange", titleRange);

        return ResponseEntity.ok(resp);
    }
    
    /**
     * [위젯 3] 공지사항
     */
    @GetMapping("/notice")
    public ResponseEntity<List<NoticeVO>> getNoticeList() {
    	log.info("getNoticeList() 실행...!");
        return ResponseEntity.ok(widgetService.getWidgetNoticeList());
    }
	
    
    /**
     * [위젯 4] 알림 위젯 데이터
     * @param loginMember
     * @return stats, list
     */
    @GetMapping("/alarm")
    public ResponseEntity<Map<String, Object>> getAlarmList(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
        if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401

        log.info("getAlarmList() 실행...!");
        
        Map<String, Object> resp = new HashMap<>();
        int memberNo = loginMember.getMemberNo();

        // 전체 / 안읽음 / 읽음 개수
        resp.put("stats", widgetService.selectNotiStats(memberNo));
        // 리스트
        resp.put("list", widgetService.getWidgetNotiList(memberNo));

        return ResponseEntity.ok(resp);
    }
    
    // 알림 상태 변경
    @PostMapping("/alarm/status")
    public ResponseEntity<String> updateAlarmStatus(@RequestBody Map<String, Object> params) {
        widgetService.updateNotificationStatus(params);
        return ResponseEntity.ok("OK");
    }
    
    // 알림 영구 삭제
    @PostMapping("/alarm/delete")
    public ResponseEntity<String> deleteAlarm(@RequestBody Map<String, Integer> params) {
        widgetService.deleteNotification(params.get("notiNo"));
        return ResponseEntity.ok("OK");
    }
    
    /**
     * [위젯 5] 북마크 프로젝트
     * - 내 업무 개수, 기간 경과율 데이터 포함
     */
    @GetMapping("/bookmark/list")
    public ResponseEntity<Map<String, Object>> getBookmarkList(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
        log.info("getBookmarkList() 실행...!");
        
        Map<String, Object> response = new HashMap<>();
        int memberNo = loginMember.getMemberNo();

        // 기업 담당자(ROLE_CLIENT) 여부 체크
        boolean isClient = false;
        if (loginMember.getMemberAuthVOList() != null) {
            isClient = loginMember.getMemberAuthVOList().stream()
                .anyMatch(auth -> "ROLE_CLIENT".equals(auth.getAuth())); 
        }
        
        // 북마크 프로젝트 목록 조회
        List<ProjectVO> projectList = widgetService.getWidgetBookmarkList(memberNo);

        response.put("projectList", projectList);
        response.put("isClient", isClient);

        return ResponseEntity.ok(response);
    }
    
    /**
     * [위젯 6] 투두 리스트 (필터링 기능 추가)
     * - projectNo가 0이면 전체, 값이 있으면 해당 프로젝트만 조회
     */
    @GetMapping("/todo/list")
    public ResponseEntity<List<TodoVO>> getTodoList(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember,
    												@RequestParam(defaultValue = "0") int projectNo) {
    	if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
    	
    	log.info("getTodoList() 실행...!");
    	
        TodoVO vo = new TodoVO();
        vo.setMemberNo(loginMember.getMemberNo());
        vo.setProjectNo(projectNo);
        
        // 동적 쿼리 적용하여 프로젝트 필터링
        return ResponseEntity.ok(todoService.selectTodoList(vo));
    }
    
    /**
     * [위젯 7] 결재 위젯 데이터 
     * - 통계 + 내 기안 목록 + (관리자면) 미승인 목록
     */
    @GetMapping("/approval/data")
    public ResponseEntity<Map<String, Object>> getApprovalData(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
        
        if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
        
        log.info("getApprovalDate() 실행...!");

        Map<String, Object> response = new HashMap<>();
        int memberNo = loginMember.getMemberNo(); 

        // 기업 관리자 체크
        boolean isClient = false;
        if (loginMember.getMemberAuthVOList() != null) {
            isClient = loginMember.getMemberAuthVOList().stream()
                .anyMatch(auth -> "ROLE_CLIENT".equals(auth.getAuth())); 
        }
        
        response.put("isClient", isClient);
        
        // 역할에 따른 조회
        if (isClient) {
            // [결재자] 통계 + 결재 대기 목록
            response.put("stats", widgetService.selectApproverStats(memberNo));
            response.put("toApprove", widgetService.selectToApproveList(memberNo));
            response.put("myDrafts", Collections.emptyList());
        } else {
            // [기안자] 통계 + 내 기안 목록
            response.put("stats", widgetService.selectApprovalStats(memberNo));
            response.put("myDrafts", widgetService.selectMyDraftList(memberNo));
            response.put("toApprove", Collections.emptyList());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // [상단 배너] 미참여 설문
    @GetMapping("/survey/pending")
    public ResponseEntity<List<SurveyVO>> getPendingSurvey(@SessionAttribute(name = "loginUser", required = false) MemberVO loginMember) {
        if (loginMember == null) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);	// 401
        log.info("getPendingServay() 실행...!");
        return ResponseEntity.ok(widgetService.selectPendingSurvey(loginMember.getMemberNo()));
    }

}
