package kr.or.ddit.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        
        config.setAllowCredentials(true); // 쿠키/세션 인증 허용
        config.setAllowedOrigins(List.of(
        		"http://localhost:5173",	// 로컬
        		"http://3.34.194.219:5173"	// AWS
        )); // 리액트 주소 허용
        config.addAllowedHeader("*"); // 모든 헤더 허용
        config.addAllowedMethod("*"); // GET, POST, PUT, DELETE 등 모든 메서드 허용
        config.setMaxAge(3600L);	  // 브라우저가 사전 요청 결과를 기억할 시간 설정
        
        source.registerCorsConfiguration("/**", config); // 모든 주소에 적용
        return new CorsFilter(source);
    }
}