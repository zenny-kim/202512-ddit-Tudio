package kr.or.ddit.util.excel.service;

import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.code.ExcelCategory; // 만든 Enum 임포트
import kr.or.ddit.util.excel.ExcelColumn;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class ExcelService {

    // fileName 대신 ExcelCategory를 받도록 수정!
    public <T> void downloadExcel(HttpServletResponse response, List<T> dataList, ExcelCategory category, String projectName, String memberName) throws Exception {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("통계데이터"); //시트 이름

        if (dataList == null || dataList.isEmpty()) {
            workbook.close();
            return;
        }
        
        LocalDateTime nowObj = LocalDateTime.now(); 
        String nowStr = nowObj.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String dateFileStr = nowObj.format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        // --- [디자인 설정: 옅은 하늘색 헤더 스타일] ---
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN); // 테두리 추가

        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // --- [디자인 설정: 숫자 콤마 스타일] ---
        CellStyle numberStyle = workbook.createCellStyle();
        numberStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));

        // --- 1. 상단 타이틀 및 정보 작성 (Enum 활용) ---
        // 0행: 보고서명
        Row row0 = sheet.createRow(0);
        row0.createCell(0).setCellValue("보고서명: " + category.getTitle());
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));

        // 1행: 프로젝트명
        Row row1 = sheet.createRow(1);
        row1.createCell(0).setCellValue("프로젝트: " + projectName);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 5));

        // 2행: 출력일시
        Row row2 = sheet.createRow(2);
        row2.createCell(0).setCellValue("출력일시: " + nowStr);
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 5));

        // 3행: 출력자
        Row row3 = sheet.createRow(3);
        row3.createCell(0).setCellValue("출력자: " + memberName);
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 0, 5));

        // --- 2. 헤더 생성 (5번째 행) ---
        Class<?> clazz = dataList.get(0).getClass();
        Field[] fields = clazz.getDeclaredFields();
        Row headerRow = sheet.createRow(5); 
        int colIdx = 0;
        for (Field field : fields) {
            if (field.isAnnotationPresent(ExcelColumn.class)) {
                Cell cell = headerRow.createCell(colIdx++);
                cell.setCellValue(field.getAnnotation(ExcelColumn.class).headerName());
                cell.setCellStyle(headerStyle); // 헤더 스타일 적용
            }
        }

        // --- 3. 데이터 행 생성 ---
        int rowIdx = 6;
        for (Object data : dataList) {
            Row row = sheet.createRow(rowIdx++);
            int cellIdx = 0;
            for (Field field : fields) {
                if (field.isAnnotationPresent(ExcelColumn.class)) {
                    field.setAccessible(true);
                    Object value = field.get(data);
                    Cell cell = row.createCell(cellIdx++);
                    
                    if (value instanceof Number) { // 숫자면 콤마 스타일
                        cell.setCellValue(((Number) value).doubleValue());
                        cell.setCellStyle(numberStyle);
                    } else {
                        cell.setCellValue(value != null ? value.toString() : "");
                    }
                }
            }
        }

        // --- 4. 부가 기능 (너비 자동조절 및 틀 고정) ---
        for (int i = 0; i < colIdx; i++) {
            sheet.autoSizeColumn(i);
            
            int currentWidth = sheet.getColumnWidth(i);
            sheet.setColumnWidth(i, (int)(currentWidth * 1.2) + 512);
        }
        sheet.createFreezePane(0, 6); // 헤더행 아래로 틀 고정

        // --- 5. 파일 다운로드 설정 (Enum 키워드 활용) ---
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String fileName = "Tudio_" + category.getFileKeyword() + "_" + dateStr;
        
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }
}