package kr.or.ddit.common.code;

import org.apache.ibatis.type.MappedTypes;

/**
 * <pre>
 * PROJ : Tudio
 * Name : TaskPriorityTypeHandler
 * DESC : CodeEnum을 구현한 TaskPriority Enum만을 단독 처리하는 제네릭 핸들러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 PSE
 * @version 1.0, 2026.01.12
 * @param <E> Enum이면서 동시에 CodeEnum을 구현한 클래스
 */
@MappedTypes(TaskPriority.class)
public class TaskPriorityTypeHandler extends CodeEnumTypeHandler<TaskPriority> {
    
    // 생성자에서 부모(CodeEnumTypeHandler)에게 내 정체(TaskPriority.class)를 강제로 주입
    public TaskPriorityTypeHandler() {
        super(TaskPriority.class);
    }
}