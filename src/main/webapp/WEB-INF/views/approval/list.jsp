<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tudio</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
.approval-pager .pagination {
	display: flex;
	justify-content: center;
	gap: 6px;
	border: none;
}

.approval-pager .page-item {
	border: none !important;
}

/* 기본 page-link를 tudio-pg 스타일로 변경 */
.approval-pager .page-link {
	border: none !important;
	background: transparent !important;
	color: #64748b !important; /* --text-muted */
	padding: 8px 14px !important;
	border-radius: 8px !important;
	font-size: 14px !important;
	transition: all 0.2s ease !important;
}

/* 마우스 올렸을 때 */
.approval-pager .page-link:hover {
	background: #f1f5f9 !important;
	color: #2f6bff !important; /* --tudio-primary-strong */
}

/* 활성화된 페이지 (active) */
.approval-pager .page-item.active .page-link {
	background: #2f6bff !important; /* --tudio-primary-strong */
	color: #fff !important;
	font-weight: 700 !important;
	box-shadow: 0 4px 10px rgba(47, 107, 255, 0.2) !important;
}
.tudio-section .tudio-table-card {
    border-collapse: collapse !important; /* 강제로 테두리 합치기 */
    border-spacing: 0 !important;        /* 간격 0으로 만들기 */
}
.file-icon-wrap {
display: inline-flex;
align-items: center;
color: #868e96; /* 차분한 회색 */
font-size: 0.8rem;
margin-left: 8px;
font-weight: 500;
gap: 2px; /* 아이콘과 숫자 사이 간격 */
}
.file-icon-wrap i {
font-size: 0.9rem; /* 아이콘 크기 미세 조정 */
}
</style>
</head>
<body class="d-flex flex-column min-vh-100">

