package kr.or.ddit.vo;

import java.text.DecimalFormat;

import lombok.Data;

@Data
public class FileDetailVO {
	 private int fileNo;
	 private int fileGroupNo;
	 private String fileOriginalName;
	 private String fileRegdate;
	 private String fileSaveName;
	 private String filePath;
	 private int fileSize;
	 private String fileFancysize;
	 private String fileExtension;
	 private String fileMime;
	 private int fileDownloadCnt;
	 private String fileDelete;
	 private String fileDeldate;
	
	 
	 //파일 다운로드 시 사이즈 확인용 (DB엔 저장 안됨)
	 public String getFileFancysize() {
		 double size = (double) this.fileSize; // fileSize 변수를 가져옴
		 String unit = "Bytes";
		 
		 if (size > 1024) {
			 size /= 1024;
			 unit = "KB";
		 }
		 if (size > 1024) {
			 size /= 1024;
			 unit = "MB";
		 }
		 if (size > 1024) {
			 size /= 1024;
			 unit = "GB";
		 }
		 
		 // 소수점 둘째 자리까지 예쁘게 포맷팅
		 DecimalFormat df = new DecimalFormat("#.##");
		 return df.format(size) + " " + unit;
	 }
}
