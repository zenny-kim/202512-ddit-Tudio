package kr.or.ddit.survey.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.survey.SurveyAnswerVO;
import kr.or.ddit.vo.survey.SurveyParticipationVO;
import kr.or.ddit.vo.survey.SurveyVO;


@Mapper
public interface ISurveyMapper {
	
	//설문 조회
	public SurveyVO getSurveyDetail(int surveyNo);
	
	//참여 정보 저장
	public int insertParticipation(SurveyParticipationVO participationVO);
	
	//설문 답변 저장
	public int insertAnswers(List<SurveyAnswerVO> answers);
	
	//중복 참여 확인
	public int checkAlreadyParticipated(SurveyParticipationVO participationVO);

	
	////// 관리자용 //////

	// 관리자 - 설문 목록 조회
	public List<Map<String, Object>> selectSurveyList();

	// 관리자 - 설문 등록
	public int insertSurveyAdmin(Map<String, Object> surveyMap);

	// 관리자 - 설문 수정
	public int updateSurveyAdmin(Map<String, Object> surveyMap);

	// 관리자 - 질문 저장
	public int insertSurveyQuestion(Map<String, Object> questionMap);
	
	// 관리자 - 보기 저장
	public int insertSurveyOption(Map<String, Object> optionMap);
	
	// 관리자 - 기존 질문/보기 삭제
	public int deleteSurveyQuestions(int surveyNo);
	
	
	// ------------ 설문 결과 ------------ 
	//설문 기본 정보 가져오기
	public Map<String, Object> selectSurveyInfo(int surveyNo);

	//설문 통계 데이터 가져오기
	public List<Map<String, Object>> selectSurveyResultRaw(int surveyNo);
	
	// ------------ 통계 ------------ 
	
	//전체 통계
	public Map<String, Object> selectDashboardStats();
	
	//설문 참여 여부 가져오기
	public List<Map<String, Object>> selectSurveyParticipants(int surveyNo);
	
	//한달간 주차별 참여 추이
	public List<Map<String, Object>> selectWeeklyTrend();
	
	
}
