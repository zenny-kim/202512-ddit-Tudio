package kr.or.ddit.notice.controller;

import java.io.File;
import java.net.URLEncoder;
import org.springframework.core.io.Resource;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.ServletContext;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.notice.service.INoticeService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;


/**
 * <pre>
 * 사이트 공지사항 사용자 페이지
 * </pre>
 * 
 * 
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/notice")
public class NoticeController {
	
	@Autowired
	private INoticeService noticeService;
	
	@Autowired
	private IFileService fileService;
	
	@Autowired
	private ServletContext servletContext;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	/**
	 * 공지사항 목록 페이지
	 * @param currentPage 현재 페이지
	 * @param searchWord 검색 키워드(제목)
	 * @param model
	 * @return 공지사항 목록 jsp
	 */
	@GetMapping("/list")
	public String noticeList(@RequestParam(name="page", required=false, defaultValue="1") int currentPage,
							 @RequestParam(name="searchWord", required=false) String searchWord,
							 Model model) {
		log.info("noticeList() 실행...!");
		
		PaginationInfoVO<NoticeVO> pagingVO = new PaginationInfoVO<>(10, 5);	// screenSize=10, blockSize=5
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setSearchWord(searchWord);
		
		// 공지사항 목록 조회 및 페이징 처리
		noticeService.retrieveNoticeList(pagingVO);
		model.addAttribute("pagingVO", pagingVO);
		
		return "notice/noticeList";
	}
	
	/**
	 * 공지사항 상세 화면
	 * @param noticeNo 상제 조회할 공지사항 번호
	 * @param model
	 * @return 공지사항 상세화면 jsp
	 */
	@GetMapping("/detail")
	public String noticeDetail(int noticeNo, Model model) {
		log.info("noticeDetail() 실행...!");
		
		// 공지사항 상세정보
		NoticeVO notice = noticeService.selectNoticeDetail(noticeNo);
		model.addAttribute("notice", notice);
			
		// 공지사항 첨부파일
		if(notice.getNoticeFileNo() > 0) {
			List<FileDetailVO> fileList = fileService.selectFileDetailList(notice.getNoticeFileNo());
			model.addAttribute("fileList", fileList);
		}
		
		return "notice/noticeDetail"; 
	}
	

	/**
	 * 공지사항 첨부파일 다운로드
	 * - 다운로드 횟수 증가
	 * @param fileNo 다운로드할 첨부파일 파일번호
	 * @return
	 */
	@GetMapping("/download")
	public ResponseEntity<Resource> fileDownload(@RequestParam("fileNo") int fileNo) {
		try {
			log.info("fileDownload() 실행...!");
			
			// 파일 메타데이터
			FileDetailVO fileDetail = fileService.selectFileDetail(fileNo);
			if (fileDetail == null) {
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}

			// 저장 경로
			String dbFilePath = fileDetail.getFilePath(); 
			File file = null;

			if (dbFilePath != null && dbFilePath.startsWith("/local/")) {
				// 일반 파일은 "/local/" 제거 후 물리 경로(uploadPath)와 결합
				String relativePath = dbFilePath.substring("/local/".length());
				file = new File(uploadPath, relativePath);
			} else {
				String realPath = servletContext.getRealPath(dbFilePath);
				file = new File(realPath);
			}
			
			// debug
			// log.info("DB 파일 경로: {}", dbFilePath);
			// log.info("실제 파일 경로: {}", file.getAbsolutePath());
			// log.info("파일 존재 여부: {}", file.exists());

			if (!file.exists()) {
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}

			noticeService.incrementFileDownloadCnt(fileNo);

			// 헤더 설정 (한글 파일명 처리)
			String originalName = fileDetail.getFileOriginalName();
			String encodedName = URLEncoder.encode(originalName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

			Resource resource = new FileSystemResource(file);
			HttpHeaders headers = new HttpHeaders();
			headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"");
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			headers.setContentLength(file.length());

			return new ResponseEntity<>(resource, headers, HttpStatus.OK);
		} catch (Exception e) {
			log.error("다운로드 에러", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}
