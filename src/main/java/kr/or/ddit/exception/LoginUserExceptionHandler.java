package kr.or.ddit.exception;

import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class LoginUserExceptionHandler {

    @ExceptionHandler(ServletRequestBindingException.class)
    public String handleSessionError(ServletRequestBindingException ex, RedirectAttributes ra) {
        
        // 에러 메시지에 'loginUser'가 포함되어 있는지 확인 (핀포인트 체크)
        if (ex.getMessage().contains("loginUser")) {
            // 딱 이 에러일 때만 로그인 페이지로 보냄
            ra.addFlashAttribute("message", "로그인을 다시 해주세요.");
            return "redirect:/tudio/login"; // 실제 사용하시는 로그인 URL로 수정하세요
        }

        // 다른 에러는 처리를 하지 않고 에러를 다시 던져서 원래대로 에러 페이지가 뜨게 합니다.
        throw new RuntimeException(ex); 
    }
}