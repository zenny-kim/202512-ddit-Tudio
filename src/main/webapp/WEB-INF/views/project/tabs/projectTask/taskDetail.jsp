<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/task_detail.css">

<div class="task-modal-wrap">
	<input type="hidden" id="detailTaskId" value="">
    <input type="hidden" id="detailProjectNo" value="">
    <input type="hidden" id="detailTaskType" value="">

	<!-- 로그인한 사용자 정보 -->
	<input type="hidden" id="currentMemberNo" value="${sessionScope.loginUser.memberNo}">
	
    <div class="task-header-section">
        <div class="d-flex justify-content-between align-items-start">
            
            <div style="flex-grow: 1; padding-right: 20px;">
                
                <div class="task-breadcrumb mb-1">
                    <span id="detailProjectName" class="breadcrumb-project">Loading</span>
                    
                    <span id="breadcrumbSeparator" class="breadcrumb-divider" style="display:none;">
                        <i class="bi bi-chevron-right"></i>
                    </span>
                    
                    <a href="#" id="btnGoParent" class="breadcrumb-link" style="display:none;">
                        상위업무 제목
                    </a>
                </div>

                <h3 class="task-title-text" id="detailTitle">Loading...</h3>
            </div>

            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        
        <div class="task-meta-info mt-3">
            <span class="d-flex align-items-center gap-1">
                <i class="bi bi-person-circle"></i> <span id="detailWriter">작성자</span>
            </span>
            <span>|</span>
            <span id="detailRegDate">202X-XX-XX</span>
        </div>
    </div>

    <div class="task-info-grid">
        <div class="task-info-row">
            <div class="task-info-label">상태</div>
            <div class="task-info-value">
                <span class="badge" id="detailTaskStatusBadge" style="padding: 6px 12px;">-</span>
            
            	<span id="detailFinishDateArea" style="display:none;">
				    <div class="d-flex align-items-center ms-2" style="gap: 4px;">
				        <span class="text-muted mx-1" style="font-size: 10px;"></span>
				        
				        <i class="fa-solid fa-calendar-check text-muted" style="font-size: 14px;"></i>
				        
				        <span id="detailFinishDate" class="fw-bold" style="font-size: 14px; margin-left: 2px;"></span>
				    </div>
				</span>
            </div>
        </div>
        
        <div class="task-info-row">
            <div class="task-info-label">중요도</div>
            <div class="task-info-value">
                <span id="detailTaskPriority" class="badge bg-light text-dark border">-</span>
            </div>
        </div>

        <div class="task-info-row">
            <div class="task-info-label">담당자</div>
            <div class="task-info-value" id="detailAssigneeArea">
                <span class="text-muted small">지정되지 않음</span>
            </div>
        </div>

        <div class="task-info-row">
            <div class="task-info-label">기간</div>
            <div class="task-info-value">
                <span id="detailPeriod">-</span>
            </div>
        </div>
        
		<div class="task-info-row">
            <div class="task-info-label">진척도</div> <div class="task-info-value w-100">
                <div id="detailRateContainer" class="d-flex align-items-center flex-grow-1 text-nowrap" style="min-width: 0;">
                    <div class="progress flex-grow-1" style="height: 6px;">
                        <div id="detailProgress" class="progress-bar bg-primary" role="progressbar" style="width: 0%"></div>
                    </div>
                    <span id="detailRateText" class="small fw-bold text-primary ms-2">0%</span>
                </div>
            </div>
        </div>
    </div>

    <div class="task-section">
        <div class="task-section-title"><i class="bi bi-justify-left"></i> 업무 내용</div>
        <div id="detailContent" class="task-content-box"></div>
    </div>

    <div id="subTaskListArea" class="task-section" style="display:none;">
        <div class="task-section-title"><i class="bi bi-list-check"></i> 단위 업무</div>
        <div id="detailSubListGroup"></div>
    </div>

    <div class="task-section">
        <div class="task-section-title"><i class="bi bi-paperclip"></i> 첨부파일</div>
        <ul class="list-group list-group-flush border rounded" id="detailFileList"></ul>
    </div>
    
    <div class="task-comment-area">
        <div class="task-section-title">댓글</div>
        <div id="detailCommentList" class="mb-3 d-flex flex-column gap-2">
             <div class="text-center text-muted small py-3">작성된 댓글이 없습니다.</div>
        </div>
        
        <div class="d-flex gap-2">
            <input type="text" class="form-control" placeholder="댓글을 입력하세요...">
            <button class="btn btn-primary btn-sm text-nowrap">등록</button>
        </div>
    </div>

    <div class="task-footer-actions">
        <div id="detailBtnGroup" class="me-auto" style="display:none;">
            <button type="button" class="btn btn-outline-danger border-0 bg-light" id="btnDeleteTask">삭제</button>
            <button type="button" class="btn btn-outline-primary border-0 bg-light ms-2" id="btnModifyTask">수정</button>
        </div>
        <button type="button" class="btn btn-primary px-4" data-bs-dismiss="modal">확인</button>
    </div>

</div>