package kr.or.ddit.dashboard.service;

import kr.or.ddit.common.WidgetType;


/**
 * <pre>
 * PROJ : Tudio
 * Name : IWidgetUpdateService
 * DESC : 위젯 변경 시 사용자에게 갱신 알림을 전달하는 서비스 인터페이스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.13
 * 
 */
public interface IWidgetUpdateService {
	/**
     * 특정 사용자의 위젯 타입에 대해 갱신 알림을 전송한다.
     * @param memberNo 알림을 받을 사용자 번호
     * @param widgetType 데이터를 갱신할 위젯 타입
     */
    public void sendWidgetUpdate(int memberNo, WidgetType widgetType);
}
