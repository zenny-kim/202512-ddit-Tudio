package kr.or.ddit.member.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import kr.or.ddit.member.mapper.IMemberMapper;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserDetailServiceImpl implements UserDetailsService {

	@Autowired
	IMemberMapper memberMapper;
	
	//스프링 시큐리티에서는 사용자아이디는 username, 비밀번호는 password
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("loadUserByUsername -> username : {}", username);
	    
	    // 1. DB에서 사용자 정보 조회
	    MemberVO memberVO = this.memberMapper.findByMemberId(username);
	    log.info("loadUserByUsername -> memberVO : {}", memberVO);
	    
	    // 2. 사용자가 없을 때 처리
	    if (memberVO == null) {
	        log.warn("사용자를 찾을 수 없음: {}", username);
	        throw new UsernameNotFoundException("아이디가 존재하지 않습니다: " + username);
	    }
	    
	    // 3. 사용자가 있을 때만 정보 리턴
	    return new CustomUser(memberVO);
	}

	
}
