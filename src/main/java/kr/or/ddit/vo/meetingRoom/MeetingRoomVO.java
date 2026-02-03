package kr.or.ddit.vo.meetingRoom;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

@Data
public class MeetingRoomVO {
	
	private int roomId;             		// 회의실 일련번호
    private int branchId;           		// 지점 일련번호
    private String roomName;        		// 회의실 이름
    private int roomCapacity;       		// 회의실 수용인원
    private String roomStatus;      		// 회의실 운영상태
    
    @JsonFormat(pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date roomRegdate; 				// 회의실 등록일
    
    @JsonFormat(pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date roomUpddate; 				// 회의실 수정일
    private int memberNo;      				// 회의실 담당자
	
}
