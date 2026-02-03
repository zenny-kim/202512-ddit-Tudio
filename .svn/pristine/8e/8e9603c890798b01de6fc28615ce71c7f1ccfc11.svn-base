package kr.or.ddit.common.code;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Getter;


/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectType
 * DESC : 프로젝트 타입 공통코드
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.11
 * 
 */
@AllArgsConstructor
@Getter
public enum ProjectType implements CodeEnum {
	IT(101, "IT"),
    MARKETING(102, "마케팅"),
    ENTERTAINMENT(103, "엔터테인먼트"),
    CONSTRUCTION(104, "건설"),
    SECURITIES(105, "증권"),
    EDUCATION(106, "학교"),
    DESIGN(107, "디자인"),
    RESEARCH(108, "연구"),
    MANUFACTURING(109, "제조&생산"),
    FNB(110, "F&B"),
    ETC(111, "기타");

    private final int code;
    private final String label;
    
    // @JsonValue: Java -> JSON
    @JsonValue 
    public int getCode() {
        return code;
    }
    
    // @JsonCreator: JSON -> Java
    @JsonCreator
    public static ProjectType fromCode(int code) {
        for (ProjectType type : ProjectType.values()) {
            if (type.getCode() == code) {
                return type;
            }
        }
        return null; // 없는 코드면 null 처리
    }
}
