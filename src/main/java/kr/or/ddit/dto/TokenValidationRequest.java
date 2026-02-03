package kr.or.ddit.dto;

import lombok.Data;

@Data
public class TokenValidationRequest {
    private String token; // Node.js가 보내준 JWT 토큰
}