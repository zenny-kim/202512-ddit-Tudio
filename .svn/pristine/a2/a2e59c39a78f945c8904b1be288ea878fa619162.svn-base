package kr.or.ddit.admin.siteMember.service.impl;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.admin.siteMember.mapper.IAdminMemberMapper;
import kr.or.ddit.admin.siteMember.service.IAdminMemberService;
import kr.or.ddit.dto.AdminUserDTO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PageResult;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminMemberServiceImpl implements IAdminMemberService {
	
	@Autowired
	private IAdminMemberMapper adminMapper;
	
	@Autowired
    private PasswordEncoder passwordEncoder;

	@Override
	public AdminUserDTO getAdminInfo(String memId) {
		return adminMapper.selectAdminMember(memId);
	}

	/**
	 * 전체 회원 수 조회
	 * PaginationInfoVO에 정의된 setTotalRecord를 호출합니다.
	 */
	@Override
	public PageResult<MemberVO> selectAdminMemberList(MemberVO memberVO) {
	    // 1. 전체 레코드 수 조회
	    int totalRecordCount = adminMapper.selectMemberCount(memberVO);
	    
	    // 2. 페이징 계산을 위해 총 개수 세팅
	    memberVO.setTotalRecord(totalRecordCount);
	    
	    // 3. 현재 페이지 다시 세팅 (startRow, endRow 계산)
	    memberVO.setCurrentPage(memberVO.getCurrentPage());

	    // 4. 페이징 번호 보정 (5개 고정 방지)
	    if (memberVO.getEndPage() > memberVO.getTotalPage()) {
	        memberVO.setEndPage(memberVO.getTotalPage());
	    }
	    if (memberVO.getTotalPage() == 0) memberVO.setEndPage(1);

	    List<MemberVO> memberList = null;
	    if(totalRecordCount > 0) {
	        // [수정 포인트] 메서드명을 selectAdminMemberList 로 변경!!
	        memberList = adminMapper.selectAdminMemberList(memberVO);
	    } else {
	        memberList = Collections.emptyList();
	    }
	    
	    return new PageResult<>(memberList, memberVO);
	}

	/**
	 * 회원 영구 삭제
	 */
	@Transactional(rollbackFor = Exception.class)
	@Override
	public String removeMember(int memberNo) {
		int result = adminMapper.deleteMember(memberNo);
		return result > 0 ? "SUCCESS" : "FAIL";
	}

	/**
	 * 엑셀 일괄 등록
	 */
	@Transactional(rollbackFor = Exception.class)
	@Override
	public int registerMembersByExcel(MultipartFile file) throws Exception {
		int totalResult = 0;
		try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
			Sheet sheet = workbook.getSheetAt(0); 
			for (int i = 1; i <= sheet.getLastRowNum(); i++) {
				Row row = sheet.getRow(i);
				if (row == null) continue;
				
				MemberVO member = new MemberVO();
				String memId = getCellValue(row.getCell(0));
				if(memId == null || memId.isEmpty()) continue;
				
				String encryptedPw = passwordEncoder.encode(memId);
				member.setMemberPw(encryptedPw);
				
				String companyNo = getCellValue(row.getCell(5));
				if (companyNo == null || companyNo.trim().isEmpty()) {
					throw new Exception((i + 1) + "행의 업체 번호(사업자 번호)가 누락되었습니다. 필수 항목입니다.");
				}
				
				member.setMemberId(memId);
				member.setMemberName(getCellValue(row.getCell(1)));
				member.setMemberEmail(getCellValue(row.getCell(2)));
				member.setMemberTel(getCellValue(row.getCell(3)));
				member.setMemberRegno(getCellValue(row.getCell(4)));
				member.setCompanyNo(companyNo); 
				member.setMemberDepartment(getCellValue(row.getCell(6)));
				member.setMemberPosition(getCellValue(row.getCell(7)));
				
				String typeFromExcel = getCellValue(row.getCell(8));
				String authRole = "기업".equals(typeFromExcel) ? "ROLE_CLIENT" : "ROLE_MEMBER";
				
				if(adminMapper.insertMember(member) > 0) {
					Map<String, Object> authMap = new HashMap<>();
					authMap.put("memberNo", member.getMemberNo());
					authMap.put("auth", authRole);
					adminMapper.insertMemberAuth(authMap);
					totalResult++;
				}
			}
		}
		return totalResult;
	}

	/**
	 * 회원 관리 리포트 엑셀 다운로드
	 */
	@Override
	public void downloadMemberExcel(String type, String keyword, HttpServletResponse response) throws Exception {
	    // [수정] Map 대신 MemberVO를 사용하여 검색 조건 세팅
	    MemberVO searchVO = new MemberVO();
	    searchVO.setType(type);
	    searchVO.setSearchKeyword(keyword);
	    
	    // 엑셀은 페이징 없이 전체 데이터를 가져오기 위해 screenSize를 크게 설정
	    searchVO.setScreenSize(999999);
	    searchVO.setCurrentPage(1);
	    searchVO.setTotalRecord(999999); 
	    
	    List<MemberVO> userList = adminMapper.selectMemberListForExcel(searchVO);

	    Workbook workbook = new XSSFWorkbook();
	    byte[] rgb = new byte[]{(byte) 247, (byte) 247, (byte) 247}; 
	    XSSFColor customGrey = new XSSFColor(rgb, null);
	    Sheet sheet = workbook.createSheet("회원관리_리포트");

	    CellStyle headerStyle = workbook.createCellStyle();
	    applyThinBorder(headerStyle); 
	    headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    headerStyle.setAlignment(HorizontalAlignment.CENTER);
	    headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
	    
	    CellStyle leftStyle = workbook.createCellStyle();
	    applyThinBorder(leftStyle);
	    leftStyle.setAlignment(HorizontalAlignment.LEFT);
	    leftStyle.setVerticalAlignment(VerticalAlignment.CENTER);
	    leftStyle.setIndention((short) 1);

	    CellStyle centerStyle = workbook.createCellStyle();
	    applyThinBorder(centerStyle);
	    centerStyle.setAlignment(HorizontalAlignment.CENTER);
	    centerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

	    CellStyle dateStyle = workbook.createCellStyle();
	    dateStyle.cloneStyleFrom(centerStyle);
	    dateStyle.setDataFormat(workbook.getCreationHelper().createDataFormat().getFormat("yyyy-MM-dd HH:mm"));

	    XSSFCellStyle withdrawnLeftStyle = (XSSFCellStyle) workbook.createCellStyle();
	    withdrawnLeftStyle.cloneStyleFrom(leftStyle);
	    withdrawnLeftStyle.setFillForegroundColor(customGrey);
	    withdrawnLeftStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    XSSFCellStyle withdrawnCenterStyle = (XSSFCellStyle) workbook.createCellStyle();
	    withdrawnCenterStyle.cloneStyleFrom(centerStyle);
	    withdrawnCenterStyle.setFillForegroundColor(customGrey);
	    withdrawnCenterStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    XSSFCellStyle withdrawnDateStyle = (XSSFCellStyle) workbook.createCellStyle();
	    withdrawnDateStyle.cloneStyleFrom(dateStyle);
	    withdrawnDateStyle.setFillForegroundColor(customGrey);
	    withdrawnDateStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    Row headerRow = sheet.createRow(0);
	    headerRow.setHeightInPoints(35);
	    String[] headers = {"번호", "아이디", "이름", "이메일", "전화번호", "부서", "직위", "업체번호", "등록번호", "가입일", "상태"};
	    for (int i = 0; i < headers.length; i++) {
	        Cell cell = headerRow.createCell(i);
	        cell.setCellValue(headers[i]);
	        cell.setCellStyle(headerStyle);
	    }

	    int rowNum = 1;
	    for (MemberVO user : userList) {
	        Row row = sheet.createRow(rowNum++);
	        row.setHeightInPoints(30);
	        boolean isWithdrawn = "Y".equals(user.getLeaveStatus());
	        CellStyle currentLeft = isWithdrawn ? withdrawnLeftStyle : leftStyle;
	        CellStyle currentCenter = isWithdrawn ? withdrawnCenterStyle : centerStyle;
	        CellStyle currentDate = isWithdrawn ? withdrawnDateStyle : dateStyle;

	        createCell(row, 0, String.valueOf(user.getMemberNo()), currentCenter);
	        createCell(row, 1, user.getMemberId(), currentLeft);
	        createCell(row, 2, user.getMemberName(), currentLeft);
	        createCell(row, 3, user.getMemberEmail(), currentLeft);
	        createCell(row, 4, user.getMemberTel(), currentCenter);
	        createCell(row, 5, user.getMemberDepartment(), currentLeft);
	        createCell(row, 6, user.getMemberPosition(), currentCenter);
	        createCell(row, 7, user.getCompanyNo(), currentCenter);
	        createCell(row, 8, String.valueOf(user.getMemberRegno()), currentCenter);
	        
	        Cell dateCell = row.createCell(9);
	        if (user.getMemberJoinDate() != null) {
	            dateCell.setCellValue(user.getMemberJoinDate());
	            dateCell.setCellStyle(currentDate);
	        } else {
	            dateCell.setCellStyle(currentCenter);
	        }
	        createCell(row, 10, isWithdrawn ? "탈퇴" : "활성", currentCenter);
	    }

	    sheet.createFreezePane(0, 1);
	    sheet.setAutoFilter(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, headers.length - 1));
	    for (int i = 0; i < headers.length; i++) {
	        sheet.autoSizeColumn(i);
	        sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1200);
	    }

	    String fileName = "Tudio_Member_Report_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xlsx";
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

	    workbook.write(response.getOutputStream());
	    workbook.close();
	}

	private void applyThinBorder(CellStyle style) {
	    style.setBorderTop(BorderStyle.THIN);
	    style.setBorderBottom(BorderStyle.THIN);
	    style.setBorderLeft(BorderStyle.THIN);
	    style.setBorderRight(BorderStyle.THIN);
	    style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	}

	private void createCell(Row row, int col, String value, CellStyle style) {
	    Cell cell = row.createCell(col);
	    cell.setCellValue(value != null ? value : "-");
	    cell.setCellStyle(style);
	}
	
	private String getCellValue(Cell cell) {
		if (cell == null) return "";
		switch (cell.getCellType()) {
			case STRING: return cell.getStringCellValue();
			case NUMERIC:
				if (DateUtil.isCellDateFormatted(cell)) {
					return new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
				}
				return String.valueOf((long) cell.getNumericCellValue());
			default: return "";
		}
	}

	@Override
	public Map<String, Object> getMemberSummaryStats() {
		return adminMapper.selectMemberSummaryStats();
	}

	@Override
	public AdminUserDTO selectMemberDetail(String memId) {
		return adminMapper.selectMemberDetail(memId);
	}
}