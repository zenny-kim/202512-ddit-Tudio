package kr.or.ddit.dto;

import java.util.Date;

import lombok.Data;

/**
 * DHTMLX Gantt Chart 를 사용하기 위한 DTO
 */

@Data
public class GanttTaskDTO {
	
	private String id;
    private String text;
    
    private Date startDate;   
    private Date endDate;

    private String start_date;
    private int duration;

    private double progress;
    private String parent;

    private String type; // "project" | "task"
    
    private int status;
    private Date subFinishdate; //실제 업무종료일
    private String subFinishdateStr; //날짜 포맷팅한 문자열
    
    // 간트 차트 업무 진행상태별 색상
    private String color = "";
    
    // 프로젝트 업무 담당자명 리스트("," 구분)
    private String managers = "";
    
}
