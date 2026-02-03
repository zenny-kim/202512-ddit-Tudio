<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/task_create.css">

<div class="task-create-wrap">

    <div class="task-create-header">
        <div>
            <h4 class="task-create-title">하위업무 추가</h4>
            <div class="task-create-subtitle">상위업무를 보조할 세부 업무를 등록합니다.</div>
        </div>
        <div class="task-actions">
            <button type="button" class="btn btn-soft" data-bs-dismiss="modal">닫기</button>
        </div>
    </div>

    <form id="createSubTaskForm" enctype="multipart/form-data">
        <input type="hidden" name="taskId" id="targetParentTaskId"> 
        
        <input type="hidden" id="hiddenParentStart">
        <input type="hidden" id="hiddenParentEnd">

        <div class="task-card">
            <div class="task-card-title">기본 정보</div>
            <div class="row g-3">
                <div class="col-md-12">
                    <label class="task-label">업무 제목 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="subTitle" placeholder="하위업무 제목을 입력하세요" required>
                </div>
                <div class="col-md-12">
                     <label class="task-label">업무 내용</label>
                     <textarea class="form-control" name="subContent" rows="4" placeholder="상세 내용을 입력하세요 (선택)"></textarea>
                </div>
            </div>
        </div>
        
        <div class="task-card">
		    <div class="task-card-title">일정 및 설정</div>
		
		    <div class="row g-3">
		        <div class="col-md-2">
		            <label class="task-label">상태</label> 
		            <select class="form-select" name="subStatus" id="subStatusSelect">
		                <c:forEach items="${subStatusList}" var="sStatus">
		                    <option value="${sStatus.name()}" ${sStatus.code == 201 ? 'selected' : ''}>
		                        ${sStatus.label}</option>
		                </c:forEach>
		            </select>
		        </div>
		
		        <div class="col-md-2">
		            <label class="task-label">중요도</label> 
		            <select class="form-select" name="subPriority" id="subPrioritySelect">
		                <c:forEach items="${subPriorityList}" var="sPriority">
		                    <option value="${sPriority.name()}" ${sPriority.code == 212 ? 'selected' : ''}>
		                        ${sPriority.label}</option>
		                </c:forEach>
		            </select>
		        </div>
		
		        <div class="col-md-4">
		            <label class="task-label">시작일</label> 
                    <input type="date" class="form-control" name="subStartdate" id="subStartdate" 
		                   onclick="this.showPicker()" style="cursor: pointer;">
		        </div>
		
		        <div class="col-md-4">
		            <div class="d-flex justify-content-between align-items-center mb-2">
		                <label class="task-label m-0">마감일</label>
                        <button type="button" class="btn btn-sm btn-soft py-0 px-2" id="btnSyncParentDate" 
		                        title="상위업무 일정과 동일하게 설정" style="font-size: 12px; height: 24px;">
		                    <i class="bi bi-arrow-repeat"></i> 상위업무 동기화
		                </button>
		            </div>
                    <input type="date" class="form-control" name="subEnddate" id="subEnddate"
		                   onclick="this.showPicker()" style="cursor: pointer;">
		        </div>
		
		        <div class="col-md-12">
		            <label class="task-label">진척도</label>
		            <div class="rate-row">
                        <input type="range" class="form-range" min="0" max="100" step="5" value="0" id="subRateRange">
		                <div class="rate-value"><span id="subRateValue">0</span>%</div>
		            </div>
		            <input type="hidden" name="subRate" id="subRateHidden" value="0">
		        </div>
		    </div>
		</div>
        
        <div class="task-card">
            <div class="task-card-title">담당자 배정</div>
            <div class="sub-assignee-box">
                 <div class="sub-assignee-list d-flex flex-wrap gap-2">
                    <c:forEach items="${memberList}" var="mem">
                        <label class="assignee-tag bg-white border" style="cursor: pointer;">
                            <input class="form-check-input me-2 mt-0" type="checkbox" name="subManagerNos" value="${mem.memberNo}">
                            <span>${mem.memberName}</span>
                        </label>
                    </c:forEach>
                 </div>
                 <div class="task-help mt-2">체크된 인원이 이 하위업무를 담당합니다.</div>
            </div>
        </div>
        
        <div class="task-card">
            <div class="task-card-title">파일 첨부</div>
            <input type="file" class="form-control" name="files" multiple>
        </div>

        <div class="task-footer">
            <button type="button" class="btn btn-soft" data-bs-dismiss="modal">취소</button>
            <button type="button" class="btn btn-primary" id="btnSubmitSubTask">등록</button>
        </div>
    </form>
</div>