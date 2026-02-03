package kr.or.ddit.videoChat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.or.ddit.member.service.impl.CustomUser;
import kr.or.ddit.util.JwtUtil;
import kr.or.ddit.videoChat.service.IVideoChatService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.VideoChatVO;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin(origins = "http://3.34.194.219:5173")
@Slf4j
@Controller
@RequestMapping("/tudio/videoChat")
public class VideoChatController {

	@Autowired
	private IVideoChatService videoChatService;
	
	@Autowired 
	private JwtUtil jwtUtil;
	
	/**
	 * 화상미팅 메인 화면
	 * @param model
	 * @param loginMember 로그인한 회원 정보
	 * @return 화상미팅 메인 페이지
	 */
	@GetMapping("/list")
	public String videChatMain(
	        @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
	        Model model, 
	        @SessionAttribute("loginUser") MemberVO loginMember) {
	    
	    int memberNo = loginMember.getMemberNo();
	    
	    // 페이징 정보 설정
	    PaginationInfoVO<VideoChatVO> pagingVO = new PaginationInfoVO<>(10, 5);
	    pagingVO.setCurrentPage(currentPage);
	    
	    // 데이터 및 전체 레코드 수 조회
	    // - memberNo를 넘겨 내가 초대된 회의 목록만 가져오도록 설정
	    videoChatService.selectVideoChatHistoryList(pagingVO, memberNo);
	    
	    // 프로젝트 목록 조회 (방 생성 모달용)
	    List<ProjectVO> projectList = videoChatService.selectMemberProjectList(memberNo);
	    
	    model.addAttribute("pagingVO", pagingVO); 
	    model.addAttribute("projectList", projectList);
	    
	    return "videoChat/list";
	}
	
	
	/**
	 * 화상미팅 초대를 위한 프로젝트 구성원 조회
	 */
	@ResponseBody
	@PostMapping("/getProjectMembers")
	public List<MemberVO> getProjectMembers(@RequestBody Map<String, Integer> data, 
	                                        @SessionAttribute("loginUser") MemberVO loginMember) {
	    int projectNo = data.get("projectNo");
	    int loginMemberNo = loginMember.getMemberNo(); 
	    
	    return videoChatService.selectProjectMemberList(projectNo, loginMemberNo);
	}
	
	
	/**
	 * 화상미팅 방 생성 요청
	 * @param videoChatVO 화상미팅 방 및 참여자 정보
	 * @param loginMember 방 생성자 정보
	 * @return
	 */
    @ResponseBody
    @PostMapping("/create")
    public VideoChatVO createRoom(@RequestBody VideoChatVO videoChatVO, @SessionAttribute("loginUser") MemberVO loginMember) {
        
        // 로그인한 사용자(방 생성자) 정보
        int memberNo = loginMember.getMemberNo();
        
        videoChatVO.setVideochatCreaterNo(memberNo);
        
        // 방 ID 및 비밀번호 UUID 생성 및 데이터베이스 저장
        VideoChatVO createdRoom = videoChatService.createVideoChatRoom(videoChatVO);
        
        return createdRoom;
    }
    
    
    /**
     * 화상미팅 대기 화면
     * @param roomId 생성한 방 ID
     * @param model
     * @return
     */
    @GetMapping("/waitingRoom")
    public String waitingRoom(@RequestParam("roomId") String roomId, Model model) {
        
        // 방 정보 및 참여자 수 조회
        Map<String, Object> chatInfo = videoChatService.getVideoChatInfo(roomId);
        
        // 유효성 검사 (방이 존재하지 않거나 잘못된 UUID일 경우)
        if (chatInfo == null) {
            // 화상미팅 초기 페이지로 이동
            return "redirect:/tudio/videoChat/list";
        }
        
        model.addAttribute("roomInfo", chatInfo.get("roomInfo"));
        model.addAttribute("memberCount", chatInfo.get("memberCount"));
        model.addAttribute("memberList", chatInfo.get("memberList"));
        
        return "videoChat/waitingRoom";
    }
    
    
    /**
     * 리액트 화상미팅 진입
     * URL: /tudio/videoChat/room/{roomId}
     */	
    @GetMapping("/room/{roomId}")
    public String enterMeetingRoom(@PathVariable("roomId") String roomId) {
    	
    	// 방 정보를 조회하여 비밀번호(roomPw) 정보 가져오기 
        Map<String, Object> chatInfo = videoChatService.getVideoChatInfo(roomId);
        if (chatInfo == null || chatInfo.get("roomInfo") == null) {
        	// 방이 없으면 리스트 페이지로 리다이렉트
            return "redirect:/tudio/videoChat/list";
        }
        
        // VideoChatVO에서 실제 비밀번호 추출
        VideoChatVO vo = (VideoChatVO) chatInfo.get("roomInfo");
        String roomPw = vo.getVideochatPw();
        
        // 사용자 정보 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUser user = (CustomUser) auth.getPrincipal();
        MemberVO member = user.getMemberVO();

        // 토큰 생성 (이름, 번호)
        String token = jwtUtil.generateToken(
            member.getMemberId(), 
            member.getMemberNo(), 
            member.getMemberName()
        );

        // 토큰만 전달
        /*
        String reactUrl = "http://localhost:5173/video/room/" + roomId 
                		+ "?token=" + token;
        */
        String reactUrl = "http://3.34.194.219:5173/video/room/" + roomId 
                + "?token=" + token
                + "&roomPw=" + roomPw;
        
        log.info("▶▶▶ 리액트로 이동: {}", reactUrl);
        
        return "redirect:" + reactUrl;
    }
    
    
    /**
     * 화상미팅 방 입장 유효성 검사
     * @param roomData 방 ID, 비밀번호
     * @return
     */
    @ResponseBody
    @PostMapping("/checkRoom")
    public boolean checkRoom(@RequestBody Map<String, String> roomData) {
        String roomId = roomData.get("roomId");
        String roomPw = roomData.get("roomPw");
        
        // 일치 여부 반환
        return videoChatService.checkRoomAccess(roomId, roomPw);
    }
    
    
    /**
     * 화상미팅 방 종료 
     * - Node.js 서버 호출
     * @param data
     * @return
     */
    @ResponseBody
    @PostMapping("/closeRoom")
    public String closeRoom(@RequestBody Map<String, String> data) {
        String roomId = data.get("roomId");
        log.info("▶▶▶ 화상미팅 종료 요청 수신: {}", roomId);
        
        // 상태를 2(종료)로 변경
        videoChatService.updateRoomStatusClosed(roomId);
        
        return "SUCCESS";
    }
    
    
    /**
     * 화상미팅 방 정보 조회
     * @param roomId 화상미팅 방 ID(UUID)
     * @return rootName 화상미팅 방 이름
     */
    @GetMapping("/getRoomInfo/{roomId}")
    @ResponseBody
    public Map<String, Object> getRoomInfo(@PathVariable String roomId) {
        Map<String, Object> result = new HashMap<>();
        String name = videoChatService.getRoomNameById(roomId); 
        result.put("roomName", name);
        return result;
    }
}
