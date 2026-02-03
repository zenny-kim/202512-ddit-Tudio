package kr.or.ddit.drive.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.drive.service.IDriveService;
import kr.or.ddit.vo.DriveFolderFileVO;
import kr.or.ddit.vo.DriveFolderVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : DriveController
 * DESC : 자료실 조회, 폴더 생성, 파일 업로드, 휴지통 이동 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 PSE
 * @version 1.0, 2025.01.03
 * 
 */
@Controller
@Slf4j
@RequestMapping("/tudio")
public class DriveController {
	
	@Autowired
	private IDriveService driveService;
	
	// 반복되는 리터럴 문자열을 final 변수로 만듦
	private static final String LOGIN_USER = "loginUser";
	
	// 저장 경로
	private static final String UPLOAD_DIR = "C:\\tudio\\";
	
	@GetMapping("/project/drive/list")
	public String projectDriveList(
								@RequestParam int projectNo,
								HttpSession session,
								Model model) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		log.info("projectDriveList() 실행~ projectNo={}, loginUser={}", projectNo, loginUser);
		
		Map<String, Object> result = driveService.getDriveList(projectNo, 0);
		model.addAttribute("driveList", result.get("driveList"));
		model.addAttribute("currentFolderId", result.get("currentFolderId"));

		if (loginUser == null) return "redirect:/tudio/login";
		
