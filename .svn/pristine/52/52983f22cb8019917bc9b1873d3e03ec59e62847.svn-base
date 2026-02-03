package kr.or.ddit.videoChat.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.project.ProjectVO;

public interface IVideoChatService {
	
	// 사용자 참여중인 프로젝트 목록 조회
	public List<ProjectVO> selectMemberProjectList(int memberNo);
	
	// 선택한 프로젝트의 프로젝트 관리자, 기업관리자 목록 조회
	public List<MemberVO> selectProjectMemberList(int projectNo, int loginMemberNo);
	
	// 채팅방 생성
	public VideoChatVO createVideoChatRoom(VideoChatVO videoChatVO);
	
	// 채팅방 정보 조회 (화상미팅 방 정보 및 인원수 조회)
    public Map<String, Object> getVideoChatInfo(String videochatId);

    // 방 유효성 체크
	public boolean checkRoomAccess(String roomId, String roomPw);

	// 화상미팅 이력 조회
	public void selectVideoChatHistoryList(PaginationInfoVO<VideoChatVO> pagingVO, int memberNo);

	// 화상미팅 종료 (상태 업데이트)
	public int updateRoomStatusClosed(String roomId);

	// 화상미팅 방 이름 조회
	public String getRoomNameById(String roomId);
}
