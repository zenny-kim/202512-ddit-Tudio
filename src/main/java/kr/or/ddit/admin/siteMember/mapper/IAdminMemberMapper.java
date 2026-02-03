package kr.or.ddit.admin.siteMember.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.dto.AdminUserDTO;
import kr.or.ddit.vo.MemberVO;

/**
 * Tudio Admin 회원 관리 매퍼 인터페이스
 */
@Mapper
public interface IAdminMemberMapper {
	
	/**
	 * 관리자 기본 정보 조회 (로그인 세션 등에서 활용)
	 * @param memId 관리자 아이디
	 * @return 관리자 정보 DTO
	 */
	public AdminUserDTO selectAdminMember(String memId);
	
	/**
	 * [UI 리스트 전용] 회원 목록 조회 (페이징 및 검색 필터 적용)
	 * @param memberVO 페이징 정보(startRow, endRow) 및 검색 조건이 담긴 VO
	 * @return 해당 페이지 구간의 회원 목록
	 */
	public List<MemberVO> selectAdminMemberList(MemberVO memberVO);

	/**
	 * [엑셀 다운로드 전용] 필터링된 전체 회원 목록 조회 (페이징 없음)
	 * @param memberVO 검색 조건이 담긴 VO
	 * @return 조건에 맞는 전체 회원 목록
	 */
	public List<MemberVO> selectMemberListForExcel(MemberVO memberVO);

	/**
	 * [페이징 계산용] 필터링 조건에 맞는 전체 회원 수 조회
	 * @param memberVO 검색 조건이 포함된 VO
	 * @return 전체 레코드 수
	 */
	public int selectMemberCount(MemberVO memberVO);

	/**
	 * 회원 상세 정보 조회 (상세 보기 모달용)
	 * @param memberNo 회원 고유 번호
	 * @return 회원 상세 정보 VO
	 */
	public AdminUserDTO selectMemberDetail(String memId);

	/**
	 * 회원 영구 삭제
	 * @param memberNo 삭제할 회원 번호
	 * @return 성공 행 수
	 */
	public int deleteMember(int memberNo);

	/**
	 * 상단 대시보드용 회원 통계 데이터 조회 (전체, 오늘 가입, 활성, 탈퇴 등)
	 * @return 통계 정보가 담긴 Map
	 */
	public Map<String, Object> selectMemberSummaryStats();

	/**
	 * [엑셀 업로드] 신규 회원 정보 저장
	 * @param memberVO 저장할 회원 정보
	 * @return 성공 행 수
	 */
	public int insertMember(MemberVO memberVO);
	
	/**
	 * [엑셀 업로드] 신규 등록 회원에게 권한(ROLE_CLIENT / ROLE_MEMBER) 부여
	 * @param authMap memberNo와 auth 정보가 담긴 맵
	 * @return 성공 행 수
	 */
	public int insertMemberAuth(Map<String, Object> authMap);
}