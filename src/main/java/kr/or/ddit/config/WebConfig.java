package kr.or.ddit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 웹 브라우저 URL: /upload/** 패턴으로 요청이 들어오면
        // 2. 실제 파일 경로: src/main/webapp/upload/ 폴더에서 찾아라
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:src/main/webapp/upload/");
    }
}