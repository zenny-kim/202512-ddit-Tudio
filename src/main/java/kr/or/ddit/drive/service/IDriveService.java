package kr.or.ddit.drive.service;

import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.DriveFolderFileVO;
import kr.or.ddit.vo.DriveFolderVO;

public interface IDriveService {
	
	/**
	 * 프로젝트 번호로 루트 폴더 ID	 조회 (Controller 지원용)
	 * @param projectNo
	 * @return
	 */
	public Integer getRootFolderId(int projectNo);
	
	/**
	 * 드라이브 목록 조회
	 * @param projectNo 프로젝트 번호
     * @param folderId 클라이언트가 요청한 폴더 ID (0이면 최상위)
	 * @return
	 */
	public Map<String, Object> getDriveList(int projectNo, int folderId);
	
	/**
	 * 휴지통 목록 조회
	 * @param projectNo
	 * @return
	 */
	public Map<String, Object> getTrashList(int projectNo);
	
	/**
	 * 파일 정보 조회 (다운로드용)
	 * @param fileNo
	 * @return
	 */
	public DriveFolderFileVO getFileInfo(int fileNo);
	
	/**
	 * 폴더&파일 상태 변경 (휴지통/복구/영구삭제)
	 * @param action
	 * @param type
	 * @param id
	 * @return
	 */
	public ServiceResult processDriveItem(String action, String type, int id);
	
	/**
	 * 프로젝트 생성시, 프로젝트 루트 폴더 생성
	 * @param projectNo
	 * @param projectName
	 * @param memberNo
	 */
	public void createProjectRootFolder(int projectNo, String projectName, int memberNo);

	/**
	 * 폴더 생성
	 * @param driveFolderVO
	 * @return
	 */
	public ServiceResult insertFolder(DriveFolderVO driveFolderVO);
	
	/**
	 * 파일 생성
	 * @param fileVO
	 * @return
	 */
	public ServiceResult insertFile(DriveFolderFileVO fileVO);
	
}
