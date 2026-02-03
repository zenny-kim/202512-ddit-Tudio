package kr.or.ddit.drive.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.code.FileIconType;
import kr.or.ddit.drive.mapper.IDriveMapper;
import kr.or.ddit.vo.DriveFolderFileVO;
import kr.or.ddit.vo.DriveFolderVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DriveServiceImpl implements IDriveService {
	
	@Autowired
	private IDriveMapper driveMapper;
	
	/**
	 * Controller에서 업로드 시 루트 ID가 필요할 때 호출
	 */
	@Override
    public Integer getRootFolderId(int projectNo) {
        return driveMapper.selectProjectRootFolderNo(projectNo);
    }
	
	/**
     * 드라이브 목록 조회 비즈니스 로직
     * @param projectNo 프로젝트 번호
     * @param folderId 클라이언트가 요청한 폴더 ID (0이면 최상위)
     * @return 목록 리스트 + 현재 폴더 ID
     */
	@Override
    public Map<String, Object> getDriveList(int projectNo, int folderId) {
        
        int targetFolderId = folderId;

        // 화면에서 최상위(0)를 요청했다면, DB에서 실제 프로젝트의 Root Folder ID를 찾아옵니다.
        if (targetFolderId == 0) {
            Integer rootId = driveMapper.selectProjectRootFolderNo(projectNo);
            
            if (rootId != null) {
                targetFolderId = rootId;
            }
        }

        List<Map<String, Object>> list = driveMapper.selectDriveItems(projectNo, targetFolderId);

        for (Map<String, Object> item : list) {
            String type = (String) item.get("fileType"); // FOLDER or FILE
            String ext = (String) item.get("fileExtension"); // 확장자
            
            // Enum을 통해 아이콘 클래스 획득
            String iconClass = FileIconType.getIconClassByExtension(type, ext);
            item.put("iconClass", iconClass);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("driveList", list);           // 실제 데이터 리스트
        result.put("currentFolderId", targetFolderId); // 현재 조회된 폴더 ID
        
        return result;
    }
	
	/**
	 * 휴지통 목록 조회
	 */
	@Override
	public Map<String, Object> getTrashList(int projectNo) {
		List<Map<String, Object>> list = driveMapper.selectTrashItems(projectNo);
        // 아이콘 처리 로직 (기존과 동일하게)
        for (Map<String, Object> item : list) {
            String type = (String) item.get("fileType");
            String ext = (String) item.get("fileExtension");
            item.put("iconClass", kr.or.ddit.common.code.FileIconType.getIconClassByExtension(type, ext));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("driveList", list);
        return result;
	}

	/**
	 * 파일 정보 조회 (다운로드)
	 */
	@Override
	public DriveFolderFileVO getFileInfo(int fileNo) {
		return driveMapper.selectFileDetail(fileNo);
	}
	
	/**
	 * 폴더 생성 로직
	 */
	@Override
	public ServiceResult insertFolder(DriveFolderVO driveFolderVO) {
	    
	    // 1. 만약 현재 위치가 최상위(0)라면?
	    //    -> 사용자는 0번(가상의 루트) 밑에 만들고 싶어하지만,
	    //    -> DB 구조상으로는 "프로젝트 루트 폴더"의 자식으로 들어가야 함.
	    if (driveFolderVO.getParentFolderNo() == 0) {
	        
	        // 해당 프로젝트의 진짜 루트 폴더 ID 조회
	        Integer rootId = driveMapper.selectProjectRootFolderNo(driveFolderVO.getProjectNo());
	        
	        if (rootId == null) {
	            // 프로젝트 루트 폴더가 없는 심각한 상황 (데이터 무결성 에러)
	            log.error("프로젝트 루트 폴더가 존재하지 않음 ProjectNo={}", driveFolderVO.getProjectNo());
	            return ServiceResult.FAILED;
	        }
	        
	        // 부모 ID를 진짜 루트 ID로 교체
	        driveFolderVO.setParentFolderNo(rootId);
	    }
	    
	    // 2. 폴더 생성 (이제 parentFolderNo에는 항상 값이 있음)
	    int row = driveMapper.insertFolder(driveFolderVO);
	    
	    return row > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	/**
	 * 파일 생성
	 */
	@Override
	public ServiceResult insertFile(DriveFolderFileVO fileVO) {
		int result = driveMapper.insertFile(fileVO);
        return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	/**
	 * 프로젝트 생성시, 프로젝트 루트 폴더 생성
	 */
	@Override
	public void createProjectRootFolder(int projectNo, String projectName, int memberNo) {
		DriveFolderVO rootFolder = new DriveFolderVO();
		rootFolder.setProjectNo(projectNo);
		rootFolder.setFolderName(projectName); // 프로젝트 명과 동일하게
		rootFolder.setMemberNo(memberNo);
        // parentFolderNo는 세팅 안함 (int 기본값 0이지만, 쿼리에서 강제로 NULL 처리할 예정)
		
		driveMapper.insertRootFolder(rootFolder);
	}
	
	

	/**
	 * 폴더&파일 상태 변경 (휴지통/복구/영구삭제)
	 * @param int id : folderNo/fileNo
	 */
	@Override
	@Transactional // 중간에 에러 발생시 전체 롤백
	public ServiceResult processDriveItem(String action, String type, int id) {
		int result = 0;
		boolean isFolder = "folder".equalsIgnoreCase(type);
		
		// 휴지통
        if ("softDelete".equals(action)) {							// 휴지통 이동
            if (isFolder) {
            	// 폴더 트리 내부 파일 먼저 처리
            	driveMapper.softDeleteFolderFiles(id);
            	// 폴더 처리
            	result = driveMapper.softDeleteFolder(id);
            } else {
            	// 개별 파일 처리
            	result = driveMapper.softDeleteFile(id);
            }
        } else if ("restore".equals(action)) {						// 복구
            if (isFolder) {
            	// 폴더 트리 내부 파일 먼저 복구
            	driveMapper.restoreFolderFiles(id);
            	// 폴더 복구
            	result = driveMapper.restoreFolder(id);
            } else {
            	// 개별 파일 복군
            	result = driveMapper.restoreFile(id);
            }
        } else if ("hardDelete".equals(action)) {					// DB 영구 삭제
            if (isFolder) {
            	// 폴더 트리 내부 파일 먼저 영구삭제
            	driveMapper.deleteFolderFiles(id);
            	// 폴더 영구삭제
            	result = driveMapper.deleteFolder(id);
            } else {
            	// 개별 파일 영구삭제
            	result = driveMapper.deleteFile(id);
            }
        }
        return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
}
