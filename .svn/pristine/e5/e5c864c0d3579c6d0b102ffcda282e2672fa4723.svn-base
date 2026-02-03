package kr.or.ddit.member.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.vo.ClientCompanyVO;

/**
 * <pre>
 * PROJ : Tudio
 * Name : BiznoApiController
 * DESC : 비즈노 api를 활용한 사업자등록번호로 회사명 조회 기능 컨트롤러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KSJ
 * @version 1.0, 2025.12.26
 * 
 */

@RestController
@RequestMapping("/bizno")
public class BiznoApiController {

	@Autowired
    private IMemberService memberService;
	
	@GetMapping("/checkDb")
    public Map<String, Object> checkDb(@RequestParam String companyNo) {
        Map<String, Object> response = new HashMap<>();
        
        // DB에서 사업자번호로 회사명 조회 (기존의 MemberService 등을 활용)
        ClientCompanyVO company = memberService.getCompanyInfoFromDb(companyNo);

        if (company != null) {
            response.put("status", "SUCCESS");
            // 객체 안에 담긴 여러 정보들을 맵에 담아 JSON으로 보냅니다.
            response.put("companyName", company.getCompanyName());
            response.put("companyCeoName", company.getCompanyCeoName());
            response.put("companyAddr1", company.getCompanyAddr1());
            response.put("companyAddr2", company.getCompanyAddr2());
        } else {
            response.put("status", "FAIL");
        }
        return response;
    }

    // [2] API 조회: 비즈노 API를 통해 정보 조회
    @GetMapping("/checkApi")
    public Map<String, Object> checkApi(@RequestParam String companyNo) {
        // 비즈노 API 호출 로직은 서비스 구현체(ServiceImpl)에 작성합니다.
        return memberService.getCompanyNameFromApi(companyNo);
    }
}
