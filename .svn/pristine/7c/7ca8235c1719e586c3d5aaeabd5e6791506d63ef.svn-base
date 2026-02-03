package kr.or.ddit.videoChat.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.videoChat.mapper.IVideoChatMapper;
import kr.or.ddit.videoChat.service.IVideoChatService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.project.ProjectVO;

@Service
public class VideoChatServiceImpl implements IVideoChatService {
	
	@Autowired
	private IVideoChatMapper videoChatMapper;
	
	@Autowired
	private INotificationService notiService;
	
	
	@Override
    public List<ProjectVO> selectMemberProjectList(int memberNo) {
        return videoChatMapper.selectMemberProjectList(memberNo);
    }
	
	@Override
	public List<MemberVO> selectProjectMemberList(int projectNo, int loginMemberNo) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("projectNo", projectNo);
	    paramMap.put("loginMemberNo", loginMemberNo);
	    
	    return videoChatMapper.selectProjectMemberList(paramMap);
	}

    @Override
    @Transactional // 방 생성과 멤버 추가는 하나의 작업으로 처리
    public VideoChatVO createVideoChatRoom(VideoChatVO videoChatVO) {
        
        // UUID로 방 ID와 비밀번호 생성
        // String uuidId = UUID.randomUUID().toString();
        String customRoomId = generateRoomId();         
        String uuidPw = UUID.randomUUID().toString().substring(0, 8); // 비밀번호는 8자리만 끊어서 사용
        
        // videoChatVO.setVideochatId(uuidId);
        videoChatVO.setVideochatId(customRoomId);
        videoChatVO.setVideochatPw(uuidPw);
        
        // 방 DB 저장 (insertVideoChatRoom 실행 시 videochatNo가 VO에 담김)
        videoChatMapper.insertVideoChatRoom(videoChatVO);
        
               
        // [KMS]"알림용 초대 리스트"는 원본을 복사해서 따로 보관
        List<String> inviteListOnly = (videoChatVO.getInviteMemberList() == null)
                ? new ArrayList<>()
                : new ArrayList<>(videoChatVO.getInviteMemberList());
        
        // [KMS] DB에 넣을 멤버 리스트는 inviteListOnly 기반으로 만들고 방장 포함
        List<String> memberListNoti = new ArrayList<>(inviteListOnly);
        
        
        // 초대 멤버 리스트 구성
        // (화면에서 넘어온 초대자 리스트 + 방장 본인도 추가해야 함)
        List<String> memberList = videoChatVO.getInviteMemberList();
        if(memberList == null) memberList = new ArrayList<>();
        
        // 방 생성자도 멤버 테이블에 추가
        String createrNoStr = String.valueOf(videoChatVO.getVideochatCreaterNo());
        if(!memberList.contains(createrNoStr)) {
            memberList.add(createrNoStr);
        }

        Map<String, Object> map = new HashMap<>();
        map.put("videochatNo", videoChatVO.getVideochatNo());
        map.put("memberList", memberList);
        
        int result = videoChatMapper.insertVideoChatMember(map);
        
        // 알림 발송 시작 
        if (result > 0) {      
        	VideoChatVO notiParam = new VideoChatVO();
        	notiParam.setVideochatNo(videoChatVO.getVideochatNo());                 // PK
            notiParam.setVideochatCreaterNo(videoChatVO.getVideochatCreaterNo());   // 방장
        	notiParam.setInviteMemberList(inviteListOnly);                          //초대자만 (방장 제외)
        	notiParam.setVideochatUrl(videoChatVO.getVideochatUrl());           
        		
        	notiService.pushVideoInviteNoti(notiParam);
        }
        // 알림 발송 끝 

        return videoChatVO;
    }
	
	// 형식: R + 숫자(3) - 숫자(2) - 숫자(3) (R721-94-152)
    private String generateRoomId() {
        Random random = new Random();
        return String.format("R%03d-%02d-%03d", 
                random.nextInt(1000),  // 0~999
                random.nextInt(100),   // 0~99
                random.nextInt(1000)   // 0~999
        );
    }

	// 화상미팅 방 정보 조회
	@Override
    public Map<String, Object> getVideoChatInfo(String videochatId) {
        Map<String, Object> resultMap = new HashMap<>();
        
        // 화상미팅 방 정보 조회
        VideoChatVO roomInfo = videoChatMapper.selectVideoChatById(videochatId);
        
        // 유효하지 않은 방이면 null 반환 또는 예외 처리
        if(roomInfo == null) {
            return null; 
        }
        
        List<MemberVO> memberList = videoChatMapper.selectVideoChatMember(videochatId);
        int memberCount = memberList.size(); // 화상미팅 참여자
        
        resultMap.put("roomInfo", roomInfo);
        resultMap.put("memberList", memberList);
        resultMap.put("memberCount", memberCount);
        
        return resultMap;
    }
	
    /**
     * 방 유효성 체크
     */
    @Override
    public boolean checkRoomAccess(String roomId, String roomPw) {
        // DB에서 해당 ID와 PW를 가진 방이 존재하는지 카운트 조회
        int count = videoChatMapper.countRoomByIdAndPw(roomId, roomPw);
        return count > 0;
    }

    @Override
    public void selectVideoChatHistoryList(PaginationInfoVO<VideoChatVO> pagingVO, int memberNo) {
        // 사용자가 참여한 전체 화상회의 수 조회 (페이징 계산용)
        int totalRecord = videoChatMapper.selectVideoChatCount(memberNo);
        pagingVO.setTotalRecord(totalRecord);

        // 검색/페이징 파라미터 
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("pagingVO", pagingVO);
        paramMap.put("memberNo", memberNo);

        // 실제 페이지 분량의 데이터 조회
        List<VideoChatVO> dataList = videoChatMapper.selectVideoChatHistoryList(paramMap);
        
        pagingVO.setDataList(dataList);
    }
    
    @Override
    public int updateRoomStatusClosed(String videochatId) {
        return videoChatMapper.updateRoomStatusClosed(videochatId);
    }
    
    @Override
    public String getRoomNameById(String roomId) {
        return videoChatMapper.getRoomNameById(roomId);
    }

}
