package kr.or.ddit.projectBoard.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.transaction.Transactional;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.project.service.IProjectService;
import kr.or.ddit.projectBoard.mapper.ITabBoardMapper;
import kr.or.ddit.projectBoard.service.ITabBoardService;
import kr.or.ddit.projectMember.service.IProjectMemberService;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.project.BoardCategoryVO;
import kr.or.ddit.vo.project.MeetingMemberVO;
import kr.or.ddit.vo.project.ProjectBoardMinutesVO;
import kr.or.ddit.vo.project.ProjectBoardVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import lombok.extern.slf4j.Slf4j;

@Service
public class TabBoardServiceImpl implements ITabBoardService {

	@Autowired
	private ITabBoardMapper boardMapper;
	
	@Autowired
    private IFileService fileService; 
	
	@Autowired
	private IFileMapper fileMapper;
	
	
	@Autowired
	private INotificationService notiService;
	
    
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	
	
	/**
     * 프로젝트 생성 시 기본 카테고리(NOTICE, FREE, MINUTES) 생성
     * - ProjectService에서 호출
     */
    @Override
    public void createDefaultCategory(int projectNo) {
        String[] defaultCategories = {"NOTICE", "FREE", "MINUTES"};

        for (String name : defaultCategories) {
            BoardCategoryVO categoryVO = new BoardCategoryVO();
            categoryVO.setProjectNo(projectNo);
            categoryVO.setCategoryName(name);
            
            boardMapper.insertCategory(categoryVO);
        }
    }
	
	
	// 게시글 목록 조회
	@Override
	public List<ProjectBoardVO> selectProjectBoardList(Map<String, Object> paramMap) {
		return boardMapper.selectProjectBoardList(paramMap);
	}

	// 게시글 등록
	@Transactional
	@Override
	public ServiceResult insertProjectBoard(ProjectBoardVO boardVO) {
		ServiceResult result = ServiceResult.FAILED;
		// 게시글 내용 저장
		int status = boardMapper.insertProjectBoard(boardVO);
		
		// 커뮤니티 공지사항 등록 발송
		if(status>0) {
			
			if("NOTICE".equalsIgnoreCase(boardVO.getCategoryName())) {
				
				int projectNo = boardVO.getProjectNo();
				int writerNo = boardVO.getMemberNo(); 
				String notiTitle = boardVO.getBoTitle();
				int targetId = boardVO.getBoNo();
			
				
				// 프로젝트 알림 푸시 대상 조회 
				NotificationVO notiVO = new NotificationVO();
				notiVO.setProjectNo(projectNo);
				notiVO.setWriterNo(writerNo);
				
				
				// 프로젝트 구성원에게 커뮤니티 공지사항 알림 INSERT
				Map<String, Object> notiMap = new HashMap<>();
				
				notiMap.put("notiType", "NOTI_TASK");
				notiMap.put("targetId",targetId);
				notiMap.put("notiUrl", "/tudio/project/detail?projectNo=" + projectNo + "&tab=board");
				notiMap.put("notiMessage", "["+notiTitle+"] 프로젝트 공지가 등록되었습니다.");
				notiMap.put("projectNo", projectNo);
				notiMap.put("writerNo", writerNo);
 
			    notiService.pushProjectNotice(notiVO,notiMap);
			   
			}// 커뮤니티 공지사항 등록 발송 끝

			
			// 회의록이라면 회의록 내용 추가 저장
			ProjectBoardMinutesVO minutesVO = boardVO.getBoardMinutesVO();
			if(minutesVO != null) {
				minutesVO.setBoNo(boardVO.getBoNo());
				boardMapper.insertBoardMinutes(minutesVO);
			}
			
			// 회의 참석자 저장
			List<MeetingMemberVO> memberList = boardVO.getMeetingMemberList();
			if (memberList != null && !memberList.isEmpty()) {
	            for (MeetingMemberVO meetingMember : memberList) {
	            	meetingMember.setBoNo(boardVO.getBoNo());
	                boardMapper.insertMeetingMember(meetingMember);
	            }
	        }
			
			//파일 저장
			List<MultipartFile> fileList = boardVO.getBoFileList();
			if(fileList != null && !fileList.isEmpty() && !fileList.get(0).isEmpty()) {
				
	            int fileGroupNo = fileService.uploadFiles(fileList, boardVO.getMemberNo(), 405);
	            if(fileGroupNo > 0) {
	                boardVO.setFileGroupNo(fileGroupNo);
	                boardMapper.updateBoardFileGroupNo(boardVO);
	            }
	        }
		}
		return ServiceResult.OK;
	}
	
	// 프로젝트 참여 멤버
	@Override
	public List<MemberVO> getProjectMemberList(int projectNo) {
		return boardMapper.getProjectMemberList(projectNo);
	}

	// 조회수 증가
	@Override
	public int increaseHitProjectBoard(int boNo) {
		return boardMapper.increaseHitProjectBoard(boNo);
	}
	
	// 게시글 상세 화면
	@Override
	public ProjectBoardVO detailProjectBoard(int boNo) {
		
		ProjectBoardVO boardVO = boardMapper.detailProjectBoard(boNo);
        if (boardVO != null && boardVO.getFileGroupNo() > 0) {
            List<FileDetailVO> fileList = fileMapper.selectFileDetailList(boardVO.getFileGroupNo());
            boardVO.setBoFileDetailList(fileList);
        }
        
        return boardVO;
	}
	
	//총 게시물 수
	@Override
	public int countProjectBoard(Map<String, Object> paramMap) {
		return boardMapper.countProjectBoard(paramMap);
	}

