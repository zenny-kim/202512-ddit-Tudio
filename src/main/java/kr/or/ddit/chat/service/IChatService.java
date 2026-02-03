package kr.or.ddit.chat.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.chat.ChatMemberVO;
import kr.or.ddit.vo.chat.ChatVO;
import kr.or.ddit.vo.chat.ChatroomVO;

public interface IChatService {

	public List<ChatroomVO> selectChatroomList(int memberNo);

	public List<ChatVO> selectChatList(ChatVO chatVo);

	public Map<String, Object> selectChatroomTitle(ChatVO chatVo);

	public List<MemberVO> selectProjectMemberList(ChatVO chatVo);

	public ServiceResult insertChatroom(
			ChatroomVO chatroomVo, 
			Map<String, Integer> privateMemberNoMap, 
			Map<String, String> privateMemberNameMap);

	public ServiceResult insertChat(ChatVO chatVo);

	public List<Integer> selectChatroomMemList(int chatroomNo);

	public Map<String, Object> deleteChatMember(Map<String, Object> deleteInfo);

	public ChatVO insertChatMember(ChatroomVO chatroomVo);

	public void updateLastReadChatNo(ChatVO chatVo);

	public int selectNotReadChatCnt(int memberNo);

	public int selectIsExistChatroom(Map<String, Integer> memberNoMap);

	public int selectLastReadChatNo(ChatMemberVO chatMemberVo);

	public int selectRoomLastChatNo(int chatroomNo);


}
