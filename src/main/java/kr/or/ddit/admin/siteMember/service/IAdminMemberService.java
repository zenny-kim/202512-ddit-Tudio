package kr.or.ddit.admin.siteMember.service;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dto.AdminUserDTO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PageResult; // [추가] 공통 페이징 결과 객체

public interface IAdminMemberService {
	
	/**
	 * 관리자 기본 정보 조회 (헤더/프로필 표시용)
	 * @param memId 관리자 아이디
	 * @return 관리자 정보 DTO
	 */
	public AdminUserDTO getAdminInfo(String memId);
	
	/**
	 * 회원 통합 목록 조회 (페이징 및 검색 필터 적용)
	 * 공지사항과 동일한 PageResult 방식을 사용하여 리액트 페이징을 지원합니다.
	 * @param memberVO 페이징 정보(currentPage) 및 검색 조건(type, keyword)이 담긴 VO
	 * @return 회원 목록과 페이징 정보가 결합된 PageResult 객체
	 */
    public PageResult<MemberVO> selectAdminMemberList(MemberVO memberVO);
   
    /**
     * 회원 영구 삭제
     * @param memberNo 삭제할 회원 번호
     * @return 성공 여부 (SUCCESS / FAIL)
     */
    public String removeMember(int memberNo);

    /**
     * 엑셀 파일을 통한 회원 일괄 가입 등록
     * @param file 업로드된 엑셀 파일
     * @return 등록 성공한 회원 수
     * @throws Exception 파일 처리 중 발생할 수 있는 예외
     */
    public int registerMembersByExcel(MultipartFile file) throws Exception;
    
    /**
     * 회원 정보 리포트 엑셀 다운로드
     * @param type 회원 유형 필터
     * @param keyword 검색어
     * @param response 엑셀 파일 출력을 위한 HTTP 응답 객체
     * @throws Exception 엑셀 생성 중 발생할 수 있는 예외
     */
    public void downloadMemberExcel(String type, String keyword, HttpServletResponse response) throws Exception;
    
    /**
     * 상단 카드용 회원 통계 데이터 조회
     * @return 전체, 오늘 가입, 기업 회원, 활성 유저 수가 담긴 Map
     */
    public Map<String, Object> getMemberSummaryStats();
    
    // 회원 상세 정보 조회
    public AdminUserDTO selectMemberDetail(String memId);
}