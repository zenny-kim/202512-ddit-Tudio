package kr.or.ddit.admin.siteNotice.controller;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.admin.siteNotice.service.ISiteNoticeService;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PageResult;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@CrossOrigin(origins = "http://localhost:5173")
@RequestMapping("/api/notice")
public class SiteNoticeApiController {
	
	@Autowired
    private jakarta.servlet.ServletContext servletContext;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	@Autowired
	private ISiteNoticeService noticeService;
	
	@Autowired
	private IFileService fileService;
	
	// 공지사항 목록 조회
	@GetMapping("/list")
	public PageResult<NoticeVO> getList(NoticeVO noticeVO){
		log.info("[API] 공지사항 목록 조회 요청 - 페이지 : {}", noticeVO.getCurrentPage());
		
		return noticeService.retrieveNoticeList(noticeVO);
	}
	
	// 공지사항 등록
	@PostMapping("/write")
	public String insert(
	    NoticeVO noticeVO, 
	    @RequestParam(value = "upfiles", required = false) java.util.List<org.springframework.web.multipart.MultipartFile> upfiles
	) {
	    log.info("[API] 공지사항 등록 시도 - 제목: {}", noticeVO.getNoticeTitle());
	    
	    try {
	        // 1. 파일이 있으면 업로드 서비스 호출
	        if (upfiles != null && !upfiles.isEmpty() && !upfiles.get(0).isEmpty()) {
	            // 동료분이 만든 서비스: 파일 저장 후 그룹번호(int) 반환
	            int fileGroupNo = fileService.uploadFiles(upfiles, noticeVO.getMemberNo(), 401);
	            noticeVO.setFileGroupNo(fileGroupNo);
	            log.info("[API] 파일 업로드 성공 - 그룹번호: {}", fileGroupNo);
	        }

	        // 2. 서비스 호출하여 DB 저장 (결과는 "SUCCESS" 또는 "FAIL")
	        String result = noticeService.createNotice(noticeVO);
	        return result;

	    } catch (Exception e) {
	        // 에러가 나면 콘솔에 에러 내용을 아주 자세하게 찍어줍니다.
	        log.error("[API ERROR] 공지사항 등록 중 에러 발생!!!", e);
	        return "FAIL"; 
	    }
	}
	
	// 공지사항 핀 상태 변경
	@PostMapping("/updatePin")
	public String updatePin(@RequestBody NoticeVO noticeVO) {
		return noticeService.modifyPin(noticeVO);
	}
	
	// 공지사항 상세 조회
	@GetMapping("/detail")
	public NoticeVO getDetail(
			@RequestParam int noticeNo, 
			@RequestParam(defaultValue = "0") int memberNo) {
		
		return noticeService.retrieveNotice(noticeNo, memberNo);
	}
	
	// 공지사항 수정
	@PostMapping("/update")
	public String update(NoticeVO noticeVO, @RequestParam(value = "upfiles", required = false) List<org.springframework.web.multipart.MultipartFile> upfiles) {
		
		noticeVO.setModMemberNo(noticeVO.getMemberNo());
		
		log.info("[API] 공지사항 수정 요청 - 번호: {}, 제목: {}, 수정자번호: {}", 
				noticeVO.getNoticeNo(), noticeVO.getNoticeTitle(), (upfiles != null ? upfiles.size() : 0));
		
		return noticeService.modifyNotice(noticeVO, upfiles);
	}
	
	// 공지사항 삭제
	@PostMapping("/delete")
	public String delete(@RequestBody NoticeVO noticeVO) {
		return noticeService.removeNotice(noticeVO.getNoticeNo());
	}
	
	// 공지사항 첨부파일 다운로드
	@GetMapping("/download")
	public ResponseEntity<Resource> downloadFile(@RequestParam int fileNo, Authentication auth){
		
		log.info("[API] 파일 다우로드 요청 - 파일 번호 : ", fileNo);
		
		try {
			// DB에서 파일 정보 조회
			FileDetailVO fileVO = fileService.selectFileDetail(fileNo);
			if(fileVO == null) return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			
			// 물리 경로 결정 
			String dbPath = fileVO.getFilePath();
			String realPath = "";
			
			if(dbPath.startsWith("/local/")) {
				realPath = uploadPath + dbPath.replace("/local/", "");
			}else {
				realPath = servletContext.getRealPath(dbPath);
			}
			
			File file = new File(realPath);
			if(!file.exists()) {
				log.error("[API ERROR] 파일 존재하지 않음 : ", realPath);
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
			
			// 파일 전송 설정
			Resource resource = new FileSystemResource(file);
			String encodedName = URLEncoder.encode(fileVO.getFileOriginalName(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
			
			HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentLength(file.length());
            headers.setContentDispositionFormData("attachment", encodedName);
            
            log.info("[API] 관리자 다운로드 완료 (횟수 미증가)");
            return new ResponseEntity<>(resource, headers, HttpStatus.OK);
			
		}catch (Exception e) {
			log.error("[API ERROR] 다운로드 오류", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}
