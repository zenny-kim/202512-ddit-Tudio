package kr.or.ddit.util;

import java.io.IOException;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.member.service.impl.UserDetailServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
	
	private final JwtUtil jwtUtil;
	
	@Autowired
	private UserDetailServiceImpl userDetailServiceImpl;
	
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
	        throws ServletException, IOException {

	    String bearerToken = request.getHeader("Authorization");
	    String token = (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) ? bearerToken.substring(7) : null;

	    if (token != null && !jwtUtil.isTokenExpired(token)) {
	        try {
	            String memId = jwtUtil.extractMemId(token);

	            UserDetails userDetails = userDetailServiceImpl.loadUserByUsername(memId);
	            
	            if (userDetails != null) {
	                UsernamePasswordAuthenticationToken authentication = 
	                    new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
	                
	                SecurityContextHolder.getContext().setAuthentication(authentication);
	                log.info("✅ 실제 권한으로 인증 성공: memId={}, authorities={}", memId, userDetails.getAuthorities());
	            }
	        } catch (Exception e) {
	            log.error("❌ 인증 과정 오류: {}", e.getMessage());
	        }
	    }
	    filterChain.doFilter(request, response);
	}
}