		return "project/tabs/drive/driveList";
	}
	
	/**
	 * 폴더&파일 목록 API
	 * @param projectNo
	 * @param folderId
	 * @param session
	 * @return
	 */
	@ResponseBody // JSON 반환 선언
	@GetMapping("/project/drive/api/list") // URL 구분 (API 용)
	public ResponseEntity<Map<String, Object>> getDriveListApi(
	        @RequestParam("projectNo") int projectNo,
	        @RequestParam(value = "folderId", defaultValue = "0") int folderId,
	        HttpSession session) {
	    
	    MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
	    
	    if (loginUser == null) {
	        return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); 
	    }

	    Map<String, Object> result = driveService.getDriveList(projectNo, folderId);
	    
	    return new ResponseEntity<>(result, HttpStatus.OK);
	}

	/**
	 * 휴지통 목록 API
	 * @param projectNo
	 * @return
	 */
    @ResponseBody
    @GetMapping("/project/drive/trash")
    public ResponseEntity<Map<String, Object>> getTrashList(@RequestParam int projectNo) {
        Map<String, Object> result = driveService.getTrashList(projectNo);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
	
    /**
     * 상태 변경 API (휴지통/복구/영구삭제)
     * @param params
     * @return
     */
    @ResponseBody
    @PostMapping("/project/drive/action")
    public ResponseEntity<String> driveAction(@RequestBody Map<String, Object> params) {
        String action = (String) params.get("action"); // softDelete, restore, hardDelete
        String type = (String) params.get("type");     // folder, file
        int id = Integer.parseInt(String.valueOf(params.get("id")));

        ServiceResult res = driveService.processDriveItem(action, type, id);
        return res == ServiceResult.OK ? 
               new ResponseEntity<>("SUCCESS", HttpStatus.OK) : 
               new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
    }
	
    /**
     * 새 폴더 생성 API
     * @param driveFolderVO (JSON 데이터: projectNo, folderName, parentFolderNo)
     */
    @ResponseBody
    @PostMapping("/project/drive/api/folder")
    public ResponseEntity<String> insertFolder(@RequestBody DriveFolderVO driveFolderVO, HttpSession session) {
        
        MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
        if (loginUser == null) {
            return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);
        }

        // 로그인한 사용자 번호 세팅 (생성자)
        driveFolderVO.setMemberNo(loginUser.getMemberNo());

        // 서비스 호출
        ServiceResult result = driveService.insertFolder(driveFolderVO);

        if (result.equals(ServiceResult.OK)) {
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * 파일 업로드 API
     * @param files
     * @param projectNo
     * @param folderId
     * @param session
     * @return
     */
    @ResponseBody
    @PostMapping("/project/drive/upload")
    public ResponseEntity<String> uploadFile(
            @RequestParam("files") org.springframework.web.multipart.MultipartFile[] files,
            @RequestParam("projectNo") int projectNo,
            @RequestParam("folderId") int folderId,
            HttpSession session) {
        
        MemberVO user = (MemberVO) session.getAttribute(LOGIN_USER);
        if (user == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);
        
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
        	dir.mkdirs(); // C:\tudio 폴더가 없으면 생성
        }
        
        int targetFolderId = folderId;
        if (targetFolderId == 0) {
            Integer rootId = driveService.getRootFolderId(projectNo);
            if (rootId == null) {
                return new ResponseEntity<>("ROOT_FOLDER_NOT_FOUND", HttpStatus.BAD_REQUEST);
            }
            targetFolderId = rootId;
        }
        
        try {
	        for (org.springframework.web.multipart.MultipartFile mf : files) {
	            DriveFolderFileVO fileVO = new DriveFolderFileVO();
	            fileVO.setFolderNo(folderId);
	            fileVO.setUploaderNo(user.getMemberNo());
	            fileVO.setFileName(mf.getOriginalFilename());
	            fileVO.setDriveFileSize(mf.getSize());
	            fileVO.setDriveFileMime(mf.getContentType());
	            
	            String originalName = mf.getOriginalFilename();
	            // 확장자 추출
	            String ext = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf(".") + 1);
	            fileVO.setDriveFileExtension(ext.toUpperCase());
	            
	            // UUID 저장명 생성
                String saveName = java.util.UUID.randomUUID().toString() + "." + ext;
                fileVO.setDriveFileSaveName(saveName);
                fileVO.setDriveFilePath(UPLOAD_DIR + saveName);
                
                // 실제 파일 물리적 저장 
                java.io.File saveFile = new java.io.File(UPLOAD_DIR, saveName);
                mf.transferTo(saveFile);
	            
                // DB 저장
	            driveService.insertFile(fileVO);
	            
	        }
        } catch (Exception e) {
        	log.error("파일 업로드 실패", e);
            return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
    }
    
    /**
     * 파일 다운로드 처리
     * @param fileNo 파일 PK
     * @param response HTTP 응답 객체
     */
    @GetMapping("/project/drive/download")
    public ResponseEntity<org.springframework.core.io.Resource> downloadFile(@RequestParam int fileNo) throws Exception {
        
        // 1. DB에서 파일 정보 조회 (Service -> Mapper -> DB)
        DriveFolderFileVO fileVO = driveService.getFileInfo(fileNo);
        
        // [체크 1] DB에 해당 파일 정보가 없으면 404 에러
        if (fileVO == null) {
            log.warn("다운로드 실패: DB에 파일 정보 없음 (fileNo={})", fileNo);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // 2. 실제 파일 객체 생성 (저장 경로 + 저장된 파일명)
        // UPLOAD_DIR은 "C:\\tudio\\" 이어야 함
        File file = new File(UPLOAD_DIR, fileVO.getDriveFileSaveName());
        
        // [체크 2] 실제 디스크에 파일이 없으면 404 에러
        if (!file.exists()) {
            log.warn("다운로드 실패: 실제 파일 없음 ({})", file.getAbsolutePath());
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // 3. 리소스 생성 및 리턴
        org.springframework.core.io.InputStreamResource resource = 
                new org.springframework.core.io.InputStreamResource(new java.io.FileInputStream(file));

        // 한글 파일명 인코딩 처리
        String encodedName = java.net.URLEncoder.encode(fileVO.getFileName(), "UTF-8").replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"")
                .contentLength(file.length())
                .contentType(org.springframework.http.MediaType.APPLICATION_OCTET_STREAM)
                .body(resource);
    }
}
