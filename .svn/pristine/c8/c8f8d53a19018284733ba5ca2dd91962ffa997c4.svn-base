package kr.or.ddit.drive.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.DriveFolderFileVO;
import kr.or.ddit.vo.DriveFolderVO;

@Mapper
public interface IDriveMapper {
	
	/**
	 * select
	 */
	// 프로젝트 폴더(최상위 루트 폴더) 조회
	public Integer selectProjectRootFolderNo(int projectNo);
	// 선택 폴더에 해당되는 모든 폴더&파일 조회
    public List<Map<String, Object>> selectDriveItems(
        @Param("projectNo") int projectNo, 
        @Param("folderId") int folderId
    );
    // 휴지통 목록 조회
    public List<Map<String, Object>> selectTrashItems(int projectNo);
    // 파일 다운로드용 정보 조회
    public DriveFolderFileVO selectFileDetail(int fileNo);
    
    /**
     * insert
     */
    // 프로젝트 폴더 생성 (프로젝트 생성시 최초 1회만 실행)
    public int insertRootFolder(DriveFolderVO driveFolderVO);
    // 폴더 생성
    public int insertFolder(DriveFolderVO driveFolderVO);
    // 파일 업로드
    public int insertFile(DriveFolderFileVO fileVO);
    
    /**
     * update
     */
    // 폴더 휴지통 이동 ('N' -> 'Y')
    public int softDeleteFolder(int folderNo);
    // 특정 폴더(및 하위 폴더)에 속한 모든 파일 휴지통 이동
    public int softDeleteFolderFiles(int folderNo);
    // 파일 휴지통 이동 ('N' -> 'Y')
    public int softDeleteFile(int fileNo);
    // 폴더 복구 ('Y' -> 'N')
    public int restoreFolder(int folderNo);
    // 특정 폴더(및 하위 폴더)에 속한 모든 파일 복구
    public int restoreFolderFiles(int folderNo);
    // 파일 복구 ('Y' -> 'N')
    public int restoreFile(int fileNo);
    
    /**
     * delete
     */
    // 폴더(및 하위 폴더) 영구 삭제 (Hard Delete)
    public int deleteFolder(int folderNo);
    // 특정 폴더(및 하위 폴더)에 속한 모든 파일 영구 삭제
    public int deleteFolderFiles(int folderNo);
    // 파일 영구 삭제 (Hard Delete)
    public int deleteFile(int fileNo);
}
