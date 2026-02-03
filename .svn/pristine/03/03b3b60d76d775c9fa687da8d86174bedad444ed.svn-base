package kr.or.ddit.dashboard.service.impl;

import java.util.ArrayList;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.dashboard.mapper.IWidgetMapper;
import kr.or.ddit.dashboard.service.ITodoService;
import kr.or.ddit.dashboard.service.IWidgetService;
import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.TodoVO;
import kr.or.ddit.vo.WidgetVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import kr.or.ddit.vo.project.ProjectVO;
import kr.or.ddit.vo.survey.SurveyVO;


@Service
public class WidgetServiceImpl implements IWidgetService {
	
	@Autowired
	private IWidgetMapper widgetMapper;
	
	@Autowired
    private ITodoService todoService;
	
	/**
	 * 신규 회원 기본 위젯 정보 생성
	 */
	@Override
	public void createDefaultWidget(int memberNo, String role) {
		List<WidgetVO> widgetList = new ArrayList<>();
		
		if ("ROLE_CLIENT".equals(role)) {	// 기업 관리자
			// 위젯 1 [시스템 공지사항]
			widgetList.add(WidgetVO.createDefault(memberNo, "NOTICE", 0, 0, 6, 4, "Y"));
			// 위젯 2 [미확인 알림]
			widgetList.add(WidgetVO.createDefault(memberNo, "ALARM", 6, 0, 6, 4, "Y"));
			// 위젯 3 [북마크 프로젝트]
			widgetList.add(WidgetVO.createDefault(memberNo, "PROJECT_BOOKMARK", 0, 4, 12, 4, "Y"));
			// 위젯 4 [기안결재]
			widgetList.add(WidgetVO.createDefault(memberNo, "DRAFT", 0, 8, 6, 4, "Y"));
		} else {	// 프로젝트 관리자 및 프로젝트 참여자
			// 위젯 1 [마감 임박 업무]
			widgetList.add(WidgetVO.createDefault(memberNo, "PROJECT_SUMMARY", 0, 0, 4, 4, "Y"));
			// 위젯2 [개인업무]
			widgetList.add(WidgetVO.createDefault(memberNo, "PERSONAL_WORK", 0, 8, 12, 4, "N"));
			// 위젯3 [시스템 공지사항]
			widgetList.add(WidgetVO.createDefault(memberNo, "NOTICE", 4, 0, 4, 4, "Y"));
			// 위젯4 [미확인 알림]
			widgetList.add(WidgetVO.createDefault(memberNo, "ALARM", 8, 0, 4, 4, "Y"));
			// 위젯 5 [북마크 프로젝트]
			widgetList.add(WidgetVO.createDefault(memberNo, "PROJECT_BOOKMARK", 0, 4, 8, 4, "Y"));
			// 위젯 6 [투두 리스트]
			widgetList.add(WidgetVO.createDefault(memberNo, "TODO", 8, 4, 4, 4, "Y"));		
			// 위젯 7 [기안결재]
			widgetList.add(WidgetVO.createDefault(memberNo, "DRAFT", 8, 10, 4, 4, "N"));
		}
			
		widgetMapper.insertDefaultWidget(widgetList);
	}
	
	/**
	 * 사용자 위젯 조회
	 */
	@Override
	public List<WidgetVO> selectWidgetList(int memberNo) {
		List<WidgetVO> widgetList = widgetMapper.selectWidgetList(memberNo);
        
        for (WidgetVO widget : widgetList) {
            int location = widget.getLocationNo();
            // 화면은 12칸의 그리드를 기준으로 함 (고정)
            widget.setX(location % 12); 	// 나머지 = 가로(x)
            widget.setY(location / 12); 	// 몫 = 세로(y)
        }
        return widgetList;
	}

	/**
	 * 위젯 레이아웃 설정 변경
	 */
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateWidgetLayout(List<WidgetVO> widgetList) {
		for(WidgetVO widget : widgetList) {
			int location = (widget.getY() * 12) + widget.getX();
			widget.setLocationNo(location);
			
			int result = widgetMapper.updateWidgetLayout(widget);
			
			if(result == 0) {
                throw new RuntimeException("위젯 설정 업데이트 실패");
            }
		}
	}
	
