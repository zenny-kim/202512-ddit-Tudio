package kr.or.ddit.common.code;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;

@Getter
@JsonFormat(shape = JsonFormat.Shape.OBJECT) // JSON 변환 시 객체 형태로 출력
public enum TaskStatus implements CodeEnum {
	
	REQUEST(201, "요청", "task-status-request"),
	PROGRESS(202, "진행", "task-status-progress"),
	DONE(203, "완료", "task-status-done"),
	HOLD(204, "보류", "task-status-hold"),
	DELAYED(205, "지연", "task-status-delayed");
	
	private final int code;
	private final String label;
	private final String cssClass;
	
	TaskStatus(int code, String label, String cssClass){
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
	
	public static TaskStatus from(int code) {
		for(TaskStatus status : values()) {
			if(status.code == code) {
				return status;
			}
		}
		throw new IllegalArgumentException("잘못된 코드: " + code);
	}
}
