package kr.or.ddit.member.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.ClientCompanyVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationSettingVO;

@Mapper
public interface IMemberMapper {
	
	//로그인 ( 아이디로 사용자 정보 가져오기 )
	public MemberVO findByMemberId(@Param("memberId") String memberId);

	//아이디 중복 확인
	public MemberVO idCheck(String memberId);
	
	//일반 회원가입
	public int memberSignup(MemberVO memberVO);
	
	//일반 회원가입 시 회사명, 사업자등록번호 저장
	public void insertCompanySimple(ClientCompanyVO companyVO);

	//회원가입 시 권한 설정
	public void insertMemberAuth(@Param("memberNo")int memberNo, @Param("auth") String auth);
	
	//회원가입 알림 디폴트
	public void insertDefaultNotification(int memberNo);
	
	//일반회원가입 프로필 경로 추가
	public void updateMemberProfile(MemberVO memberVO);
	
	//아이디 찾기
	public String findMemberId(MemberVO memberVO);
	
	//비밀번호 찾기
	public MemberVO findMemberPw(MemberVO memberVO);
	
	//임시비밀번호 업데이트
	public int updateNewMemberPw(MemberVO memberVO);

	//사업자등록번호 db 조회
	public ClientCompanyVO getCompanyInfo(String companyNo);

	//기업담당자 회원가입
	public int insertClientCompany(ClientCompanyVO companyVO);

	//회원정보 수정
	public int updateMember(MemberVO memberVO);

	//회원정보 수정 - 알림수정
	public int updateNotification(NotificationSettingVO notificationSettingVO);

	// 관리자 전용 회원 목록 조회
	public List<MemberVO> selectAdminMemberList(@Param("type") String type);
	
}