	/**
	 * 위젯 사용여부 설정 변경
	 */
	@Override
	public int updateWidgetStatus(Map<String, Object> params) {
		return widgetMapper.updateWidgetStatus(params);
	}
	
	
	/**
	 * [위젯 1] 프로젝트 요약 (상위업무 d-day 기준 상위 5개 출력)
	 */
	@Override
    public List<ProjectTaskVO> selectDeadlineTask(int memberNo) {
        return widgetMapper.selectDeadlineTask(memberNo);
    }
	
	
	/**
	 * [위젯 2] 개인 업무
	 */
	@Override
    public List<Map<String, Object>> selectWeeklyWorkList(Map<String, Object> params) {
        return widgetMapper.selectWeeklyWorkList(params);
    }

	/**
	 * [위젯 3] 시스템 공지사항
	 */
	@Override
    public List<NoticeVO> getWidgetNoticeList() {
        return widgetMapper.selectWidgetNoticeList();
    }
	
	/**
	 * [위젯 4] 미확인 알림
	 */
	@Override
	public List<NotificationVO> getWidgetNotiList(int memberNo) {
	    return widgetMapper.selectWidgetNotiList(memberNo);
	}
	
	@Override
	public Map<String, Object> selectNotiStats(int memberNo) {
		return widgetMapper.selectNotiStats(memberNo);
	}
	
	/*
	 * 알림 상태 변경
	 */
	@Override
    public int updateNotificationStatus(Map<String, Object> params) {
        return widgetMapper.updateNotificationStatus(params);
    }

	/*
	 * 알림 영구 삭제
	 */
    @Override
    public int deleteNotification(int notiNo) {
        return widgetMapper.deleteNotification(notiNo);
    }
	
	
	/**
	 * [위젯 5] 북마크 프로젝트
	 */
	@Override
    public List<ProjectVO> getWidgetBookmarkList(int memberNo) {
        return widgetMapper.selectWidgetBookmarkList(memberNo);
    }
	
	/**
     * [위젯 6] 투두 리스트
     */
    @Override
    public List<TodoVO> getWidgetTodoList(TodoVO todoVO) {
        return todoService.selectTodoList(todoVO);
    }
	
    /**
     * [위젯 6-1] 투두 등록
     */
    @Override
    public int createWidgetTodo(TodoVO todoVO) {
        return todoService.insertTodo(todoVO);
    }
    
    /**
     * [위젯 6-2] 투두 상태 변경
     */
    @Override
    public int modifyWidgetTodoStatus(TodoVO todoVO) {
        return todoService.updateTodoStatus(todoVO);
    }
    
    /**
     * [위젯 6-3] 투두 내용 수정
     */
    @Override
    public int modifyWidgetTodoContent(TodoVO todoVO) {
        return todoService.updateTodoContent(todoVO);
    }
    
    /**
     * [위젯 6-4] 투두 삭제
     */
    @Override
    public int removeWidgetTodo(TodoVO todoVO) {
        return todoService.deleteTodo(todoVO);
    }
	
    /*
     * [위젯 7] 결재
     */
    @Override
    public Map<String, Object> selectApprovalStats(int memberNo) {
        return widgetMapper.selectDocumentlStats(memberNo);
    }
    
    @Override
    public List<DraftDocumentVO> selectMyDraftList(int memberNo) {
        return widgetMapper.selectMyDraftList(memberNo);
    }
    
    @Override
	public Map<String, Object> selectApproverStats(int memberNo) {
		return widgetMapper.selectApprovalStats(memberNo);
	}
    
    @Override
    public List<DraftDocumentVO> selectToApproveList(int memberNo) {
        return widgetMapper.selectToApproveList(memberNo);
    }

    /*
     * [상단 배너] 설문
     */
    @Override
    public List<SurveyVO> selectPendingSurvey(int memberNo) {
        return widgetMapper.selectPendingSurvey(memberNo);
    }


}
