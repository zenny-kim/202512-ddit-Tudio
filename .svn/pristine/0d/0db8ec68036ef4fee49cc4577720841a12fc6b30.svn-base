package kr.or.ddit.comment.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CommentVO;

@Mapper
public interface ICommentMapper {

	// 댓글 등록
	public int insertComment(CommentVO commentVO);
	
	// 댓글 목록
	public List<CommentVO> selectCommentList(CommentVO commentVO);
	
	// 댓글 수정 ( 대댓글 수정 포함 )
	public int updateComment(CommentVO commentVO);

	// 댓글 삭제 ( 대댓글 삭제 포함 )
	public int deleteComment(CommentVO commentVO);
	
	// 대댓글 등록
	public int insertReplyComment(CommentVO commentVO);
	
	
}
