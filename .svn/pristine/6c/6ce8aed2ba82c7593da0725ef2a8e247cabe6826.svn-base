package kr.or.ddit.videoChat.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.dto.TokenValidationRequest;
import kr.or.ddit.dto.TokenValidationResponse;
import kr.or.ddit.util.JwtUtil;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/tudio/api/auth")
@RequiredArgsConstructor
public class VideoAuthController {

    private final JwtUtil jwtUtil;

    // Node.js가 호출하는 검증 API
    @PostMapping("/validate-token")
    public TokenValidationResponse validateToken(@RequestBody TokenValidationRequest request) {
        String token = request.getToken();
        TokenValidationResponse response = new TokenValidationResponse();

        // 토큰 존재 여부 확인
        if (token == null || token.isEmpty()) {
            response.setValid(false);
            response.setMessage("Token is missing.");
            return response;
        }

        try {
            // 만료 확인 
            if (jwtUtil.isTokenExpired(token)) {
                response.setValid(false);
                response.setMessage("Token is expired.");
                return response;
            }

            // 정보 추출
            String memId = jwtUtil.extractMemId(token);
            String memName = jwtUtil.extractMemName(token); 

            if (memId == null || memId.isEmpty()) {
                response.setValid(false);
                return response;
            }

            // 검증 성공 응답
            response.setValid(true);
            response.setMemId(memId);
            response.setMemName(memName);
            response.setMessage("Token is valid.");

        } catch (Exception e) {
            response.setValid(false);
            response.setMessage("Validation Failed: " + e.getMessage());
        }

        return response;
    }
}