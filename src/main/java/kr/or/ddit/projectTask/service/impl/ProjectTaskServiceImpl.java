package kr.or.ddit.projectTask.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.common.code.TaskPriority;
import kr.or.ddit.common.code.TaskStatus;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.notice.service.INoticeService;
import kr.or.ddit.notification.mapper.INotificationMapper;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.projectTask.mapper.IProjectTaskMapper;
import kr.or.ddit.projectTask.service.IProjectTaskService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.project.ProjectTaskManagerVO;
import kr.or.ddit.vo.project.ProjectTaskSubVO;
import kr.or.ddit.vo.project.ProjectTaskVO;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * PROJ : Tudio
 * Name : ProjectTaskServiceImpl
 * DESC : 프로젝트 상위업무 생성, 수정, 삭제, 목록 서비스 구현클래스
 * </pre>
 * 
 * @author [대덕인재개발원] team1 PSE
 * @version 1.0, 2025.01.02
 * 
 */
@Service
@Slf4j
public class ProjectTaskServiceImpl implements IProjectTaskService {
	
	@Autowired
	private IProjectTaskMapper projectTaskMapper;
	
	@Autowired
	private IFileService fileService;
	
	@Autowired
	private INotificationService notiService;
	
	
	// [알림KMS] 담당자 중복리스트 유틸메서드 
	private List<Integer> distinctList(List<Integer> list) {
		if (list == null || list.isEmpty()) return Collections.emptyList();
		return list.stream().distinct().collect(Collectors.toList());
	}

	
	// [알림KMS] 담당자 지정 알림 발송  유틸메서드 
	private List<Integer> toMemberNoList(List<ProjectTaskManagerVO> managers) {
		if (managers == null || managers.isEmpty()) return Collections.emptyList();
		return managers.stream()
				.map(ProjectTaskManagerVO::getMemberNo)   // ★ memberNo getter 전제
				.filter(m -> m != null)
				.distinct()
				.collect(Collectors.toList());
	}
	
	/**
	 * 내 업무 목록 조회
	 */
	@Override
	public Map<Integer, List<ProjectTaskVO>> getMyTaskList(int memberNo, String type, Integer projectStatus) {
		
		Map<String, Object> params = new HashMap<>();
		params.put("memberNo", memberNo);
		params.put("type", (type == null) ? "" : type);
		params.put("projectStatus", (projectStatus == null) ? 0 : projectStatus);
		
		log.info("selectMyTaskList params: memberNo={}, type={}, status={}", memberNo, type, projectStatus);
		
		List<ProjectTaskVO> myTaskList = projectTaskMapper.selectMyTaskList(params);
		
		log.info("selectMyTaskList result size: {}", myTaskList != null ? myTaskList.size() : 0);
		
		// 조회된 리스트를 화면에 보내기 전, 지연 상태 검사 수행
		if (myTaskList != null) {
			for (ProjectTaskVO task : myTaskList) {
				checkAndAutoUpdateStatus(task);
			}
		}
		
		Map<Integer, List<ProjectTaskVO>> taskMap = myTaskList.stream()
														.collect(Collectors.groupingBy(
																	ProjectTaskVO::getProjectNo,
																	LinkedHashMap::new,	//LinkedHashMap으로 SQL 정렬 순서 유지
																	Collectors.toList()
																));
		
		return taskMap;
	}

