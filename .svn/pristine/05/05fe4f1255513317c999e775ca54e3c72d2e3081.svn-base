package kr.or.ddit.file.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.FileDetailVO;

public interface IFileService {

	// 게시글 파일 등록
	public String fileUpload(MultipartFile file, int memberNo, int fileType);

	// 게시글 파일 여러개 등록
	public int uploadFiles(List<MultipartFile> fileList, int memberNo, int fileType);

	// 파일 다운로드 시 한개 조회
	public FileDetailVO selectFileDetail(int fileNo);
	
	// [PSE 추가] 파일 그룹 번호로 종속된 파일 디테일 목록 조회
	public List<FileDetailVO> selectFileDetailList(int fileGroupNo);
	
	// [KJS 추가] 기존에 존재하는 fileGroup에 새 파일 추가
	public int insertFilesToExistingGroup(List<MultipartFile> fileList, int memberNo, int fileType, int fileGroupNo);

	// [KJS 추가] 특정 파일의 삭제상태를 'Y'로 변경
	int updateFileDelete(int fileNo);
	
	// [YHB 추가] 파일 등록 메소드 오버로딩 (pdf)
	public String fileUpload(String originalName, byte[] fileData, int memberNo, int fileType);
}
