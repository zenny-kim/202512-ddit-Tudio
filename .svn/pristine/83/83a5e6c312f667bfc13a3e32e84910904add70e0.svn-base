package kr.or.ddit.chatbot.tool;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

@Component
public class ChatbotTool {
	
	

	@Tool(description = "기안 작성 방법(절차)과 상황에 따른 양식 선택 가이드를 설명합니다.")
	public String getHowToApproval() {
		
		Map<String, Object> guideData = new LinkedHashMap<>();
		
		String steps =  "1. 사이트 사이드바에 있는 [결재] 탭을 클릭합니다. "
					+ "2. [결재 작성] 버튼을 클릭합니다."
					+ "3. 결재선을 지정합니다."
					+ "4. 프로젝트를 선택합니다."
					+ "5. 보안 여부를 선택합니다.(공개/비공개)"
					+ "6. 양식을 선택합니다."
					+ "7. 제목을 작성합니다."
					+ "8. 내부 양식에 맞는 내용을 작성합니다."
					+ "9. 결재 상신 버튼을 클릭합니다.";
		
		guideData.put("작성_절차", steps);
		
		Map<String, String> forms = new LinkedHashMap<>();
        forms.put("1. 자원/인력 투입 요청", "서버, 장비 구매, 라이선스 구입 또는 추가 개발 인력이 필요할 때");
        forms.put("2. 일정변경 요청", "마감 기한 연장, 조기 종료, 마일스톤 변경 등 스케줄 조정 시");
        forms.put("3. 예산조정 요청", "프로젝트 진행 비용이 부족하거나, 남은 예산을 반납/이월할 때");
        forms.put("4. 검수 및 보고", "중간 산출물 컨펌, 주간/월간 보고 시");
        forms.put("5. 최종 완료 보고", "프로젝트 종료 후 결과물 제출 시");
        forms.put("6. 기타 요청", "위의 사유에 해당하지 않는 일반적인 요청 (회식비 등)");
        
        guideData.put("양식_선택_가이드", forms);
		
		return guideData.toString();
	}
	
