package kr.or.ddit.stats.dto;

import kr.or.ddit.util.excel.ExcelColumn;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class StatsExcelTestDTO {
	@ExcelColumn(headerName = "팀원 이름")
    private String name;

    @ExcelColumn(headerName = "담당 업무")
    private String task;

    @ExcelColumn(headerName = "진행률(%)")
    private int progress;
    
    // 이 필드는 어노테이션이 없으므로 엑셀에 안 나옴
    private String privateNote;
}