<section class="tudio-section">
	<!-- APPROVAL LIST 화면 입니다. -->
	<jsp:include page="../include/headerUser.jsp" />

	<div class="d-flex flex-grow-1">
		<!-- 사이드바 -->
		<jsp:include page="../include/sidebarUser.jsp">
			<jsp:param name="menu" value="approval" />
		</jsp:include>

		<main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
			<div class="container-fluid">

				<div class="d-flex justify-content-between align-items-center">
					<!-- 소제목 -->
					<h2 class="h3 fw-bold text-primary-dark mb-4">
						<i class="bi bi-file-earmark-check me-2"></i> 결재 관리
					</h2>
				</div>


				<!-- ================ 미니 위젯 ================ -->


				<div class="summary-container mb-5">
					<c:choose>
						<%-- [1] 기안자 입장 (ROLE_MEMBER 권한을 가진 사람) --%>
						<%-- [1] MANAGER(기안자)용 카드 구성 --%>
						<c:when test="${projectRole eq 'MANAGER' or projectRole eq 'MEMBER' or (projectNo == 0 and userAuth eq 'ROLE_MEMBER')}">
							<div class="summary-card">
								<span class="summary-label">결재 진행</span>
								<div class="summary-value">${stats.PROGRESS_COUNT}<small>건</small></div>
								<span class="summary-badge bg-primary text-white">진행 중</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">반려된 문서</span>
								<div class="summary-value">${stats.REJECT_COUNT}
									<small>건</small>
								</div>
								<span class="summary-badge bg-danger text-white">확인 필요</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">임시 보관</span>
								<div class="summary-value">${stats.TEMP_COUNT}
									<small>건</small>
								</div>
								<span class="summary-badge bg-secondary text-white">작성 중</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">장기 미결</span>
								<div class="summary-value text-danger">${stats.LONG_TERM_COUNT}
									<small>건</small>
								</div>
								<span
									class="summary-badge ${stats.LONG_TERM_COUNT > 0 ? 'bg-warning text-dark' : 'bg-light text-muted'}">
									3일 이상 지연 </span>
							</div>
						</c:when>
						
						<%-- [2] 결재자 입장 (ROLE_CLIENT 권한을 가진 사람) --%>
						<%-- [2] CLIENT(결재자)용 카드 구성 --%>
						<c:when test="${projectRole eq 'CLIENT' or (projectNo == 0 and userAuth eq 'ROLE_CLIENT')}">
							<div class="summary-card">
								<span class="summary-label">결재 대기</span>
								<div class="summary-value">${stats.WAIT_COUNT}
									<small>건</small>
								</div>
								<span class="summary-badge bg-warning text-dark">내 결재 순서</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">반려한 문서</span>
								<div class="summary-value">${stats.MY_REJECT_COUNT}
									<small>건</small>
								</div>
								<span class="summary-badge bg-light text-muted">반려 이력</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">결재 완료</span>
								<div class="summary-value">${stats.COMPLETE_COUNT}
									<small>건</small>
								</div>
								<span class="summary-badge bg-success text-white">처리 완료</span>
							</div>

							<div class="summary-card">
								<span class="summary-label">장기 미결</span>
								<div class="summary-value text-danger">${stats.LONG_TERM_COUNT}
									<small>건</small>
								</div>
								<span
									class="summary-badge ${stats.LONG_TERM_COUNT > 0 ? 'bg-danger text-white' : 'bg-light text-muted'}">
									빠른 처리 요망 </span>
							</div>
						</c:when>
						
						<%-- [3] 전체보기(projectNo=0)일 때 기본 카드 --%>
				        <c:otherwise>
				            <div class="summary-card">
				                <span class="summary-label">전체 결재 건수</span>
				                <div class="summary-value">${pagingVO.totalRecord}<small>건</small></div>
				                <span class="summary-badge bg-dark text-white">전체 현황</span>
				            </div>
			            </c:otherwise>
					</c:choose>
				</div>

				<!-- ================ TAB ================ -->
				

				<div class="tudio-scope">
					<div class="d-flex justify-content-between align-items-end mb-0">
					<ul class="nav nav-tabs custom-index-tabs border-0 mb-0"
						id="approvalTabs" role="tablist" style="margin-bottom: -1px !important;"> 

						<li class="nav-item">
							<button
								class="nav-link ${param.tabType == 'ALL' or empty param.tabType ? 'active' : ''}"
								onclick="changeTab('ALL')" type="button">
								<i class="bi bi-list-ul"></i> <span>전체</span>
							</button>
						</li>

						<%-- [MANAGER / MEMBER] 전용 탭 --%>
						<c:if
							test="${projectRole eq 'MANAGER' or projectRole eq 'MEMBER' or (projectNo == 0 and userAuth eq 'ROLE_MEMBER')}">
							<li class="nav-item">
								<button
									class="nav-link ${param.tabType == 'PROGRESS' ? 'active' : ''}"
									onclick="changeTab('PROGRESS')" type="button">
									<i class="bi bi-hourglass-split"></i> <span>결재 진행</span>
								</button>
							</li>
							<li class="nav-item">
								<button
									class="nav-link ${param.tabType == 'TEMP' ? 'active' : ''}"
									onclick="changeTab('TEMP')" type="button">
									<i class="bi bi-pencil-square"></i> <span>임시보관</span>
								</button>
							</li>
						</c:if>
						
						<%-- [CLIENT] 전용 탭 --%>
						<c:if test="${projectRole eq 'CLIENT' or (projectNo == 0 and userAuth eq 'ROLE_CLIENT')}">
							<li class="nav-item">
								<button
									class="nav-link ${param.tabType == 'WAIT' ? 'active' : ''}"
									onclick="changeTab('WAIT')"
									type="button">
									<i class="bi bi-file-earmark-check"></i> <span>결재 대기</span>
								</button>
							</li>
						</c:if>

						<li class="nav-item">
							<button
								class="nav-link ${param.tabType == 'REJECT' ? 'active' : ''}"
								onclick="changeTab('REJECT')" type="button">
								<i class="bi bi-exclamation-octagon"></i> <span>반려</span>
							</button>
						</li>

						<li class="nav-item">
							<button
								class="nav-link ${param.tabType == 'COMPLETE' ? 'active' : ''}"
								onclick="changeTab('COMPLETE')"
								type="button">
								<i class="bi bi-check-all"></i> <span>최종 승인</span>
							</button>
						</li>
					</ul>
					
					<c:if test="${projectRole eq 'MANAGER' or (projectNo == 0 and userAuth eq 'ROLE_MEMBER')}">
						<div class="ms-auto pb-2">
							<button type="button" class="tudio-btn tudio-btn-primary" 
					               onclick="location.href='/tudio/approval/form?projectNo=${projectNo}'">
								<i class="bi bi-plus-lg me-1"></i> 결재 작성
							</button>
						</div>
					</c:if>		
					
					</div>

					<div class="tab-content tab-content-card" id="approvalTabContent">
						
						<div class="tudio-section-header mb-4">
						    <div class="d-flex align-items-center gap-3">
							    <h2 class="h5 fw-bold m-0 text-primary-dark align-items-center" id="taskViewTitle">
							    	<i class="bi bi-collection-fill me-2"></i> 프로젝트 선택
							    </h2>
						    	<!-- 셀렉트박스 -->
								<div class="d-flex align-items-center gap-4">
									<select class="form-select form-select-sm" style="width: 250px;"
										onchange="changeProject(this.value)">
										<option value="0">-- 프로젝트를 선택하세요 --</option>
										<c:forEach items="${myProjectList}" var="p">
											<option value="${p.projectNo}"
												${p.projectNo == projectNo ? 'selected' : ''}>
												${p.projectName}</option>
										</c:forEach>
									</select>
								</div>
						    </div>
						</div>
						
						<div class="table-section">
							<div class="tudio-table-wrap">
							<table class="tudio-table-card">
								<thead>
									<tr>
										<th class="text-center" style="width: 80px">번호</th>
						                <th class="text-center" style="width: 100px">상태</th>
						                <th class="text-center" style="width: 210px">프로젝트</th>
						                <th class="text">제목</th>
						                <th class="text-center" style="width: 120px">기안자</th>
						                <th class="text-center" style="width: 140px">기안일</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="totalRecord" value="${pagingVO.totalRecord}" />
									<c:set var="currentPage" value="${pagingVO.currentPage}" />
									<c:set var="screenSize" value="${pagingVO.screenSize}" />
									<c:choose>
										<c:when test="${empty pagingVO.dataList}">
											<tr>
						                        <td colspan="6">
						                            <div class="tudio-empty">
						                                <i class="bi bi-file-earmark-x"></i>
						                                <div class="title">해당하는 문서가 없습니다.</div>
						                            </div>
						                        </td>
						                    </tr>
										</c:when>
										<c:otherwise>
											<c:forEach items="${pagingVO.dataList}" var="draft" varStatus="status">
						                        <tr class="row-click">
						                            <td class="text-center">
						                               <c:choose>
													        <c:when test="${pagingVO.totalRecord > 0}">
													            ${pagingVO.totalRecord - (pagingVO.currentPage - 1) * pagingVO.screenSize - status.index}
													        </c:when>
													        <c:otherwise>
													            ${fn:length(pagingVO.dataList) - status.index}
													        </c:otherwise>
													    </c:choose>
						                            </td>
						                            <td class="text-center">
						                                <c:choose>
						                                    <%-- common.css의 .tudio-badge 클래스 사용 --%>
						                                    <c:when test="${draft.documentStatus == 611}">
						                                        <span class="tudio-badge qna">대기</span>
						                                    </c:when>
						                                    <c:when test="${draft.documentStatus == 612}">
						                                        <span class="tudio-badge free">진행중</span>
						                                    </c:when>
						                                    <c:when test="${draft.documentStatus == 613}">
						                                        <span class="tudio-badge" style="background: rgba(59, 130, 246, .10); color: #3B82F6;">완료</span>
						                                    </c:when>
						                                    <c:when test="${draft.documentStatus == 614}">
						                                        <span class="tudio-badge notice">반려</span>
						                                    </c:when>
						                                    <c:otherwise>
						                                        <span class="tudio-badge" style="background: #f1f5f9; color: #64748b;">임시보관</span>
						                                    </c:otherwise>
						                                </c:choose>
						                            </td>
						                            <td class="text-center">
						                                <span class="tudio-item-sub">${draft.projectName}</span>
						                            </td>
						                            <td class="title">
						                                <a href="/tudio/approval/detail?no=${draft.documentNo}" class="text-decoration-none text-dark">
						                                    ${draft.documentTitle}
							                                <c:if test="${draft.fileCount > 0}">
													            <span class="file-icon-wrap" title="첨부파일 ${draft.fileCount}개">
													                <i class="bi bi-paperclip"></i>
													                <span>${draft.fileCount}</span>
													            </span>
													        </c:if>
						                                </a>
						                            </td>
						                            <td class="text-center">${draft.drafterName}</td>
						                            <td class="text-center">
						                                ${draft.documentRegdate}
						                            </td>
						                        </tr>
						                    </c:forEach>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
						<div class="approval-pager mt-4">
							${pagingVO.getPagingHTML()}</div>
					</div>
				</div>
			</div>
			</div>
		</main>
	</div>
	<jsp:include page="../chat/main.jsp"/>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	</div>
	
	</section>
	<script type="text/javascript">
		$(function() {
			// 1. 페이징 버튼 클릭 이벤트
			// 공통 VO가 만든 .page-link를 클릭했을 때 동작합니다.
			$(".approval-pager").on("click", ".page-link", function(e) {
				e.preventDefault(); // a 태그 기본 이동 막기

				let page = $(this).data("page"); // 클릭한 페이지 번호
				if (!page)
					return; // 번호가 없으면 무시

				// 현재 URL의 파라미터들을 유지하면서 페이지 번호만 바꿉니다.
				let url = new URL(window.location.href);
				url.searchParams.set("page", page);

				location.href = url.href;
			});

			// 2. 검색 버튼 클릭 이벤트
			$("#searchBtn").on("click", function() {
				let searchType = $("#searchType").val();
				let searchWord = $("#searchWord").val();

				let url = new URL(window.location.href);
				url.searchParams.set("page", "1"); // 검색 시 1페이지로 리셋
				url.searchParams.set("searchType", searchType);
				url.searchParams.set("searchWord", searchWord);

				location.href = url.href;
			});
		});

		/**
		 * 3. 프로젝트 변경 함수 (추가/수정)
		 * 셀렉트 박스에서 프로젝트를 선택했을 때 실행
		 */
		function changeProject(pNo) {
			let url = new URL("/tudio/approval/list", window.location.origin);

			if (pNo && pNo !== "0") {
				url.searchParams.set("projectNo", pNo);
			}

			url.searchParams.set("menu", "approval");

			location.href = url.href;
		}

		/**
		 * 탭 이동 함수
		 * 탭을 클릭할 때 tabType을 파라미터로 넘깁니다.
		 */
		function changeTab(tabType) {
			let url = new URL(window.location.href);
			url.searchParams.set("tabType", tabType);
			url.searchParams.set("page", "1"); // 탭 이동 시에도 1페이지로 리셋
			url.searchParams.set("menu", "approval");

			location.href = url.href;
		}
	</script>
</body>
</html>