package kr.or.ddit.common;

/**
 * <pre>
 * PROJ : Tudio
 * Name : WidgetType
 * DESC : 위젯 타입
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.09
 * 
 */
public enum WidgetType {
	PROJECT_SUMMARY("프로젝트요약"),
    PERSONAL_WORK("개인업무"),
    NOTICE("공지사항"),
    ALARM("미확인알림"),
    PROJECT_BOOKMARK("프로젝트북마크"),
    TODO("할일목록"),
	DRAFT("전자결재");

    private final String label;
    
    WidgetType(String label) { 
    	this.label = label; 
    }
    
    public String getLabel() {
    	return label;
    }
}
