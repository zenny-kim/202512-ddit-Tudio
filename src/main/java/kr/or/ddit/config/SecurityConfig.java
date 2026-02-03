package kr.or.ddit.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.member.service.impl.UserDetailServiceImpl;
import kr.or.ddit.util.JwtAuthenticationFilter;

@Configuration
@EnableWebSecurity(debug = false)
@EnableMethodSecurity // pre(전)Authorize, post(후)Authorize 애너테이션 사용 가능
public class SecurityConfig {

   @Autowired
   private DataSource dataSource;
   
   @Autowired
   private CustomAuthFailureHandler customAuthFailureHandler;

   @Autowired
   private CustomLoginSuccessHandler customLoginSuccessHandler;
   
   @Autowired
   UserDetailServiceImpl userDetailServiceImpl;
   
   @Autowired
   private CorsConfig corsConfig;
   
   @Autowired
   private JwtAuthenticationFilter jwtAuthenticationFilter;

   @Bean // 매개변수
   protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
      return http.csrf(csrf -> csrf.disable()).addFilter(corsConfig.corsFilter()).httpBasic(hbasic -> hbasic.disable())
            .headers(config -> config.frameOptions(customizer -> customizer.sameOrigin()))
            .authorizeHttpRequests(authz -> authz
            	  // 모든 OPTIONS 요청은 인증 없이 통과 (CORS Preflight) - 리액트 sts 요청 에러 해결을 위해 설정
            	  .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                  .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ASYNC).permitAll()
                  .requestMatchers("/api/member/**", "/api/notice/**").hasRole("ADMIN")
                  // 화상 채팅 관련 경로는 인증된 사용자만 접근 가능하도록 설정
                  .requestMatchers("/tudio/videoChat/getRoomInfo/**", "/tudio/videoChat/closeRoom").authenticated()
                  //여기 안에 필요한 사이트 넣어주기
                  //로그인 이전에도 가능
                  .requestMatchers(
                		"/",
                		"/upload/**",
                		"/admin/**",
                		"/tudio/main",
                		"/tudio/terms",
                		"/tudio/login",
                        "/tudio/memberType",
                        "/tudio/memberSignup",
                        "/tudio/clientSignup",
                        "/tudio/idCheck",
                        "/tudio/findMemberId",
                        "/tudio/findMemberPw",
                        "/tudio/emailAuthCode",
                        "/tudio/verifyAuthCode",
                        "/bizno/**",
                        "/member/**",
                        "/tudio/project/invite/check",
                        "/tudio/project/invite/verify/",
                        "/tudio/notice/**",
                        "/tudio/faq/**",
                        "/resources/**", 
                        "/static/**", 
                        "/css/**", 
                        "/js/**",
                        "/fonts/**",
                        "/images/**", 
                        "/favicon.ico",
                        "/images/favicon.ico",
                        "/adminlte/**", 
                        "/error",
                        "/tudio/api/auth/validate-token",
                        "/api/auth/validate-token"
                   )
                  .permitAll()
                  // 이외 주소는 로그인 한 사용자만 가능
                  .anyRequest().authenticated())
            
            	.formLogin(formLogin -> formLogin
                     .loginPage("/tudio/login")
                     .loginProcessingUrl("/login")
                     .failureHandler(customAuthFailureHandler)
                     .successHandler(customLoginSuccessHandler)
                     .permitAll()
                 )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            .sessionManagement(session -> session.maximumSessions(2))
            .logout(logout -> logout
            	    .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "GET"))
            	    .logoutSuccessUrl("/tudio/login?logout=true")
            	    .invalidateHttpSession(true)
            	    .deleteCookies("JSESSIONID")
            	).build();
   }

   // 인증(로그인=Authentication) 관리자 설정
   public AuthenticationManager authenticationManager(HttpSecurity http, BCryptPasswordEncoder bCryptPasswordEncoder,
         UserDetailsService detailsService) {

      DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
      authProvider.setUserDetailsService(this.userDetailServiceImpl);
      authProvider.setPasswordEncoder(bCryptPasswordEncoder);
      return new ProviderManager(authProvider);
   }
   
   @Bean
   public DaoAuthenticationProvider daoAuthenticationProvider() {
       DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
       provider.setUserDetailsService(userDetailServiceImpl); // 만든 서비스 연결
       provider.setPasswordEncoder(bCryptPasswordEncoder());  // 인코더 연결
       provider.setHideUserNotFoundExceptions(false); 
       
       return provider;
   }

   @Bean
   public WebSecurityCustomizer webSecurityCustomizer() {
       return (web) -> web.ignoring().requestMatchers(
           new AntPathRequestMatcher("/static/**"),
           new AntPathRequestMatcher("/resources/**"),
           new AntPathRequestMatcher("/css/**"),       
           new AntPathRequestMatcher("/js/**"),
           new AntPathRequestMatcher("/images/**"),
           new AntPathRequestMatcher("/tudio/survey/assets/**"), 
           new AntPathRequestMatcher("/adminte/**"), 
           new AntPathRequestMatcher("/error/**"), 
           new AntPathRequestMatcher("/images/favicon.ico"),
           new AntPathRequestMatcher("/favicon.ico"),            
           new AntPathRequestMatcher("/vite.svg"),
           new AntPathRequestMatcher("/.well-known/**")
       );
   }

   //패스워드 인코더로 사용할 빈 등록
   @Bean
   public BCryptPasswordEncoder bCryptPasswordEncoder() {
      return new BCryptPasswordEncoder();
   }
   
   @Bean
   public AuthenticationSuccessHandler roleBasedSuccessHandler() {
       return (request, response, authentication) -> {
       
           boolean isAdmin = authentication.getAuthorities().stream()
                   .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

           // contextPath가 있든 없든 안전하게 처리
           String ctx = request.getContextPath(); // 보통 "" 또는 "/tudio"

           // ROLE_ADMIN -> /admin
           // ROLE_MEMBER, ROLE_CLIENT -> /tudio
           String targetUrl = isAdmin ? ctx + "/admin" : ctx + "/tudio/main";

           response.sendRedirect(targetUrl);
       };
   }
   

}