	/**
	 * 업무 전체 리스트 조회
	 * @param int projectNo
	 */
	@Override
	public List<ProjectTaskVO> selectTaskList(int projectNo, String sortType, String sortOrder) {
		
		// Mapper에 보낼 파라미터 Map 생성
		Map<String, Object> searchParams = new HashMap<>();
		searchParams.put("projectNo", projectNo);
		searchParams.put("sortType", sortType);
		searchParams.put("sortOrder", sortOrder);
		
		List<ProjectTaskVO> taskList = projectTaskMapper.selectTaskList(searchParams);
		List<ProjectTaskSubVO> subTaskList = projectTaskMapper.selectSubTaskList(projectNo);
		List<ProjectTaskManagerVO> managerList = projectTaskMapper.selectTaskManagerList(projectNo);
		
		// 프로젝트 전체 목록 조회 시에도 자동 업데이트 수행
		// 1. 상위업무 체크
		for (ProjectTaskVO task : taskList) {
			checkAndAutoUpdateStatus(task);
		}
		// 2. 하위업무 체크
		for (ProjectTaskSubVO sub : subTaskList) {
			checkAndAutoUpdateStatus(sub);
		}
		
		// 상위업무별 하위업무 리스트를 담는 Map (key: taskId)
		Map<Integer, List<ProjectTaskSubVO>> subTaskMap = new HashMap<>();
		for(ProjectTaskSubVO subTask : subTaskList) {
			// subTaskMap에 subTask.getTaskId()인 키에대한 리스트 값이 없으면 새로 생성해서 넣고 반환
			subTaskMap.computeIfAbsent(subTask.getTaskId(), key -> new ArrayList<>())
									.add(subTask);
		}
		
		// 상위업무별 담당자를 담는 Map (key: workId=taskId)
		Map<Integer, List<ProjectTaskManagerVO>> taskManagerMap = new HashMap<>();
		// 하위업무별 담당자를 담는 Map (key: workId=subId)
		Map<Integer, List<ProjectTaskManagerVO>> subManagerMap = new HashMap<>();
		for(ProjectTaskManagerVO manager : managerList) {
			if(manager.getWorkType().equals("T")) {				// 업무 타입이 상위업무인 경우
				taskManagerMap.computeIfAbsent(manager.getWorkId(), key -> new ArrayList<>())
											.add(manager);
			} else if(manager.getWorkType().equals("S")) {		// 업무 타입이 하위업무인 경우
				subManagerMap.computeIfAbsent(manager.getWorkId(), key -> new ArrayList<>())
											.add(manager);
			}
		}
		
		// 뷁 - 추후 추가되는 값인데 Collections.emptyList()로 할지 ArrayList로 할지 추후 고민...
		// 하위업무 담당자 세팅
		for(ProjectTaskSubVO subTask : subTaskList) {	// Collections.emptyList(): 불변의 emptyList 객체
			subTask.setSubManagers(subManagerMap.getOrDefault(subTask.getSubId(), Collections.emptyList()));
		}
		
		for(ProjectTaskVO projectTask : taskList) {
			int taskId = projectTask.getTaskId();
			
			// 상위업무 담당자 세팅
			projectTask.setTaskManagers(taskManagerMap.getOrDefault(taskId, Collections.emptyList()));
			
			// 상위업무에 종속된 하위업무 세팅
			projectTask.setSubTasks(subTaskMap.getOrDefault(taskId, Collections.emptyList()));
		}
		
		return taskList;
	}
	
	/*
	 * 업무 고정
	 */
	@Override
	public String setTaskPin(int id, String type, int memberNo) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("id", id);
	    params.put("memberNo", memberNo);
	    
	    int result = 0;
	    if ("T".equals(type)) {
	        result = projectTaskMapper.setTaskPin(params);
	    } else {
	        result = projectTaskMapper.setSubTaskPin(params);
	    }
	    
