package kr.or.ddit.config;

import java.util.Set;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.boot.autoconfigure.ConfigurationCustomizer;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.type.filter.AssignableTypeFilter;
import org.springframework.util.ClassUtils;

import kr.or.ddit.common.code.CodeEnum;
import kr.or.ddit.common.code.CodeEnumTypeHandler;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : MybatisConfig
 * DESC : MyBatis 설정 클래스
 * </pre>
 * CodeEnum 인터페이스를 구현한 모든 Enum을 스캔하여 CodeEnumTypeHandler를 자동 등록한다.
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.13
 * 
 */
@Slf4j
@Configuration
public class MybatisConfig {

    @Bean
    public ConfigurationCustomizer mybatisConfigurationCustomizer() {
        return configuration -> {
            // 스캔할 기본 패키지 지정 (프로젝트 최상위 패키지)
            String basePackage = "kr.or.ddit"; 

            // CodeEnum 인터페이스를 구현한 클래스만 찾도록 필터 설정
            ClassPathScanningCandidateComponentProvider scanner = new ClassPathScanningCandidateComponentProvider(false);
            scanner.addIncludeFilter(new AssignableTypeFilter(CodeEnum.class));

            // 패키지 스캔
            Set<BeanDefinition> components = scanner.findCandidateComponents(basePackage);

            for (BeanDefinition component : components) {
                try {
                    // 찾은 클래스를 로딩
                    Class<?> clazz = ClassUtils.forName(component.getBeanClassName(), ClassUtils.getDefaultClassLoader());

                    // Enum이면서 CodeEnum을 구현한 것인지 확인
                    if (clazz.isEnum() && CodeEnum.class.isAssignableFrom(clazz)) {
                        
                        configuration.getTypeHandlerRegistry().register(clazz, CodeEnumTypeHandler.class);

                        log.info("MyBatis 공통코드 핸들러 자동 등록: {}", clazz.getSimpleName());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };
    }
}