package kr.or.ddit.vo.project;

import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

@Data
public class ProjectBoardMinutesVO {
	
	 private int boNo;					// 게시판일련번호
	 
	 //데이터를 form 에서 선택할때 (선택용 쓰고 있어서T를 넣어야 맞음)
	 @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	 @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")	//데이터 전송용
	 private LocalDateTime meetingDate;
	 
	 private String meetingGoal;		// 회의 목표
	 private String meetingResult;		// 회의 결과
	 
}
