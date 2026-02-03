package kr.or.ddit.dashboard.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.TodoVO;
import kr.or.ddit.vo.WidgetVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import kr.or.ddit.vo.project.ProjectVO;
import kr.or.ddit.vo.survey.SurveyVO;

public interface IWidgetService {
	// 사용자 회원가입시 자동으로 등록되는 기본 위젯 정보 등록
	public void createDefaultWidget(int memberNo, String role);
	
	// 위젯 레이아웃 설정 및 관리
	public List<WidgetVO> selectWidgetList(int memberNo);
	public void updateWidgetLayout(List<WidgetVO> widgetList);
	public int updateWidgetStatus(Map<String, Object> params);
	
	// 위젯별 정보
	public List<ProjectTaskVO> selectDeadlineTask(int memberNo);
	public List<Map<String, Object>> selectWeeklyWorkList(Map<String, Object> params);
	public List<NoticeVO> getWidgetNoticeList();
	
	// [위젯 4] 알림
	public Map<String, Object> selectNotiStats(int memberNo);
	public List<NotificationVO> getWidgetNotiList(int memberNo);
	// 알림 읽음처리, 삭제
	public int updateNotificationStatus(Map<String, Object> params);
	public int deleteNotification(int notiNo);
	
	public List<ProjectVO> getWidgetBookmarkList(int memberNo);
	public List<TodoVO> getWidgetTodoList(TodoVO todoVO);
	
    
    // [결재] 통계 및 목록
    public Map<String, Object> selectApprovalStats(int memberNo);	// 기안작성자
    public List<DraftDocumentVO> selectMyDraftList(int memberNo);
    public Map<String, Object> selectApproverStats(int memberNo);				// 결재자
    public List<DraftDocumentVO> selectToApproveList(int memberNo);

	// [투두 리스트]
	public int createWidgetTodo(TodoVO todoVO);
	public int modifyWidgetTodoStatus(TodoVO todoVO);
	public int modifyWidgetTodoContent(TodoVO todoVO);
	public int removeWidgetTodo(TodoVO todoVO);

	// [설문] 미참여 조회
	public List<SurveyVO> selectPendingSurvey(int memberNo);
	
}