	    return result > 0 ? "SUCCESS" : "FAIL";
	}

	/**
	 * 업무 생성
	 */
	@Transactional
	@Override
	public ServiceResult createTask(ProjectTaskVO projectTaskVO, int writerNo) {
		
		if (projectTaskVO.getTaskStatus() == null) projectTaskVO.setTaskStatus(TaskStatus.REQUEST);
        if (projectTaskVO.getTaskPriority() == null) projectTaskVO.setTaskPriority(TaskPriority.NORMAL);
        
        // 상위업무 생성
		int status = projectTaskMapper.insertTask(projectTaskVO);
		
		if(status > 0) {
			// 상위업무 담당자 생성
			List<Integer> taskManagerNos = projectTaskVO.getTaskManagerNos();
			if(taskManagerNos != null && !taskManagerNos.isEmpty()) {
				Map<String, Object> tManager = new HashMap<>();
				tManager.put("workId", projectTaskVO.getTaskId());
				tManager.put("taskManagerNos", taskManagerNos);
				projectTaskMapper.insertTaskManager(tManager);
				
				
			// 알림 시작	
				int projectNo = projectTaskVO.getProjectNo();				
				NotificationVO notiVO = new NotificationVO();
				notiVO.setNotiMessage("["+projectTaskVO.getTaskTitle()+"]"+" 업무 담당자로 지정되었습니다.");
				notiService.pushManagerNoti(projectNo,projectTaskVO.getTaskId(),taskManagerNos,notiVO);	
			// 알림 끝	
				
			}
			
			// 종속된 하위업무 생성
			if(projectTaskVO.getSubTasks() != null) {
				for(ProjectTaskSubVO sub : projectTaskVO.getSubTasks()) {
					sub.setTaskId(projectTaskVO.getTaskId());
					sub.setSubWriter(writerNo);
					
					if (sub.getSubStatus() == null) sub.setSubStatus(TaskStatus.REQUEST);
					if (sub.getSubPriority() == null) sub.setSubPriority(TaskPriority.NORMAL);
					
					projectTaskMapper.insertSubTask(sub);
					
					// 하위업무 담당자 생성
					List<Integer> subManagerNos = sub.getSubManagerNos();
					if (subManagerNos != null && !subManagerNos.isEmpty()) {
						Map<String, Object> sManager = new HashMap<>();
						sManager.put("workId", sub.getSubId());
						sManager.put("subManagerNos", subManagerNos);
						projectTaskMapper.insertSubManager(sManager);
						
						// 담당자 지정 알림 시작	
						int projectNo = projectTaskVO.getProjectNo();				
						NotificationVO notiVO = new NotificationVO();
						notiVO.setNotiMessage("["+sub.getSubTitle()+"]"+" 업무 담당자로 지정되었습니다.");
						notiService.pushManagerNoti(projectNo,projectTaskVO.getTaskId(),taskManagerNos,notiVO);	
					    // 담당자 지정 알림 끝
					}
				}
			}
			return ServiceResult.OK;
		}
		return ServiceResult.FAILED;
	}

	/**
	 * 하위 업무 생성
	 */
	@Override
	public ServiceResult createSubTask(ProjectTaskSubVO subVO, int writerNo) {
		if (subVO.getSubStatus() == null) subVO.setSubStatus(TaskStatus.REQUEST);
		if (subVO.getSubPriority() == null) subVO.setSubPriority(TaskPriority.NORMAL);
		
		int status = projectTaskMapper.insertSubTask(subVO);
		
		if(status > 0) {
			List<Integer> subManagerNos = subVO.getSubManagerNos();
			if(subManagerNos != null && !subManagerNos.isEmpty()) {
				Map<String, Object> subManager = new HashMap<>();
				subManager.put("workId", subVO.getSubId());
				subManager.put("subManagerNos", subManagerNos);
				projectTaskMapper.insertSubManager(subManager);
				
				
				
				// 업무 담당자 지정 알림 시작	
				int projectNo = notiService.selectProjectNoByTaskId(subVO.getTaskId());

				NotificationVO notiVO = new NotificationVO();
				notiVO.setNotiMessage("["+subVO.getSubTitle()+"]"+" 업무 담당자로 지정되었습니다.");
				notiService.pushManagerNoti(projectNo,subVO.getTaskId(),subManagerNos,notiVO);	
		   	    // 업무 담당자 지정 알림 끝
			}
			
			syncParentTask(subVO.getTaskId());
			
			return ServiceResult.OK;
		}
		return ServiceResult.FAILED;
	}
	
	/**
	 * 상위업무 수정
	 * @param taskVO
	 * @param deleteSubIds
	 * @return ServiceResult : OK | FAILED
	 */
	@Transactional
	@Override
	public ServiceResult updateTaskWithSubTasks(ProjectTaskVO taskVO, List<Integer> deleteSubIds) {
		
		
		// [알림KMS] 기존 담당자 리스트
		List<Integer> beforeTaskManagers = toMemberNoList(projectTaskMapper.selectTaskManagers(taskVO.getTaskId()));
		
		
		// [검증] 상위업무 날짜가 변경되었을 때, 종속된 하위업무들의 범위를 벗어나는지 체크
        List<ProjectTaskSubVO> subTasks = projectTaskMapper.selectSubListByTaskId(taskVO.getTaskId());
        if (subTasks != null) {
            for (ProjectTaskSubVO sub : subTasks) {
                // 상위 시작일이 하위 시작일보다 늦어지면 안됨
                if (taskVO.getTaskStartdate().after(sub.getSubStartdate())) {
                    return ServiceResult.FAILED; 
                }
                // 상위 마감일이 하위 마감일보다 빨라지면 안됨
                if (taskVO.getTaskEnddate().before(sub.getSubEnddate())) {
                    return ServiceResult.FAILED; 
                }
            }
        }
        
        // 상위업무 완료일 로직
        if (taskVO.getTaskStatus() != TaskStatus.DONE) {
			taskVO.setTaskFinishdate(null); // 완료 상태가 아니면 날짜 지움
		} else if (taskVO.getTaskFinishdate() == null) {
			taskVO.setTaskFinishdate(new Date()); // 완료인데 날짜 없으면 오늘 날짜
		}
        
		// 상위업무 업데이트
		int result = projectTaskMapper.updateTask(taskVO);
		
		// 업무 업데이트 알림 시작	
		List<Integer> receivers = notiService.selectSubManagerPmNoti(taskVO.getTaskId());
		int projectNo = notiService.selectProjectNoByTaskId(taskVO.getTaskId());
		NotificationVO notiVO = new NotificationVO();
		notiVO.setNotiMessage("["+taskVO.getTaskTitle()+"]"+" 업무 정보가 변경되었습니다.");
		notiService.pushManagerNoti(projectNo,taskVO.getTaskId(),receivers,notiVO);	
   	    // 업무 업데이트 알림 끝

		 
		 
		Map<String, Object> delParamT = new HashMap<>();
		// 상위업무 담당자 업데이트 (삭제 후 재등록)
		delParamT.put("workId", taskVO.getTaskId());
		delParamT.put("workType", "T");
		projectTaskMapper.deleteTaskManager(delParamT);
		
		// 상위업무 담당자 중복 제거 후 INSERT
		//[알림KMS] 기존담당자 리스트
		List<Integer> afterTaskManagers = Collections.emptyList();
		
		if(taskVO.getTaskManagerNos() != null && !taskVO.getTaskManagerNos().isEmpty()) {
	        // List -> Set -> List로 중복 제거
	        List<Integer> distinctMembers = taskVO.getTaskManagerNos().stream()
	                                              .distinct()
	                                              .collect(Collectors.toList());
	        
	        Map<String, Object> insParamT = new HashMap<>();
	        insParamT.put("workId", taskVO.getTaskId());
	        insParamT.put("taskManagerNos", distinctMembers); // 중복 제거된 리스트 사용
	        projectTaskMapper.insertTaskManager(insParamT);
	        
	        afterTaskManagers = distinctMembers;    
		}
		
		//새로 추가된 상위업무 담당자에게만 알림 시작
		List<Integer> addedTaskManagers = afterTaskManagers.stream()
				.filter(m -> !beforeTaskManagers.contains(m))
				.collect(Collectors.toList());

		if(!addedTaskManagers.isEmpty()) {
			NotificationVO assignVO = new NotificationVO();
			assignVO.setNotiMessage("[" + taskVO.getTaskTitle() + "] 업무 담당자로 지정되었습니다.");
			notiService.pushManagerNoti(projectNo, taskVO.getTaskId(), addedTaskManagers, assignVO);
		}
		//새로 추가된 상위업무 담당자에게만 알림 끝
		
		
		// 하위업무 삭제 처리 - 삭제 버튼을 누른 하위업무
		if(deleteSubIds != null && !deleteSubIds.isEmpty()) {
			for(Integer subId : deleteSubIds) {
				// 하위업무 담당자 삭제
				Map<String, Object> delParamS = new HashMap<>();
				delParamS.put("workId", subId);
				delParamS.put("workType", "S");
				projectTaskMapper.deleteTaskManager(delParamS);
				
				// 하위업무 삭제
				projectTaskMapper.deleteSubTask(subId);
			}
		}
		
		// 하위업무 수정 및 신규 등록
		List<ProjectTaskSubVO> subList = taskVO.getSubTasks();
		if(subList != null && !subList.isEmpty()) {
			for(ProjectTaskSubVO sub : subList) {
				// 상위업무 일현번호 세팅
				sub.setTaskId(taskVO.getTaskId()); // 뷁 이거 안 해도 되지 않나?
				
				if (sub.getSubStatus() != TaskStatus.DONE) {
					sub.setSubFinishdate(null);
				} else if (sub.getSubFinishdate() == null) {
					sub.setSubFinishdate(new Date());
				}
				
				// 하위업무 담당자 삭제(초기화)
				if(sub.getSubId() > 0) {
					Map<String, Object> delParamS = new HashMap<>();
					delParamS.put("workId", sub.getSubId());
					delParamS.put("workType", "S");
					projectTaskMapper.deleteTaskManager(delParamS);
					
					// 기존 하위업무 업데이트
					projectTaskMapper.updateSubTask(sub);
				} else {
					// 신규 하위업무 등록
					if(sub.getSubWriter() == 0) {
						sub.setSubWriter(taskVO.getTaskWriter());	// 현재는 작성자만 수정 가능한 구조.
					}
					
					// default 안전장치 (null 방지)
					if(sub.getSubStatus() == null) sub.setSubStatus(TaskStatus.REQUEST); 
	                if(sub.getSubPriority() == null) sub.setSubPriority(TaskPriority.NORMAL);
	                
					projectTaskMapper.insertSubTask(sub);
				}
				
				// 하위업무 담당자 중복 제거 후 (재)등록
				if(sub.getSubManagerNos() != null && !sub.getSubManagerNos().isEmpty()) {
	                // List -> Set -> List로 중복 제거
	                List<Integer> distinctSubMembers = sub.getSubManagerNos().stream()
	                                                      .distinct()
	                                                      .collect(Collectors.toList());
	                
	                Map<String, Object> insParamS = new HashMap<>();
	                insParamS.put("workId", sub.getSubId());
	                insParamS.put("subManagerNos", distinctSubMembers); // 중복 제거된 리스트 사용
	                projectTaskMapper.insertSubManager(insParamS);
	            }
			}
		}
		// 내 업무 상위업무 진척도 자동 계산 실패 해결을 위한 시도... 
		syncParentTask(taskVO.getTaskId());
		return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	/**
	 * 하위업무 수정
	 */
	@Override
    public ServiceResult updateSubTask(ProjectTaskSubVO subVO) {
		// 화면에서 taskId가 넘어오지 않을 수도 있고, 안전하게 DB에서 조회하는 것
		ProjectTaskSubVO currentVO = projectTaskMapper.selectSubTaskDetail(subVO.getSubId());
		if(currentVO == null) return ServiceResult.FAILED;
		
		int parentTaskId = currentVO.getTaskId();
		ProjectTaskVO parentTask = projectTaskMapper.selectTaskDetail(parentTaskId);
		// 날짜 비교 로직
        // 하위 시작일 < 상위 시작일 OR 하위 마감일 > 상위 마감일 이면 에러
        if (parentTask != null) {
            if (subVO.getSubStartdate() != null && subVO.getSubStartdate().before(parentTask.getTaskStartdate())) {
                return ServiceResult.FAILED; // 또는 별도 에러 코드 리턴 (예: INVALID_DATE)
            }
            if (subVO.getSubEnddate() != null && subVO.getSubEnddate().after(parentTask.getTaskEnddate())) {
                return ServiceResult.FAILED; 
            }
        }
        
        // 하위업무 완료일 처리 로직
        if (subVO.getSubStatus() != TaskStatus.DONE) {
			subVO.setSubFinishdate(null);
		} else if (subVO.getSubFinishdate() == null) {
			subVO.setSubFinishdate(new Date());
		}
        
        
        //[알림KMS] 변경 전 담당자 목록
        List<Integer> beforeManagerNos = projectTaskMapper.selectSubTaskManagers(subVO.getSubId()).stream()
                .map(ProjectTaskManagerVO::getMemberNo)
                .distinct()
                .collect(Collectors.toList());
		
        int result = projectTaskMapper.updateSubTask(subVO);
        

        // 업무 변경 알림 시작 (기존 그대로)
        List<Integer> receivers = notiService.selectSubManagerPmNoti(parentTaskId);
        int projectNo = notiService.selectProjectNoByTaskId(parentTaskId);

        if(result > 0) {
            NotificationVO notiVO1 = new NotificationVO();
            notiVO1.setNotiMessage("[" + subVO.getSubTitle() + "] 업무 정보가 변경되었습니다.");
            notiService.pushManagerNoti(projectNo, parentTaskId, receivers, notiVO1);
        }else {
            return ServiceResult.FAILED;
        }
        // 업무 변경 알림 끝
        

        
	    // 기존 하위업무 담당자 전체 삭제
		Map<String, Object> deleteMap = new HashMap<>();
		deleteMap.put("workId", subVO.getSubId());
		deleteMap.put("workType", "S"); // 하위업무 타입
		projectTaskMapper.deleteTaskManager(deleteMap);
		
		// 새로운 담당자가 선택되었다면 등록
		List<Integer> managerNos = subVO.getSubManagerNos(); 
		
		if(managerNos != null && !managerNos.isEmpty()) {
			Map<String, Object> insertMap = new HashMap<>();
			insertMap.put("workId", subVO.getSubId());
			insertMap.put("subManagerNos", managerNos); 
		
		projectTaskMapper.insertSubManager(insertMap);
		
		
		// [알림KMS] 추가된사람에게 알림발송 시작
        List<Integer> distinctManagerNos = managerNos.stream().distinct().collect(Collectors.toList());
        List<Integer> added = distinctManagerNos.stream()
                .filter(m -> !beforeManagerNos.contains(m))
                .collect(Collectors.toList());

        if(!added.isEmpty()) {
            NotificationVO notiVO2 = new NotificationVO();
            notiVO2.setNotiMessage("[" + subVO.getSubTitle() + "] 업무 담당자로 지정되었습니다.");
            notiService.pushManagerNoti(projectNo, subVO.getTaskId(), added, notiVO2);
        }
     // [알림KMS] 추가된사람에게 알림발송 끝
    }
		
        if(result > 0) {
        	syncParentTask(parentTaskId);
        	return ServiceResult.OK;
        } else {
        	return ServiceResult.FAILED;
        }
    }

	/**
	 * 상위 업무 상세
	 */
	@Override
	public ProjectTaskVO getTaskDetail(int taskId) {
		// 상위업무 상세정보 조회
		ProjectTaskVO taskVO = projectTaskMapper.selectTaskDetail(taskId);
		
		if(taskVO != null) {
			// 상세 조회 시 상태 최신화
			checkAndAutoUpdateStatus(taskVO);
			
			// 종속된 파일 정보 조회
			if(taskVO.getFileGroupNo() > 0) {
				List<FileDetailVO> fileList = fileService.selectFileDetailList(taskVO.getFileGroupNo());
				taskVO.setFileList(fileList);
			}
			
			// 담당자 조회
			List<ProjectTaskManagerVO> managers = projectTaskMapper.selectTaskManagers(taskId);
			taskVO.setTaskManagers(managers);
			
			// 종속된 하위업무 목록 조회
			List<ProjectTaskSubVO> subList = projectTaskMapper.selectSubListByTaskId(taskId);
			
			// 종속된 하위업무 담당자 조회
			if(subList != null && !subList.isEmpty()) {
				for(ProjectTaskSubVO sub : subList) {
					checkAndAutoUpdateStatus(sub); // 상태 체크 및 DB 업데이트
					
					List<ProjectTaskManagerVO> subManagers = projectTaskMapper.selectSubTaskManagers(sub.getSubId());
					sub.setSubManagers(subManagers);		
				}
			}
			taskVO.setSubTasks(subList);
		}
		return taskVO;
	}

	/**
	 * 하위 업무 상세
	 */
	@Override
	public ProjectTaskSubVO getSubTaskDetail(int subId) {
		ProjectTaskSubVO subVO = projectTaskMapper.selectSubTaskDetail(subId);
		
		if(subVO != null) {
			// 하위업무 상세 조회 시 상태 최신화
			checkAndAutoUpdateStatus(subVO);
			
			// 파일 정보 조회
			if(subVO.getFileGroupNo() > 0) {
				List<FileDetailVO> fileList = fileService.selectFileDetailList(subVO.getFileGroupNo());
				subVO.setFileList(fileList);
			}
			// 담당자 조회
			List<ProjectTaskManagerVO> managers = projectTaskMapper.selectSubTaskManagers(subId);
			subVO.setSubManagers(managers);
		}
		
		return subVO;
	}
	
	/**
	 * 상위업무 진척도 및 상태값 업데이트
	 */
	@Override
	public ServiceResult updateSubTaskRate(int subId, int subRate) {
		ProjectTaskSubVO subVO = projectTaskMapper.selectSubTaskDetail(subId);
		if(subVO == null) return ServiceResult.FAILED;
		
		// 규칙을 적용한 후의 업무 상태값
		TaskStatus newStatus = determineStatus(subRate, subVO.getSubEnddate(), subVO.getSubStatus());
		
		// 진척도와 상태 업데이트
		subVO.setSubRate(subRate);
		subVO.setSubStatus(newStatus);
		
		// 결정된 상태(newStatus)에 따라 완료일 처리
		if (newStatus == TaskStatus.DONE) {
			// 100%가 되어 완료상태가 되면 오늘 날짜 찍기 (이미 있으면 유지)
			if (subVO.getSubFinishdate() == null) {
				subVO.setSubFinishdate(new Date());
			}
		} else {
			// 100% 미만으로 떨어져서 완료 상태가 풀리면 날짜 삭제
			subVO.setSubFinishdate(null);
		}
		
		int cnt = projectTaskMapper.updateSubTask(subVO);
		
		if(cnt > 0) {
			syncParentTask(subVO.getTaskId());
			return ServiceResult.OK;
		}
		return ServiceResult.FAILED;
	}
	
	/**
	 * 업무 삭제
	 */
	@Transactional
	@Override
	public ServiceResult deleteTask(int workId, String type) {
		int result = 0;
	    
	    if ("T".equals(type)) {
	        // 해당 상위업무에 속한 하위업무들의 ID 조회 (먼저 조회해야 함)
	        List<ProjectTaskSubVO> subList = projectTaskMapper.selectSubListByTaskId(workId);
	        
	        // 하위업무들 삭제 (담당자 -> 본체 순)
	        for(ProjectTaskSubVO sub : subList) {
	            Map<String, Object> delParamS = new HashMap<>();
	            delParamS.put("workId", sub.getSubId());
	            delParamS.put("workType", "S");
	            projectTaskMapper.deleteTaskManager(delParamS); // 하위 담당자 삭제
	            
	            projectTaskMapper.deleteSubTask(sub.getSubId()); // 하위 업무 삭제
	        }
	        
	        // 상위업무 담당자 삭제
	        Map<String, Object> delParamT = new HashMap<>();
	        delParamT.put("workId", workId);
	        delParamT.put("workType", "T");
	        projectTaskMapper.deleteTaskManager(delParamT);
	        
	        // 상위업무 본체 삭제
	        result = projectTaskMapper.deleteTask(workId);
	        
	    } else {
	        // 하위업무 담당자 삭제
	        Map<String, Object> delParamS = new HashMap<>();
	        delParamS.put("workId", workId);
	        delParamS.put("workType", "S");
	        projectTaskMapper.deleteTaskManager(delParamS);
	        
	        // 하위업무 본체 삭제
	        result = projectTaskMapper.deleteSubTask(workId);
	    }
	    
	    return result > 0 ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	/**
	 * 상위업무 진척도 및 상태값 업데이트 메서드 
	 * - 종속된 하위업무 진척도의 평균값으로 업데이트
	 * @param taskId
	 */
	private void syncParentTask(int taskId) {
		List<ProjectTaskSubVO> subList = projectTaskMapper.selectSubListByTaskId(taskId);
		
		int avgRate = 0;
		if(subList != null && !subList.isEmpty()) {
			int total = 0;
			
			for(ProjectTaskSubVO sub : subList) {
				total += sub.getSubRate();
			}
			avgRate = (int) Math.round(total / subList.size());
		}
		
		ProjectTaskVO parentTaskVO = projectTaskMapper.selectTaskDetail(taskId);
		if(parentTaskVO == null) return;
		
		parentTaskVO.setTaskRate(avgRate);
		
		TaskStatus newParentStatus = determineStatus(avgRate, parentTaskVO.getTaskEnddate(), parentTaskVO.getTaskStatus());
		parentTaskVO.setTaskStatus(newParentStatus);
		
		projectTaskMapper.updateTask(parentTaskVO);
	}
	
	/**
	 * 진척도와 마감일 기반 상태 업데이트 메서드
	 * @param rate : 업무 진행도
	 * @param endDate : 업무 마감일
	 * @param currentStatus : 사용자 지정 업무 상태
	 * @return status : 업데이트 되는 업무 상태
	 */
	private TaskStatus determineStatus(int rate, Date endDate, TaskStatus currentStatus) {
		// 1. [핵심 수정] 사용자가 '보류(HOLD)'로 설정했다면, 진척도와 상관없이 보류 상태 유지
		if (currentStatus == TaskStatus.HOLD) {
			return TaskStatus.HOLD;
		}
		
		TaskStatus newStatus = TaskStatus.REQUEST;	// default: 요청 (0%)
		
		if(rate == 100) {
			newStatus = TaskStatus.DONE;	// 완료 (100%)
		} else if(rate > 0) {
			newStatus = TaskStatus.PROGRESS;	// 진행 (5% ~ 95%)
		}
		
		// '지연' 상태 체크 (보류가 아닌 경우에만)
		if(currentStatus != TaskStatus.HOLD && endDate != null) {
			Date now = new Date();
			if(now.after(endDate)) {
				if(newStatus != TaskStatus.DONE) {
					newStatus = TaskStatus.DELAYED;
				}
			}
		}
		return newStatus;
	}
	
	private void checkAndAutoUpdateStatus(ProjectTaskVO task) {
		if (task == null) return;
		
		// 지연 조건 충족 시
		if (isOverdue(task.getTaskEnddate(), task.getTaskStatus())) {
			task.setTaskStatus(TaskStatus.DELAYED);
			projectTaskMapper.updateTask(task); // DB 업데이트
			log.info("Auto-updated Task ID {} to DELAYED", task.getTaskId());
		}
		
		// 종속된 하위업무가 있다면 같이 체크
		if (task.getSubTasks() != null) {
			for (ProjectTaskSubVO sub : task.getSubTasks()) {
				checkAndAutoUpdateStatus(sub);
			}
		}
	}

	// 하위업무용 오버로딩
	private void checkAndAutoUpdateStatus(ProjectTaskSubVO sub) {
		if (sub == null) return;
		
		if (isOverdue(sub.getSubEnddate(), sub.getSubStatus())) {
			sub.setSubStatus(TaskStatus.DELAYED);
			projectTaskMapper.updateSubTask(sub); // DB 업데이트
			log.info("Auto-updated SubTask ID {} to DELAYED", sub.getSubId());
		}
	}

	// [지연 판단 로직] 마감일 지남 && (완료/보류/지연) 상태가 아님
	private boolean isOverdue(Date endDate, TaskStatus status) {
		if (endDate == null || status == null) return false;
		
		Date now = new Date();
		// 날짜 비교 (After) && 상태 체크
		return now.after(endDate) 
				&& status != TaskStatus.DONE 
				&& status != TaskStatus.HOLD 
				&& status != TaskStatus.DELAYED;
	}
}
