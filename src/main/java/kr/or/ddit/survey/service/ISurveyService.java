package kr.or.ddit.survey.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.survey.SurveyParticipationVO;
import kr.or.ddit.vo.survey.SurveyVO;

public interface ISurveyService {
	
	// ================= 사용자 =================
	
	// 설문 상세 조회
	public SurveyVO getSurveyDetail(int surveyNo, int memberNo);
    
	// 설문 참여 저장 (답변 포함)
	public ServiceResult insertParticipation(SurveyParticipationVO participationVO);

	// 중복 참여 확인
	public boolean checkAlreadyParticipated(int surveyNo, int memberNo);

	
	// ================= 관리자 =================
	
	// 관리자 - 설문 목록 조회
	public List<Map<String, Object>> selectSurveyList();

	// 관리자 - 설문 등록 (질문/보기 포함)
	public ServiceResult insertSurveyAdmin(Map<String, Object> surveyMap);

	// 관리자 - 설문 수정 (질문/보기 재등록)
	public ServiceResult updateSurveyAdmin(Map<String, Object> surveyMap);

	// 관리자 - 설문 결과/통계 조회
	public Map<String, Object> resultSurveyAdmin(int surveyNo);
    
	// 관리자 - 대시보드 통계 데이터 조회 (카드 + 차트)
	public Map<String, Object> getDashboardData();
	
	// 관리자 - 설문 참여자 명단 조회
	public List<Map<String, Object>> selectSurveyParticipants(int surveyNo);
	
}