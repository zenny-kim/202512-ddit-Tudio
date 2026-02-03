package kr.or.ddit.member.service.impl;

import java.util.Collection;
import java.util.stream.Collectors;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import kr.or.ddit.vo.MemberVO;

public class CustomUser extends User {

	private MemberVO memberVO;
	
	public CustomUser(String username, String password
			, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUser(MemberVO memberVO) {
        //User의 생성자를 호출합
        //super(사용자아이디, 비밀번호, 권한리스트)
        super(memberVO.getMemberId(), memberVO.getMemberPw(), 
              memberVO.getMemberAuthVOList().stream()
                      .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
                      .collect(Collectors.toList()));
        this.memberVO = memberVO;
    }
	
	
	public MemberVO getMemberVO() {
		return memberVO;
	}

	public void setMemberVO(MemberVO memberVO) {
		this.memberVO = memberVO;
	}

}
