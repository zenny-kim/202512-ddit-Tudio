package kr.or.ddit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

//@Configuration : 설정과 관련된 클래스라고 인식하는 어노테이션
@Configuration
public class FileConfigration implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/upload/**").addResourceLocations("file:///C:/upload/");
		WebMvcConfigurer.super.addResourceHandlers(registry);
	}
	
}
