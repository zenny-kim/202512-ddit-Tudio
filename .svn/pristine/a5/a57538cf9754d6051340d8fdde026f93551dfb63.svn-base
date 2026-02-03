package kr.or.ddit.member.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.vo.ClientCompanyVO;
import kr.or.ddit.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;



/**
 * <pre>
 * PROJ : Tudio
 * Name : MemberController
 * DESC : 회원가입 화면, 일반/기업 회원가입, 아이디중복확인, 이메일 인증 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2025.12.26
 * 
 */
@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/tudio")
public class MemberController {
	
	private final IMemberService memberService;
	
	// 회원 타입 선택 화면
	@GetMapping("/memberType")
	public String memberType() {
		log.info("memberType() 실행");
		return "member/memberType";
	}
	
	//일반 회원가입 화면
	@GetMapping("/memberSignup")
	public String memberSignupPage() {
		log.info("memberSignupPage() 실행");
		return "member/memberSignup";
	}
	
	//일반 회원가입 기능
	@PostMapping("/memberSignup")
	public String memberSignup(MemberVO memberVO,ClientCompanyVO companyVO, Model model, RedirectAttributes ra) {
		log.info("memberSignup() 실행");
		String goPage ="";
		Map<String, String> errors = new HashMap<>();
		
		//유효성 검사
		if(StringUtils.isBlank(memberVO.getMemberId())) {
			errors.put("memberId", "아이디를 입력해주세요.");
		}
		if(StringUtils.isBlank(memberVO.getMemberPw())) {
			errors.put("memberPw", "비밀번호를 입력해주세요.");
		}
		if(StringUtils.isBlank(memberVO.getMemberName())) {
			errors.put("memberName", "이름을 입력해주세요.");
		}
		if(!memberVO.getMemberPw().equals(memberVO.getMemberPwConfirm())) {
		    errors.put("memberPwConfirm", "비밀번호가 일치하지 않습니다.");
		}
		if(StringUtils.isBlank(memberVO.getMemberTel())) {
	        errors.put("memberTel", "연락처를 입력해주세요.");
	    }
		
		if(errors.size() > 0) {
			log.info("유효성 검사 실패! 원인: " + errors.toString());
			model.addAttribute("errors", errors);
			model.addAttribute("member", memberVO);
			return "member/memberSignup";
		} else {
			ServiceResult result = memberService.signup(memberVO,companyVO);
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "회원가입 성공");
				goPage="redirect:/tudio/login";
			} else {
				model.addAttribute("errors", "다시시도해주세요");
				model.addAttribute("member", memberVO);
				goPage="member/memberSignup";
			}
		}
		return goPage;
	}
	
	//아이디 중복 확인
	@PostMapping("/idCheck")
	public ResponseEntity<ServiceResult> idCheck(@RequestBody Map<String, String> map){
		log.info("idCheck() 실행");
		log.info("id : "+map.get("memberId"));
		ServiceResult result = memberService.idCheck(map.get("memberId"));
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	//이메일 인증 기능
	@PostMapping("/emailAuthCode")
	@ResponseBody
	public String emailAuthCode(@RequestBody Map<String, String> map, HttpSession session) {	
	    String memberEmail = map.get("memberEmail");
	    log.info("전달받은 이메일 주소: {}", memberEmail);
	    String authCode = String.format("%06d", (int)(Math.random() * 1000000));

	    session.setAttribute("emailAuthCode", authCode);
	    session.setMaxInactiveInterval(5 * 60); // 5분 유지

	    try {
	    	memberService.emailAuthCode(memberEmail, authCode);
	        return "SUCCESS";
	    } catch (Exception e) {
	    	log.error("메일 발송 중 에러 발생", e);
	        return "FAIL";
	    }
	}
	
	// 인증번호 확인 컨트롤러
	@PostMapping("/verifyAuthCode")
	@ResponseBody
	public String verifyAuthCode(@RequestBody Map<String, String> map, HttpSession session) {
	    String inputCode = map.get("inputCode");
	    String sessionCode = (String)session.getAttribute("emailAuthCode");
	    log.info("사용자 입력: {}, 세션 저장 번호: {}", inputCode, sessionCode);
	    if (sessionCode != null && sessionCode.equals(inputCode)) {
	        session.removeAttribute("emailAuthCode"); 
	        return "MATCH";
	    } else {
	        return "NOT_MATCH";
	    }
	}
	
	//////////////////////////////// 기업 회원가입 ////////////////////////////////////////
	
	// 기업회원가입 화면
	@GetMapping("/clientSignup")
	public String clientSignupPage() {
		log.info("clientSignupPage() 실행");
		return "member/clientSignup";
	}
	
	// 기업 회원가입 기능
	@PostMapping("/clientSignup")
	public String clientSignup(
		    MemberVO memberVO, ClientCompanyVO companyVO,
		    MultipartFile profileImageFile,MultipartFile bizFile,
		    Model model, RedirectAttributes ra) {
		log.info("clientSignup() 실행 - ID: {}, Company: {}", memberVO.getMemberId(), companyVO.getCompanyName());

		Map<String, String> errors = new HashMap<>();
		if (StringUtils.isBlank(memberVO.getMemberId())) {
			errors.put("memberId", "아이디를 입력해주세요.");
		}
		if (StringUtils.isBlank(memberVO.getMemberPw())) {
			errors.put("memberPw", "비밀번호를 입력해주세요.");
		}
		if (StringUtils.isBlank(memberVO.getMemberName())) {
			errors.put("memberName", "이름을 입력해주세요.");
		}
		if (!memberVO.getMemberPw().equals(memberVO.getMemberPwConfirm())) {
			errors.put("memberPwConfirm", "비밀번호가 일치하지 않습니다.");
		}
		if (StringUtils.isBlank(memberVO.getMemberTel())) {
			errors.put("memberTel", "연락처를 입력해주세요.");
		}
		if (errors.size() > 0) {
			log.info("유효성 검사 실패! 원인: " + errors.toString());
			model.addAttribute("errors", errors);
			model.addAttribute("member", memberVO);
			return "member/clientSignup";
		} else {
			ServiceResult result = memberService.clientSignup(memberVO, companyVO, profileImageFile, bizFile);
			if (result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "기업 회원가입 성공");
				return "redirect:/tudio/login";
			} else {
				model.addAttribute("errors", "다시시도해주세요");
				model.addAttribute("member", memberVO);
				return "member/clientSignup";
			}
		}
	}
	
	
}
