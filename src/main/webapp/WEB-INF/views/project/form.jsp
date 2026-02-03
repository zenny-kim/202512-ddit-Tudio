<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>Tudio</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
	<!--<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project.css">-->
</head>

<body class="d-flex flex-column min-vh-100"
	data-context-path="${pageContext.request.contextPath}"
	data-status="${status}" data-project-no="${project.projectNo}">

	<jsp:include page="../include/headerUser.jsp" />

	<div class="d-flex flex-grow-1">
		<jsp:include page="../include/sidebarUser.jsp">
			<jsp:param name="menu" value="${status eq 'c' ? 'project_new' : 'project_list'}" />
		</jsp:include>

		<!-- ✅ main-content 통일 -->
		<main class="main-content-wrap flex-grow-1">
			<div class="container-fluid px-4 pt-4 py-4">

				<!-- ✅ 타이틀 톤 통일 -->
				<div class="d-flex align-items-center justify-content-between mb-4">
					<h1 class="h3 fw-bold m-0 text-primary-dark">
						<i class="bi bi-folder-${status eq 'u' ? 'check' : 'plus'} me-2"></i>
						${status eq 'u' ? '프로젝트 설정' : '프로젝트 생성'}

						<c:if test="${project.projectStatus eq 1}">
							<span class="badge bg-success ms-3 fs-6">
								<i class="bi bi-check-circle-fill me-1"></i> 완료됨
							</span>
						</c:if>
						
						<c:if test="${status eq 'c'}">
					        <button type="button" class="btn btn-sm btn-outline-secondary opacity-50" id="btnAutoFill">
					            <i class="bi bi-magic me-1"></i> 시연용 자동입력
					        </button>
					    </c:if>
					</h1>
				</div>

				<div class="row justify-content-center">
					<div class="col-lg-10">

						<!-- ✅ card -> tudio-card (공통 카드 톤) -->
						<div class="tudio-card p-4">

							<form id="projectForm">

								<c:if test="${status eq 'c'}">
									<div class="alert alert-info bg-opacity-10 small mb-4">
										<i class="bi bi-info-circle-fill me-1"></i> 프로젝트를 생성하는 사용자는 자동으로 <strong>프로젝트 관리자</strong> 권한이 부여됩니다.
									</div>
								</c:if>

								<div class="mb-4">
									<label for="projectName" class="form-label fw-bold">
										프로젝트명 <span class="text-danger">*</span>
									</label> 
									<input type="text" class="form-control" id="projectName" name="projectName" placeholder="예: 차세대 금융 플랫폼 구축"
										value="${project.projectName}" required>
								</div>

								<div class="mb-4">
									<label for="projectDesc" class="form-label fw-bold">프로젝트에 대한 설명</label>
									<textarea class="form-control" id="projectDesc" name="projectDesc" rows="3"
										placeholder="프로젝트의 목적, 주요 목표, 핵심 범위 등을 입력하세요.">${project.projectDesc}</textarea>
								</div>

								<div class="row mb-5">
									<div class="col-md-4">
										<label for="projectType" class="form-label fw-bold">
											프로젝트 유형 <span class="text-danger">*</span>
										</label> 
										<select class="form-select" id="projectType" name="projectType" required>
											<option value="" disabled ${empty project.projectType ? 'selected' : ''}>선택해주세요</option>
											        
											<c:forEach items="${projectType}" var="type">
												<option value="${type.code}" ${project.projectType == type ? 'selected' : ''}>
											    	${type.label}
											    </option>
											</c:forEach>
										</select>
									</div>

									<div class="col-md-4">
										<label for="startDate" class="form-label fw-bold">
											프로젝트 시작일시 <span class="text-danger">*</span>
										</label>
										<input type="date" class="form-control" id="startDate" name="projectStartdate"
											value="<fmt:formatDate value='${project.projectStartdate}' pattern='yyyy-MM-dd'/>" required>
									</div>

									<div class="col-md-4">
										<label for="endDate" class="form-label fw-bold">
											프로젝트 종료일시 <span class="text-danger">*</span>
										</label>
										<input type="date" class="form-control" id="endDate" name="projectEnddate"
											value="<fmt:formatDate value='${project.projectEnddate}' pattern='yyyy-MM-dd'/>" required>
									</div>
								</div>

								<!-- ✅ 섹션 타이틀 톤 통일 -->
								<h5 class="fw-bold mb-2 text-primary-dark border-top pt-4">
									<i class="bi bi-layout-text-window-reverse me-1"></i> 프로젝트 탭 및 순서 설정
								</h5>

								<p class="text-muted small mb-4">${status eq 'u' ? '현재 설정된 탭 순서대로 표시됩니다.' : '프로젝트 상세 화면에서 사용할 탭을 선택하고 순서를 변경할 수 있습니다.'}</p>
								

								<!-- ✅ table : project_common.css -->
								<div class="table-responsive mb-4">
									<table class="table table-bordered align-middle">
										<thead>
											<tr>
												<th style="width: 10%;" class="text-center">이동</th>
												<th style="width: 40%;">탭 이름 (기능)</th>
												<th style="width: 20%;" class="text-center">사용 여부</th>
												<th style="width: 30%;">비고</th>
											</tr>
										</thead>
										<tbody id="tabSortableList">
											<c:forEach items="${tabList}" var="tab">
												<c:set var="rowClass" value="${tab.id eq 8 ? 'static-row table-light' : 'draggable-row'}" />
												<tr class="${rowClass}" data-tap-id="${tab.id}">
													<td class="text-center drag-handle">
														<c:if test="${tab.id ne 8}">
															<i class="bi bi-grip-vertical text-secondary" style="cursor: grab;"></i>
														</c:if>
														<c:if test="${tab.id eq 8}">
															<i class="bi bi-lock-fill text-muted" title="고정됨"></i>
														</c:if>
													</td>
													<td>
														<i class="bi ${tab.icon} me-2 ${tab.color}"></i>
														<strong>${tab.name}</strong>
														<!--<c:if test="${tab.id eq 1}"><span class="badge bg-danger ms-1">필수</span></c:if>-->
														<!--<c:if test="${tab.id eq 8}"><span class="badge bg-secondary ms-1">고정</span></c:if>-->
													</td>
													<td class="text-center">
														<div class="form-check form-switch d-flex justify-content-center">
															<c:choose>
																<c:when test="${tab.id eq 2}">
																	<input class="form-check-input" type="checkbox" role="switch" checked disabled>
																	<input type="hidden" class="fixed-tab-check" value="2"> 
																</c:when>
																<c:otherwise>
																	<input class="form-check-input" type="checkbox" role="switch" ${tab.checked ? 'checked' : ''}>
																</c:otherwise>
															</c:choose>
														</div>
													</td>
													<td class="small text-muted">${tab.desc}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>

								<h5 class="fw-bold mb-2 text-primary-dark border-top pt-4">
									<i class="bi bi-people-fill me-1"></i> 팀원 구성 및 초대
								</h5>

								<div
									class="d-flex justify-content-between align-items-center mb-3">
									<p class="text-muted small mb-0">
										<i class="bi bi-exclamation-circle me-1"></i> ${status eq 'u' ? '팀원을 추가하거나 제외할 수 있습니다.' : '팀원이 없는 프로젝트는 <strong>생성 7일 후 자동으로 삭제</strong>됩니다.'}
									</p>

									<button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#inviteModal">
										<i class="bi bi-envelope-plus me-1"></i> 팀원 초대
									</button>
								</div>

								<div class="table-responsive mb-4">
									<table class="table table-bordered align-middle">
										<thead>
											<tr>
												<th scope="col" class="w-5 text-center">권한</th>
												<th scope="col" class="w-25">사용자 이름</th>
												<th scope="col" class="w-45">이메일</th>
												<th scope="col" class="w-25 text-center">관리</th>
											</tr>
										</thead>
										<tbody id="participantList">
											<c:if test="${status eq 'c'}">
												<tr data-type="MANAGER">
													<td class="text-center">
														<span class="badge bg-secondary"><i class="bi bi-person-fill me-1"></i>프로젝트 관리자</span>
													</td>
													<td>
														<span class="fw-bold">${loginUser.memberName}</span>
														<span class="badge bg-secondary ms-1"></span>
														<span class="badge bg-light text-secondary border ms-1 small">본인</span>
													</td>
													<td>${loginUser.memberEmail}</td>
													<td class="text-center">
														<button type="button" class="btn btn-sm btn-outline-secondary p-1" disabled>
															<i class="bi bi-lock-fill"></i>
														</button>
													</td>
												</tr>
											</c:if>

											<c:if test="${status eq 'u'}">
												<c:forEach items="${project.memberList}" var="mem">
													<c:set var="isPending" value="${mem.memberNo == 0 or mem.projectMemstatus eq 'P'}" />
													<c:set var="isDeleted" value="${mem.projectMemstatus eq 'N'}" />
													<c:set var="isManager" value="${mem.projectRole eq 'MANAGER'}" />
												
													<tr data-type="${mem.projectRole}" class="${isDeleted ? 'table-secondary text-muted excluded-member' : (isPending ? 'table-warning' : '')}">
														<td class="text-center">
															<c:choose>
																<c:when test="${mem.projectRole eq 'CLIENT'}">
																	<span class="badge bg-warning text-dark ms-2"><i class="bi bi-building me-1"></i>기업 담당자</span>
																</c:when>
																<c:when test="${mem.projectRole eq 'MANAGER'}">
																	<span class="badge bg-secondary ms-1">
																		<i class="bi bi-person-fill me-1"></i>프로젝트 관리자
																	</span>
																</c:when>
																<c:otherwise>
																	<span class="badge bg-primary ms-2">
																		<i class="bi bi-person me-1"></i>프로젝트 참여자
																	</span>
																</c:otherwise>
															</c:choose> 
														</td>
														
														<td>
															<span class="fw-bold ${isDeleted ? 'text-muted' : 'text-dark'}">${mem.memberName}</span>
															<c:if test="${mem.projectRole eq 'MANAGER'}">
																<span class="badge bg-light text-secondary border ms-1 small">본인</span>
															</c:if>
															<c:choose>
																<c:when test="${isPending}">
																	<span class="badge bg-warning text-dark border ms-1">
																		<i class="bi bi-envelope-paper me-1"></i>초대중
																	</span>
																</c:when>
																<c:when test="${isDeleted}">
																	<span class="badge bg-secondary border ms-1">삭제됨</span>
																</c:when>
															</c:choose>
														</td>

														<td class="${isDeleted ? 'text-decoration-line-through' : ''}">
															${mem.memberEmail}
														</td>

														<td class="text-center">
													<c:choose>
														<c:when test="${isManager}">
															<button class="btn btn-sm btn-outline-secondary p-1" disabled>
																<i class="bi bi-lock-fill"></i>
															</button>
														</c:when>
														<c:otherwise>
														<c:if test="${mem.projectMemstatus eq 'Y'}">
															<c:if test="${mem.projectRole ne 'CLIENT'}">
																<button type="button" class="btn btn-sm btn-outline-dark p-1 me-1 btn-delegate-manager" title="관리자 권한 위임" 
																	data-no="${mem.memberNo}" data-name="${mem.memberName}">
																	<i class="bi bi-person-up"></i>
																</button>
															</c:if>
															<button type="button" class="btn btn-sm btn-outline-danger p-1 btn-remove-member" title="삭제">
																<i class="bi bi-trash"></i>
															</button>
														</c:if>
														<c:if test="${isPending}">
															<button type="button" class="btn btn-sm btn-outline-danger p-1 btn-cancel-invite" title="초대 취소" data-email="${mem.memberEmail}">
																<i class="bi bi-x-lg"></i>
															</button>
														</c:if>
														<c:if test="${isDeleted}">
															<button type="button" class="btn btn-sm btn-outline-success p-1 btn-restore-member" title="복구">
																<i class="bi bi-arrow-counterclockwise"></i>
															</button>
														</c:if>
														</c:otherwise>
													</c:choose>
														</td>
													</tr>
												</c:forEach>
											</c:if>
										</tbody>
									</table>
								</div>

								<div class="d-flex justify-content-end pt-3 border-top">
									<button type="button" class="btn btn-outline-secondary me-2" onclick="history.back()">
										<i class="bi bi-arrow-left me-1"></i>취소
									</button>
									<button type="button" class="btn btn-primary me-2" id="projectSubmitBtn">
										<i class="bi bi-folder-${status eq 'u' ? 'check' : 'plus'} me-1"></i>
										${status eq 'u' ? '프로젝트 수정' : '프로젝트 생성'}
									</button>
								</div>
								
								<c:if test="${status eq 'u' and loginUser.memberNo eq project.memberNo}">
								    <div class="row mt-3 g-3"> 
										<div class="col-12 mb-1">
											<h6 class="fw-bold text-secondary text-uppercase small ls-1">
												<i class="bi bi-sliders me-1"></i> 프로젝트 상태 관리
										    </h6>
										    <hr class="mt-1 mb-3 text-secondary opacity-25">
										</div>
										
										<div class="col-md-6">
											<div class="card h-100 border-danger bg-white shadow-sm">
												<div class="card-body d-flex justify-content-between align-items-center p-4">
													<div>
														<h6 class="fw-bold text-danger mb-1">
															<i class="bi bi-exclamation-triangle-fill me-1"></i> 프로젝트 삭제
														</h6>
														<p class="text-muted small mb-0">
															모든 프로젝트 구성원의 접근이 차단됩니다.
														</p>
													</div>
													<button type="button" class="btn btn-outline-danger fw-bold text-nowrap" id="btnDeleteProject">
														<i class="bi bi-trash3-fill me-1"></i> 삭제
													</button>
												</div>
											</div>
										</div>
										<div class="col-md-6">
											<c:choose>
												<%-- (1) 이미 완료된 경우 -> 재진행 버튼 --%>
												<c:when test="${project.projectStatus eq 1}">
													<div class="card h-100 border-warning bg-white shadow-sm">
														<div class="card-body d-flex justify-content-between align-items-center p-4">
															<div>
																<h6 class="fw-bold text-warning text-dark mb-1">
																	<i class="bi bi-arrow-counterclockwise me-1"></i> 완료 취소 (재진행)
																</h6>
																<p class="text-muted small mb-0">
																	프로젝트를 다시 <strong>진행 중</strong> 상태로 변경합니다.<br>
																	업무 수정 및 팀원 관리가 가능해집니다.
																</p>
															</div>
															<button type="button" class="btn btn-outline-warning fw-bold text-dark text-nowrap" id="btnReopenProject">
																<i class="bi bi-arrow-counterclockwise me-1"></i> 재진행
															</button>
														</div>
													</div>
												</c:when>
												<%-- (2) 진행 중인 경우 -> 완료 버튼 --%>
												<c:otherwise>
													<div class="card h-100 border-success bg-white shadow-sm">
														<div class="card-body d-flex justify-content-between align-items-center p-4">
															<div>
																<h6 class="fw-bold text-success mb-1">
																	<i class="bi bi-check-circle-fill me-1"></i> 프로젝트 완료
																</h6>
																<p class="text-muted small mb-0">
																	모든 업무를 마감하고 <strong>읽기 전용</strong>으로 변경합니다.<br>
																	(언제든 다시 재진행할 수 있습니다)
																</p>
															</div>
															<%-- 중단(2) 상태가 아닐 때만 버튼 노출 --%>
															<c:if test="${project.projectStatus ne 2}">
																<button type="button" class="btn btn-outline-success fw-bold text-nowrap" id="btnCompleteProject">
																	<i class="bi bi-check-lg me-1"></i> 완료
																</button>
															</c:if>
														</div>
													</div>
												</c:otherwise>
											</c:choose>
										</div> 
									</div> 
								</c:if>
							</form>
						</div>
					</div>
				</div>

			</div>
		</main>
	</div>

	<jsp:include page="../include/footer.jsp">
		<jsp:param name="footer" value="create" />
	</jsp:include>

	<!-- ✅ invite modal: 공통 모달 스킨 적용 -->
	<div class="modal fade" id="inviteModal" tabindex="-1" aria-labelledby="inviteModalLabel">
		<div class="modal-dialog" style="min-width: 650px;">
			<div class="modal-content tudio-modal">
				<div class="modal-header tudio-modal-header">
					<h5 class="modal-title fw-bold tudio-modal-title" id="inviteModalLabel">
						<i class="bi bi-envelope-paper me-2"></i> 팀원 초대
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>

				<div class="modal-body p-4">
					<div class="row g-4">
						<div class="col-md-6 border-end">
							<h6 class="fw-bold text-primary mb-3"><i class="bi bi-search me-1"></i> 사용자 검색</h6>
				            <div class="mb-4">
				            	<label class="form-label fw-bold small text-muted text-uppercase mb-2">STEP 1. 초대 역할 선택</label>
								<div class="btn-group w-100 shadow-sm" role="group">
									<input type="radio" class="btn-check" name="inviteType" id="typeMember" value="MEMBER" checked>
									<label class="btn btn-outline-primary py-2" for="typeMember">
										<i class="bi bi-person me-1"></i> 팀원
									</label>
									<input type="radio" class="btn-check" name="inviteType" id="typeClient" value="CLIENT">
									<label class="btn btn-outline-warning text-dark py-2" for="typeClient">
										<i class="bi bi-building me-1"></i> 기업 담당자
									</label>
								</div>
							</div>
							
							<div class="mb-3">
								<label class="form-label fw-bold small text-muted text-uppercase mb-2">STEP 2. 이메일 검색</label>
								<div class="input-group shadow-sm">
									<span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
									<input type="text" class="form-control border-start-0 ps-0" id="searchEmailKeyword" placeholder="이메일 주소를 입력하세요" autocomplete="off">
									<button class="btn btn-dark px-3" type="button" id="btnSearchMember">검색</button>
								</div>
								<div class="form-text small mt-1">
									<i class="bi bi-info-circle me-1"></i>정확한 이메일 주소를 입력해야 검색됩니다.
								</div>
							</div>
							<div id="searchResultArea" class="mt-4">
								<div class="text-center text-muted py-5 rounded-3 border border-dashed bg-light">
									<i class="bi bi-envelope-open fs-1 text-secondary opacity-50 mb-2"></i>
									<p class="small mb-0">이메일을 입력하여 사용자를 검색하세요.<br>가입하지 않은 사용자도 초대할 수 있습니다.</p>
								</div>
							</div>							
						</div>
						<div class="col-md-6 ps-md-4 d-flex flex-column">
							<div class="d-flex justify-content-between align-items-center mb-3">
								<label class="form-label fw-bold small text-muted text-uppercase mb-0">STEP 3. 초대 목록</label>
								<span class="badge bg-secondary rounded-pill" id="candidateCount">0명</span>
							</div>
						    <div class="card flex-grow-1 border shadow-sm" style="min-height: 350px; max-height: 400px;">
								<div class="card-body p-0 overflow-auto custom-scrollbar">
									<ul class="list-group list-group-flush" id="inviteCandidateList">
										<li class="list-group-item border-0 text-center text-muted py-5 mt-5 empty-msg">
											<i class="bi bi-basket3 fs-1 text-secondary opacity-50 mb-3"></i>
											<p class="small">검색된 사용자를 추가하면<br>이곳에 표시됩니다.</p>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer bg-light">
					<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary px-4" id="processInviteBtn">
						<i class="bi bi-send me-1"></i> 팀원 초대
					</button>
				</div>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.15.0/Sortable.min.js"></script>
	<!--<script src="${pageContext.request.contextPath}/js/projectForm.js"></script>-->
	<script src="${pageContext.request.contextPath}/js/projectCreate.js"></script>
</body>
</html>
