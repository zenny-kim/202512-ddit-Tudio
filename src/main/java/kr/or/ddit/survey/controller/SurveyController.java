package kr.or.ddit.survey.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.survey.service.ISurveyService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.survey.SurveyParticipationVO;
import kr.or.ddit.vo.survey.SurveyVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : SurveyController
 * DESC : 설문조사 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.05
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio/survey")
public class SurveyController {
	
	@Autowired
    private ISurveyService surveyService;
	

//    // 데이터 전송
//    @GetMapping("/detail/{surveyNo}")
//    @ResponseBody
//    public ResponseEntity<SurveyVO> getSurveyDetail(@PathVariable int surveyNo, HttpSession session) {
//	    log.info("getSurveyDetail() START");
//	    log.info("요청받은 설문 번호: {}", surveyNo);
//	    
//	    MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
//        int memberNo = 0;
//
//        if (loginUser != null) {
//            memberNo = loginUser.getMemberNo();
//            log.info("로그인 유저 번호: {}", memberNo);
//        } else {
//            log.warn("로그인 정보 없음 (비회원 조회)");
//        }
//	    
//	    SurveyVO surveyVO = surveyService.getSurveyDetail(surveyNo,memberNo);
//	    if (surveyVO == null) {
//	        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
//	    }
//	    log.info("참여 여부(participated): {}", surveyVO.isParticipated());
//	    log.info("조회된 설문 데이터: {}", surveyVO);
//        return ResponseEntity.ok(surveyVO);
//    }
    
    // 화면 이동 및 데이터 전달
    @GetMapping("/detail/{surveyNo}")
    public String getSurveyDetail(@PathVariable int surveyNo, HttpSession session, Model model) {
        log.info("getSurveyDetail() START");
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        int memberNo = 0;

        if (loginUser != null) {
            memberNo = loginUser.getMemberNo();
        }
        
        // 서비스에서 설문 정보 가져오기
        SurveyVO surveyVO = surveyService.getSurveyDetail(surveyNo, memberNo);
        
        // 설문이 없으면 에러 페이지나 목록으로 리다이렉트 (예시)
        if (surveyVO == null) {
            return "redirect:/error/404"; 
        }
        
        // JSP로 데이터 전달 (React의 setSurveyData와 비슷한 역할)
        model.addAttribute("survey", surveyVO);
        
        log.info("참여 여부: {}", surveyVO.isParticipated());

        // /WEB-INF/views/survey/detail.jsp 를 찾아갑니다.
        return "survey/surveyForm"; 
    }
    
    

    // 설문 저장
    @PostMapping("/submit")
    @ResponseBody
    public ResponseEntity<String> submitSurvey(@RequestBody SurveyParticipationVO participationVO, 
            HttpSession session){
    	//로그인 사용자 memberVO 꺼내기
    	MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
    	//로그인 여부 체크
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        //참여자 세팅
        participationVO.setMemberNo(loginUser.getMemberNo());
        //참여자, 상세답변 저장
        ServiceResult result = surveyService.insertParticipation(participationVO);

        if (result == ServiceResult.EXSIST) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("ALREADY_DONE");		//중복 참여
        } else if (result == ServiceResult.OK) {
            return ResponseEntity.ok("SUCCESS");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("FAIL");
        }
    }

}
