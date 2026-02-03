package kr.or.ddit.admin.survey.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.survey.service.ISurveyService;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : AdminSurveyController
 * DESC : 설문 관리, 목록, 결과 확인 관리자용 컨트롤러
 * </pre>
 * * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.25
 * */

@Slf4j
@RestController
@RequestMapping("/tudio/admin/survey")
public class AdminSurveyController {

	@Autowired
	private ISurveyService surveyService;
	
	// 관리자 - 설문 목록 조회
	@GetMapping("/list")
	public List<Map<String, Object>> selectSurveyList() {
		log.info("AdminSurveyController - 목록 조회 요청");
		return surveyService.selectSurveyList();
	}
	
	// 관리자 - 설문 등록 (질문/보기 포함)
	@PostMapping("/insert")
	public String insertSurveyAdmin(@RequestBody Map<String, Object> surveyMap) {
		log.info("Admin - 설문 등록 : {}", surveyMap);
		ServiceResult result = surveyService.insertSurveyAdmin(surveyMap);
		return result == ServiceResult.OK ? "SUCCESS" : "FAIL";
	}
	
	// 관리자 - 설문 수정 (기존 질문 삭제 후 재생성)
	@PutMapping("/update")
	public String updateSurveyAdmin(@RequestBody Map<String, Object> surveyMap) {
		log.info("Admin - 설문 수정 : {}", surveyMap);
		ServiceResult result = surveyService.updateSurveyAdmin(surveyMap);
		return result == ServiceResult.OK ? "SUCCESS" : "FAIL";
	}
	
	// 관리자 - 설문 결과/통계 상세 조회
	@GetMapping("/result/{surveyNo}")
	public Map<String, Object> resultSurveyAdmin(@PathVariable int surveyNo) {
		log.info("Admin - 결과 조회 : {}", surveyNo);
		return surveyService.resultSurveyAdmin(surveyNo);
	}
	
	// 관리자 - 대시보드 통계 데이터 조회
	@GetMapping("/dashboard")
	public Map<String, Object> getDashboardStats() {
		log.info("Admin - 대시보드 통계 요청");
		return surveyService.getDashboardData();
	}
	
	// 관리자 - 설문 참여자 명단 조회
	// (참여자 목록 팝업 등에서 사용 가능)
	@GetMapping("/participants/{surveyNo}")
	public List<Map<String, Object>> selectSurveyParticipants(@PathVariable int surveyNo) {
		log.info("Admin - 참여자 명단 조회 : {}", surveyNo);
		return surveyService.selectSurveyParticipants(surveyNo);
	}
}