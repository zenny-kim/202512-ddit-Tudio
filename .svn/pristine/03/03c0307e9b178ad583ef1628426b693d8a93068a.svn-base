package kr.or.ddit.projectMember.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.projectMember.service.IProjectMemberService;
import kr.or.ddit.vo.project.ProjectMemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : projectBoard
 * DESC : 프로젝트 구성원
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KMS
 * @version 1.0, 2025.12.30
 * 
 */
@Slf4j
@Controller
@RequestMapping("/tudio/project/member")
public class ProjectMemberController {

	@Autowired
	private IProjectMemberService projectMemberService;

	/**
	 * 프로젝트 구성원 jsp 탭 조각 반환 (HTML fragment)
	 * 
	 * @param projectNo
	 * @param model
	 * @return
	 */
	@GetMapping("/view") // ㄴㄴ
	public String projectTabMemberList(@RequestParam int projectNo, Model model) {

		List<ProjectMemberVO> projectMemberList = projectMemberService.projectMemberList(projectNo);
		int projectMemberCount = projectMemberService.projectMemberCount(projectNo);
		model.addAttribute("projectMemberList", projectMemberList);
		model.addAttribute("projectMemberCount", projectMemberCount);
		model.addAttribute("projectNo", projectNo);

		return "project/tabs/tabMember";
	}
	
	
	  
	  /**
	   * 구성원 목록 JSON 반환 (검색 비동기)
	   *  searchWord가 있으면  검색 전용 리스트고 없으면 공용 리스트
	   * @param projectNo
	   * @param searchType
	   * @param searchWord
	   * @return
	   */
	  @GetMapping("/listData")
	  @ResponseBody
	  public Map<String,Object> projectMemberListData(
			  @RequestParam int projectNo,
			  @RequestParam(required = false, defaultValue ="memberName") String searchType,
			  @RequestParam(required = false) String searchWord){
		  
		  List<ProjectMemberVO> listData;
		  
		  // 검색어 없으면 공용 쿼리 그대로 사용
		  
		  if(StringUtils.isBlank(searchWord)) {
			  listData=projectMemberService.projectMemberList(projectNo);
		  }else {
			  Map<String, Object> param = new HashMap<>();
			  param.put("projectNo", projectNo);
			  param.put("searchType", searchType);
			  param.put("searchWord", searchWord.trim());
			  
			  listData = projectMemberService.projectMemberListSearch(param); // 비동기용 
		  }
		  
		  Map<String, Object> result = new HashMap<>();
		  result.put("listData", listData);
		  return result;
		  
	  }
	  

	/**
	 * 모달 JSON 반환
	 * 
	 * @param projectNo
	 * @param memberNo
	 * @return
	 */
	@GetMapping("/memberModal")
	@ResponseBody 
	public ProjectMemberVO projectMemberDetail(@RequestParam int projectNo, @RequestParam int memberNo) {

		ProjectMemberVO vo = new ProjectMemberVO();
		vo.setMemberNo(memberNo);
		vo.setProjectNo(projectNo); // VO에 값 주입
		// 파라미터가 projectNo를 포함해서 2개가 필요하고, ProjectVOTabMemberVO에 projectNo가 있는 경우
		// projectNo를 ProjectTabMemberVO에 넣고 파라미터를 1개로 처리하기

		return projectMemberService.projectMemberDetail(vo);
	}

	
	
	 /**
	  * 차트 데이터 반환  
	  * @param projectNo
	  * @return
	  */
	  @GetMapping("/memberChart")	  
	  @ResponseBody 
	  public List<ProjectMemberVO> projectMemberDetailTaskCountChart(@RequestParam int projectNo) {
		
		  return projectMemberService.projectMemberDetailTaskCountChart(projectNo);
	  
	  }

}
