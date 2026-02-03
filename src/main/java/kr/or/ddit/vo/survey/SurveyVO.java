package kr.or.ddit.vo.survey;

import java.time.LocalDateTime;
import java.util.List;

import lombok.*;

@Getter @Setter
@NoArgsConstructor
public class SurveyVO {
	
	// 설문 테이블
	
    private int surveyNo;                 			// 설문조사 일련번호
    private int surveyWriter;            			// 작성자 memberNo
    private String surveyTitle;            			// 제목
    private String surveyDescription;      			// 내용
    private LocalDateTime surveyRegisterDate; 		// 등록일
    private LocalDateTime surveyStartDate;   		// 시작일
    private LocalDateTime surveyEndDate;      		// 종료일
    private String surveyCloseStatus;      			// 마감여부 (Y/N) default N
    private String surveyDeleteStatus;     			// 삭제여부 (Y/N) default N

    private List<SurveyQuestionVO> questionList; // (컬럼 아님)설문 조회 시 질문 담을 리스트

	public boolean isParticipated;					// 참여 여부 확인
    
}