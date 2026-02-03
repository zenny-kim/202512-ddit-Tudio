package kr.or.ddit.videoChat.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.project.ProjectVO;

@Mapper
public interface IVideoChatMapper {
	
	// 사용자 참여중인 프로젝트 목록 조회
	public List<ProjectVO> selectMemberProjectList(int memberNo);
	
	// 프로젝트 구성원 조회
    public List<MemberVO> selectProjectMemberList(Map<String, Object> paramMap);

    // 화상미팅 방 등록
	public int insertVideoChatRoom(VideoChatVO videoChatVO);

	// 화상미팅 방 참여자 등록
	public int insertVideoChatMember(Map<String, Object> map);
	
	// 방 정보 조회
    public VideoChatVO selectVideoChatById(String videochatId);

    // 참여자 수 조회
    public int countVideoChatMember(String videochatId);

    // 방 유효성 체크
	public int countRoomByIdAndPw(String roomId, String roomPw);

	// 방 초대 정보 조회
	public List<MemberVO> selectVideoChatMember(String videochatId);

	// 화상미팅 이력 개수 조회 (목록 페이징)
	public int selectVideoChatCount(int memberNo);

	// 화상미팅 이력 조회
	public List<VideoChatVO> selectVideoChatHistoryList(Map<String, Object> paramMap);

	// 화상미팅 종료 (상태 업데이트)
	public int updateRoomStatusClosed(String videochatId);

	// 화상미팅 방 이름 조회 (리액트 화면 표시)
	public String getRoomNameById(String roomId);
	
}
