package kr.or.ddit.common;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.project.mapper.IProjectMapper;
import kr.or.ddit.project.service.IProjectService;
import kr.or.ddit.vo.project.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProjectScheduler {
	
	@Autowired
	private IProjectService projectService;
	
	@Autowired
	private IProjectMapper projectMapper;
	
	// 매일 오전 9시에 실행
	@Scheduled(cron = "0 0 9 * * *")
	public void checkProjectPeriod() {
		log.info("checkProjectPeriod() 실행...!");
		
		// 1. 자동 삭제 (기준: 프로젝트 팀원 없음 + 프로젝트 생성일로부터 7일 경과)
		List<ProjectVO> projectDeletes = projectMapper.selectProjectForDelete();
		if(projectDeletes != null && !projectDeletes.isEmpty()) {
			for(ProjectVO project : projectDeletes) {
				log.info("프로젝트 팀원이 초대되지 않은 프로젝트 자동 삭제 (ID: {}, Name: {})", project.getProjectNo(), project.getProjectName());
				
				// 물리 삭제 처리
				projectMapper.deleteProject(project.getProjectNo());
				
				// 프로젝트 생성 관리자에게 삭제 알림 메일 발송
				projectService.sendDeleteNoti(project);
			}
		}
		
		// 경고 알림
		List<ProjectVO> projectWarning = projectMapper.selectProjectForWarning();
		if(projectWarning != null && !projectWarning.isEmpty()) {
			for(ProjectVO project : projectWarning) {
				// 남은 기간
				int remainDays = 7 - (int) project.getElapsedDays();
				
				if(remainDays > 0) {
					log.info("프로젝트 경과 알림 (ID : {}, 남은기간 : {}일)", project.getProjectNo(), remainDays);
					projectService.sendWarningNoti(project, remainDays);
				}
			}
		}
	}
}
