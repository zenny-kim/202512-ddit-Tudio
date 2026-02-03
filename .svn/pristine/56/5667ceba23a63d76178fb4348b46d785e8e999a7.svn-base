package kr.or.ddit.project.service.impl;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.openpdf.text.Chunk;
import org.openpdf.text.Document;
import org.openpdf.text.Element;
import org.openpdf.text.Font;
import org.openpdf.text.Image;
import org.openpdf.text.PageSize;
import org.openpdf.text.Paragraph;
import org.openpdf.text.Phrase;
import org.openpdf.text.pdf.BaseFont;
import org.openpdf.text.pdf.PdfPCell;
import org.openpdf.text.pdf.PdfPTable;
import org.openpdf.text.pdf.PdfWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.mail.internet.MimeMessage;
import kr.or.ddit.drive.mapper.IDriveMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.project.mapper.IProjectMapper;
import kr.or.ddit.project.service.IProjectReportService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectReportServiceImpl implements IProjectReportService {
    
    @Autowired 
    private JavaMailSender mailSender;
    
    @Autowired  
    private IFileService fileService;
    
    @Autowired  
    private IProjectMapper projectMapper;
    
    @Autowired
    private IDriveMapper driveMapper;
    
    @Value("${kr.or.ddit.upload.path}") 
    private String uploadPath;
    
    @Value("${tudio.security.secret-key}") 
    private String secretKey;

    // 헤더 색상
    private static final Color HEADER_BG = new Color(219, 234, 254);
    
    // 관리자 이메일
 	private static final String EMAIL_ADMIN = "sujeong1246@gmail.com";
 	

    @Override
    @Transactional
    public void generateReportAndSendMail(Map<String, String> data) throws Exception {
        
        int projectNo = Integer.parseInt(data.get("projectNo"));
        int pmNo = (data.get("memberNo") != null && !data.get("memberNo").isEmpty()) ? Integer.parseInt(data.get("memberNo")) : 0;
        String pmComment = data.getOrDefault("pmComment", "");
        String progressImgBase64 = data.get("progressChartImage");
        String memberImgBase64 = data.get("memberChartImage");

        ProjectVO project = projectMapper.selectProjectDetailForReport(projectNo);
        List<MemberVO> allMembers = projectMapper.selectProjectMemberListForReport(projectNo);
        List<Map<String, Object>> taskList = projectMapper.selectProjectTaskListForReport(projectNo);

        // 고객사/팀원 분리
        List<MemberVO> clients = new ArrayList<>();
        List<MemberVO> teamMembers = new ArrayList<>();
        for(MemberVO m : allMembers) {
            if("CLIENT".equals(m.getMemberRole())) clients.add(m);
            else teamMembers.add(m);
        }

        // 파일명
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyMMdd"));
        String originalFileName = today + "_" + project.getProjectName().replaceAll(" ", "_") + "_결과보고서.pdf";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // PDF 생성
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4, 30, 30, 30, 30); // 여백 조정
        
        try {
            PdfWriter.getInstance(document, baos);
            document.open();

            BaseFont bf = getBaseFont();
            Font titleFont = new Font(bf, 24, Font.BOLD);
            Font sectionFont = new Font(bf, 11, Font.BOLD);
            Font headerFont = new Font(bf, 10, Font.BOLD);
            Font bodyFont = new Font(bf, 9, Font.NORMAL);
            Font redFont = new Font(bf, 9, Font.BOLD, Color.RED);

            // [TITLE]
            Paragraph docTitle = new Paragraph("프로젝트 결과보고서", titleFont);
            docTitle.setAlignment(Element.ALIGN_CENTER);
            docTitle.setSpacingAfter(25);
            document.add(docTitle);

            // [1. 프로젝트 개요]
            addSectionHeader(document, "프로젝트 개요", sectionFont);
            PdfPTable infoTable = new PdfPTable(4);
            infoTable.setWidthPercentage(100);
            infoTable.setWidths(new float[]{18f, 32f, 18f, 32f});
            
            addCell(infoTable, "프로젝트명", headerFont, true);
            addCell(infoTable, project.getProjectName(), bodyFont, false, Element.ALIGN_LEFT);
            addCell(infoTable, "프로젝트 관리자", headerFont, true);
            addCell(infoTable, project.getPmName(), bodyFont, false, Element.ALIGN_LEFT);
            
            String period = sdf.format(project.getProjectStartdate()) + " ~ " + 
                            (project.getProjectFinishdate() != null ? sdf.format(project.getProjectFinishdate()) : "-");
            addCell(infoTable, "프로젝트 기간", headerFont, true);
            PdfPCell periodCell = new PdfPCell(new Phrase(period, bodyFont));
            periodCell.setColspan(3);
            periodCell.setPadding(6);
            infoTable.addCell(periodCell);
            
            addCell(infoTable, "프로젝트 목적\n(개요)", headerFont, true);
            PdfPCell descCell = new PdfPCell(new Phrase(project.getProjectDesc(), bodyFont));
            descCell.setColspan(3);
            descCell.setPadding(6);
            descCell.setMinimumHeight(60f);
            infoTable.addCell(descCell);
            document.add(infoTable);

            // [2. 고객사]
            addSectionHeader(document, "고객사", sectionFont);
            PdfPTable clientTable = new PdfPTable(4);
            clientTable.setWidthPercentage(100);
            clientTable.setWidths(new float[]{25f, 25f, 25f, 25f});
            addTableHeader(clientTable, new String[]{"기업명", "부서/직책", "성명", "역할"}, headerFont);
            
            if(clients.isEmpty()) {
                PdfPCell emptyCell = new PdfPCell(new Phrase("- 등록된 고객사 정보 없음 -", bodyFont));
                emptyCell.setColspan(4);
                emptyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                emptyCell.setPadding(6);
                clientTable.addCell(emptyCell);
            } else {
                for(MemberVO m : clients) {
                    addCell(clientTable, m.getCompanyName(), bodyFont, false);
                    addCell(clientTable, m.getMemberDepartment() + " / " + m.getMemberPosition(), bodyFont, false);
                    addCell(clientTable, m.getMemberName(), bodyFont, false);
                    addCell(clientTable, "기업 담당자", bodyFont, false);
                }
            }
            document.add(clientTable);

            // [프로젝트 구성원 및 역할]
            addSectionHeader(document, "프로젝트 구성원 및 역할", sectionFont);
            PdfPTable teamTable = new PdfPTable(5);
            teamTable.setWidthPercentage(100);
            teamTable.setWidths(new float[]{20f, 20f, 20f, 20f, 40f});
            addTableHeader(teamTable, new String[]{"소속", "부서", "직책", "성명", "역할"}, headerFont);
            
            for(MemberVO m : teamMembers) {
            	addCell(teamTable, m.getCompanyName(), bodyFont, false);
                addCell(teamTable, m.getMemberDepartment(), bodyFont, false);
                addCell(teamTable, m.getMemberPosition(), bodyFont, false);
                addCell(teamTable, m.getMemberName(), bodyFont, false);
                String role = "MANAGER".equals(m.getMemberRole()) ? "프로젝트 관리자" : "프로젝트 참여자";
                addCell(teamTable, role, bodyFont, false);
            }
            document.add(teamTable);

            // [세부 추진 사항] 
            addSectionHeader(document, "세부 추진 사항", sectionFont);
            PdfPTable taskTable = new PdfPTable(5);
            taskTable.setWidthPercentage(100);
            taskTable.setWidths(new float[]{12f, 33f, 10f, 35f, 10f});
            addTableHeader(taskTable, new String[]{"구분", "업무 내용", "담당자", "투입 기간", "상태"}, headerFont);
            
            for (Map<String, Object> task : taskList) {
                addCell(taskTable, (String)task.get("WORK_TYPE"), bodyFont, false);
                String taskTitle = ("단위업무".equals(task.get("WORK_TYPE")) ? "  └ " : "") + task.get("TITLE");
                addCell(taskTable, taskTitle, bodyFont, false, Element.ALIGN_LEFT);
                addCell(taskTable, (String)task.get("ASSIGNEE"), bodyFont, false);
                
                String dateStr = task.get("START_DATE") + " ~ " + task.get("FINISH_DATE");
                addCell(taskTable, dateStr, bodyFont, false);

                String status = "Y".equals(task.get("IS_DELAYED")) ? "지연" : "-";
                addCell(taskTable, status, "Y".equals(task.get("IS_DELAYED")) ? redFont : bodyFont, false);
            }
            document.add(taskTable);

            // [프로젝트 성과 분석]
            addSectionHeader(document, "프로젝트 성과 분석", sectionFont);
            PdfPTable resultTable = new PdfPTable(2);
            resultTable.setWidthPercentage(100);
            resultTable.setWidths(new float[]{50f, 50f});
            addTableHeader(resultTable, new String[]{"프로젝트 실적 (통계)", "차후 진행 시 보완사항 (종합 의견)"}, headerFont);
            
            // 좌측 차트 영역
            PdfPCell chartCell = new PdfPCell();
            chartCell.setPadding(10);
            if (progressImgBase64 != null && !progressImgBase64.isEmpty()) {
                Paragraph p1 = new Paragraph("[업무 일정 준수율]", bodyFont);
                p1.setAlignment(Element.ALIGN_CENTER);
                chartCell.addElement(p1);
                Image img1 = Image.getInstance(Base64.getDecoder().decode(progressImgBase64.split(",")[1]));
                img1.scaleToFit(180, 130);
                img1.setAlignment(Element.ALIGN_CENTER);
                chartCell.addElement(img1);
            }
            if (memberImgBase64 != null && !memberImgBase64.isEmpty()) {
                Paragraph p2 = new Paragraph("\n[팀원별 업무 기여도]", bodyFont);
                p2.setAlignment(Element.ALIGN_CENTER);
                chartCell.addElement(p2);
                Image img2 = Image.getInstance(Base64.getDecoder().decode(memberImgBase64.split(",")[1]));
                img2.scaleToFit(180, 130);
                img2.setAlignment(Element.ALIGN_CENTER);
                chartCell.addElement(img2);
            }
            resultTable.addCell(chartCell);
            
            // 우측 의견 영역
            PdfPCell commentCell = new PdfPCell();
            commentCell.setPadding(10);
            
            Chunk commentChunk = new Chunk(pmComment, bodyFont);
            commentChunk.setCharacterSpacing(1.0f); // 자간 조정
            
            Paragraph commentPara = new Paragraph(commentChunk);
            commentPara.setLeading(0, 1.8f); // 줄간격(행간) 조정
            commentCell.addElement(commentPara); 
            commentCell.setVerticalAlignment(Element.ALIGN_TOP);
            commentCell.setMinimumHeight(150f);
            
            resultTable.addCell(commentCell);
            document.add(resultTable);
            
        } catch (Exception e) {
            log.error("PDF 생성 오류", e);
            throw e;
        } finally {
            if(document.isOpen()) document.close();
        }

        // 결과보고서 암호화/저장/발송 로직 
        byte[] pdfBytes = baos.toByteArray();
        byte[] encryptedBytes = encrypt(pdfBytes);
        
        // 파일 업로드
        String webPath = fileService.fileUpload(originalFileName, encryptedBytes, pmNo, 415);
        log.info("보고서 업로드 완료 - webPath: {}", webPath);
        
        if (webPath != null && !webPath.isEmpty()) {
        	Map<String, Object> updateParam = new HashMap<>();
            updateParam.put("projectNo", projectNo);
            updateParam.put("pmNo", pmNo);
                       
            int row = projectMapper.updateProjectFileGroupNo(updateParam);
            log.info("프로젝트 파일 그룹 번호 업데이트 실행 결과: {}건 (ProjectNo: {})", row, projectNo);
        } else {
            log.error("업로드된 webPath가 유효하지 않아 업데이트를 스킵합니다.");
        }
        
        try {
        	if (webPath == null) return;
        	String savedFileName = webPath.substring(webPath.lastIndexOf("/") + 1);
        	// String physicalPath = uploadPath + File.separator + "projectReport" + File.separator + savedFileName;
        	
        	File folder = new File(uploadPath, "projectReport");
            File file = new File(folder, savedFileName);
            
            String physicalPath = file.getAbsolutePath();
            
            log.info("메일 첨부파일 탐색 경로: {}", physicalPath);
            
            // 파일 존재 여부 확인
            if (!file.exists()) {
                log.error(">>> [치명적 에러] 파일을 찾을 수 없습니다! <<<");
                log.error(">>> 설정된 uploadPath: {}", uploadPath);
                log.error(">>> 실제 찾는 경로: {}", physicalPath);
                log.error(">>> 폴더 존재 여부: {}", folder.exists());
                return; // 파일이 없으면 메일을 못 보내므로 메일 전송 중단
            }
            
            // 메일 수신자 조회
            List<MemberVO> recList = projectMapper.selectProjectMemberListForReport(projectNo);
            String[] recipients = recList.stream().map(MemberVO::getMemberEmail)
            									  .filter(e->e!=null && !e.isEmpty())
            									  .toArray(String[]::new);
            if (recipients.length > 0) {
            	log.info("메일 발송 시작 (수신자: {}명)", recipients.length);
            	sendEmailWithDecryptedAttachment(physicalPath, originalFileName, recipients, project.getPmName());
            } else {
                log.warn("메일 수신자가 없어 발송 중단");
            }
        	
        } catch (Exception e) {
        	log.error("메일 발송 준비 중 오류 발생", e);
        }   
    }

    private BaseFont getBaseFont() throws Exception {
        String fontPath = "C:/Windows/Fonts/malgun.ttf";
        if(!new File(fontPath).exists()) return BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.EMBEDDED);
        return BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
    }

    private void addSectionHeader(Document doc, String title, Font font) throws Exception {
        Paragraph p = new Paragraph("■ " + title, font);
        p.setSpacingBefore(15);
        p.setSpacingAfter(5);
        doc.add(p);
    }
    
    private void addTableHeader(PdfPTable table, String[] headers, Font font) {
        for (String h : headers) {
            addCell(table, h, font, true, Element.ALIGN_CENTER);
        }
    }
    
    private void addCell(PdfPTable table, String text, Font font, boolean isHeader) {
        addCell(table, text, font, isHeader, Element.ALIGN_CENTER);
    }

    private void addCell(PdfPTable table, String text, Font font, boolean isHeader, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(6);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        if(isHeader) {
            cell.setBackgroundColor(HEADER_BG); 
        }
        table.addCell(cell);
    }
    
    /**
     * 결과보고서 암호화 및 메일 발송
     * @param data
     * @return
     * @throws Exception
     */
    private byte[] encrypt(byte[] data) throws Exception {
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "AES"));
        return cipher.doFinal(data);
    }
    
    private void sendEmailWithDecryptedAttachment(String filePath, String fileName, String[] recipients, String pmName) {
        try {
            File file = new File(filePath);
            FileInputStream fis = new FileInputStream(file);
            byte[] fileContent = new byte[(int) file.length()];
            fis.read(fileContent); fis.close();

            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "AES"));
            byte[] decrypted = cipher.doFinal(fileContent);

            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper h = new MimeMessageHelper(msg, true, "UTF-8");
            
            h.setFrom(EMAIL_ADMIN);
            h.setTo(recipients);
            h.setSubject("[Tudio] 프로젝트 결과보고서: " + fileName.replace(".pdf", ""));
            h.setText("<h3>프로젝트 결과보고서입니다.</h3><p>첨부파일을 확인해주세요.</p>", true);
            h.addAttachment(fileName, new ByteArrayResource(decrypted));
            mailSender.send(msg);
            
            log.info(">>> 메일 전송 성공! (파일명: {})", fileName);
        } catch (Exception e) { 
        	log.error(">>> [메일 전송 실패] 에러 메시지: {}", e.getMessage());
            log.error(">>> 에러 상세:", e);
        }
    }
}