<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
/* 선택된 멤버 태그 스타일 개선 */
.attendee-tag {
    display: inline-flex !important;
    align-items: center;
    gap: 4px;
    padding: 2px 8px;
    margin: 1px;
    border-radius: var(--tudio-radius-sm); /* 기존 변수 활용 */
    font-size: 13px;
    font-weight: 500;
    background-color: #E0F2FE; 
    color: #0369A1;
    border: 1px solid #BAE6FD;
}

.btn-remove-member {
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
    color: #0369A1;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    transition: all 0.2s;
}

.btn-remove-member:hover {
    background-color: #0369A1;
    color: #fff;
}
</style>

<section class="tudio-section tudio-scope">
	<c:set value="등록" var="name" />
	<c:if test="${status eq 'u' }">
		<c:set value="수정" var="name" />
	</c:if>
	<div class="tudio-section-header">
        <h4 class="mb-0 text-primary-dark" style="font-weight: 800;">
            <i class="bi bi-file-earmark-text me-2"></i>게시글 ${name }
        </h4>
        <button class="tudio-btn" id="btnBackToList" style="background: white; border:1px solid #e2e8f0;">목록으로</button>
    </div>
    
	<c:set var="actionUrl" value="${pageContext.request.contextPath}/tudio/project/board/insert" />
	<c:if test="${status eq 'u'}">
	    <c:set var="actionUrl" value="${pageContext.request.contextPath}/tudio/project/board/update" />
	</c:if>
    <form id="insertForm" action="${actionUrl}" method="post" enctype="multipart/form-data">
		<input type="hidden" name="projectNo" value="${projectNo}">
		<c:if test="${status eq 'u' }">
			<input type="hidden" id="boNo" name="boNo" value="${board.boNo }"/>
			<input type="hidden" id="serverCategory" value="${board.categoryName}"/>
		</c:if>
	    <div class="p-4" style="background-color: var(--tudio-surface-soft); border-radius: var(--tudio-radius-md);">
	        <label class="tudio-form-label"><i class="bi bi-list-check me-1"></i> 게시글 구분</label>
	        <div class="d-flex gap-4">
	            <div class="form-check">
				    <input class="form-check-input" type="radio" name="categoryName" id="cateNotice" value="NOTICE" 
				           ${board.categoryName == 'NOTICE' ? 'checked' : ''}>
				    <label class="form-check-label" for="cateNotice">공지사항 ${name}</label>
				</div>
				<div class="form-check">
				    <input class="form-check-input" type="radio" name="categoryName" id="cateFree" value="FREE" 
				           ${(board.categoryName == 'FREE' || empty board.categoryName) ? 'checked' : ''}>
				    <label class="form-check-label" for="cateFree">자유게시판 ${name}</label>
				</div>
				<div class="form-check">
				    <input class="form-check-input" type="radio" name="categoryName" id="cateMinutes" value="MINUTES" 
				           ${board.categoryName == 'MINUTES' ? 'checked' : ''}>
				    <label class="form-check-label" for="cateMinutes">회의록 ${name}</label>
				</div>
	        </div>
	    </div>
	
	    <div class="p-4">
	        <div class="mb-4">
	            <label class="tudio-form-label" id="titleLabel"><i class="bi bi-tag-fill me-1"></i> 제목</label>
	            <input type="text" class="form-control form-control" name="boTitle" id="boardTitle" value="${board.boTitle }" placeholder="제목을 입력해주세요." required>
	        </div>

	        <div id="meetingDetailsArea" style="display: none;">
	            <div class="row g-4 mb-4">
	                <div class="col-md-4">
	                    <label class="tudio-form-label"><i class="bi bi-calendar-event me-1"></i> 회의 일시</label>
	                    <input type="datetime-local" class="form-control" name="boardMinutesVO.meetingDate" value="${board.boardMinutesVO.meetingDate }">
	                </div>
	
	                <div class="col-md-8">
					    <label class="tudio-form-label"><i class="bi bi-people-fill me-1"></i> 참석자 선택</label>
					    <div class="d-flex gap-2">
					        <div id="selectedAttendeeNames" class="form-control d-flex flex-wrap gap-2" style="min-height: 45px; height: auto; background-color: #f8f9fa;">
					            <span class="text-muted">선택된 참석자가 없습니다.</span>
					        </div>
					        <button type="button" class="tudio-btn tudio-btn-outline-primary" style="white-space: nowrap;" data-bs-toggle="modal" data-bs-target="#attendeeModal">
					            <i class="bi bi-search"></i> 검색
					        </button>
					    </div>
					    <div id="attendeeHiddenInputs"></div>
					    <div id="oldAttendees" style="display:none;">
						    <c:forEach items="${board.meetingMemberList}" var="list">
						        <c:if test="${not empty list.memberVO.memberName}">
						        	<span class="old-mem" data-no="${list.memberNo}" data-name="${list.memberVO.memberName}"></span>
						    	</c:if>
						    </c:forEach>
						</div>
					</div>
	
	                <div class="col-12">
	                    <label class="tudio-form-label"><i class="bi bi-bullseye me-1"></i> 회의 목표</label>
	                    <input type="text" class="form-control" name="boardMinutesVO.meetingGoal" value="${board.boardMinutesVO.meetingGoal }" placeholder="이번 회의의 핵심 목표를 입력하세요.">
	                </div>
	            </div>
	        </div>
	
	        <div class="mb-4">
	            <label class="tudio-form-label" id="contentLabel"><i class="bi bi-chat-left-text-fill me-1"></i> 내용</label>
	            <textarea class="form-control tudio-textarea" name="boContent" style="min-height: 250px;" placeholder="내용을 입력하세요.">${board.boContent }</textarea>
	        </div>
	
	        <div id="meetingResultArea" style="display: none;">
	            <div class="mb-4">
	                <label class="tudio-form-label" style="color: #0d6efd;"><i class="bi bi-check-circle-fill me-1"></i> 회의 결과 및 결정사항</label>
	                <textarea class="form-control" name="boardMinutesVO.meetingResult" style="min-height: 150px; border: 1px solid #BFDBFE; background-color: #f8fbff;" placeholder="결정된 사항이나 향후 할 일을 입력하세요.">${board.boardMinutesVO.meetingResult }</textarea>
	            </div>
	        </div>
	
	        <div class="mb-4">
	            <label class="tudio-form-label"><i class="bi bi-paperclip me-1"></i> 파일</label>
	            <div class="file-upload-wrapper">
	                <input type="file" class="form-control" name="boFileList" multiple>
	            </div>
	        </div>
	
	        <div class="d-flex justify-content-center gap-3 mt-5 pt-4 border-top">
	            <button type="submit" class="tudio-btn tudio-btn-primary" id="submitBtn" style="width: 115px;">
	                <i class="bi bi-check-lg"></i> 저장하기
	            </button>
	        </div>
	    </div>
    </form>
</section>

<!-- 회의록 참석자 선택 시 모달창 -->
<div class="modal fade" id="attendeeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title font-weight-bold">참석자 검색</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="text" id="memberSearchInput" class="form-control mb-3" placeholder="이름이나 ID로 검색하세요.">
                <div style="max-height: 300px; overflow-y: auto;">
                    <ul class="list-group" id="memberSearchList">
                        <c:forEach items="${memberList}" var="mem">
                            <li class="list-group-item d-flex justify-content-between align-items-center member-item" 
                                data-no="${mem.memberNo}" data-name="${mem.memberName}">
                                <span>${mem.memberName} <small class="text-muted">(${mem.memberId})</small></span>
                                <button type="button" class="btn btn-sm btn-outline-primary btn-add-member">추가</button>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
