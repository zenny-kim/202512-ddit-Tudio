<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tudio - My Task</title>
    <jsp:include page="/WEB-INF/views/include/common.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my_task.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/include/headerUser.jsp"/>
    
    <div class="d-flex flex-grow-1">
        <jsp:include page="../include/sidebarUser.jsp">
              <jsp:param name="menu" value="myTask" />
        </jsp:include>
        
        <main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
            <div class="container-fluid my-task-container">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-primary-dark m-0">
                            <i class="bi bi-collection me-2"></i>내 업무 모아보기
                        </h3>
                        <p class="text-muted mb-0 small mt-2">참여 중인 모든 프로젝트의 업무를 한눈에 확인하세요.</p>
                        
                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" id="toggleAllCheckbox" style="cursor: pointer;" checked>
                            <label class="form-check-label small text-muted user-select-none" for="toggleAllCheckbox" style="cursor: pointer;">
                                업무 모두 펼치기
                            </label>
                        </div>
                    </div>
                    
                    <form id="filterForm" action="${pageContext.request.contextPath}/tudio/myTask" method="get" class="d-flex align-items-center gap-2">
                        <select name="projectStatus" class="form-select form-select-sm" style="width: 140px;" onchange="this.form.submit()">
						    <option value="0" ${param.projectStatus == '0' || param.projectStatus == null ? 'selected' : ''}>진행중 프로젝트</option>
						    
						    <option value="1" ${param.projectStatus == '1' ? 'selected' : ''}>완료된 프로젝트</option>
						    
						    <option value="3" ${param.projectStatus == '3' ? 'selected' : ''}>전체 프로젝트</option>
						</select>

                        <div class="btn-group" role="group">
						    <input type="radio" class="btn-check" name="type" id="typeAll" value="" onchange="this.form.submit()">
						    <label class="btn btn-outline-primary btn-sm" for="typeAll">전체</label>
						
						    <input type="radio" class="btn-check" name="type" id="typeWriter" value="writer" onchange="this.form.submit()">
						    <label class="btn btn-outline-primary btn-sm" for="typeWriter">작성자</label>
						
						    <input type="radio" class="btn-check" name="type" id="typeManager" value="manager" onchange="this.form.submit()">
						    <label class="btn btn-outline-primary btn-sm" for="typeManager">담당자</label>
						</div>
