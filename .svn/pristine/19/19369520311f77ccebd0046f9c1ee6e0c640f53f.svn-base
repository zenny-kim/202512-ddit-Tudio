package kr.or.ddit.vo.project;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;

@Data
public class ProjectMiniHeaderVO {
	private int projectNo;	// 프로젝트 일련번호
	private String fixTab;	// 1:게시판, 2:업무, 3:일정, 4:간트차트, 5:자료실, 6:구성원
	
	public List<Integer> getTabOrderList() {
        if (this.fixTab == null || this.fixTab.trim().isEmpty()) {
            return new ArrayList<>(); // null 대신 빈 리스트 반환 (NullPointerException 방지)
        }

        List<Integer> list = new ArrayList<>();
        String[] split = this.fixTab.split(",");
        
        for (String s : split) {
            try {
                list.add(Integer.parseInt(s.trim()));
            } catch (NumberFormatException e) {
                // 숫자가 아닌 이상한 값이 들어있으면 무시하고 계속 진행
                continue; 
            }
        }
        return list;
    }
	
	public void setTabOrderList(List<Integer> tabOrderList) {
        if (tabOrderList != null && !tabOrderList.isEmpty()) {
            // 리스트 -> 콤마 문자열 변환
            this.fixTab = tabOrderList.stream()
                                      .map(String::valueOf)
                                      .collect(Collectors.joining(","));
        } else {
            this.fixTab = "";
        }
    }
}
