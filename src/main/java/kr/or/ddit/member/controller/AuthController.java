package kr.or.ddit.member.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : AuthController
 * DESC : 로그인, 권한(사용자/사이트관리자)별 메인 페이지, ID,PW 찾기, 마이페이지 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2025.12.26
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio")
public class AuthController {

	@Autowired
	private IMemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;
	
	
	
	// 루트 경로("/")로 접속했을 때 실행
    @GetMapping("/")
    public String home() {
        return "main"; // views/main.jsp 파일을 찾아감
    }

    // /tudio/main 경로로 접속했을 때 실행 (SecurityConfig에 맞춰둠)
    @GetMapping("/main")
    public String mainPage() {
        return "main"; // views/main.jsp 파일을 찾아감
    }
    
    // 이용약관 경로
    @GetMapping("/terms")
    public String terms() {
        return "terms"; // /WEB-INF/views/terms.jsp
    }
    
    //로그인 화면
    @GetMapping("/login")
    public String loginPage() {
		return "login";
    	
    }
	
	//아이디 찾기 화면
	@GetMapping("/findMemberId")
	public String findMemberIdPage() {
	    return "member/findMemberId";
	}

	//아이디 찾기 기능
	@PostMapping("/findMemberId")
	public ResponseEntity<String> findMemberId(@RequestBody MemberVO memberVO){
		log.info("findMemberId() 실행");
		ResponseEntity<String> entity = null;
		String memberId = memberService.findMemberId(memberVO);
		if(memberId != null) {
	        entity = ResponseEntity.ok(memberId);
	    } else {
	    	entity = ResponseEntity.badRequest().build();
	    }
		return entity;
		
	}
	
	//비밀번호 찾기 화면
	@GetMapping("/findMemberPw")
	public String findMemberPwPage() {
	    return "member/findMemberPw";
	}
	
	//비밀번호 찾기 기능
	@PostMapping("/findMemberPw")
	public ResponseEntity<MemberVO> pwForgetProcess(@RequestBody MemberVO memberVO){
		log.info("pwForgetProcess 실행");
		MemberVO resultVO = memberService.findMemberPw(memberVO);
		if(resultVO != null) {
	        return ResponseEntity.ok(resultVO);
	    } else {
	    	return ResponseEntity.badRequest().build();
	    }
	}
	
	//마이페이지 화면
	@GetMapping("/memberMypage")
	public String memberMypage(Principal principal, Model  model) {
	    String memberId = principal.getName();   
	    MemberVO memberVO = memberService.findByMemberId(memberId);
	    
	    model.addAttribute("memberVO", memberVO);
	    return "member/memberMypage"; 
	}
	
	//마이페이지 수정 기능
	@PostMapping("/memberModify")
	public String memberModify(MemberVO memberVO, 
	                           @RequestParam(value="profileImageFile", required=false) MultipartFile profileImageFile,
	                           Principal principal, HttpSession session,
	                           RedirectAttributes ra) {
	    
	    // 1. 현재 로그인 사용자 확인
		if (principal == null) return "redirect:/tudio/login";
	    String loginId = principal.getName();
	    
	    // 2. 세션의 ID를 VO에 넣기
	    MemberVO loginMember = memberService.findByMemberId(loginId);
	    memberVO.setMemberId(loginId);
	    memberVO.setMemberNo(loginMember.getMemberNo());

	    // 3. 서비스 호출
	    try {
	        boolean isSuccess = memberService.memberModify(memberVO, profileImageFile);
	        
	        if (isSuccess) {
	            // 수정한 최신 정보를 다시 조회해서 세션에 덮어쓰기
	            MemberVO updatedMember = memberService.findByMemberId(memberVO.getMemberId());
	            session.setAttribute("memberVO", updatedMember);
	            ra.addFlashAttribute("msg", "회원정보가 수정되었습니다.");
	        } else {
	            ra.addFlashAttribute("msg", "수정에 실패했습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        ra.addFlashAttribute("msg", "오류가 발생했습니다.");
	    }

	    return "redirect:/tudio/memberMypage";
	}
	
	
}
