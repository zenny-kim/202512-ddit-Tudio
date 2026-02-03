package kr.or.ddit.stats.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.code.ExcelCategory;
import kr.or.ddit.stats.dto.StatsExcelTestDTO;
import kr.or.ddit.util.excel.service.ExcelService;

@Controller
public class StatsExcelTestController {
	
	@Autowired
    private ExcelService excelService;

    @GetMapping("/excel/test")
    @ResponseBody
    public void testDownload(HttpServletResponse response, @RequestParam String projectNo) throws Exception {
        // 테스트용 가짜 데이터
        List<StatsExcelTestDTO> list = Arrays.asList(
            new StatsExcelTestDTO("김철수", "데이터 수집", 80, "비고1"),
            new StatsExcelTestDTO("이영희", "UI 디자인", 100, "비고2"),
            new StatsExcelTestDTO("박민수", "DB 설계", 50, "비고3")
        );
        
        String projectName = "시연용 테스트 프로젝트"; 
        String memberName = "관리자(나)";
        
        // 3. 공통 엑셀 서비스 호출
        excelService.downloadExcel(response, list, ExcelCategory.PROJECT_TASK_STAT, projectName, memberName);
    }
}
