package kr.or.ddit.admin.faq.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.api.client.util.Value;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.admin.faq.service.IFaqService;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.member.service.impl.UserDetailServiceImpl;
import kr.or.ddit.vo.FaqVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : FaqApiController
 * DESC : FAQ 컨트롤러 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KJS
 * @version 1.0, 2026.01.14
 * 
 */
@Slf4j
@RestController
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequestMapping("/api/faq")
public class FaqApiController {

    private final UserDetailServiceImpl userDetailServiceImpl;

	@Autowired
	private IFaqService faqService;
	
	@Autowired
	private IFileService fileService;
    
	// 반복되는 리터럴 문자열을 final 변수로 만듦
	private static final String LOGIN_USER = "loginUser";

    FaqApiController(UserDetailServiceImpl userDetailServiceImpl) {
        this.userDetailServiceImpl = userDetailServiceImpl;
    }
	
    /**
     * 전체 FAQ 목록 출력
     * @return 전체 FaqVO 리스트
     */
	@GetMapping("/list")
	public List<FaqVO> faqList() {
		return faqService.selectFaqList();
	}
	
	/**
	 * 새 FAQ 생성
	 * @param faqVo 
	 * @param session
	 * @return 성공/실패 여부
	 */
	@PostMapping("/write")
	public ServiceResult writeFaq(@ModelAttribute FaqVO faqVo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ServiceResult result = ServiceResult.FAILED;
		
		if(loginUser != null) {
			int fileGroupNo = fileService.uploadFiles(faqVo.getFileList(), loginUser.getMemberNo(), 411);
			LocalDateTime now = LocalDateTime.now();
			
			faqVo.setAdminNo(loginUser.getMemberNo());
			faqVo.setFaqRegdate(now);
			faqVo.setFaqUpdate(now);
			faqVo.setFileGroupNo(fileGroupNo);
			result = faqService.insertFaq(faqVo);
		}
		
		return result;
	}
	
	/**
	 * 특정 FAQ 수정
	 * @param faqVo
	 * @param session
	 * @return 성공/실패 여부
	 */
	@PostMapping("/edit")
	public ServiceResult editFaq(@ModelAttribute FaqVO faqVo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ServiceResult result = ServiceResult.FAILED;
		
		if(loginUser != null) {
			// 삭제된 파일이 있다면 삭제
			if(faqVo.getDeleteFileNoList() == null || (!faqVo.getDeleteFileNoList().isEmpty())) {
				for(int fileNo : faqVo.getDeleteFileNoList()) {
					fileService.updateFileDelete(fileNo);
				}
			}
				
			// 새로 추가된 파일 등록
			if(faqVo.getFileList() == null || (!faqVo.getFileList().isEmpty())) {
				fileService.insertFilesToExistingGroup(
						faqVo.getFileList(), loginUser.getMemberNo(), 411, faqVo.getFileGroupNo());
			}
			
			LocalDateTime now = LocalDateTime.now();
			
			faqVo.setAdminNo(loginUser.getMemberNo());
			faqVo.setFaqUpdate(now);
			result = faqService.updateFaq(faqVo);
		}

		return result;
	}
	
	/**
	 * 특정 FAQ에 첨부된 fileDetailVO 리스트 가져오기
	 * @param fileGroupNo
	 * @param session
	 * @return List<FileDetailVO>
	 */
	@GetMapping("/fileList")
	public List<FileDetailVO> loadFaqFiles(
			@RequestParam String fileGroupNo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		List<FileDetailVO> fileDetailList = new ArrayList<>();
		
		if(loginUser != null) {
			fileDetailList = fileService.selectFileDetailList(Integer.parseInt(fileGroupNo));
			log.info(fileDetailList.toString());
		}
		
		return fileDetailList;
	}
	
	/**
	 * FAQ 공개 상태 변경
	 * @param faqVo
	 * @param session
	 * @return 성공/실패 여부
	 */
	@PostMapping("/changeStatus")
	public ServiceResult changePublicStatus(
			@RequestBody FaqVO faqVo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ServiceResult result = ServiceResult.FAILED;
		
		if(loginUser != null) {
			result = faqService.updatePublicStatus(faqVo);
		}
		
		return result;
	}
	
	/**
	 * 특정 FAQ 삭제
	 * @param faqNo
	 * @param session
	 * @return 성공/실패 여부
	 */
	@PostMapping("/delete")
	public ServiceResult deleteFaq(@RequestParam String faqNo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ServiceResult result = ServiceResult.FAILED;
		
		if(loginUser != null ) {
			result = faqService.deleteFaq(Integer.parseInt(faqNo));
		}
		
		return result;
	}

	/**
	 * FAQ 목록 순서 수정
	 * @param faqList
	 * @param session
	 * @return 성공/실패 여부
	 */
	@PostMapping("/changeOrder")
	public ServiceResult changeFaqOrder(@RequestBody List<FaqVO> faqList, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ServiceResult result = ServiceResult.FAILED;
		
		if(loginUser != null ) {
			result = faqService.updateFaqOrder(faqList);
		}
		
		return result;
	}
	
	
}
