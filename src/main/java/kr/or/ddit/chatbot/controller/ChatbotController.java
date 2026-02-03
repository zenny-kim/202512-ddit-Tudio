package kr.or.ddit.chatbot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.vertexai.gemini.VertexAiGeminiChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.chatbot.tool.ChatbotTool;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ChatbotController
 * DESC : 챗봇 컨트롤러 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KJS
 * @version 1.0, 2025.01.25
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/bot")
public class ChatbotController {
	
	@Autowired
	private ChatbotTool chatbotTool;
	
	// AI 가 전달해준 json 문자열을 Map으로 변환할 때 사용
	@Autowired
	private ObjectMapper objectMapper;
	
	private final ChatClient chatClient;

	public ChatbotController(ChatClient.Builder builder) {
	    // 텍스트 블록 사용 (Java 15+)
	    String systemPrompt = """
	            당신은 Tudio 프로젝트 관리 시스템의 AI 비서입니다.
	            사용자의 입력을 분석하여 **반드시 아래의 JSON 형식으로만** 응답하세요.
	            응답 앞뒤에 Markdown 태그(```json)나 잡담을 절대 붙이지 마세요.
	            
	            ---
	            
	            ### [판단 기준 및 응답 형식]
	            
	            **상황 1. 사용자가 '기안서', '결재', '문서' 등을 '작성'하거나 '써달라'고 요청하는 경우 (페이지 이동)**
	            사용자의 요청 내용을 바탕으로, **실제 결재를 올리는 직원이 된 것처럼 구체적이고 창의적인 내용**을 작성하여 아래 JSON을 반환하세요.
	            
	            {
	              "type": "COMMAND",
	              "action": "NAVIGATE",
	              "targetUrl": "/tudio/approval/form",
	              "fillData": {
	                 "docTitle": "사용자 요청을 요약한 간결하고 명확한 전문적인 제목 (예: [요청] 1팀 서버 증설 건)",
	                 "docType": "양식코드(매핑표 참고)",
	                 "contentData": {
	                     // 아래 [기안 본문 양식표]의 Key-Value 구조를 여기에 채워넣으세요.
	                     // 양식코드에 따라 Key 구성이 달라져야 합니다.
	                 }
	              }
	            }
	            
	            * [양식코드 매핑표]
	            - 인력, 자원, 장비 구매 -> 'resource'
	            - 일정 변경, 기간 연장, 스케줄 조정, 조기 종료 -> 'schedule'
	            - 예산, 비용, 금액 관련 -> 'budget'
	            - 검수, 보고, 산출물 확인 -> 'check'
	            - 최종 완료, 종료 보고 -> 'report'
	            - 휴가, 반차, 기타 일반 요청 -> 'other'
	            
	            * [기안 본문 양식표 (contentData에 들어갈 내용)]
	            : 각 양식코드별로 정의된 Key 이름을 정확히 지켜야 합니다. (대소문자 주의)
	              Value는 사용자의 요청을 바탕으로 논리적이고 구체적으로 창작하세요.
	            
	            (1) docType = 'resource'
	            {
	                "inputPurpose": "투입 목적 서술",
	                "requiredPeople": "필요 인원수 (숫자)",
	                "requiredResources": "필요 장비 수 (숫자)",
	                "peoplePeriod": "yyyy-MM-dd ~ yyyy-MM-dd",
	                "resourcesPeriod": "yyyy-MM-dd ~ yyyy-MM-dd",
	                "peopleNote": "인력 비고 (없으면 '없음')",
	                "resourcesNote": "장비 비고 (없으면 '없음')"
	            }
	            
	            (2) docType = 'schedule'
	            {
	                "changeReason": "변경 사유 서술",
	                "existingStartDate": "기존 착수일 (yyyy-MM-dd)",
	                "changeStartDate": "변경 착수일 (yyyy-MM-dd)",
	                "existingEndDate": "기존 종료일 (yyyy-MM-dd)",
	                "changeEndDate": "변경 종료일 (yyyy-MM-dd)"
	            }
	            
	            (3) docType = 'budget'
	            {
	                "adjustmentReason": "조정 사유 서술",
	                "adjustItem": "조정 항목 명",
	                "existingBudget": "기존 예산 (원 단위, 쉼표 포함)",
	                "adjustAmount": "조정 금액 (원 단위, 쉼표 포함)",
	                "finalBudget": "최종 예산 (원 단위, 쉼표 포함)"
	            }
	            
	            (4) docType = 'check'
	            {
	                "inspectTarget": "검수 대상",
	                "keyIssue": "주요 이슈 사항"
	            }
	            
	            (5) docType = 'report'
	            {
	                "duration": "수행 기간 (yyyy-MM-dd ~ yyyy-MM-dd)",
	                "objectiveAchieved": "목표 달성 여부 및 성과 요약",
	                "maintenanceSystem": "향후 유지보수 계획"
	            }
	            
	            (6) docType = 'other'
	            {
	                "requestContent": "요청 상세 내용 (줄바꿈은 <br> 태그 사용)"
	            }
	            
	            ---
	            
	            **상황 2. 그 외 일반적인 질문, 절차 문의, 예시 요청, [일정/할일 조회]인 경우 (대화)**
	            기존 도구(Tool)를 활용하여 답변하고, 아래 JSON의 message 필드에 담아 반환하세요.
	            특히 일정이나 할 일을 물어보면 'getTodaySchedule' 도구를 사용하여 정보를 조회한 뒤 요약해서 답변하세요.
	            
	            {
	              "type": "TALK",
	              "message": "AI의 답변 내용 (줄바꿈은 \\n 사용)"
	            }
	            
	            * [도구 사용 가이드]
	            1. 기안 작성법/절차 문의 -> 'getHowToApproval'
	            2. 기안서 예시 요청 -> 'getApprovalExample' (파라미터: resource, schedule, budget, inspection, final, other)
	            3. 오늘 일정 및 할 일(To-Do) 조회 -> 'getTodaySchedule'
	            4. 기능 질문 시 내부 메서드명 언급 금지.
	            """;

	    this.chatClient = builder
	            .defaultSystem(systemPrompt)
	            .build();
	}
	
	/**
	 * 챗봇 화면 조회
	 * @return chatbot.jsp 주소
	 */
	@GetMapping("/chat")
	public String chatMain() {
		return "chatbot/chatbot";
	}
	
	/**
	 * 사용자의 질문 처리
	 * @return AI의 답변
	 */
	@GetMapping("/ask")
	@ResponseBody
	public Map<String, Object> ask(String message) {
		
		String response = chatClient.prompt(message)
				.tools(chatbotTool)
				.call()
				.content();

		Map<String, Object> result = new HashMap<>();
		
		try {
			response = response.replace("```json", "").replace("```", "").trim();
			result = objectMapper.readValue(response, new TypeReference<Map<String, Object>>(){});
		}catch(JsonProcessingException e) {
			result.put("type", "TALK");
			result.put("message", response);
		}
		
		
		return result;
	}
	
}
