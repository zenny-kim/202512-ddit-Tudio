package kr.or.ddit.dashboard.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.WidgetType;
import kr.or.ddit.dashboard.service.IWidgetUpdateService;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class WidgetUpdateServiceImpl implements IWidgetUpdateService {
	
	@Autowired
    private SimpMessagingTemplate messagingTemplate;
	
	@Override
    public void sendWidgetUpdate(int memberNo, WidgetType widgetType) {
        String destination = "/sub/dashboard/" + memberNo;

        // 전송할 데이터 설정
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", widgetType.name()); 			
        payload.put("timestamp", System.currentTimeMillis()); 	

        try {
            messagingTemplate.convertAndSend(destination, payload);
            log.info("🔔 위젯 갱신 신호 발송 성공 [Target: {}, Type: {}]", memberNo, widgetType);
        } catch (Exception e) {
            log.error("🚫 위젯 갱신 신호 발송 실패 [Target: {}]", memberNo, e);
        }
    }
	
}
