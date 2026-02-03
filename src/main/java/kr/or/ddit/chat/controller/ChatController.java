package kr.or.ddit.chat.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.chat.service.IChatService;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.member.controller.AuthController;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.chat.ChatMemberVO;
import kr.or.ddit.vo.chat.ChatVO;
import kr.or.ddit.vo.chat.ChatroomVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ChattingController
 * DESC : 채팅 컨트롤러 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KJS
 * @version 1.0, 2025.12.26
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/chat")
public class ChatController {
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private IChatService chatService;
	
	@Autowired
	private IFileService fileService;
	
	// 특정 Broker로 메세지 전달
	@Autowired
	private SimpMessagingTemplate template;
	
	// 반복되는 리터럴 문자열을 final 변수로 만듦
	private static final String LOGIN_USER = "loginUser";

	//일반 파일 경로 (C:/upload/)
	@Value("${kr.or.ddit.upload.path}")
    private String uploadPath;
	
	//이미지 파일 경로 (svn = src/main/webapp/upload/)
	@Value("${kr.or.ddit.imageUpload.path}")
    private String imageUploadPath;
	
	/**
	 * 채팅 버튼이 있는 메인 화면 조회
	 * @return main.jsp 주소
	 */
	@GetMapping("/main")
	public String chatMain() {
		return "chat/main";
	}
	
