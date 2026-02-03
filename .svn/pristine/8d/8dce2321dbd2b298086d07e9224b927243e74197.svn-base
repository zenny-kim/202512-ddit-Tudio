package kr.or.ddit.member.service;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.ClientCompanyVO;
import kr.or.ddit.vo.MemberVO;


public interface IMemberService {

	//아이디 비밀번호 찾기
	public String findMemberId(MemberVO memberVO);
	public MemberVO findMemberPw(MemberVO memberVO);
	
	//아이디 중복확인
	public ServiceResult idCheck(String memberId);

	//프로젝트 사용자 회원가입
	public ServiceResult signup(MemberVO memberVO, ClientCompanyVO companyVO);
	
	//프로젝트 사용자 이메일 인증
	public void emailAuthCode(String email, String authCode);
	
	//사업자번호 db 조회 -> api 사용 조회
	public ClientCompanyVO getCompanyInfoFromDb(String companyNo);
	public Map<String, Object> getCompanyNameFromApi(String companyNo);
	
	//기업관리자 회원가입
	public ServiceResult clientSignup
		(MemberVO memberVO, ClientCompanyVO companyVO, MultipartFile profileImageFile,MultipartFile bizFile);
	
	//회원 마이파이지 조회
	public MemberVO findByMemberId(String memberId);
	//회원 마이페이지 수정
	public boolean memberModify(MemberVO memberVO, MultipartFile profileImageFile);
}
