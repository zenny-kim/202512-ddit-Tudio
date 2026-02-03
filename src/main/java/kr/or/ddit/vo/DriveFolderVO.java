package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class DriveFolderVO {
	 private int folderNo;					// 폴더일련번호
	 private int projectNo;                 // 프로젝트 일련번호
	 private String folderName;             // 폴더명
	 private int memberNo;                  // 폴더 생성자
	 private int parentFolderNo;            // 상위폴더 일련번호
	 private Date folderRegdate;            // 폴더 생성일
	 private Date folderDelete;             // 폴더 삭제여부
	 private Date folderDeldate;            // 폴더 삭제일
	 
	 private List<DriveFolderFileVO> driveFileList;	// 폴더 내 파일 목록
}
