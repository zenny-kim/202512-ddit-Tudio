package kr.or.ddit.chat.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.chat.ChatMemberVO;
import kr.or.ddit.vo.chat.ChatVO;
import kr.or.ddit.vo.chat.ChatroomVO;

@Mapper
public interface IChatMapper {

	public List<ChatroomVO> selectChatroomList(int memberNo);

	public List<ChatVO> selectChatList(ChatVO chatVo);

	public Map<String, Object> selectChatroomTitle(ChatVO chatVo);

	public List<MemberVO> selectProjectMemberList(ChatVO chatVo);

	public int insertChatroom(ChatroomVO chatroomVo);

	public void insertChatMember(ChatMemberVO chatMemberVo);

	public int insertChat(ChatVO chatVo);

	public void updateLastChat(ChatroomVO chatroomVo);

	public void updateLastReadChatNo(ChatVO chatVo);

	public List<Integer> selectChatroomMemList(int chatroomNo);

	public void insertSystemChat(ChatVO chatVo);

	public int deleteChatMember(Map<String, Object> deleteInfo);

	public int updateChatroom(int chatroomNo);

	public int deleteChatroom(int chatroomNo);

	public int deleteAllChat(int chatroomNo);

	public void updateChatroomInfo(Map<String, Object> inviteInfo);

	public int selectNotReadChatCnt(int memberNo);
	
	public int selectIsExistChatroom(Map<String, Integer> memberNoMap);
	
	public int selectLastReadChatNo(ChatMemberVO chatMemberVo);
	
	public int selectRoomLastChatNo(int chatroomNo);
}