<!--                         
                        <button type="button" class="tudio-btn tudio-btn-primary ms-2" data-bs-toggle="modal" data-bs-target="#newTaskModal">
                            <i class="bi bi-plus-lg"></i> 새 업무 등록
                        </button>
 -->                        
                    </form>
                </div>
        
                <c:choose>
                    <c:when test="${empty myTaskMap}">
                        <div class="text-center py-5 text-muted border rounded bg-white mt-5">
                            <i class="bi bi-clipboard-x fs-1 d-block mb-3"></i>
                            <p class="m-0">조회된 업무가 없습니다.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${myTaskMap}" var="entry">
                            <c:set var="taskList" value="${entry.value}" />
                            <c:set var="pName" value="${taskList[0].projectName}" />

                            <div class="tudio-section mb-5">
                                <div class="tudio-section-header">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-folder2-open text-primary-dark"></i>
                                        
                                        <span class="fw-bold text-primary-dark project-link" 
                                              onclick="goToProject(${entry.key})" 
                                              title="프로젝트 메인으로 이동">
                                            ${pName}
                                        </span>
                                        
                                        <span class="tudio-badge bg-light text-secondary border">${fn:length(taskList)}</span>
                                    </div>
                                </div>
                                <div class="p-0">
                                    <table class="tudio-table-card mb-0">
									    <colgroup>
									        <col style="width: 18%;"> <col style="width: 7%;">  <col style="width: 8%;">  <col style="width: 9%;">  <col style="width: 9%;">  <col style="width: 9%;">  <col style="width: 8%;">  <col style="width: 10%;"> <col style="width: 7%;">  </colgroup>
									    <thead>
									        <tr>
									            <th>업무명</th>
									            <th>상태</th>
									            <th>담당자</th>
									            <th>시작일</th> 
									            <th>마감일</th>
									            <th>완료일</th> 
									            <th>중요도</th>
									            <th>진척도</th>
									            <th>작성자</th> 
									        </tr>
									    </thead>
									    <tbody>
									        <c:forEach items="${taskList}" var="task">
									            
									            <c:set var="isMyParent" value="${task.isMyTask eq 'Y'}" />
									            <c:set var="hasSubTasks" value="${not empty task.subTasks}" />
									
									            <c:if test="${!isMyParent}">
									                <tr class="task-shell-row">
									                    <td class="task-title">
									                        <c:if test="${hasSubTasks}">
									                            <span class="toggle-btn me-2" onclick="toggleSubTasks('${task.taskId}', this)">
									                                <i class="bi bi-caret-right-fill toggle-icon"></i>
									                            </span>
									                        </c:if>
									                        <c:if test="${!hasSubTasks}"><span style="width:20px; display:inline-block;"></span></c:if>
									                        
									                        <span class="text-muted" style="text-decoration: none;">${task.taskTitle}</span>
									                    </td>
									                    <td colspan="8" class="text-start">
									                        <span class="small text-muted ps-2" style="opacity: 0.6;">
									                            <i class="bi bi-info-circle me-1"></i>내 단위업무가 포함된 상위 그룹입니다.
									                        </span>
									                    </td>
									                </tr>
									            </c:if>
									
									            <c:if test="${isMyParent}">
									                <tr class="task-row" onclick="openDetailPanel('${task.taskId}', 'T')" style="cursor: pointer;">
									                    <td class="task-title">
									                        <c:if test="${hasSubTasks}">
									                            <span class="toggle-btn me-2" onclick="toggleSubTasks('${task.taskId}', this); event.stopPropagation();">
																    <i class="bi bi-caret-right-fill toggle-icon"></i>
																</span>
									                        </c:if>
									                        <c:if test="${!hasSubTasks}">
									                            <span class="me-1" style="width: 20px; display:inline-block;"></span> 
									                        </c:if>
									                        
									                        <span class="task-title-text">${task.taskTitle}</span>
									                    </td>
									
									                    <td><span class="tudio-badge task-status-${fn:toLowerCase(task.taskStatus.name())}">${task.taskStatus.label}</span></td>
									                    <td>
														    <c:set var="tNames" value="${fn:split(task.taskManagerName, ', ')}" />
														    <c:choose>
														        <c:when test="${empty tNames}">
														            <span class="small text-muted">-</span>
														        </c:when>
														        <c:when test="${fn:length(tNames) > 1}">
														            <span class="small text-dark" title="${task.taskManagerName}">
														                ${tNames[0]} <span class="small text-muted">외 ${fn:length(tNames) - 1}명</span>
														            </span>
														        </c:when>
														        <c:otherwise>
														            <span class="small text-dark">${tNames[0]}</span>
														        </c:otherwise>
														    </c:choose>
														</td>
									                    <td><span class="small text-muted"><fmt:formatDate value="${task.taskStartdate}" pattern="yyyy.MM.dd"/></span></td>
									                    <td><span class="small text-muted"><fmt:formatDate value="${task.taskEnddate}" pattern="yyyy.MM.dd"/></span></td>
									                    
									                    <td>
									                        <c:if test="${not empty task.taskFinishdate}">
									                            <span class="small fw-bold ${task.taskFinishdate.time > task.taskEnddate.time ? 'text-danger' : 'text-success'}">
									                                <fmt:formatDate value="${task.taskFinishdate}" pattern="yyyy.MM.dd"/>
									                            </span>
									                        </c:if>
									                        <c:if test="${empty task.taskFinishdate}">
									                            <span class="small text-muted">-</span>
									                        </c:if>
									                    </td>
									
									                    <td><span class="tudio-badge task-priority-${fn:toLowerCase(task.taskPriority.name())}">${task.taskPriority.label}</span></td>
									                    <td>
									                        <div class="d-flex align-items-center justify-content-center gap-2">
									                            <div class="progress" style="height: 6px; width: 60px;">
									                                <div class="progress-bar bg-primary" style="width: ${task.taskRate}%"></div>
									                            </div>
									                            <span class="small text-muted" style="width: 30px;">${task.taskRate}%</span>
									                        </div>
									                    </td>
									                    <td><span class="small text-muted">${task.writerName}</span></td>
									                </tr>
									            </c:if>
									
									            <c:forEach items="${task.subTasks}" var="sub">
									                <tr class="sub-row sub-group-${task.taskId}" onclick="openDetailPanel('${sub.subId}', 'S')" style="cursor: pointer;">
									                    <td class="sub-title">
									                        <div class="d-flex align-items-center">
									                            <i class="bi bi-arrow-return-right text-muted me-2"></i>
									                            <span class="text-dark small">${sub.subTitle}</span>
									                        </div>
									                    </td>
									                    
									                    <td><span class="tudio-badge task-status-${fn:toLowerCase(sub.subStatus.name())}">${sub.subStatus.label}</span></td>
									                    <td>
														    <c:set var="sNames" value="${fn:split(sub.taskManagerName, ', ')}" />
														    <c:choose>
														        <c:when test="${empty sNames}">
														            <span class="small text-muted">-</span>
														        </c:when>
														        <c:when test="${fn:length(sNames) > 1}">
														            <span class="small text-dark" title="${sub.taskManagerName}">
														                ${sNames[0]} <span class="small text-muted">외 ${fn:length(sNames) - 1}명</span>
														            </span>
														        </c:when>
														        <c:otherwise>
														            <span class="small text-dark">${sNames[0]}</span>
														        </c:otherwise>
														    </c:choose>
														</td>
									                    <td><span class="small text-muted"><fmt:formatDate value="${sub.subStartdate}" pattern="yyyy.MM.dd"/></span></td>
									                    <td><span class="small text-muted"><fmt:formatDate value="${sub.subEnddate}" pattern="yyyy.MM.dd"/></span></td>
									                    
									                    <td>
									                        <c:if test="${not empty sub.subFinishdate}">
									                            <span class="small fw-bold ${sub.subFinishdate.time > sub.subEnddate.time ? 'text-danger' : 'text-success'}">
									                                <fmt:formatDate value="${sub.subFinishdate}" pattern="yyyy.MM.dd"/>
									                            </span>
									                        </c:if>
									                        <c:if test="${empty sub.subFinishdate}">
									                            <span class="small text-muted">-</span>
									                        </c:if>
									                    </td>
									
									                    <td><span class="tudio-badge task-priority-${fn:toLowerCase(sub.subPriority.name())}">${sub.subPriority.label}</span></td>
									                    <td>
									                        <div class="d-flex align-items-center justify-content-center gap-2">
									                            <div class="progress" style="height: 6px; width: 60px;">
									                                <div class="progress-bar bg-success" style="width: ${sub.subRate}%"></div>
									                            </div>
									                            <span class="small text-muted" style="width: 30px;">${sub.subRate}%</span>
									                        </div>
									                    </td>
									                    <td><span class="small text-muted">${sub.writerName}</span></td>
									                </tr>
									            </c:forEach>
									        </c:forEach>
									    </tbody>
									</table>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
		
		        <div id="projectTaskContainer" class="d-flex flex-column gap-4"></div>
		
		    </div>
		</main>
	</div>
    
    <div id="taskDetailPanel" class="task-detail-panel">
        <div class="panel-header">
            <h5 class="fw-bold mb-0 text-primary-dark">
                <i class="bi bi-pencil-square me-2"></i>업무 상세
            </h5>
            <button type="button" class="btn-close" onclick="closeTaskPanel()"></button>
        </div>
        
        <div class="panel-body">
            <form id="taskEditForm">
                <input type="hidden" name="id" id="detailId">
                <input type="hidden" name="type" id="detailType"> 
                <input type="hidden" name="projectNo" id="detailProjectNo">

                <div id="taskBreadcrumbArea" class="task-breadcrumb"></div>

				<label class="form-label small fw-bold text-muted mb-1">업무명</label>
				
                <div class="task-title-wrapper">
                    <input type="text" class="form-control" name="title" id="detailTitle" placeholder="업무 제목을 입력하세요" autocomplete="off">
                    <i class="bi bi-pencil-fill title-edit-icon"></i>
                </div>

                <div class="row g-2 mb-4 align-items-end task-info-row">
                    <div class="col-2">
                        <label class="form-label small fw-bold text-muted mb-1">상태</label>
                        <select class="form-select form-select-sm" name="status" id="detailStatus">
                            <option value="REQUEST">요청</option>
                            <option value="PROGRESS">진행</option>
                            <option value="DONE">완료</option>
                            <option value="HOLD">보류</option>
                            <option value="DELAYED">지연</option>
                        </select>
                    </div>
                    
                    <div class="col-2">
                        <label class="form-label small fw-bold text-muted mb-1">중요도</label>
                        <select class="form-select form-select-sm" name="priority" id="detailPriority">
                            <option value="URGENT">긴급</option>
                            <option value="HIGH">높음</option>
                            <option value="NORMAL">보통</option>
                            <option value="LOW">낮음</option>
                        </select>
                    </div>

                    <div class="col-4">
                        <label class="form-label small fw-bold text-muted mb-1" for="detailStart">시작일</label>
                        <div class="date-input-wrapper">
                            <input type="date" class="form-control form-control-sm cursor-pointer" name="startdate" id="detailStart">
                        </div>
                    </div>

                    <div class="col-4">
                        <label class="form-label small fw-bold text-muted mb-1" for="detailEnd">마감일</label>
                        <div class="date-input-wrapper">
                            <input type="date" class="form-control form-control-sm cursor-pointer" name="enddate" id="detailEnd">
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted d-flex justify-content-between">
                        <span>진척도</span>
                        <span id="detailRateVal" class="text-primary">0%</span>
                    </label>
                    <input type="range" class="form-range" name="rate" id="detailRate" min="0" max="100" step="5">
                </div>
                
                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted">담당자 (다중 선택 가능)</label>
                    
                    <div class="dropdown">
                        <button class="form-select form-select-sm text-start d-flex justify-content-between align-items-center" 
                                type="button" id="assigneeDropdownBtn" data-bs-toggle="dropdown" aria-expanded="false">
                            <span>데이터 로딩 중...</span>
                            <i class="bi bi-chevron-down small text-muted"></i>
                        </button>
                        
                        <div class="dropdown-menu w-100" aria-labelledby="assigneeDropdownBtn">
                            <div class="dropdown-search-wrap">
                                <input type="text" class="dropdown-search-input" id="assigneeSearchInput" placeholder="이름으로 검색...">
                            </div>
                            
                            <ul id="assigneeDropdownList" class="list-unstyled mb-0">
                                </ul>
                        </div>
                    </div>
                    
                    <div id="selectedAssigneeArea" class="d-flex flex-wrap gap-1 mt-2"></div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted">상세 내용</label>
                    <textarea class="form-control" name="content" id="detailContent" rows="6" style="resize: none;"></textarea>
                </div>

				<div class="mb-4">
                    <label class="form-label small fw-bold text-muted">첨부파일</label>
                    <ul id="detailFileList" class="list-group list-group-flush border rounded-3" style="background-color: #f8fafc;">
                        </ul>
                </div>
            </form>
        </div>
        
        <div class="panel-footer d-flex justify-content-end gap-2">
            <button type="button" class="tudio-btn tudio-btn-outline-danger" id="btnDeleteDetail">삭제</button>
            <button type="button" class="tudio-btn tudio-btn-primary" id="btnSaveDetail">저장</button>
        </div>
    </div>

    <div class="modal fade" id="newTaskModal" tabindex="-1">
       <div class="modal-dialog modal-dialog-centered tudio-modal">
            <div class="modal-content">
                <div class="modal-header tudio-modal-header"><h5 class="modal-title tudio-modal-title fw-bold">새 업무 등록</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body"><form><div class="mb-3"><label class="form-label small fw-bold text-muted">업무명</label><input type="text" class="form-control"></div></form></div>
                <div class="modal-footer tudio-modal-footer"><button type="button" class="tudio-btn tudio-btn-outline" data-bs-dismiss="modal">취소</button><button type="button" class="tudio-btn tudio-btn-primary">등록하기</button></div>
            </div>
        </div>
    </div>

    <jsp:include page="../chat/main.jsp"/>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    
    <script src="${pageContext.request.contextPath}/js/myTask.js"></script>
</body>
</html>