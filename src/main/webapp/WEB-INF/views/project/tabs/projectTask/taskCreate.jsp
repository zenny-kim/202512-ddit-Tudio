<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/task_create.css">

<div class="task-create-wrap">

	<div class="task-create-header">
		<div>
			<h4 class="task-create-title">${isEdit ? '업무 수정' : '새 업무 생성'}</h4>
			<div class="task-create-subtitle">
				${isEdit ? '업무 내용을 수정합니다.' : '필수 항목을 입력하고 업무를 생성하세요.'}
			</div>
		</div>
	</div>

	<form id="createTaskForm" method="post" action="${pageContext.request.contextPath}/tudio/project/task/${isEdit ? 'update' : 'create'}">
		<input type="hidden" name="projectNo" value="${projectNo}" />

		<c:if test="${isEdit}">
            <input type="hidden" name="taskId" value="${task.taskId}" />
            <input type="hidden" name="fileGroupNo" value="${task.fileGroupNo}" /> 
        </c:if>
        
		<div class="task-card">
			<div class="d-flex justify-content-between align-items-center mb-3">
		        <div class="task-card-title mb-0">기본 정보</div>
		        
		        <button type="button" class="btn btn-sm btn-outline-secondary" id="btnFillDummyData" 
		                style="font-size: 12px; border-color: #ddd; color: #666;">
		            <i class="bi bi-magic me-1"></i>데이터 불러오기
		        </button>
		    </div>

			<div class="row g-3">
				<div class="col-md-12">
					<label class="task-label">업무 제목 <span class="text-danger">*</span></label>
					<input type="text" class="form-control" name="taskTitle"
						placeholder="업무 제목 입력" required value="${task.taskTitle}">
				</div>

				<div class="col-md-12">
					<label class="task-label">업무 내용</label>
					<textarea class="form-control" name="taskContent" rows="5"
						placeholder="업무 상세 내용 입력">${task.taskContent}</textarea>
				</div>
			</div>
		</div>

		<!-- 2) 일정/상태/중요도/진척도 -->
		<div class="task-card">
		    <div class="task-card-title">일정 및 설정</div>
		
		    <div class="row g-3">
		        <div class="col-md-2">
		            <label class="task-label">상태</label> 
		            <select class="form-select" name="taskStatus" id="taskStatusSelect">
		                <c:forEach items="${taskStatusList}" var="tStatus">
		                    <option value="${tStatus.name()}" 
                                ${isEdit and task.taskStatus == tStatus ? 'selected' : (not isEdit and tStatus.code == 201 ? 'selected' : '')}>
                                ${tStatus.label}
                            </option>
		                </c:forEach>
		            </select>
		        </div>
		
		        <div class="col-md-2">
		            <label class="task-label">중요도</label> 
		            <select class="form-select" name="taskPriority" id="taskPrioritySelect">
		                <c:forEach items="${taskPriorityList}" var="tPriority">
		                    <option value="${tPriority.name()}" 
                                ${isEdit and task.taskPriority == tPriority ? 'selected' : (not isEdit and tPriority.code == 212 ? 'selected' : '')}>
                                ${tPriority.label}
                            </option>
		                </c:forEach>
		            </select>
		        </div>
		
		        <div class="col-md-4">
		            <label class="task-label">시작일</label> 
		            <fmt:formatDate value="${task.taskStartdate}" pattern="yyyy-MM-dd" var="startDate"/>
		            <input type="date" class="form-control" name="taskStartdate" id="taskStartdate" 
		                   onclick="this.showPicker()" style="cursor: pointer;" value="${startDate}">
		        </div>
		
		        <div class="col-md-4">
		            <div class="d-flex justify-content-between align-items-center mb-2">
		                <label class="task-label m-0">마감일</label>
		                <button type="button" class="btn btn-sm btn-soft py-0 px-2" id="syncProjectEndBtn" 
		                        title="프로젝트 마감일로 설정" style="font-size: 12px; height: 24px;">
		                    <i class="bi bi-arrow-repeat"></i> 동기화
		                </button>
		            </div>
		            <fmt:formatDate value="${task.taskEnddate}" pattern="yyyy-MM-dd" var="endDate"/>
		            <input type="date" class="form-control" name="taskEnddate" id="taskEnddate"
		                   onclick="this.showPicker()" style="cursor: pointer;" value="${endDate}">
		        </div>
		
		        <div class="col-md-12">
				    <label class="task-label">진척도</label>
				    <div class="rate-row d-flex align-items-center">
				        
				        <div id="taskRateInputMode" class="flex-grow-1">
				            <input type="range" class="form-range" min="0" max="100" step="5" 
				                   value="${isEdit ? task.taskRate : 0}" id="taskRateRange">
				        </div>
				
				        <div id="taskRateStaticMode" class="flex-grow-1" style="display:none;">
				            <div class="progress" style="height: 6px;">
				                <div class="progress-bar bg-primary" id="taskRateStaticBar" role="progressbar" style="width: 0%"></div>
				            </div>
				        </div>
				
				        <div class="rate-value ms-3">
				            <span id="taskRateValue" class="fw-bold text-primary">${isEdit ? task.taskRate : 0}</span>%
				        </div>
				    </div>
				    <input type="hidden" name="taskRate" id="taskRateHidden" value="${isEdit ? task.taskRate : 0}">
				</div>
		    </div>
		</div>

		<!-- 3) 상위업무 담당자 -->
		<div class="task-card">
			<div class="task-card-title">담당자</div>

			<div class="assignee-box">
				<input type="text" class="assignee-input" id="assigneeSearchInput"
					placeholder="이름 입력시 팀원 목록 필터링 (클릭 시 자동 목록)"
					autocomplete="off">

				<div class="assignee-tags" id="selectedAssigneeTags"></div>
 
				<div class="assignee-dropdown" id="assigneeDropdown">
		            <c:forEach items="${memberList}" var="mem">
		                <c:set var="isAssignee" value="false" />
		                <c:if test="${isEdit and not empty task.taskManagers}">
		                    <c:forEach items="${task.taskManagers}" var="tm">
		                        <c:if test="${tm.memberNo eq mem.memberNo}">
		                            <c:set var="isAssignee" value="true" />
		                        </c:if>
		                    </c:forEach>
		                </c:if>
		
		                <div class="assignee-item" 
		                    data-member-no="${mem.memberNo}"
		                    data-member-name="${mem.memberName}">
		                    
		                    <div class="d-flex align-items-center w-100">
		                        <div class="form-check m-0 me-2">
		                            <input class="form-check-input" type="checkbox" ${isAssignee ? 'checked' : ''}>
		                        </div>
		                        <div class="name flex-grow-1">${mem.memberName}</div>
		                    </div>
		                </div>
		            </c:forEach>
		        </div>
				<div class="task-help">선택된 인원 자동 상단 이동</div>

				<!-- 서버로 보내는 상위 담당자 목록 : name="taskManagerNos" -->
				<div id="taskManagerNosFields"></div>
			</div>
		</div>
		
		<c:if test="${!isEdit}">
			<div class="task-card"></div>
		</c:if>

		<!-- 4) 하위업무(다건) -->
		<div class="task-card">
			<div class="d-flex justify-content-between align-items-center mb-2">
				<div class="task-card-title mb-0">단위업무</div>
				<div class="d-flex gap-2">
					<input type="hidden" name="deleteSubIds" id="deleteSubIds" value="" />
					
					<button type="button" class="btn btn-soft" id="syncSubDatesBtn">업무 일정 동기화</button>
					<button type="button" class="btn btn-soft" id="addSubTaskBtn">+단위업무 추가</button>
				</div>
			</div>

			<div class="subtask-list" id="subTaskList">
				<div class="task-help">단위업무는 제목/기간/담당자만 입력, 나머지는 서버에서 default 처리.</div>
				
				<c:if test="${isEdit and not empty task.subTasks}">
		            <c:forEach items="${task.subTasks}" var="sub" varStatus="vs">
		                <div class="subtask-item" data-sub-index="${vs.index}">
		                    <input type="hidden" name="subTasks[${vs.index}].subId" value="${sub.subId}" class="sub-id-input">
		                    
		                    <!-- 수정시 입력받지 않는 기존의 단위업무 값 - null 방지 -->
		                    <input type="hidden" name="subTasks[${vs.index}].subStatus" value="${sub.subStatus}"> 
				            <input type="hidden" name="subTasks[${vs.index}].subPriority" value="${sub.subPriority}">
				            <input type="hidden" name="subTasks[${vs.index}].subRate" value="${sub.subRate}">
				            
		                    <div class="subtask-head">
		                        <p class="subtask-title">단위업무 ${vs.count}</p>
		                        <button type="button" class="subtask-remove" 
		                                data-action="removeSubTask" 
		                                data-existing-sub-id="${sub.subId}">삭제</button>
		                    </div>
		
		                    <div class="row g-2 align-items-end">
		                        <div class="col-md-6">
		                            <label class="task-label">제목 <span class="text-danger">*</span></label>
		                            <input type="text" class="form-control" 
		                                   name="subTasks[${vs.index}].subTitle" 
		                                   value="${sub.subTitle}" required>
		                        </div>
		
		                        <div class="col-md-3">
		                            <label class="task-label">시작일</label>
		                            <fmt:formatDate value="${sub.subStartdate}" pattern="yyyy-MM-dd" var="sDate"/>
		                            <input type="date" class="form-control" 
		                                   name="subTasks[${vs.index}].subStartdate" 
		                                   value="${sDate}" data-role="subStart">
		                        </div>
		
		                        <div class="col-md-3">
		                            <label class="task-label">마감일</label>
		                            <fmt:formatDate value="${sub.subEnddate}" pattern="yyyy-MM-dd" var="eDate"/>
		                            <input type="date" class="form-control" 
		                                   name="subTasks[${vs.index}].subEnddate" 
		                                   value="${eDate}" data-role="subEnd">
		                        </div>
		
		                        <div class="col-md-12">
		                            <label class="task-label">담당자</label>
		                            <div class="sub-assignee-box" data-sub-assignee>
		                                <div class="sub-assignee-list">
		                                    <c:forEach items="${memberList}" var="m">
		                                        <c:set var="isChecked" value="false" />
		                                        <c:forEach items="${sub.subManagers}" var="sm">
		                                            <c:if test="${sm.memberNo eq m.memberNo}">
		                                                <c:set var="isChecked" value="true" />
		                                            </c:if>
		                                        </c:forEach>
		                                        
		                                        <label class="sub-assignee-item" 
		                                               data-member-no="${m.memberNo}">
		                                            <input type="checkbox" class="form-check-input me-2" ${isChecked ? 'checked' : ''}>
		                                            <span>${m.memberName}</span>
		                                        </label>
		                                    </c:forEach>
		                                </div>
		                                
		                                <div class="subManagerNosFields" data-sub-manager-nos-fields>
		                                    <c:forEach items="${sub.subManagers}" var="sm">
		                                        <input type="hidden" name="subTasks[${vs.index}].subManagerNos" value="${sm.memberNo}">
		                                    </c:forEach>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                </div>
		            </c:forEach>
		        </c:if>
				
			</div>

			<div class="task-help">단위업무는 제목/기간/담당자만 입력하고, 나머지는 서버 default
				값으로 저장하세요.</div>
		</div>

		<!-- 5) 파일 첨부(UI만) -->
		<div class="task-card">
			<div class="task-card-title">파일 첨부</div>
			<input type="file" class="form-control" name="files" multiple>
			<div class="task-help">최대 10개, 개당 50MB 이하 (추후 검증 로직 추가 예정)</div>
		</div>

		<div class="task-footer">
			<button type="button" class="btn btn-soft" id="btnCancelTask">취소</button>
			<button type="button" class="btn btn-primary" id="submitTaskBtn">완료</button>
		</div>
	</form>