	@Tool(description = "사용자가 특정 상황(자원/인력, 일정, 예산, 검수/보고, 완료, 기타)에 대한 기안서 예시를 요청할 때, 상황에 딱 맞는 템플릿 구조를 제공합니다.")
    public String getApprovalExample(
            @ToolParam(description = "사용자가 요청한 기안의 유형 키워드 (예: 'resource', 'schedule', 'budget', 'inspection', 'final', 'other')") String keyword) {
        
        Map<String, String> template = new LinkedHashMap<>();
        String formName = "";

        // AI가 넘겨준 키워드에 따라 다른 템플릿을 조립합니다.
        if (keyword.contains("resource") || keyword.contains("인력") || keyword.contains("자원")) {
            formName = "1. 자원/인력 투입 요청";
            template.put("제목", "프로젝트명과 구체적인 투입 자원(인력/장비) 이름을 합쳐서 작성하세요.");
            template.put("요청 목적", "현재 프로젝트의 문제점(일정 지연, 품질 저하 등)과 자원 투입이 필요한 이유를 논리적으로 서술하세요.");
            template.put("요청 상세", "필요한 인력의 구체적 스펙(연차, 기술 스택)이나 장비의 모델명 및 수량을 명시하세요.");
            template.put("투입 기간",  "YYYY-MM-DD ~ YYYY-MM-DD (총 O개월) 와 같은 형식으로 작성하세요.");
            template.put("기대 효과", "자원 투입 시 얻을 수 있는 정량적/정성적 기대 효과 3가지를 작성하세요.");
            template.put("미투입 시 리스크", "승인되지 않을 경우 발생할 수 있는 구체적인 위험 요소(납기 지연 등)를 경고하세요.");
            template.put("비용 영향", "투입되는 자원에 대한 월 예상 비용과 총 소요 예산을 원화(KRW) 단위로 구체적으로 산출하세요.");

        } else if (keyword.contains("schedule") || keyword.contains("일정")) {
            formName = "2. 일정변경 요청";
            template.put("제목", "프로젝트명과 변경되는 단계(Phase)명을 포함하여 제목을 작성하세요.");
            template.put("변경 사유", "일정이 변경되어야만 하는 불가피한 사유(고객사 요구사항 변경, 기술적 이슈 등)를 상세히 기술하세요.");
            template.put("변경 상세", "기존 계획된 날짜(Start~End)와 변경하려는 날짜(Start~End)를 비교하여 명시하세요.");
            template.put("영향 범위", "이번 일정 변경이 전체 프로젝트 마일스톤이나 타 부서에 미치는 영향을 분석하세요.");
            template.put("대응 방안", "변경된 일정을 준수하기 위한 구체적인 야근 계획이나 인력 재배치 계획을 작성하세요.");

        } else if (keyword.contains("budget") || keyword.contains("예산")) {
            formName = "3. 예산조정 요청";
            template.put("제목", "프로젝트명과 예산 증액/감액/이월 여부를 명시하여 제목을 작성하세요.");
            template.put("조정 사유", "당초 예산 계획과 달라진 원인(물가 상승, 스코프 확대 등)을 상세히 기술하세요.");
            template.put("조정 상세", "기존 예산액, 조정 요청액, 그리고 최종 차액(+/-)을 원화 단위로 명확히 표기하세요.");
            template.put("산출 근거", "조정 요청액이 도출된 근거(견적서, 시장 조사 결과 등)를 언급하세요.");
            template.put("비용 효율화 방안", "추가 예산 집행 시 낭비를 최소화하기 위한 관리 방안을 제시하세요.");

        } else if (keyword.contains("inspection") || keyword.contains("검수") || keyword.contains("보고")) {
            formName = "4. 검수 및 보고";
            template.put("제목", "프로젝트명과 검수 대상 단계(예: 분석/설계/구현)를 포함하여 제목을 작성하세요.");
            template.put("보고 개요", "금번 보고의 대상 기간과 수행한 주요 업무 내용을 요약하여 작성하세요.");
            template.put("산출물 목록", "검수 요청할 산출물 파일명(예: 요구사항정의서_v1.0.hwpx) 목록을 나열하세요.");
            template.put("검수 요청 사항", "검수자가 중점적으로 확인해 주었으면 하는 사항이나 컨펌이 필요한 의사결정 포인트를 적으세요.");
            template.put("특이 사항", "업무 진행 중 발생한 이슈나 리스크 현황을 공유하세요.");

        } else if (keyword.contains("final") || keyword.contains("완료")) {
            formName = "5. 최종 완료 보고";
            template.put("제목", "프로젝트명과 '최종 완료 보고'라는 단어를 포함하여 제목을 작성하세요.");
            template.put("프로젝트 개요", "전체 수행 기간(Start~End)과 총 투입 공수(M/M)를 요약하세요.");
            template.put("완료 산출물", "최종 인도물(소스코드, 매뉴얼, 완료보고서 등) 목록을 작성하세요.");
            template.put("목표 달성도", "착수 시 설정한 KPI 대비 최종 달성 결과를 수치로 비교하여 작성하세요.");
            template.put("유지보수 계획", "프로젝트 종료 후 하자 보수 기간과 지원 범위, 담당자를 명시하세요."); 
            template.put("Lessons Learned", "프로젝트 진행 과정에서 잘된 점(Keep)과 아쉬웠던 점(Problem)을 회고 형태로 작성하세요.");

        } else {
            formName = "6. 기타 요청";
            template.put("제목", "프로젝트명과 요청하려는 핵심 내용을 요약하여 제목을 작성하세요.");
            template.put("요청 사유", "이 기안을 작성하게 된 구체적인 배경과 이유를 육하원칙에 따라 서술하세요.");
            template.put("상세 내용", "요청하고자 하는 내용을 구체적으로 상세하게 기술하세요.");
            template.put("비고", "참고할 만한 관련 문서나 특이사항이 있다면 적으세요.");
        }

        return "다음은 '" + formName + "' 작성을 위한 표준 템플릿 데이터입니다.\n"
	        + "Key는 문서의 목차이고, Value는 당신이 작성해야 할 내용에 대한 지시사항(힌트)입니다.\n"
	        + "이 데이터를 바탕으로 가상의 프로젝트 상황(Tudio 프로젝트)을 설정하여, 기안서 예시를 작성해주세요.\n"
	        + "Value에 있는 힌트 문구는 출력하지 말고, 당신이 창작한 '구체적인 내용'으로 바꿔서 출력해야 합니다.\n"
	        + "데이터: " + template.toString();
    }
	
	@Tool(description = "오늘의 일정(Schedule)과 할 일(To-Do List) 목록을 조회합니다.")
    public String getTodaySchedule() {
        // ============================================================
        // [TODO] 여기에 DB 조회 코드를 작성하세요 (Service 호출 등)
		// 투두리스트 : selectTodoList / 일정은 오늘 날짜의 일정만 가져오는 쿼리 작성해야함
        // 현재 로그인한 사용자의 ID를 세션 등에서 가져와서 조회해야 합니다.
        // ============================================================
        
        // [예시 데이터 반환 - DB 연동 후에는 DB 데이터를 Map이나 JSON 문자열로 만들어 리턴하세요]
        Map<String, String> todayData = new LinkedHashMap<>();
        
        // 예: List<ScheduleVO> schedules = service.getTodaySchedules(userId);
        // 예: List<TodoVO> todos = service.getTodayTodos(userId);
        
        // AI에게 던져줄 데이터 포맷팅
        todayData.put("오늘_날짜", "2026-01-31 (토)");
        todayData.put("일정_목록", "1. 주간 업무 회의 (대회의실), 2. 고객사 미팅");
        todayData.put("할일_목록(TODO)", "1. 결재 상신하기, 2. 프로젝트 코드 리뷰, 3. 회식 장소 예약");
        
        // 데이터가 없는 경우의 처리 예시
        // if (schedules.isEmpty()) todayData.put("일정_목록", "일정이 없습니다.");

        return todayData.toString();
    }
	
}
