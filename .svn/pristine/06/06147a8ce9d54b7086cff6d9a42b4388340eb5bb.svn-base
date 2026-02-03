package kr.or.ddit.projectTask.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.dto.GanttTaskDTO;
import kr.or.ddit.projectTask.mapper.IProjectTaskMapper;
import kr.or.ddit.projectTask.service.IProjectGanttService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectGanttServiceImpl implements IProjectGanttService {
	
	@Autowired
    private IProjectTaskMapper mapper;

	@Override
    public List<GanttTaskDTO> getGanttTaskList(int projectNo) {

    	List<GanttTaskDTO> list = mapper.selectGanttTaskList(projectNo);

    	for (GanttTaskDTO dto : list) {
    		// 1. [기존 유지] 간트 차트 막대기를 그리기 위한 필수 로직
    	    if (dto.getStartDate() != null && dto.getEndDate() != null) {
    	        dto.setStart_date(format(dto.getStartDate())); // 시작 시점
    	        dto.setDuration(calcDuration(dto.getStartDate(), dto.getEndDate())); // 막대기 길이
    	    }

    	    // 2. [신규/수정] '실제종료일' 컬럼에 보여줄 글자 가공 로직
    	    // 컬럼명이 SUB_FINISHDATE로 바뀌었으니 필드명도 확인해 보세요!
    	    if (dto.getStatus() == 203 && dto.getSubFinishdate() != null) {
    	        // Date 타입의 데이터를 String 타입 필드(subFinishdateStr)에 넣어줌
    	        dto.setSubFinishdateStr(format(dto.getSubFinishdate())); 
    	    } else {
    	        dto.setSubFinishdateStr("-"); 
    	    }
    	    
    	    // 3.간트차트 색상 설정
    	    if(dto.getParent().equals("0")) {
    	    	dto.setColor("#3636");
    	    }else {
    	    	if(dto.getStatus() ==201) {
    	    		dto.setColor("#F59E0B");
    	    	}else if(dto.getStatus() ==202) {
    	    		dto.setColor("#3B82F6");
    	    	}else if(dto.getStatus() ==203) {
    	    		dto.setColor("#22C55E");
    	    	}else if(dto.getStatus() ==204) {
    	    		dto.setColor("#64748B");
    	    	}else if(dto.getStatus() ==205) {
    	    		dto.setColor("#ef4444");
    	    	}
    	    	
    	    }
        }
        return list;
    }
    
    
    private String format(Date date) {
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    private int calcDuration(Date start, Date end) {
        long diff = end.getTime() - start.getTime();
        return (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS) + 1;
    }
}
