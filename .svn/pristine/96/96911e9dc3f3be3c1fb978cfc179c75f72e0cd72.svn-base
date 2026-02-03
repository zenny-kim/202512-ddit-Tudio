package kr.or.ddit.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;

@Mapper
public interface IFileMapper {
	
	// [파일 목록 조회] id="selectFileDetailList"
	public List<FileDetailVO> selectFileDetailList(int fileGroupNo);
    
    // [파일 그룹 저장] id="insertFileGroup"
    public int insertFileGroup(FileGroupVO fileGroupVO);
    
    // [파일 디테일 저장] id="insertFileDetail"
    public int insertFileDetail(FileDetailVO fileDetailVO);
    
    // [파일 그룹 논리 삭제] id="updateFileGroupDelete"
    public int updateFileGroupDelete(int fileGroupNo);
    
    // [파일 디테일 논리 삭제] id="updateFileDelete"
    public int updateFileDelete(int fileNo);
    
    // [프로필 디테일 물리 삭제] id="deleteProfileFile"
    public int deleteProfileFile(int memberNo);
    
    // [프로필 그룹 물리 삭제] id="deleteProfileGroup"
    public int deleteProfileGroup(int memberNo);
    
    // [프로필 변경 시 경로 확인] 프로필 실제 파일을 지우기 위해 경로를 알아오는 쿼리
    public List<FileDetailVO> selectProfileFileDetail(int memberNo);
 
    // [단일 파일 목록 조회] id="selectFileDetail" 파일 다운로드 시 필요
	public FileDetailVO selectFileDetail(int fileNo);

}