	/**
	 * 로그인한 유저의 안읽은 모든 채팅 개수 
	 * @param session
	 * @return 안읽은 모든 채팅 개수
	 */
	@GetMapping("/allNotReadCnt")
	@ResponseBody
	public int allNotReadCnt(HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		int allNotReadCnt = 0;
		if(loginUser != null) {
			allNotReadCnt = chatService.selectNotReadChatCnt(loginUser.getMemberNo());
		}
		return allNotReadCnt;
	}
	
	
	/**
	 * 채팅방 생성 화면 조회
	 * @param model
	 * @param session
	 * @return new.jsp 주소
	 */
	@GetMapping("/new")
	public String newChatroom(Model model, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			ChatVO chatVo = new ChatVO();
			chatVo.setMemberNo(loginUser.getMemberNo());
			
			List<MemberVO> memberList = chatService.selectProjectMemberList(chatVo);
			model.addAttribute("memberList", memberList);
			model.addAttribute("myName", loginUser.getMemberName());
		}
		return "chat/new";
	}
	
	/**
	 * 새로운 채팅방 생성
	 * @param chatroomVo
	 * @param session
	 * @return 성공 여부와 채팅방 번호를 담은 map
	 */
	@PostMapping("/new")
	public ResponseEntity<Map<String, Object>> insertNewChatroom(
			@RequestBody ChatroomVO chatroomVo, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		ServiceResult result = null;
		
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			Map<String, Integer> privateMemberNoMap = new HashMap<>();
			Map<String, String> privateMemberNameMap = new HashMap<>();

			// 개인 채팅방으로 생성한 경우, 
			if(chatroomVo.getChatroomType().equals("PRIVATE")) {
				// 채팅방의 존재여부를 확인하기 위한 map에 값 넣기 & 채팅방 이름 생성을 위한 map에 값 넣기
				privateMemberNoMap.put("youMemNo", chatroomVo.getChatMemberNoList().get(0));
				privateMemberNameMap.put("youMemName", chatroomVo.getChatMemberNameList().get(0));
			}
			
			chatroomVo.getChatMemberNoList().add(loginUser.getMemberNo());
			chatroomVo.getChatMemberNameList().add(loginUser.getMemberName());
			privateMemberNoMap.put("myMemNo", loginUser.getMemberNo());
			privateMemberNameMap.put("myMemName", loginUser.getMemberName());
			
			int existChatroomNo = chatService.selectIsExistChatroom(privateMemberNoMap);
			
			if(existChatroomNo > 0) {
				result = ServiceResult.OK;
				map.put("chatroomNo", existChatroomNo);
			}else {
				result = chatService.insertChatroom(chatroomVo, privateMemberNoMap, privateMemberNameMap);
				map.put("chatroomNo", chatroomVo.getChatroomNo());
			}
			
			map.put("result", result);
		}
		return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
	}
	
	/**
	 * 현재 로그인된 회원의 채팅방 목록 조회
	 * @param model
	 * @param session
	 * @return list.jsp 주소
	 */
	@GetMapping("/list")
	public String chatroomList(Model model, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			List<ChatroomVO> chatroomList = chatService.selectChatroomList(loginUser.getMemberNo());
			model.addAttribute("chatroomList", chatroomList);
			model.addAttribute("memberNo", loginUser.getMemberNo());
		}
		return "chat/list";
	}
	
	/**
	 * 사용자가 검색한 채팅방 목록 조회 
	 * @param session
	 * @return 채팅방 리스트
	 */
	@GetMapping("/list/search")
	public ResponseEntity<List<ChatroomVO>> searchChatroomList(HttpSession session){
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		List<ChatroomVO> searchChatroomList = null;
		if(loginUser != null) {
//			searchChatroomList = chatService.selectSearchRoomList();
		}
		
		return new ResponseEntity<>(searchChatroomList, HttpStatus.OK);
	}
	
	/**
	 * 특정 채팅방의 마지막으로 읽은 채팅 번호 업데이트
	 * @param chatVo
	 * @param session
	 */
	@PostMapping("/update/lastReadChatNo")
	@ResponseBody
	public void updateLastReadChatNo(@RequestBody ChatVO chatVo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			chatVo.setMemberNo(loginUser.getMemberNo());
			chatService.updateLastReadChatNo(chatVo);
		}
	}
	
	/**
	 * chatroomNo에 해당하는 채팅방 상세 화면 조회
	 * @param chatVo
	 * @param model
	 * @param session
	 * @return chatroom.jsp 주소
	 */
	@GetMapping("/chatroom/{chatroomNo}")
	public String chatroom(
			ChatVO chatVo, Model model, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			chatVo.setMemberNo(loginUser.getMemberNo());
			List<MemberVO> memberList = chatService.selectProjectMemberList(chatVo);
			List<ChatVO> chatList = chatService.selectChatList(chatVo);
			Map<String, Object> chatroomTitle = chatService.selectChatroomTitle(chatVo);
			
			model.addAttribute("chatList", chatList);
			model.addAttribute("chatroomTitle", chatroomTitle);
			model.addAttribute("memberList", memberList);
			model.addAttribute("myMemNo", loginUser.getMemberNo());
			model.addAttribute("myName", loginUser.getMemberName());
		}
		return "chat/chatroom";
	}

	/**
	 * 채팅방에 멤버 초대하기 
	 * @param chatroomVo
	 * @param session
	 * @return 변경된 채팅방 인원수
	 */
	@PostMapping("/invite")
	public ResponseEntity<String> inviteMember(
			@RequestBody ChatroomVO chatroomVo, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		String memCount = null; 
		if(loginUser != null) {
			chatroomVo.setInviter(loginUser.getMemberName());
			ChatVO systemChat = chatService.insertChatMember(chatroomVo);
			
			Map<String, Object> changeTitle = chatService.selectChatroomTitle(systemChat);
			memCount = String.valueOf(changeTitle.get("MEM_COUNT"));
			
			String chatUrl = "/sub/chat/chatroom/" + chatroomVo.getChatroomNo();
			template.convertAndSend(chatUrl, systemChat);
		}
		return new ResponseEntity<String>(memCount, HttpStatus.OK);
	}
	
	/**
	 * 채팅방 나가기 (특정 chatMember 삭제)
	 * @param deleteInfo chatroomNo, memberNo(나가는 사람)가 담겨있음
	 * @param model
	 * @param session
	 * @return delete 결과
	 */
	@PostMapping("/chatroom/exit")
	public ResponseEntity<ServiceResult> exitChatroom(
			@RequestBody Map<String, Object> deleteInfo, Model model, HttpSession session){
		ServiceResult result = null;
		
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		if(loginUser != null) {
			Map<String, Object> delResultMap = chatService.deleteChatMember(deleteInfo);
			result = (ServiceResult) delResultMap.get("result");
			// 실시간으로 해당 채팅방의 모든 사용자에게 퇴장 메세지 전송
			String chatUrl = "/sub/chat/chatroom/" + (int)deleteInfo.get("chatroomNo");
			template.convertAndSend(chatUrl, delResultMap.get("chatVo"));
		}
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);
	}
	
	/**
	 * 사용자의 화면상에 출력되어 있는 채팅보다 더 이전 채팅 목록들을 조회
	 * @param chatVo
	 * @param session
	 * @return List<ChatVO>와 상태코드를 담은 ResponseEntity 객체
	 */
	@GetMapping("/chatroom/oldchat")
	@ResponseBody
	public ResponseEntity<List<ChatVO>> oldChats(ChatVO chatVo, HttpSession session){
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		ResponseEntity<List<ChatVO>> entity = null;
		
		if(loginUser != null) {
			chatVo.setMemberNo(loginUser.getMemberNo());
			List<ChatVO> chatList =  chatService.selectChatList(chatVo);
			entity = new ResponseEntity<List<ChatVO>>(chatList, HttpStatus.OK);
		}
		
		return entity;
	}
	
	/**
	 * 채팅으로 전송된 파일 저장 및 다른 사용자들에게 파일 주소 전송
	 * @param file
	 * @return
	 */
	@PostMapping("/file/upload")
	public ResponseEntity<List<FileDetailVO>> uploadFile(List<MultipartFile> fileList, HttpSession session){
		MemberVO loginUser = (MemberVO) session.getAttribute(LOGIN_USER);
		List<FileDetailVO> fileDetailList = null;
		if(loginUser != null) {
			int fileGroupNo = fileService.uploadFiles(fileList, loginUser.getMemberNo(), 407);
			fileDetailList = fileService.selectFileDetailList(fileGroupNo);
			log.info("myLog" + fileGroupNo);
		}
		
		return new ResponseEntity<List<FileDetailVO>>(fileDetailList, HttpStatus.OK);
	}
	
	/**
	 * 채팅으로 받은 파일 다운로드
	 * @param fileNo
	 * @param response
	 * @throws IOException 
	 */
	@GetMapping("/download")
	public void fileDownload(@RequestParam("fileNo") int fileNo, HttpServletResponse response) throws IOException {
		// DB에서 파일 정보 조회
	    FileDetailVO fileVO = fileService.selectFileDetail(fileNo);
	    if (fileVO == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "DB 파일 정보 없음");
            return;
        }
	    // 실제 물리 파일 찾기
	    String dbPath = fileVO.getFilePath();
        File file = null;
	    
        // DB 경로 /local/ 들어가는 파일 : C드라이브 파일
        if (dbPath != null && dbPath.startsWith("/local/")) {
            String realFileName = dbPath.replace("/local/", "");
            file = new File(uploadPath + realFileName);
        } else {
            // DB 경로 /upload/ 시작 파일 : svn 내부 저장 이미지
            String realPath = servletContext.getRealPath(dbPath);
            file = new File(realPath);
        }

        // 파일 여부 확인
        if (!file.exists()) {
            log.error("파일이 존재하지 않습니다. 경로: {}", file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
            return;
        }

        // 다운로드
        String encodedName = URLEncoder.encode(
            fileVO.getFileOriginalName(), "UTF-8"
        ).replaceAll("\\+", "%20"); // 공백 처리

        response.setContentType("application/octet-stream");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"" + encodedName + "\""
        );
        response.setContentLengthLong(file.length());

        // 사용자에게 파일 데이터 전송
        FileUtils.copyFile(file, response.getOutputStream());
	
	}
	
	/**
	 * Client가 보낸 메세지를 전송해줌
	 * @param chatVo
	 */
	// RequestMapping과는 상관없이 해당 주소로 오는 메세지를 받음 : /pub/chat/message
	@MessageMapping("/chat/message")	
	public void message(ChatVO chatVo) {
		chatService.insertChat(chatVo);
		List<Integer> memNoList = chatService.selectChatroomMemList(chatVo.getChatroomNo());
		
		String chatUrl = "/sub/chat/chatroom/" + chatVo.getChatroomNo();
		template.convertAndSend(chatUrl, chatVo);
		for(int memNo : memNoList) {
			String roomListUrl = "/sub/newChat/alarm/" + memNo;
			template.convertAndSend(roomListUrl, chatVo);
		}
	}

}
