package kr.or.ddit.notification.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.log.service.ILogActionService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : NotificationController
 * DESC : 실시간 알림 컨트롤러 클래스
 *        (알림 목록 조회, 읽음 처리, 삭제)
 * </pre>
 *
 * @author [대덕인재개발원] team1 KMS
 * @version 1.0, 2025.01.09
 */
@Slf4j
@RestController
@RequestMapping("/tudio/noti")
@EnableScheduling
public class NotificationController {

	@Autowired
	private INotificationService notiService;

	@Autowired
	private ILogActionService actionService;

	private int getMemberNo(HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		return loginUser.getMemberNo();
	}

	/**
	 * 알림 목록 조회
	 *
	 * @param tab
	 * @param session
	 * @return
	 */
	@GetMapping("/list")
	public Map<String, Object> notificationList(@RequestParam(defaultValue = "all") String tab, HttpSession session) {
		int memberNo = getMemberNo(session);

		// List<NotificationVO> notiList = notiService.notiList(memberNo, ㅅㅁ);
		List<NotificationVO> notiList = notiService.notiListByTab(memberNo, tab);
		int notiUnreadCount = notiService.notiUnreadCount(memberNo);

		Map<String, Object> res = new HashMap<>();
		res.put("notiList", notiList);
		res.put("notiUnreadCount", notiUnreadCount);

		return res;
	}

	/**
	 * 특정 알림 읽음 처리
	 *
	 * @param notiNo
	 * @param session
	 * @return
	 */
	@PostMapping("/read")
	public Map<String, Object> notificationRead(@RequestParam long notiNo, HttpSession session) {
		int memberNo = getMemberNo(session);

		notiService.notiMarkRead(memberNo, notiNo);

		Map<String, Object> res = new HashMap<>();
		res.put("memberNo", memberNo);

		res.put("notiUnreadCount", notiService.notiUnreadCount(memberNo));

		return res;
	}

	/**
	 * 특정 알림 삭제
	 *
	 * @param notiNo
	 * @param session
	 * @return
	 */
	@PostMapping("/delete")
	public Map<String, Object> notificationDelete(@RequestParam long notiNo, HttpSession session) {
		int memberNo = getMemberNo(session);

		notiService.notiDelete(memberNo, notiNo);

		Map<String, Object> res = new HashMap<>();
		res.put("memberNo", memberNo);

		res.put("notiUnreadCount", notiService.notiUnreadCount(memberNo));

		return res;
	}

	/**
	 * <p>
	 * [알림 위젯] 읽음/안읽음 상태 토글
	 * </p>
	 * 
	 * @date 2026.01.21
	 * @author YHB
	 */
	@PostMapping("/toggle")
	public Map<String, Object> notificationToggle(@RequestBody Map<String, Integer> params, HttpSession session) {

		int memberNo = getMemberNo(session);
		long notiNo = Long.parseLong(String.valueOf(params.get("notiNo")));

		notiService.toggleNotificationRead(memberNo, notiNo);

		Map<String, Object> res = new HashMap<>();
		res.put("status", "SUCCESS");
		res.put("notiUnreadCount", notiService.notiUnreadCount(memberNo)); // 변경된 안읽음 알림 개수

		return res;
	}


	@Scheduled(cron = "0 34 15 * * *", zone = "Asia/Seoul")
	public void deadLineNoti() {
		try {
			notiService.pushScheduleNoti();
		} catch (Exception e) {
			log.error("deadLineNoti failed", e);

		}
	}


    @Scheduled(cron = "0 0 4 * * *",zone = "Asia/Seoul")
    public void deleteOldNoti() {
    	 log.info("🔔 deleteOldNoti scheduler start");
    	    try {
    	        int deleted = notiService.deleteOldNoti();
    	        log.info("🗑 deleted noti count = {}", deleted);
    	    } catch (Exception e) {
    	        log.error("❌ deleteOldNoti failed", e);
    	    }
    
    }  
}