package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DriveFolderFileVO {
	 private int driveFolderFileNo;				   // 드라이브 파일 일련번호
	 private int folderNo;                         // 폴더일련번호
	 private int uploaderNo;                       // 파일작성자
	 private String fileName;                      // 원본파일명
	 private String driveFileSaveName;             // 서버저장명
	 private Date driveFileRegdate;                // 파일생성일
	 private long driveFileSize;                   // 파일크기
	 private String driveFileFancysize;            // 파일팬시사이즈
	 private String driveFileExtension;            // 파일확장자
	 private String driveFileMime;                 // 파일형식
	 private int driveFileDownloadCnt;             // 다운로드 횟수
	 private String driveFileDelete;               // 삭제여부(Y/N)
	 private int delMemberNo;                      // 파일삭제
	 private String driveFileDeldate;              // 파일삭제일
	 private String driveFilePath;            	   // 파일삭제일
	
}
