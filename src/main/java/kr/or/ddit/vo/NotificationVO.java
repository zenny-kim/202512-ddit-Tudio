package kr.or.ddit.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class NotificationVO {
	private int notiNo; 				// 알림 번호
	private int memberNo; 				// 알림 수신인 회원번호
	private String notiType;			// 알림 타입
	private int targetId; 				// 알림 발신지 테이블 PK
	private String notiUrl;				// 알림 URL
	private String isRead;				// 알림 읽음여부 (읽음: Y / 읽지않음: N)	
	private Timestamp notiRegdate;		// 알림 생성일시
	private String notiCategory; 		// 알림 카테고리. [초대] 회의실 이런 식으로
	private String notiMessage;			// 알림 메세지
	
	
	private int projectNo; 				// 프로젝트 번호
	private int writerNo; 				// 보낸사람

	
	private String senderId;			// 알림 발신인
	
	// 위젯 통계 데이터 추출을 위한 필드
	private int allCount;				// 전체 알림 개수
	private int readCount;				// 읽은 알림 개수
	private int unreadCount;			// 읽지 않은 알림 개수
	
	
	
	// 상/하위 업무,개인업무 일정 알림 
	private String scheduleType;		//
	private int scheduleId; 			// 상위,하위,개인 일정의 번호
	private String projectName;			// 프로젝트 이름
	private String scheduleTitle; 		// 스케줄 알림 이름 (개인 일정 제목과 상/하위 프로젝트 제목)
	private int scheduleDday;			// 마감일
}

