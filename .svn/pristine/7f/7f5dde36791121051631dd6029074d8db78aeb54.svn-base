<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tudio - ${project.projectName}</title> 
    <%-- 공통 CSS/JS 인클루드 --%>
    <jsp:include page="/WEB-INF/views/include/common.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/todo_modal.css">
</head>
<body data-context-path="${pageContext.request.contextPath}" 
    data-project-no="${project.projectNo}"
    class="d-flex flex-column min-vh-100">

    <%-- 1. 상단 공통 헤더 --%>
    <jsp:include page="../include/headerUser.jsp"/>
    
    <%-- 2. 레이아웃 래퍼: 사이드바와 본문을 가로로 배치 --%>
    <div class="d-flex flex-grow-1">
    
        <%-- 사이드바 영역 --%>
        <jsp:include page="../include/sidebarUser.jsp">
              <jsp:param name="menu" value="project_list" />
        </jsp:include>

        <%-- 메인 콘텐츠 영역 --%>
        <main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
            <div class="container-fluid">
                
                <%-- A. 프로젝트 타이틀 및 관리 버튼 --%>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="d-flex align-items-center">
                        <h2 class="h3 fw-bold text-primary-dark m-0">
                            <i class="bi bi-layout-text-sidebar-reverse me-2"></i> ${project.projectName} 
                        </h2>
                        
                        <%-- 프로젝트 상태 표시 뱃지 --%>
                        <c:choose>
                            <c:when test="${project.projectStatus eq 0}">
                                <span class="badge bg-success fs-6 ms-3">진행 중</span>
                            </c:when>
                            <c:when test="${project.projectStatus eq 1}">
                                <span class="badge bg-secondary fs-6 ms-3">완료</span>
                            </c:when>
                        </c:choose>

                        <%-- 결과보고서 생성 이력이 경우 다운로드 버튼 노출 --%>
                        <c:if test="${not empty project.latestReportfileno}">
                            <a href="${pageContext.request.contextPath}/tudio/project/report/download?fileNo=${project.latestReportfileno}" 
                               class="btn btn-outline-primary btn-sm ms-2 fw-bold shadow-sm" 
                               title="결과보고서 다운로드">
                                <i class="bi bi-file-earmark-pdf-fill me-1"></i> 결과보고서 PDF 다운로드
                            </a>
                        </c:if>
                    </div>
                
                    <div class="d-flex gap-2">
                        <%-- 프로젝트 상태가 완료(1)일 경우 결과보고서 버튼 노출 --%>
                        <c:if test="${project.projectStatus eq 1}">
                            <a href="${pageContext.request.contextPath}/tudio/project/report/${project.projectNo}" 
                               target="_blank" rel="noopener noreferrer"
                               class="tudio-btn border-primary text-primary btn-sm text-decoration-none d-inline-flex align-items-center justify-content-center">                            
                                <c:choose>
                                    <c:when test="${empty project.latestReportfileno}">
                                        <i class="bi bi-pencil-square me-1"></i> 결과보고서 작성
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-arrow-repeat me-1"></i> 결과보고서 수정 및 재발송
                                    </c:otherwise>
                                </c:choose>
                            </a>    
                        </c:if>
                        
                        <%-- 프로젝트 관리자인 경우 설정 버튼 노출 --%>
                        <c:if test="${loginMember eq project.memberNo}">
                            <button class="tudio-btn border-secondary text-secondary btn-sm" 
                                    onclick="location.href='${pageContext.request.contextPath}/tudio/project/update?projectNo=${project.projectNo}'">
                                <i class="bi bi-gear"></i> 설정
                            </button>
                        </c:if>
                            
                        <%-- 프로젝트 북마크 설정 버튼 --%>
                        <button type="button" class="tudio-btn border-warning text-warning btn-sm" id="btnBookmark"
                            title="북마크 ${bookmark eq 'Y' ? '해제' : '등록'}">
                            <span id="bookmarkText">${bookmark eq 'Y' ? '북마크 해제' : '북마크 등록'}</span>
                            <i class="bi ${bookmark eq 'Y' ? 'bi-star-fill' : 'bi-star'}"></i>
                        </button>
                    </div>
                </div>

                <%-- 프로젝트 요약 정보 카드 (미니 위젯) --%>
                <div class="summary-container mb-5">
                    <%-- 프로젝트 디데이 --%>
                    <div class="summary-card cursor-pointer hover-effect" onclick="goToTab('stats')">
                        <span class="summary-label">프로젝트 기간</span>
                        <div class="summary-value" style="font-size: 1.1rem;">
                            <fmt:formatDate value="${project.projectStartdate}" pattern="yyyy.MM.dd"/> ~ 
                            <fmt:formatDate value="${project.projectEnddate}" pattern="yyyy.MM.dd"/>
                        </div>
                        <%-- D-day 조건 분기 --%>
                        <span class="summary-badge ${project.dday < 0 ? 'bg-light text-muted' : ''}">
                            <c:choose>
                                <c:when test="${project.dday < 0}">
                                    <i class="bi bi-check-circle-fill me-1"></i> 종료됨 (D+${project.dday * -1})
                                </c:when>
                                <c:when test="${project.dday == 0}">
                                    <span class="badge bg-danger">D-Day</span> 오늘 마감
                                </c:when>
                                <c:otherwise>D-${project.dday}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
        
                    <%-- 프로젝트 진행률 --%>
                    <div class="summary-card cursor-pointer hover-effect" onclick="goToTab('gantt')">
                        <span class="summary-label">전체 업무 진행률</span>
                        <div class="d-flex align-items-baseline">
                            <div class="summary-value me-2">
                            	<c:out value="${not empty project.overallProgress ? project.overallProgress : 0}" />%
                            </div>
                            <span class="summary-subtext">(${project.completedTaskCount}/${project.totalTaskCount}건 완료)</span>
                        </div>
                        <div class="summary-progress-wrapper">
                            <div class="summary-progress-bar" style="width: ${not empty project.overallProgress ? project.overallProgress : 0}%"></div>
                       </div>
                    </div>
                    
                    <%-- 프로젝트 구성원 (기업 담당자 제외) --%>
                    <div class="summary-card cursor-pointer hover-effect" onclick="goToTab('member')">
                        <span class="summary-label">투입 인력</span>
                        <div class="summary-value">${project.projectMemberCount}명</div>
                        <div class="mt-2 small text-muted"><i class="bi bi-people me-1"></i>참여 중 구성원</div>
                        <span class="summary-subtext">(기업 담당자 제외)</span>
                    </div>
                    
                    <%-- 지연 업무 --%>
                    <div class="summary-card cursor-pointer hover-effect" onclick="goToTab('task')">
                        <span class="summary-label">지연 업무</span>
                        <div class="summary-value text-danger-custom">${project.delayedTaskCount} 건</div>
                        <span class="summary-subtext">조치가 시급합니다!</span>
                    </div>
                    
                    <%-- 투두 리스트 --%>
                    <div class="summary-card cursor-pointer hover-effect" onclick="openTodoModal()">
                        <span class="summary-label">To Do List</span>
                        <div class="summary-value" id="todoSummaryCount">
							<span class="spinner-border spinner-border-sm text-primary"></span>
						</div>
                        <div class="summary-subtext"><i class="bi bi-check2-square text-primary opacity-75"></i> 클릭하여 관리</div>
                    </div>
                </div>
                
                <%-- 하단 탭 메뉴 영역 --%>
                <div class="tudio-scope">
                    <ul class="nav nav-tabs custom-index-tabs border-0" id="projectTabs" role="tablist">
                        <c:set var="rawTabs" value="${project.miniheader.fixTab}" />
                        <c:if test="${empty rawTabs}">
                        	<c:set var="rawTabs" value="1,2,3,4,5,6,7,8" />
                        </c:if>
                        <c:set var="cleanTabs" value="${fn:replace(rawTabs, ' ', '')}" />
                        <c:set var="tabOrder" value="${fn:split(cleanTabs, ',')}" />
                            
                        <%-- 권한 필터링 및 Active 처리 --%>
                        <c:set var="visibleTabCount" value="0" />
                        <c:forEach items="${tabOrder}" var="tabId" varStatus="status">
                            <c:set var="showTab" value="true" />
                            
                            <%-- [권한 제어] 기업회원(ROLE_CLIENT)인 경우 업무(2), 드라이브(5), 커뮤니티(6) 숨김 처리 --%>
                            <sec:authorize access="hasRole('ROLE_CLIENT')">
                                <c:if test="${tabId eq '2' or tabId eq '5' or tabId eq '6'}"> 
                                    <c:set var="showTab" value="false" /> 
                                </c:if>
                            </sec:authorize>
                            
                            <c:if test="${showTab}">
                                <%-- 첫 번째 탭 active 활성화 --%>
                                <c:set var="isActive" value="${visibleTabCount == 0 ? 'active' : ''}" />
                                
                                <li class="nav-item" role="presentation">
                                    <c:choose>
                                        <c:when test="${tabId eq '1'}">
                                            <button class="nav-link ${isActive}" id="stats-tab" data-tab="stats" data-bs-toggle="tab" data-bs-target="#stats" type="button">
                                                <i class="bi bi-pie-chart-fill"></i> 요약·분석
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '2'}">
                                            <button class="nav-link ${isActive}" id="task-tab" data-tab="task" data-bs-toggle="tab" data-bs-target="#task" type="button">
                                                <i class="bi bi-check2-square"></i> 업무
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '3'}">
                                            <button class="nav-link ${isActive}" id="gantt-tab" data-tab="gantt" data-bs-toggle="tab" data-bs-target="#gantt" type="button">
                                                <i class="bi bi-bar-chart-steps"></i> 진행현황
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '4'}">
                                            <button class="nav-link ${isActive}" id="calendar-tab" data-tab="calendar" data-bs-toggle="tab" data-bs-target="#calendar" type="button">
                                                <i class="bi bi-calendar3"></i> 일정
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '5'}">
                                            <button class="nav-link ${isActive}" id="drive-tab" data-tab="drive" data-bs-toggle="tab" data-bs-target="#drive" type="button">
                                                <i class="bi bi-folder-fill"></i> 드라이브
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '6'}">
                                            <button class="nav-link ${isActive}" id="board-tab" data-tab="board" data-bs-toggle="tab" data-bs-target="#board" type="button">
                                                <i class="bi bi-card-list"></i> 커뮤니티
                                            </button>
                                        </c:when>
                                        <c:when test="${tabId eq '7'}">
                                            <button class="nav-link ${isActive}" id="members-tab" data-tab="member" data-bs-toggle="tab" data-bs-target="#member" type="button">
                                                <i class="bi bi-people-fill"></i> 구성원
                                            </button>            
                                        </c:when>
                                        <c:when test="${tabId eq '8'}">
                                            <button class="nav-link ${isActive}" id="meetingRoom-tab" data-tab="meetingRoom" data-bs-toggle="tab" data-bs-target="#meetingRoom" type="button">
                                                <i class="bi bi-door-open-fill"></i> 회의실
                                            </button>
                                        </c:when>
                                    </c:choose>
                                </li>
                                <c:set var="visibleTabCount" value="${visibleTabCount + 1}" />
                            </c:if>
                        </c:forEach>
                    </ul>
                    
                    <%-- 탭의 실제 내용(HTML)이 비동기로 들어갈 곳 --%>
                    <div class="tab-content tab-content-card" id="projectTabContent"></div>
                </div> <%-- // tudio-scope 끝 --%>
                
            </div> <%-- // container-fluid 끝 --%>
        </main> <%-- // main 끝 --%>
    </div> <%-- // 사이드바-메인 전체 래퍼 닫기 --%>
    
    <%-- D. 공용 모달 영역 --%>
    <div class="modal fade" id="projectCommonModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" id="projectCommonModalDialog">
            <div class="modal-content" id="projectCommonModalContent">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%-- 투두 리스트 관리 전용 모달 --%>
    <div class="modal fade" id="todoManageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content tudio-modal-content">
                <div class="modal-header tudio-modal-header">
                    <div>
                        <h4 class="fw-bold m-0" style="color: #1e293b;">To Do List</h4>
                        <p class="text-muted small m-0 mt-1">
                            <i class="bi bi-folder-fill text-primary me-1"></i> ${project.projectName}
                        </p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0">
                    <div class="px-4 py-3 bg-white border-bottom sticky-top" style="z-index: 10;">
                        <div class="todo-input-box">
                            <input type="text" id="newTodoInput" class="todo-real-input" placeholder="할 일을 입력하세요 (Enter)" autocomplete="off">
                            <button class="btn-todo-add" onclick="addTodo()" type="button">
                                <i class="bi bi-arrow-up-short fs-4"></i>
                            </button>
                        </div>
                    </div>
                    <div class="todo-list-area py-3" id="todoListBody">
                        <div class="text-center py-5">
                            <div class="spinner-border text-primary opacity-50" role="status"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top-0 bg-light py-2 px-4 justify-content-between">
                    <span class="text-muted" style="font-size: 0.75rem;">
                        <i class="bi bi-check2-circle me-1"></i>더블 클릭하여 내용 수정
                    </span>
                </div>
            </div>
        </div>
    </div>

    <%-- 실시간 채팅 인클루드 및 푸터 --%>
    <jsp:include page="../chat/main.jsp"/>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    
    <script>
        const projectNo = "${project.projectNo}"; 
    </script>
    <script src="${pageContext.request.contextPath}/js/projectMain.js"></script>
    <script src="${pageContext.request.contextPath}/js/projectBoard.js"></script>    
    <script src="${pageContext.request.contextPath}/js/tabTask.js"></script>    
    <script src="${pageContext.request.contextPath}/js/drive.js"></script>
</body>
</html>