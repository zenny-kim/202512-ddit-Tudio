package kr.or.ddit.comment.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.CommentVO;

public interface ICommentService {

	// 댓글 등록
	public ServiceResult insertComment(CommentVO commentVO);
	
	// 댓글 목록
	public List<CommentVO> selectCommentList(CommentVO commentVO);
	
	// 댓글 수정 ( 대댓글 수정 포함 )
	public ServiceResult updateComment(CommentVO commentVO);
	
	// 댓글 삭제 ( 대댓글 삭제 포함 )
	public ServiceResult deleteComment(CommentVO commentVO);

	// 대댓글 등록
	public ServiceResult insertReplyComment(CommentVO commentVO);

	
	
	
}
