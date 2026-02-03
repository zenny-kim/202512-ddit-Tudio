package kr.or.ddit.survey.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.survey.mapper.ISurveyMapper;
import kr.or.ddit.survey.service.ISurveyService;
import kr.or.ddit.vo.survey.SurveyAnswerVO;
import kr.or.ddit.vo.survey.SurveyParticipationVO;
import kr.or.ddit.vo.survey.SurveyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SurveyServiceImpl implements ISurveyService {
	
	@Autowired
	private ISurveyMapper surveyMapper;
	
	// ================= [사용자 기능] =================

	@Override
	public SurveyVO getSurveyDetail(int surveyNo, int memberNo) {
		SurveyVO surveyVO = surveyMapper.getSurveyDetail(surveyNo);
        // 로그인한 사람(memberNo > 0)이라면, 참여 기록이 있는지 미리 확인
        if (surveyVO != null && memberNo > 0) {
            SurveyParticipationVO checkVO = new SurveyParticipationVO();
            checkVO.setSurveyNo(surveyNo);
            checkVO.setMemberNo(memberNo);
            
            int count = surveyMapper.checkAlreadyParticipated(checkVO);
            if (count > 0) {
                surveyVO.setParticipated(true);
            }
        }
		return surveyVO;
	}

	@Override
	public boolean checkAlreadyParticipated(int surveyNo, int memberNo) {
		SurveyParticipationVO checkVO = new SurveyParticipationVO();
		checkVO.setSurveyNo(surveyNo);
		checkVO.setMemberNo(memberNo);
		return surveyMapper.checkAlreadyParticipated(checkVO) > 0;
	}

	@Override
	@Transactional
	public ServiceResult insertParticipation(SurveyParticipationVO participationVO) {
		// 중복참여 확인
		int count = surveyMapper.checkAlreadyParticipated(participationVO);
		if (count > 0) {
	        return ServiceResult.EXSIST;
	    }
		
		// 참여 정보 저장
		int masterResult = surveyMapper.insertParticipation(participationVO);
		
		if (masterResult > 0) {
			int participationNo = participationVO.getSurveyParticipationNo();
			// VO 안에 있는 answerList에 참여번호 세팅
			if (participationVO.getAnswerList() != null) {
				for (SurveyAnswerVO answerVO : participationVO.getAnswerList()) {
					answerVO.setSurveyParticipationNo(participationNo);
		        }
	            // 상세 답변 일괄 저장
	            int detailResult = surveyMapper.insertAnswers(participationVO.getAnswerList());
	            if (detailResult > 0) {
	                return ServiceResult.OK;
	            }
			}
        }
        return ServiceResult.FAILED;
	}

	// ================= [관리자 기능] =================
	
	// 목록 조회
	@Override
	public List<Map<String, Object>> selectSurveyList() {
		return surveyMapper.selectSurveyList();
	}

	//설문 등록
	@Override
	@Transactional
	public ServiceResult insertSurveyAdmin(Map<String, Object> surveyMap) {
		try {
			surveyMapper.insertSurveyAdmin(surveyMap);
			saveQuestionsAndOptions(surveyMap);
			
			return ServiceResult.OK;
		} catch (Exception e) {
			log.error("설문 등록 에러", e);
			return ServiceResult.FAILED;
		}
	}

	// 설문 수정
	@Override
	@Transactional
	public ServiceResult updateSurveyAdmin(Map<String, Object> surveyMap) {
		try {
			//기본 정보 수정
			int result = surveyMapper.updateSurveyAdmin(surveyMap);
			if (result == 0) return ServiceResult.FAILED;

			//기존 질문/보기 삭제
			int surveyNo = Integer.parseInt(String.valueOf(surveyMap.get("surveyNo")));
			surveyMapper.deleteSurveyQuestions(surveyNo);

			//질문 및 보기 재저장
			saveQuestionsAndOptions(surveyMap);

			return ServiceResult.OK;
		} catch (Exception e) {
			log.error("설문 수정 에러", e);
			return ServiceResult.FAILED;
		}
	}
	
	// 질문과 보기 저장 로직 분리
	@SuppressWarnings("unchecked")
	private void saveQuestionsAndOptions(Map<String, Object> surveyMap) {
		int surveyNo = Integer.parseInt(String.valueOf(surveyMap.get("surveyNo")));
		
		// 프론트엔드에서 보낸 questionList (List<Map>)
		List<Map<String, Object>> questionList = (List<Map<String, Object>>) surveyMap.get("questionList");

		if (questionList != null) {
			for (int i = 0; i < questionList.size(); i++) {
				Map<String, Object> qMap = questionList.get(i);
				qMap.put("surveyNo", surveyNo);
				qMap.put("questionOrder", i + 1);

				// 질문 저장 (selectKey로 questionNo 생성됨)
				surveyMapper.insertSurveyQuestion(qMap);
				
				// 보기(Option) 저장
				List<Map<String, Object>> optionList = (List<Map<String, Object>>) qMap.get("optionList");
				if (optionList != null) {
					for (int j = 0; j < optionList.size(); j++) {
						Map<String, Object> oMap = optionList.get(j);
						oMap.put("questionNo", qMap.get("questionNo")); // 생성된 질문번호 사용
						oMap.put("answerOrder", j + 1);
						surveyMapper.insertSurveyOption(oMap);
					}
				}
			}
		}
	}

	// 상세 결과/통계 조회
	@Override
	public Map<String, Object> resultSurveyAdmin(int surveyNo) {
		Map<String, Object> resultMap = new HashMap<>();

        // 설문 기본 정보 가져오기
        Map<String, Object> info = surveyMapper.selectSurveyInfo(surveyNo);
        resultMap.put("info", info);

        // 통계 데이터 가져오기
        List<Map<String, Object>> rawData = surveyMapper.selectSurveyResultRaw(surveyNo);
        
        // 데이터를 질문별로 묶기
        List<Map<String, Object>> statsList = new ArrayList<>();
        Map<String, Map<String, Object>> questionMap = new LinkedHashMap<>(); // 순서 유지

        for (Map<String, Object> row : rawData) {
            String qNo = String.valueOf(row.get("QUESTION_NO"));
            
            // 질문 생성
            if (!questionMap.containsKey(qNo)) {
                Map<String, Object> qData = new HashMap<>();
                qData.put("QUESTION_NO", row.get("QUESTION_NO"));
                qData.put("QUESTION_CONTENT", row.get("QUESTION_CONTENT"));
                qData.put("TOTAL_VOTES", 0); 
                qData.put("options", new ArrayList<Map<String, Object>>()); 
                
                questionMap.put(qNo, qData);
                statsList.add(qData);
            }
            
            // 보기(Option) 추가
            Map<String, Object> currentQuestion = questionMap.get(qNo);
            @SuppressWarnings("unchecked")
			List<Map<String, Object>> options = (List<Map<String, Object>>) currentQuestion.get("options");
            
            Map<String, Object> option = new HashMap<>();
            option.put("ANSWER_NO", row.get("ANSWER_NO"));
            option.put("ANSWER_CONTENT", row.get("ANSWER_CONTENT"));
            
            // 투표수 처리 (null 체크)
            int voteCount = row.get("VOTE_COUNT") == null ? 0 : Integer.parseInt(String.valueOf(row.get("VOTE_COUNT")));
            option.put("VOTE_COUNT", voteCount);
            
            options.add(option);
            
            // 총 투표수 누적
            int currentTotal = (int) currentQuestion.get("TOTAL_VOTES");
            currentQuestion.put("TOTAL_VOTES", currentTotal + voteCount);
        }

        resultMap.put("stats", statsList);
		return resultMap;
	}

	// 대시보드 통계 조회
	@Override
	public Map<String, Object> getDashboardData() {
		Map<String, Object> resultMap = new HashMap<>();
		
		// 전체 통계 (누적, 오늘, 전체회원)
		Map<String, Object> basicStats = surveyMapper.selectDashboardStats();
		resultMap.put("basic", basicStats);
		
		// 주간 추이 그래프 데이터
		List<Map<String, Object>> weeklyStats = surveyMapper.selectWeeklyTrend();
		resultMap.put("weekly", weeklyStats);
		
		return resultMap;
	}

	// 참여자 명단 조회
	@Override
	public List<Map<String, Object>> selectSurveyParticipants(int surveyNo) {
		return surveyMapper.selectSurveyParticipants(surveyNo);
	}

}