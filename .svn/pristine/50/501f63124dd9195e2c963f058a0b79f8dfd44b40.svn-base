package kr.or.ddit.inquiry.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.inquiry.service.IInquiryService;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.InquiryPaginationInfoVO;
import kr.or.ddit.vo.InquiryVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : class
 * DESC : 1:1 문의사항 (사용자) 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KHJ
 * @version 1.0, 2025.12.30
 * 
 */


@Slf4j
@Controller
@RequestMapping("/tudio/inquiry")
public class InquiryController {
	
	@Autowired
	private IInquiryService inquiryService;
	
	@Autowired
	private IMemberService memberService;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@GetMapping("/list")
	public String inquiryList(@RequestParam(name="page", required=false, defaultValue="1") int currentPage, 
			@RequestParam(value="searchStatus", required=false) String searchStatus,
			@RequestParam(value="searchType", required=false) String searchType,
		    @RequestParam(value="searchWord", required=false) String searchWord,
			Principal principal, Model model, HttpSession session){
		
		if (principal == null) {
	        log.warn("인증 정보(Principal) 없음 -> 로그인 페이지로 이동");
	        return "redirect:/tudio/login";
	    }
		
		String memberId = principal.getName();
	    MemberVO member = memberService.findByMemberId(memberId);
		
		if (member == null) {
            return "redirect:/tudio/login";
        }
		
		session.setAttribute("loginUser", member);
		
		int userNo = member.getMemberNo();
		
		InquiryPaginationInfoVO<InquiryVO> pagingVO = new InquiryPaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
        pagingVO.setUserNo(userNo); 
        pagingVO.setSearchStatus(searchStatus);
        pagingVO.setSearchType(searchType); 
        pagingVO.setSearchWord(searchWord);

        int totalRecord = inquiryService.getInquiryCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        // 3. 페이징 데이터 리스트 조회
        List<InquiryVO> inquiryList = inquiryService.getInquiryListByUser(pagingVO);
        pagingVO.setDataList(inquiryList);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("loginUser", member);

		return "inquiry/list";
	}
	
	@GetMapping("/detail/{inquiryNo}")
    public String inquiryDetail(@PathVariable int inquiryNo, Model model) {

		InquiryVO inquiry = inquiryService.getInquiryDetail(inquiryNo);		
		model.addAttribute("inquiry", inquiry);
		
		if(inquiry.getFileGroupNo() != 0) {
	        model.addAttribute("fileList", inquiryService.getFileList(inquiry.getFileGroupNo()));
	    }
        return "inquiry/detail";
    }
	
	@GetMapping("/form")
    public String inquiryForm(@RequestParam(name="inquiryNo", required=false) Integer inquiryNo, Model model) {
		// inquiryNo가 파라미터로 넘어오면 '수정' 모드
	    if (inquiryNo != null) {
	        InquiryVO inquiry = inquiryService.getInquiryDetail(inquiryNo);
	        model.addAttribute("inquiry", inquiry);
	        
	        // 만약 첨부파일 수정도 필요하다면 파일 리스트도 담아줍니다.
	        if(inquiry.getFileGroupNo() != 0) {
	            model.addAttribute("fileList", inquiryService.getFileList(inquiry.getFileGroupNo()));
	        }
	    }
        return "inquiry/form";
    }
	
	@PostMapping("/create")
    public String createInquiry(InquiryVO inquiryVO, @RequestParam(required = false) List<MultipartFile> files, HttpSession session) {
		
		log.info("createInquiry() 실행");
		
		MemberVO member = (MemberVO) session.getAttribute("loginUser");
		
	    if(member == null) {
	    	return "redirect:/tudio/login";
	    }
	    
	    inquiryVO.setUserNo(member.getMemberNo());
	    inquiryService.registerInquiry(inquiryVO, files);

        return "redirect:/tudio/inquiry/list";
    }

    @PostMapping("/update")
    public String updateInquiry(InquiryVO inquiryVO, @RequestParam(required = false) List<MultipartFile> files, HttpSession session) {
    	
    	// 세션 속성명을 list에서 사용한 "memberVO"로 통일하세요!
        MemberVO member = (MemberVO) session.getAttribute("memberVO");
        
        if(member == null) {
            return "redirect:/tudio/login";
        }

        inquiryVO.setUserNo(member.getMemberNo());
        inquiryService.modifyInquiry(inquiryVO, files);

        return "redirect:/tudio/inquiry/detail/" + inquiryVO.getInquiryNo();
    }

    @PostMapping("/delete")
    public String deleteInquiry(@RequestParam int inquiryNo, HttpSession session) {
    	
    	MemberVO member = (MemberVO) session.getAttribute("loginUser");
	    if(member == null) {
	    	log.warn("세션 만료 또는 로그인 정보 없음");
	        return "redirect:/tudio/login"; 
	    }

	    inquiryService.removeInquiryByUser(inquiryNo, member.getMemberNo());
	    return "redirect:/tudio/inquiry/list";
    }
    
    @GetMapping("/download")
    public void download(@RequestParam("fileNo") int fileNo, HttpServletResponse response) {
        try {
            // 1. DB에서 파일 정보 조회
            FileDetailVO fileDetail = inquiryService.getFileDetail(fileNo);
            if (fileDetail == null) return;

            // 2. 경로 계산 (중요!)
            // DB filePath: /upload/inquiry/12/uuid_name.jpg
            // uploadPath: C:/upload/ (또는 설정된 경로)
            // 실제 파일은 C:/upload/inquiry/12/uuid_name.jpg 에 있음
            String dbPath = fileDetail.getFilePath(); 
            String relativePath = dbPath.replace("/upload/", ""); // inquiry/12/uuid_name.jpg
            
            File file = new File(uploadPath, relativePath);

            if (!file.exists()) {
                log.error("파일이 실제 경로에 존재하지 않습니다: " + file.getAbsolutePath());
                return;
            }

            // 3. 파일명 인코딩 및 응답 설정
            String originalName = fileDetail.getFileOriginalName();
            String encodedName = URLEncoder.encode(originalName, "UTF-8").replaceAll("\\+", "%20");

            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
            
            // 4. 전송
            try (InputStream is = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int len;
                while ((len = is.read(buffer)) != -1) {
                    os.write(buffer, 0, len);
                }
            }
        } catch (Exception e) {
            log.error("다운로드 실패", e);
        }
    }
}