</div>

<script type="text/javascript">
	var initialSubCount = ${isEdit and not empty task.subTasks ? fn:length(task.subTasks) : 0};
</script>

<script type="text/template" id="subTaskTemplate">
  <div class="subtask-item" data-sub-index="{{idx}}">
	<!-- DB 에러 방지 -->
	<input type="hidden" name="subTasks[{{idx}}].subStatus" value="REQUEST"> 
	<input type="hidden" name="subTasks[{{idx}}].subPriority" value="NORMAL"> 
	<input type="hidden" name="subTasks[{{idx}}].subRate" value="0">

    <div class="subtask-head">
      <p class="subtask-title">단위업무 {{n}}</p>
      <button type="button" class="subtask-remove" data-action="removeSubTask">삭제</button>
    </div>

    <div class="row g-2 align-items-end">
      <div class="col-md-6">
        <label class="task-label">제목 <span class="text-danger">*</span></label>
        <input type="text" class="form-control" name="subTasks[{{idx}}].subTitle" required>
      </div>

      <div class="col-md-3">
        <label class="task-label">시작일</label>
        <input type="date" class="form-control" name="subTasks[{{idx}}].subStartdate" data-role="subStart">
      </div>

      <div class="col-md-3">
        <div class="d-flex justify-content-between align-items-center mb-1">
            <label class="task-label m-0">마감일</label>
            <button type="button" class="btn btn-sm btn-soft py-0 px-2 btn-sync-parent" 
                    title="상위업무 일정과 동일하게 설정" style="font-size: 11px; height: 20px;">
                <i class="bi bi-arrow-repeat"></i> 일정 동기화
            </button>
        </div>
        <input type="date" class="form-control" name="subTasks[{{idx}}].subEnddate" data-role="subEnd">
      </div>

      <div class="col-md-12">
        <label class="task-label">담당자</label>

        <!-- 하위 담당자 선택 UI: 우선 다건은 체크리스트로 간다 -->
        <div class="sub-assignee-box" data-sub-assignee>
          <div class="sub-assignee-list">
            <c:forEach items="${memberList}" var="m">
              <label class="sub-assignee-item" data-member-no="${m.memberNo}" data-member-name="${m.memberName}">
                <input type="checkbox" class="form-check-input me-2">
                <span>${m.memberName}</span>
              </label>
            </c:forEach>
          </div>
          <!-- 서버로 보낼 하위 담당자 hidden inputs 영역 -->
          <div class="subManagerNosFields" data-sub-manager-nos-fields></div>
        </div>

        <div class="task-help">체크한 인원들이 하위업무 담당자로 저장됩니다.</div>
      </div>
    </div>
  </div>
</script>