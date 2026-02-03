package kr.or.ddit.util;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtil {

    @Value("${jwt.secret.key}") 
    private String secretKey;
    
    @Value("${jwt.expiration:86400000}") // 기본값: 24시간
    private long jwtExpiration;
    
    // 로그인용 등으로 사용하던 기본 메서드
    public String generateToken(String memId) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, memId);
    }

    // 화상회의용 메서드 - 이름(memName)과 번호(memNo)를 포함하여 생성
    public String generateToken(String memId, int memNo, String memName) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("memNo", memNo);
        claims.put("memName", memName); // 화면에 표시할 이름 저장
        return createToken(claims, memId);
    }
    
    private String createToken(Map<String, Object> claims, String subject) {
        SecretKey key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(secretKey));
        
        return Jwts.builder()
                .claims(claims)      // payload 설정
                .subject(subject)    // ID 설정
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(key)       // 서명
                .compact();
    }

    // 토큰에서 모든 Claim 추출
    private Claims extractAllClaims(String token) {
        SecretKey key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(secretKey));
        return Jwts.parser()
                .verifyWith(key) 
                .build()
                .parseSignedClaims(token) 
                .getPayload();
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    public String extractMemId(String token) {
        return extractClaim(token, Claims::getSubject); 
    }

    // 토큰에서 사용자 이름(memName) 추출
    public String extractMemName(String token) {
        return extractClaim(token, claims -> claims.get("memName", String.class));
    }
    
    // 토큰에서 사용자 번호(memNo) 추출 
    public Integer extractMemNo(String token) {
        return extractClaim(token, claims -> claims.get("memNo", Integer.class));
    }

    public boolean isTokenExpired(String token) {
        return extractClaim(token, Claims::getExpiration).before(new Date());
    }
}