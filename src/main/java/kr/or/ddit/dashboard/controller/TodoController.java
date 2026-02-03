package kr.or.ddit.dashboard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.or.ddit.dashboard.service.ITodoService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.TodoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/tudio/dashboard/todo")
public class TodoController {
	
	@Autowired
	private ITodoService todoService;
	
	/**
     * 투두리스트 목록 조회는 WidgetController에서 처리
     */

    /**
     * 투두 리스트 등록
     * @param todoVO
     * @param loginMember
     * @return
     */
    @PostMapping("/insert")
    public ResponseEntity<String> createTodo(@RequestBody TodoVO todoVO, 
                                             @SessionAttribute("loginUser") MemberVO loginMember) {
        if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
        
        try {
        	log.info("createTodo() 실행...!");
        	
            todoVO.setMemberNo(loginMember.getMemberNo());           
            int cnt = todoService.insertTodo(todoVO);
            return cnt > 0 ? ResponseEntity.ok("OK") : ResponseEntity.ok("FAIL");
        } catch (Exception e) {
            log.error("투두 등록 실패", e);
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 투두 리스트 상태 변경 [완료/미완료]
     */
    @PostMapping("/updateStatus")
    public ResponseEntity<String> updateTodoStatus(@RequestBody TodoVO todoVO,
    		@SessionAttribute("loginUser") MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
    	
        try {
        	log.info("updateTodoStatus() 실행...!");
        	
        	todoVO.setMemberNo(loginMember.getMemberNo());   
            int cnt = todoService.updateTodoStatus(todoVO);
            return cnt > 0 ? ResponseEntity.ok("OK") : ResponseEntity.ok("FAIL");
        } catch (Exception e) {
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * 투두 리스트 내용 수정 
     * @param todoVO 수정할 투두 리스트 정보
     * @return
     */
    @PostMapping("/updateContent")
    public ResponseEntity<String> updateTodoContent(@RequestBody TodoVO todoVO,
    		@SessionAttribute("loginUser") MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
    	
        try {
        	log.info("updateTodoContent() 실행...!");
        	
        	todoVO.setMemberNo(loginMember.getMemberNo());   
            int cnt = todoService.updateTodoContent(todoVO);
            return cnt > 0 ? ResponseEntity.ok("OK") : ResponseEntity.ok("FAIL");
        } catch (Exception e) {
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 투두 리스트 삭제
     * @param todoVO 삭제할 투두 리스트 정보
     * @return
     */
    @PostMapping("/delete")
    public ResponseEntity<String> deleteTodo(@RequestBody TodoVO todoVO,
    										 @SessionAttribute("loginUser") MemberVO loginMember) {
    	if (loginMember == null) return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);	// 401
    	
        try {
        	log.info("deleteTodo() 실행...!");
        	
        	todoVO.setMemberNo(loginMember.getMemberNo());   
            int cnt = todoService.deleteTodo(todoVO);
            return cnt > 0 ? ResponseEntity.ok("OK") : ResponseEntity.ok("FAIL");
        } catch (Exception e) {
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
