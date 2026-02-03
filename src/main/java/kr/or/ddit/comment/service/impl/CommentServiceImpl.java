package kr.or.ddit.comment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.comment.mapper.ICommentMapper;
import kr.or.ddit.comment.service.ICommentService;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.NotificationSettingVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.project.ProjectBoardVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : CommentServiceImpl
 * DESC : 게시판, 업무 등 댓글 기능 공통 서비스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2026.01.14
 * 
 */

@Slf4j
@Service
public class CommentServiceImpl implements ICommentService {

	@Autowired
	private IFileService fileService;

	@Autowired
	private ICommentMapper commentMapper;

	@Autowired
	private INotificationService notiService;

	/**
	 * <p>
	 * 댓글 작성
	 * </p>
	 * 
	 * @date 2026.01.15
	 * @author [대덕인재개발원] team1 KSJ
	 * @param CommentVO     댓글내용, 작성자, 댓글타입 등
	 * @param ServiceResult OK:성공, FAILED :실패
	 */
	@Override
	public ServiceResult insertComment(CommentVO commentVO) {
		ServiceResult result = ServiceResult.FAILED;

		List<MultipartFile> fileList = commentVO.getCmtFileList();
		if (fileList != null && !fileList.isEmpty()) {
			boolean hasFile = false;
			for (MultipartFile f : fileList) {
				if (f.getSize() > 0 && f.getOriginalFilename() != null && !f.getOriginalFilename().isEmpty()) {
					hasFile = true;
					break;
				}
			}

			if (hasFile) {
				int fileGroupNo = fileService.uploadFiles(fileList, commentVO.getMemberNo(), 412);
				commentVO.setFileGroupNo(fileGroupNo);
			}
		}

		int status = commentMapper.insertComment(commentVO);
		if (status > 0) {
			result = ServiceResult.OK;

		// 커뮤니티 댓글 알림
			if ("B".equalsIgnoreCase(commentVO.getTargetType())) {
				int boNo = commentVO.getTargetId();
				int commentWriter = commentVO.getMemberNo();

				ProjectBoardVO vo = notiService.notiCommentNoti(boNo);
				int writerNo = vo.getWriterNo();
				String notiTitle = vo.getBoTitle();
				int projectNo = vo.getProjectNo();
				String categoryName = vo.getCategoryName();
				String projectName = vo.getProjectName();

				NotificationSettingVO notiMem = notiService.notiAllMember(writerNo);
				int boardWriter = notiMem.getMemberNo();

				if (commentWriter != boardWriter) {
					NotificationVO notiVO = new NotificationVO();
					notiVO.setMemberNo(boardWriter);
					notiVO.setTargetId(boNo);
					notiVO.setNotiUrl("/tudio/project/detail?projectNo=" + projectNo + "&tab=board");
		
					String notiType = "";
					String notiMessage = "";

					if ("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("자유").equals(categoryName)) {
						notiType = "NOTI_ETC";
						notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
						projectName = "";
					} else if ("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("회의").equals(categoryName)) {
						notiType = "NOTI_ETC";
						notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
						projectName = "";
					} else if ("Y".equalsIgnoreCase(notiMem.getNotiProjectNotice()) && ("공지").equals(categoryName)) {
						notiType = "NOTI_TASK";
						notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
					}

					notiVO.setNotiCategory(projectName);
					notiVO.setNotiType(notiType);
					notiVO.setNotiMessage(notiMessage);

					int cnt = notiService.insertNotification(notiVO);
				}

			}
		// 커뮤니티 댓글 알림 끝	
			

		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * <p>
	 * 댓글 목록
	 * </p>
	 * 
	 * @date 2026.01.15
	 * @author [대덕인재개발원] team1 KSJ
	 * @param CommentVO 댓글번호
	 */
	@Override
	public List<CommentVO> selectCommentList(CommentVO commentVO) {
		return commentMapper.selectCommentList(commentVO);
	}

	/**
	 * <p>
	 * 댓글 수정
	 * </p>
	 * 
	 * @date 2026.01.15
	 * @author [대덕인재개발원] team1 KSJ
	 * @param CommentVO 댓글번호
	 * @return ServiceResult OK:삭제 성공, FAILED:삭제 실패
	 */
	@Override
	public ServiceResult updateComment(CommentVO commentVO) {
		ServiceResult result = null;
		int status = commentMapper.updateComment(commentVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * <p>
	 * 댓글 삭제
	 * </p>
	 * 
	 * @date 2026.01.15
	 * @author [대덕인재개발원] team1 KSJ
	 * @param CommentVO 댓글번호
	 * @return ServiceResult OK:삭제 성공, FAILED:삭제 실패
	 */
	@Override
	public ServiceResult deleteComment(CommentVO commentVO) {
		ServiceResult result = null;
		int status = commentMapper.deleteComment(commentVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * <p>
	 * 대댓글 등록
	 * </p>
	 * 
	 * @date 2026.01.15
	 * @author [대덕인재개발원] team1 KSJ
	 * @param CommentVO 댓글번호
	 * @return ServiceResult OK:성공, FAILED:실패
	 */
	@Override
	public ServiceResult insertReplyComment(CommentVO commentVO) {
		ServiceResult result = ServiceResult.FAILED;
		List<MultipartFile> fileList = commentVO.getCmtFileList();
		if (fileList != null && !fileList.isEmpty()) {
			boolean hasFile = false;
			for (MultipartFile f : fileList) {
				if (f.getSize() > 0 && f.getOriginalFilename() != null && !f.getOriginalFilename().isEmpty()) {
					hasFile = true;
					break;
				}
			}

			if (hasFile) {
				// 동일하게 파일 저장 호출
				int fileGroupNo = fileService.uploadFiles(fileList, commentVO.getMemberNo(), 413);
				commentVO.setFileGroupNo(fileGroupNo);
			}
		}
		int status = commentMapper.insertReplyComment(commentVO);

		if (status > 0) {
			result = ServiceResult.OK;


		// 커뮤니티 답글 알림 	
			if("B".equalsIgnoreCase(commentVO.getTargetType())) {
				int boNo = commentVO.getTargetId();
				int commentWriter = commentVO.getMemberNo();
				
				Map<String, Object> notiMap = new HashMap<>();
				
				notiMap.put("parentCmtNo", commentVO.getCmtNo());
				notiMap.put("boNo", boNo);

				// 부모 댓글 조회하기
				Map<String, Object> parentCom= notiService.selectNotiReply(notiMap);
				
				int replyReceiver = Integer.parseInt(parentCom.get("memberNo").toString());	//// ROOTC.MEMBER_NO
				int projectNo = Integer.parseInt(parentCom.get("projectNo").toString());
				String cmtContent = (String) parentCom.get("cmtContent");
				String categoryName= (String) parentCom.get("categoryName");
				String projectName= (String) parentCom.get("projectName");
				
				NotificationSettingVO notiMem =notiService.notiAllMember(replyReceiver);
				
				int boardWriter = notiMem.getMemberNo();
				
				 if( commentWriter != boardWriter) {
					 NotificationVO notiVO = new NotificationVO();
					 notiVO.setMemberNo(replyReceiver);
					 notiVO.setTargetId(boNo);
					 notiVO.setNotiUrl("/tudio/project/detail?projectNo=" + projectNo + "&tab=board");
					 
					 String notiType = "";
					 String notiMessage = "";
					 
					 if("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("FREE").equals(categoryName)) {
						 notiType ="NOTI_ETC";
						 notiMessage= "["+cmtContent+"]에 답글이 달렸습니다.";
						 projectName="";
					 } else if("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("MINUTES").equals(categoryName)){
						 notiType ="NOTI_ETC";
						 notiMessage= "["+cmtContent+"]에 답글이 달렸습니다.";
						 projectName="";
					 } else if("Y".equalsIgnoreCase(notiMem.getNotiProjectNotice()) && ("NOTICE").equals(categoryName)) {
						 notiType = "NOTI_TASK";
						 notiMessage= "["+cmtContent+"]에 답글이 달렸습니다.";
					 }
					 
					  notiVO.setNotiCategory(projectName);
					  notiVO.setNotiType(notiType);
					  notiVO.setNotiMessage(notiMessage);

					int cnt= notiService.insertNotification(notiVO);
					
					if(cnt > 0) {	// 대댓글을 달았고 댓글 작성자한테 알림 보내기 성공 시
						ProjectBoardVO vo = notiService.notiCommentNoti(boNo);
						String notiTitle = vo.getBoTitle();
						notiVO.setMemberNo(vo.getWriterNo());
						if ("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("FREE").equals(categoryName)) {
							notiType = "NOTI_ETC";
							notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
							projectName = "";
						} else if ("Y".equalsIgnoreCase(notiMem.getNotiBoComment()) && ("MINUTES").equals(categoryName)) {
							notiType = "NOTI_ETC";
							notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
							projectName = "";
						} else if ("Y".equalsIgnoreCase(notiMem.getNotiProjectNotice()) && ("NOTICE").equals(categoryName)) {
							notiType = "NOTI_TASK";
							notiMessage = "[" + notiTitle + "]에 댓글이 달렸습니다.";
						}
						
						notiVO.setNotiCategory(projectName);
						notiVO.setNotiType(notiType);
						notiVO.setNotiMessage(notiMessage);
						notiService.insertNotification(notiVO);
					}
				 }
				 	
			}
		// 커뮤니티 답글 알림 끝  		
			
			
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

}
