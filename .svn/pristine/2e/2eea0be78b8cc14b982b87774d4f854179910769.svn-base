package kr.or.ddit.dashboard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.DraftDocumentVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.WidgetVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import kr.or.ddit.vo.project.ProjectVO;
import kr.or.ddit.vo.survey.SurveyVO;

@Mapper
public interface IWidgetMapper {

	// 회원가입시 기본 위젯 설정 정보 등록
	public void insertDefaultWidget(List<WidgetVO> widgetList);
	
	// 위젯 목록 조회
	public List<WidgetVO> selectWidgetList(int memberNo);
	// 위젯 레이아웃 변경
	public int updateWidgetLayout(WidgetVO widgetVO);
	// 위젯 사용여부 변경
	public int updateWidgetStatus(Map<String, Object> params);
	
	// [위젯 1] 마감 임박 업무 조회
    public List<ProjectTaskVO> selectDeadlineTask(int memberNo);
    
    // [위젯 2] 개인 업무
    public List<Map<String, Object>> selectWeeklyWorkList(Map<String, Object> params);

    // [위젯 3] 시스템 공지사항
	public List<NoticeVO> selectWidgetNoticeList();
	
	// [위젯 4] 시스템 미확인 알림
	public List<NotificationVO> selectWidgetNotiList(int memberNo);
	public Map<String, Object> selectNotiStats(int memberNo);
	
	// [위젯 5] 북마크 프로젝트
	public List<ProjectVO> selectWidgetBookmarkList(int memberNo);
	
	// [위젯 6] 투두 리스트는 ITodoMapper에서 처리
	
	// [위젯 7] 결재
	public Map<String, Object> selectDocumentlStats(int memberNo);
	public List<DraftDocumentVO> selectMyDraftList(int memberNo);
	public Map<String, Object> selectApprovalStats(int memberNo);
	public List<DraftDocumentVO> selectToApproveList(int memberNo);
	
	// 설문
	public List<SurveyVO> selectPendingSurvey(int memberNo);

	public int updateNotificationStatus(Map<String, Object> params);
	public int deleteNotification(int notiNo);

}
