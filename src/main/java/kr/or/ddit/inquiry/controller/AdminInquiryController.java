package kr.or.ddit.inquiry.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
 * DESC : 1:1 문의사항 (관리자) 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KHJ
 * @version 1.0, 2025.12.30
 * 
 */

@Slf4j
@CrossOrigin(origins = "http://localhost:5173")
@RestController
@RequestMapping("/api/admin/board/inquiry") // 관리자 전용 경로(/admin/**: 관리자(Admin) 권한이 있는 사람만 허용)
public class AdminInquiryController {

    @Autowired
    private IInquiryService inquiryService;
    
    @Autowired
    private IMemberService memberService;
    
    @Value("${kr.or.ddit.upload.path}")
    private String uploadPath;

    //관리자용 전체 문의 목록 조회
    @GetMapping("/list")
    public InquiryPaginationInfoVO<InquiryVO> adminInquiryList(
            @RequestParam(name="page", required=false, defaultValue="1") int currentPage, 
            @RequestParam(value="searchStatus", required=false) String searchStatus,
            @RequestParam(value="searchType", required=false) String searchType,
		    @RequestParam(value="searchWord", required=false) String searchWord,
		    @RequestParam(value="inquiryType", required=false) String inquiryType,
            Principal principal, Model model, HttpSession session) {
        
        log.info("관리자 문의 목록 조회 실행");
        
        //현재 로그인한 관리자 정보 가져오기
        if (principal != null) {
            String memberId = principal.getName();
            MemberVO memberVO = memberService.findByMemberId(memberId);
            
            session.setAttribute("loginUser", memberVO);
            model.addAttribute("loginUser", memberVO); 
        }
        
        model.addAttribute("isAdmin", true);

        InquiryPaginationInfoVO<InquiryVO> pagingVO = new InquiryPaginationInfoVO<>();
        pagingVO.setSearchStatus(searchStatus);
        
        int totalRecord = inquiryService.getInquiryCountAll(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setSearchType(searchType); 
        pagingVO.setSearchWord(searchWord);
        pagingVO.setInquiryType(inquiryType);

        List<InquiryVO> inquiryList = inquiryService.getInquiryListAll(pagingVO);
        pagingVO.setDataList(inquiryList);
        
        int completedCount = inquiryService.getCompletedCount(pagingVO); 
        pagingVO.setCompletedCount(completedCount);

        model.addAttribute("pagingVO", pagingVO);
        
        return pagingVO; 
    }

    //관리자용 상세 보기
    @GetMapping("/detail/data/{inquiryNo}")
    public Map<String, Object> adminInquiryDetail(@PathVariable int inquiryNo, Principal principal) {
        
    	Map<String, Object> response = new HashMap<>();
        
        InquiryVO inquiry = inquiryService.getInquiryDetail(inquiryNo);
        
        if (inquiry != null && inquiry.getFileGroupNo() > 0) {
        	List<FileDetailVO> fileList = inquiryService.getFileList(inquiry.getFileGroupNo());
            response.put("fileList", fileList);
        }
        
        response.put("post", inquiry);

        if (principal != null) {
            response.put("loginUser", memberService.findByMemberId(principal.getName()));
        }
        
        InquiryPaginationInfoVO<InquiryVO> pagingVO = new InquiryPaginationInfoVO<>();
        int totalRecord = inquiryService.getInquiryCountAll(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        
        int completedCount = inquiryService.getCompletedCount(pagingVO); 
        pagingVO.setCompletedCount(completedCount);
        
        response.put("pagingInfo", pagingVO);
        
        
        return response;
    }

    //답변 등록 처리 (관리자 전용 기능)
    @PostMapping("/reply")
    public String registerReply(InquiryVO inquiryVO, Principal principal) {
    	
    	if (principal != null) {
            MemberVO admin = memberService.findByMemberId(principal.getName());
            inquiryVO.setAdminNo(admin.getMemberNo());
        }
        inquiryService.registerReply(inquiryVO); 
        // 등록 후 성공 파라미터 전달
        return "redirect:/admin/inquiry/detail/" + inquiryVO.getInquiryNo() + "?msg=regSuccess";
    }
    
    // 문의글 전체 삭제 (기존 delete 로직 활용)
    @GetMapping("/delete")
    public String deleteInquiry(@RequestParam int inquiryNo) {
    	inquiryService.deleteInquiryByAdmin(inquiryNo); // 맵퍼의 deleteInquiryByAdmin 호출
    	return "redirect:/admin/inquiry/list?msg=totalDelSuccess";
    }
    
    // 답변 삭제 (수정 대신 삭제 후 재등록 유도)
    @GetMapping("/replyDelete")
    public String deleteReply(@RequestParam int inquiryNo) {
        inquiryService.removeInquiryReply(inquiryNo); 
        // 삭제 후 성공 파라미터 전달
        return "redirect:/admin/inquiry/detail/" + inquiryNo + "?msg=delSuccess";
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