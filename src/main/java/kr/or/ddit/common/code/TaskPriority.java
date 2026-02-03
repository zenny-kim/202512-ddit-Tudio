package kr.or.ddit.common.code;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;

@Getter
@JsonFormat(shape = JsonFormat.Shape.OBJECT) // JSON 변환 시 객체 형태로 출력
public enum TaskPriority implements CodeEnum {

	LOW(211, "낮음", "task-priority-low"),
	NORMAL(212, "보통", "task-priority-normal"),
	HIGH(213, "높음", "task-priority-high"),
	URGENT(214, "긴급", "task-priority-urgent");
	
	private final int code;
	private final String label;
	private final String cssClass;
	
	TaskPriority(int code, String label, String cssClass){
		this.code = code;
		this.label = label;
		this.cssClass = cssClass;
	}
	
	@Override
	public int getCode() {
		return code;
	}
	
	@Override
	public String getLabel() {
		return label;
	}
	
	public String getCssClass() {
		return cssClass;
	}
	
	public static TaskPriority from(int code) {
		for(TaskPriority priority : values()) {
			if(priority.code == code) {
				return priority;
			}
		}
		throw new IllegalArgumentException("잘못된 코드: " + code);
	}
	
}