	// 게시글 수정
	@Transactional
	@Override
	public ServiceResult updateProjectBoard(ProjectBoardVO boardVO) {
		ServiceResult result = ServiceResult.FAILED;
		//게시글 수정
		int status = boardMapper.updateProjectBoard(boardVO);
		if(status > 0) {
			
		// 커뮤니티 공지사항 변경사항 알림
			if("NOTICE".equalsIgnoreCase(boardVO.getCategoryName())) {
			
			int projectNo = boardVO.getProjectNo();
			int writerNo = boardVO.getMemberNo(); 
			String notiTitle = boardVO.getBoTitle();
			int targetId = boardVO.getBoNo();
		
			// 프로젝트 알림 푸시 대상 조회 
			NotificationVO notiVO = new NotificationVO();
			notiVO.setProjectNo(projectNo);
			notiVO.setWriterNo(writerNo);
			
			
			// 프로젝트 구성원에게 커뮤니티 공지사항 알림 INSERT
			Map<String, Object> notiMap = new HashMap<>();
			
			notiMap.put("notiType", "NOTI_TASK");
			notiMap.put("targetId",targetId);
			notiMap.put("notiUrl", "/tudio/project/detail?projectNo=" + projectNo + "&tab=board");
			notiMap.put("notiMessage", "["+notiTitle+"] 프로젝트 공지가 변경되었습니다.");
			notiMap.put("projectNo", projectNo);
			notiMap.put("writerNo", writerNo);
 
			    notiService.pushProjectNotice(notiVO,notiMap);
			   
			} 
		  // 커뮤니티 공지사항 변경사항 알림 끝

			int boNo = boardVO.getBoNo();
			boardMapper.deleteBoardMinutes(boNo);
	        boardMapper.deleteMeetingMember(boNo);
	        
	        if("MINUTES".equals(boardVO.getCategoryName())) {
	            ProjectBoardMinutesVO minutesVO = boardVO.getBoardMinutesVO();
	            if(minutesVO != null) {
	                minutesVO.setBoNo(boNo);
	                boardMapper.insertBoardMinutes(minutesVO);
	            }
	            List<MeetingMemberVO> memberList = boardVO.getMeetingMemberList();
	            if (memberList != null && !memberList.isEmpty()) {
	                for (MeetingMemberVO mm : memberList) {
	                    mm.setBoNo(boNo);
	                    boardMapper.insertMeetingMember(mm);
	                }
	            }
	        }
	        
			List<MultipartFile> fileList = boardVO.getBoFileList();
			if (fileList != null && !fileList.isEmpty() && !fileList.get(0).isEmpty()) {
				List<FileDetailVO> oldFiles = fileMapper.selectFileDetailList(boardVO.getFileGroupNo());
				if(oldFiles != null && !oldFiles.isEmpty()) {
					for (FileDetailVO oldFile : oldFiles) {
						String relativePath = oldFile.getFilePath().replace("/upload/", "");
						File file = new File(uploadPath + relativePath);
                        if (file.exists()) {
                            file.delete(); // 실제 파일 삭제
                        }
					}
				}
				if (boardVO.getFileGroupNo() > 0) {
	                fileMapper.updateFileGroupDelete(boardVO.getFileGroupNo());
	            }
				int newFileGroupNo = fileService.uploadFiles(fileList, boardVO.getMemberNo(), 405);
				if (newFileGroupNo > 0) {
	                boardVO.setFileGroupNo(newFileGroupNo);
	                boardMapper.updateBoardFileGroupNo(boardVO);
	            }
			}
			result = ServiceResult.OK;
		}
		
		return result;	
	}

	//게시글 삭제
	@Override
	public ServiceResult deleteProjectBoard(int boNo) {
		ServiceResult result = ServiceResult.FAILED;
		//1.자식 테이블 삭제, 2.부모 테이블 삭제, 3. 물리적 파일 삭제
		ProjectBoardVO boardVO = boardMapper.detailProjectBoard(boNo);
		
		if (boardVO == null) {
	        return ServiceResult.FAILED;
	    }
		boardMapper.deleteBoardMinutes(boNo);  // 회의록 삭제
	    boardMapper.deleteMeetingMember(boNo); // 참석자 삭제
	    // boardMapper.deleteComments(boNo);	// 댓글 삭제
	    int status = boardMapper.deleteProjectBoard(boNo);
	    if (status > 0) {
	        // 4. 물리적 파일 삭제 및 파일 DB 정리
	        int fileGroupNo = boardVO.getFileGroupNo();
	        if (fileGroupNo > 0) {
	            // 파일 상세 리스트 조회
	            List<FileDetailVO> fileList = fileMapper.selectFileDetailList(fileGroupNo);
	            
	            if (fileList != null && !fileList.isEmpty()) {
	                for (FileDetailVO fileDetail : fileList) {
	                    // 서버 하드디스크의 실제 파일 삭제 (updateBoard에서 썼던 로직 활용)
	                    String relativePath = fileDetail.getFilePath().replace("/upload/", "");
	                    File file = new File(uploadPath + relativePath);
	                    if (file.exists()) {
	                        file.delete();
	                    }
	                }
	                // DB에서 파일 데이터 삭제 (논리 삭제 updateFileGroupDelete를 써도 되고, 실제 삭제를 써도 됩니다)
	                fileMapper.deleteProfileFile(fileGroupNo); 
	                fileMapper.deleteProfileGroup(fileGroupNo);
	            }
	        }
	        result = ServiceResult.OK;
	    }
		return result;
	}

	

}
