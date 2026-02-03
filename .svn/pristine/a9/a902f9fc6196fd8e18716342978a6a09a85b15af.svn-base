package kr.or.ddit.vo;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class FaqVO {
	private int faqNo;
	private int adminNo;
	private String faqTitle;
	private String faqContent;
	
	@JsonFormat(pattern = "yyyy MM dd a HH:mm", timezone = "Asia/Seoul")
	private LocalDateTime faqRegdate;
	
	@JsonFormat(pattern = "yyyy MM dd a HH:mm", timezone = "Asia/Seoul")
	private LocalDateTime faqUpdate;
	
	private int faqOrder;
	private int faqHit;
	private int fileGroupNo;
	private String publicStatus;
	
	// 파일을 편하게 받기 위해 files 필드 추가
	private List<MultipartFile> fileList;
	
	// FAQ 수정시, 기존에 존재하던 파일 중 삭제할 파일번호 list
	private List<Integer> deleteFileNoList;
}
