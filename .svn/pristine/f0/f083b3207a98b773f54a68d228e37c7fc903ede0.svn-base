package kr.or.ddit.projectTask.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.dto.GanttTaskDTO;
import kr.or.ddit.projectTask.service.IProjectGanttService;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectGanttController
 * DESC : 간트차트 클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 KHJ
 * @version 1.0, 2026.01.07
 * 
 */

@Slf4j
@Controller
@RequestMapping("/tudio/project")
public class ProjectGanttController {
	
	@Autowired
    private IProjectGanttService ganttService;
	
	/**
	 *  간트차트 화면 진입 
	 */
	@GetMapping("/gantt/view")
	public String ganttPage(@RequestParam(value="projectNo", required=false, defaultValue="0") int projectNo, Model model) {
		
		model.addAttribute("projectNo", projectNo);
		return "gantt/gantt";
	}
	
	
	/**
	 * 간트 차트에 뿌릴 데이터 리턴(JSON)
	 */
	@GetMapping("/gantt/data")
    @ResponseBody
    public Map<String, Object> getGanttData(@RequestParam(value = "projectNo", required = false) int projectNo) {
		log.warn("ganttData 호출됨 / projectNo = [{}]", projectNo);
        Map<String, Object> result = new HashMap<>();
        
        if (projectNo <= 0) {
            result.put("data", new ArrayList<GanttTaskDTO>()); 
            return result; 
        }
        result.put("data", ganttService.getGanttTaskList(projectNo));
        return result;
    }
	
}
