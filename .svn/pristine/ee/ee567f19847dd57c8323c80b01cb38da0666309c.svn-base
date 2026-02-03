package kr.or.ddit.project.controller;

import java.io.File;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.project.mapper.IProjectMapper;
import kr.or.ddit.project.service.IProjectReportService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;


/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectReportController
 * DESC : 프로젝트 결과보고서 생성 및 다운로드
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.16
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/project")
public class ProjectReportController {
	
	@Autowired
	private IProjectMapper projectMapper;
	
	@Autowired
	private IProjectReportService reportService;
	
	@Autowired
	private IFileService fileService;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	@Value("${tudio.security.secret-key}")
	private String secretKey;
	
	
	/**
	 * 프로젝트 결과보고서 미리보기 화면
	 * @param projectNo
	 * @param model
	 * @return
	 */
    @GetMapping("/report/{projectNo}")
    public String reportPreview(@PathVariable int projectNo, Model model) {
        
        // 프로젝트 상세
        ProjectVO project = projectMapper.selectProjectDetailForReport(projectNo);
        
        // 구성원 목록
        List<MemberVO> memberList = projectMapper.selectProjectMemberListForReport(projectNo);
        
        // 전체 업무 목록 
        List<Map<String, Object>> taskList = projectMapper.selectProjectTaskListForReport(projectNo);
        
        // 일정 준수 통계
        Map<String, Object> complianceStats = projectMapper.selectTaskComplianceStats(projectNo);
        
        // 팀원별 기여도 통계
        List<Map<String, Object>> contributionStats = projectMapper.selectMemberContributionStats(projectNo);

        model.addAttribute("project", project);
        model.addAttribute("memberList", memberList);
        model.addAttribute("taskList", taskList);
        model.addAttribute("complianceStats", complianceStats);
        model.addAttribute("contributionStats", contributionStats);

        return "project/reportForm"; 
    }

    
    /**
     * 결과보고서 PDF 생성 및 메일 발송 요청
     * @param data 결과보고서 데이터
     * @param ra
     * @return
     */
    @PostMapping("/report/send")
    public String sendReport(@RequestParam Map<String, String> data, RedirectAttributes ra) {
        try {
            reportService.generateReportAndSendMail(data);
            ra.addFlashAttribute("message", "결과보고서가 메일로 발송되었습니다.");
        } catch (Exception e) {
            log.error("보고서 발송 실패", e);
            ra.addFlashAttribute("error", "보고서 발송 중 오류가 발생했습니다.");
        }
        
        String projectNo = data.get("projectNo");
        return "redirect:/tudio/project/report/" + projectNo;
    }
    
    /**
     * 프로젝트 결과보고서 PDF 다운로드
     * @param fileNo
     * @param response
     */
    @GetMapping("/report/download")
    public void downloadReport(@RequestParam("fileNo") int fileNo, HttpServletResponse response) {
        try {
            FileDetailVO fileDetail = fileService.selectFileDetail(fileNo);
            if (fileDetail == null) return;

            // 물리 파일 경로 파악 (415 타입은 "projectReport" 폴더)
            File targetFile = new File(uploadPath + File.separator + "projectReport", fileDetail.getFileSaveName());
            
            if (!targetFile.exists()) {
                log.error("파일이 존재하지 않습니다: {}", targetFile.getPath());
                return;
            }

            // 암호화된 파일 읽기 및 복호화
            byte[] encryptedBytes = java.nio.file.Files.readAllBytes(targetFile.toPath());
            byte[] decryptedBytes = decrypt(encryptedBytes);

            // 응답 헤더 설정 (PDF 타입 및 한글 파일명 처리)
            String encodedName = java.net.URLEncoder.encode(fileDetail.getFileOriginalName(), "UTF-8").replaceAll("\\+", "%20");
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\"");
            response.setContentLength(decryptedBytes.length);

            // 스트림 전송
            try (java.io.OutputStream os = response.getOutputStream()) {
                os.write(decryptedBytes);
                os.flush();
            }
        } catch (Exception e) {
            log.error("보고서 다운로드 실패", e);
        }
    }

    /**
     * 프로젝트 결과보고서 복호화
     * @param data
     * @return
     * @throws Exception
     */
    private byte[] decrypt(byte[] data) throws Exception {
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("AES");
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, new javax.crypto.spec.SecretKeySpec(secretKey.getBytes("UTF-8"), "AES"));
        return cipher.doFinal(data);
    }
}
