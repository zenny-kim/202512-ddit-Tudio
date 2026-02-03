package kr.or.ddit.projectInsight.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.projectInsight.service.IProjectInsightService;
import kr.or.ddit.vo.project.ProjectInsightVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/tudio/project")
public class ProjectInsightController {
	
	@Autowired
	private IProjectInsightService insightService;
	
	@GetMapping("/stats/view")
	public String projectInsight(@RequestParam("projectNo") int projectNo, Model model) {
		
		log.info("Project Insight 접속 - 프로젝트 번호: {}", projectNo);
		
		Map<String, Object> insightData = insightService.getInsightDashboardData(projectNo);
		
		List<ProjectInsightVO> priorityData = insightService.selectPriorityDistribution(projectNo);
		
		List<ProjectInsightVO> progressData =  insightService.selectProgressPct(projectNo);
		
		
		model.addAttribute("insight", insightData.get("insight"));
	    model.addAttribute("memberList", insightData.get("memberList"));
	    model.addAttribute("projectNo", projectNo);
	    
	    model.addAttribute("priorityData", priorityData);
	    model.addAttribute("progressData", progressData);
		
		return "project/tabs/tabStats";
	}
	

}
