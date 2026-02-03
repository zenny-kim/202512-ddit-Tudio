package kr.or.ddit.admin.siteMember.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.admin.siteMember.service.IAdminMemberService;
import kr.or.ddit.dto.AdminUserDTO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PageResult;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/member")
public class AdminMemberController {
	
	@Autowired
	private IAdminMemberService adminMemberService;
	
	/**
	 * [내 정보 조회]
	 * 관리자 헤더 및 프로필 정보를 가져옵니다.
	 */
	@GetMapping("/me")
	public ResponseEntity<?> getMyInfo(Authentication authentication){
		if (authentication == null || !authentication.isAuthenticated()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}
		
		String memId = authentication.getName();
		log.info("[Controller] 관리자 정보 요청 ID: {}", memId);
		
		AdminUserDTO adminInfo = adminMemberService.getAdminInfo(memId);
		
		if (adminInfo != null) {
			return ResponseEntity.ok(adminInfo);
		} else {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("회원 정보를 찾을 수 없습니다.");
		}
	}
	
	/**
	 * [로그아웃]
	 */
	@PostMapping("/logout")
	public ResponseEntity<?> logout(HttpServletRequest request){
		try {
			request.getSession().invalidate();
			log.info("[Controller] 관리자 로그아웃 처리 완료");
			return ResponseEntity.ok("로그아웃 되었습니다.");
		} catch (Exception e) {
			log.error("로그아웃 중 오류 발생", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	/**
	 * 회원 목록 조회 
	 * 공지사항과 동일한 PageResult 방식을 적용했습니다.
	 */
	@GetMapping("/list")
	public ResponseEntity<PageResult<MemberVO>> getMemberList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "type", defaultValue = "all") String type,
			@RequestParam(value = "keyword", required = false) String keyword) {
		
		log.info("[Controller] 회원 목록 요청 - 페이지: {}, 필터: {}, 키워드: {}", page, type, keyword);
		
		// 1. MemberVO 객체에 검색 및 페이징 파라미터 매핑
		MemberVO memberVO = new MemberVO();
		memberVO.setCurrentPage(page);
		memberVO.setType(type);
		memberVO.setSearchKeyword(keyword);
		
		// 2. 서비스 호출 (PageResult 반환)
		PageResult<MemberVO> result = adminMemberService.selectAdminMemberList(memberVO);
		
		return ResponseEntity.ok(result);
	}

	/**
	 * 회원 영구 삭제
	 * 관리자가 '영구 삭제' 버튼을 클릭했을 때 호출됩니다.
	 */
	@DeleteMapping("/delete/{memberNo}")
	public ResponseEntity<String> deleteMember(@PathVariable("memberNo") int memberNo) {
		log.info("[Controller] 회원 삭제 요청 - 번호: {}", memberNo);
		String result = adminMemberService.removeMember(memberNo);
		return "SUCCESS".equals(result) ? ResponseEntity.ok(result) : ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
	}
	
	/**
	 * 엑셀 일괄 업로드 및 자동 가입
	 */
	@PostMapping("/upload-excel")
    public ResponseEntity<?> uploadExcel(@RequestParam("excelFile") MultipartFile file) {
        try {
            int count = adminMemberService.registerMembersByExcel(file);
            Map<String, Object> response = new HashMap<>();
            response.put("count", count);
            response.put("message", "성공적으로 등록되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("엑셀 업로드 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("파일 처리 중 오류: " + e.getMessage());
        }
    }
	
	/**
	 * 회원 관리 리포트 엑셀 다운로드
	 */
	@GetMapping("/download-excel")
	public void downloadExcel(
	        @RequestParam(value = "type", defaultValue = "all") String type,
	        @RequestParam(value = "keyword", required = false) String keyword,
	        HttpServletResponse response) {
	    try {
	    	log.info("[Controller] 엑셀 다운로드 요청 - 유형: {}, 키워드: {}", type, keyword);
	        adminMemberService.downloadMemberExcel(type, keyword, response);
	    } catch (Exception e) {
	        log.error("엑셀 다운로드 중 오류 발생", e);
	    }
	}
	
	/**
	 * 상단 요약 통계 정보 조회
	 * GET /api/member/stats
	 */
	@GetMapping("/stats")
	public ResponseEntity<Map<String, Object>> getMemberStats() {
	    log.info("[Controller] 회원 통계 데이터 요청");
	    Map<String, Object> stats = adminMemberService.getMemberSummaryStats();
	    return ResponseEntity.ok(stats);
	}
	
	/**
     * 회원 상세 정보 조회 API
     * @param memId 조회할 회원의 ID
     */
    @GetMapping("/detail/{memId}")
    public ResponseEntity<AdminUserDTO> getMemberDetail(@PathVariable String memId) {
        log.info("회원 상세 정보 조회 요청 - ID: {}", memId);
        
        // 서비스 호출
        AdminUserDTO memberDetail = adminMemberService.selectMemberDetail(memId);
        
        if (memberDetail != null) {
             // 데이터가 있으면 200 OK와 함께 데이터 전송
            return new ResponseEntity<>(memberDetail, HttpStatus.OK);
        } else {
            // 데이터가 없으면 404 Not Found
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}