<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/task_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<div class="tab-content-cards">
	<div class="tudio-section-header mb-4">
		<h5 class="mb-0 text-primary-dark fw-bold" id="taskViewTitle">
		<i class="fa-solid fa-chalkboard-user me-2"></i>업무
			목록 (리스트)</h5>
		<div class="d-flex gap-2">
			<button class="tudio-btn tudio-btn-primary" id="createTaskBtn">
				<i class="bi bi-plus"></i> 새 업무 추가
			</button>
			<button class="tudio-btn" id="toggleViewButton"
				style="border: 1px solid var(--tudio-border-soft);">
				<i class="bi bi-list me-1"></i> 칸반 보기
			</button>
		</div>
	</div>

	<c:if test="${not empty errorMsg}">
		<div id="taskErrorMsg" data-error-msg="${fn:escapeXml(errorMsg)}"
			style="display: none;"></div>
	</c:if>

	<div id="listView" >

		<div class="d-flex justify-content-between align-items-center mb-3 px-3">
			<!-- 단위 업무 일괄 가시화 체크박스 -->
			<div class="form-check ms-2">
				<input class="form-check-input" type="checkbox" id="toggleAllCheckbox" style="cursor: pointer;" checked> 
					<label class="form-check-label text-muted user-select-none" for="toggleAllCheckbox" style="cursor: pointer;"> 
						업무 펼치기 
					</label>
			</div>

			<!-- 업무 정렬 선택 -->
			<div class="d-flex align-items-center gap-4">
				<div class="d-flex gap-2" id="taskSortControl">
					<input type="hidden" id="currentSortType" value="${not empty param.sortType ? param.sortType : 'REGDATE'}">
					<input type="hidden" id="currentSortOrder" value="${not empty param.sortOrder ? param.sortOrder : 'DESC'}">

					<button type="button"
						class="btn btn-sm btn-link text-decoration-none sort-btn ${empty param.sortType || param.sortType == 'REGDATE' ? 'fw-bold text-primary' : 'text-muted'}"
						data-sort-type="REGDATE" data-default-order="DESC">작성일순
						<c:if test="${empty param.sortType || param.sortType == 'REGDATE'}">
							<i class="fa-solid ${param.sortOrder == 'ASC' ? 'fa-arrow-up' : 'fa-arrow-down'} ms-1 small"></i>
						</c:if>
					</button>

					<span class="text-muted small align-self-center">|</span>

					<button type="button"
						class="btn btn-sm btn-link text-decoration-none sort-btn ${param.sortType == 'ENDDATE' ? 'fw-bold text-primary' : 'text-muted'}"
						data-sort-type="ENDDATE" data-default-order="ASC">
						마감일순
						<c:if test="${param.sortType == 'ENDDATE'}">
							<i class="fa-solid ${param.sortOrder == 'DESC' ? 'fa-arrow-down' : 'fa-arrow-up'} ms-1 small"></i>
						</c:if>
					</button>

					<span class="text-muted small align-self-center">|</span>

					<button type="button"
						class="btn btn-sm btn-link text-decoration-none sort-btn ${param.sortType == 'PRIORITY' ? 'fw-bold text-primary' : 'text-muted'}"
						data-sort-type="PRIORITY" data-default-order="DESC">중요도순
						<c:if test="${param.sortType == 'PRIORITY'}">
							<i class="fa-solid ${param.sortOrder == 'ASC' ? 'fa-arrow-up' : 'fa-arrow-down'} ms-1 small"></i>
						</c:if>
					</button>
				</div>

				<div class="d-flex align-items-center gap-2">
					<div class="tudio-search">
						<input type="text" placeholder="검색어를 입력하세요" />
					</div>
					<button class="tudio-search-btn" aria-label="search">검색</button>
				</div>
			</div>
		</div>
		
		<div class="tudio-table-wrap">
			<table class="tudio-table-card">
			<colgroup>
					<col style="width: 20%;"> <col style="width: 8%;">  <col style="width: 8%;">  <col style="width: 9%;">  <col style="width: 9%;">  <col style="width: 9%;">  <col style="width: 8%;">  <col style="width: 12%;"> <col style="width: 7%;">  
			</colgroup>
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
					<c:if test="${empty taskList}">
                        <tr>
                            <td colspan="8" class="text-center py-5 text-muted">
                                <i class="bi bi-clipboard-x fs-1 d-block mb-3 opacity-50"></i>
                                <span>등록된 업무가 없습니다.</span>
                            </td>
                        </tr>
                    </c:if>
					<c:forEach items="${taskList}" var="task">
						<tr class="task-row" data-task-id="${task.taskId}" style="cursor: pointer;">
							<td class="task-title">
								<span class="toggle-btn me-2 p-1" style="cursor: pointer;">
                                    <i class="bi bi-caret-right-fill toggle-icon text-muted"></i>
                                </span>
                                
								<div class="pin-wrapper me-2" onclick="setPin('${task.taskId}', 'T', event)">
						            <i class="bi bi-pin-angle${task.taskPinYn eq 'Y' ? '-fill active' : ''} task-pin-icon"
						               data-bs-toggle="tooltip" 
						               data-bs-placement="top" 
						               title="${task.taskPinYn eq 'Y' ? '고정자: ' += task.taskPinMemberName : '상단 고정'}">
						            </i>
						        </div>
        
								<span class="task-title-text fw-bold text-dark">${task.taskTitle}</span>
							</td>
							<td>
								<span class="tudio-badge ${task.taskStatus.cssClass }">${task.taskStatus.label }</span>
							</td>

							<td><c:set value="${task.taskManagers }" var="taskManager" />
								<c:choose>
									<c:when test="${empty taskManager }">
										<span>-</span>
									</c:when>
									<c:when test="${fn:length(taskManager) > 1 }">
										<span>${taskManager[0].memberName } 외
											${fn:length(taskManager) -1 }명</span>
									</c:when>
									<c:otherwise>
										<span>${taskManager[0].memberName }</span>
									</c:otherwise>
								</c:choose></td>
							<td class="text-muted">
								<fmt:formatDate value="${task.taskStartdate }" pattern="yyyy-MM-dd" />
							</td>
							<td class="text-muted">
					            <fmt:formatDate value="${task.taskEnddate }" pattern="yyyy-MM-dd" />
					        </td>
					
					        <td class="text-muted">
								<c:choose>
									<c:when test="${not empty task.taskFinishdate}">
										<c:if test="${task.taskFinishdate.time > task.taskEnddate.time}">
											<span class="text-danger" title="지연 완료">
												<fmt:formatDate value="${task.taskFinishdate}" pattern="yyyy-MM-dd" />
											</span>
										</c:if>
										<c:if test="${task.taskFinishdate.time <= task.taskEnddate.time}">
											<span class="text-success" title="정상 완료">
												<fmt:formatDate value="${task.taskFinishdate}" pattern="yyyy-MM-dd" />
											</span>
										</c:if>
									</c:when>
									<c:otherwise>
										<span>-</span>
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<span class="tudio-badge ${task.taskPriority.cssClass}">${task.taskPriority.label }</span>
							</td>

							<td>
								<div class="d-flex align-items-center gap-2">
									<div class="progress" style="height: 6px; width: 60px;">
										<div class="progress-bar bg-primary" role="progressbar"
											style="width: ${task.taskRate}%;"
											aria-valuenow="${task.taskRate}" aria-valuemin="0"
											aria-valuemax="100"></div>
									</div>
									<span class="small text-muted" style="min-width: 30px;">${task.taskRate }%</span>
								</div>
							</td>

							<td><small class="text-muted">${task.writerName }</small></td>
						</tr>

						<c:forEach items="${task.subTasks }" var="sub">
							<tr class="sub-row" data-parent-task-id="${sub.taskId}"
								data-sub-id="${sub.subId }"
								style="display: none; background: #fafafa;">
								<td class="sub-title ps-4">
									<div class="d-flex align-items-center">
							            <i class="bi bi-arrow-return-right text-muted me-2"></i>
							            
							            <div class="pin-wrapper me-2" onclick="setPin('${sub.subId}', 'S', event)">
							                <i class="bi bi-pin-angle${sub.subPinYn eq 'Y' ? '-fill active' : ''} sub-pin-icon"
							                   data-bs-toggle="tooltip" 
							                   title="${sub.subPinYn eq 'Y' ? '고정자: ' += sub.subPinMemberName : '상단 고정'}">
							                </i>
							            </div>
							            
							            <span>${sub.subTitle}</span>
							        </div>
								</td>
								<td><span class="tudio-badge ${sub.subStatus.cssClass }">${sub.subStatus.label }</span></td>

								<td><c:set value="${sub.subManagers }" var="subManager" />
									<c:choose>
										<c:when test="${empty subManager }">
											<span>-</span>
										</c:when>
										<c:when test="${fn:length(subManager) > 1 }">
											<span>${subManager[0].memberName } 외
												${fn:length(subManager) -1 }명</span>
										</c:when>
										<c:otherwise>
											<span>${subManager[0].memberName }</span>
										</c:otherwise>
									</c:choose></td>
								<td class="text-muted">
									<fmt:formatDate value="${sub.subStartdate }" pattern="yyyy-MM-dd" />
								</td>
								<td class="text-muted">
					                <fmt:formatDate value="${sub.subEnddate }" pattern="yyyy-MM-dd" />
					            </td>
					
					            <td class="text-muted">
									<c:choose>
										<c:when test="${not empty sub.subFinishdate}">
											<c:if test="${sub.subFinishdate.time > sub.subEnddate.time}">
												<span class="text-danger" title="지연 완료">
													<fmt:formatDate value="${sub.subFinishdate}" pattern="yyyy-MM-dd" />
												</span>
											</c:if>
											<c:if test="${sub.subFinishdate.time <= sub.subEnddate.time}">
												<span class="text-success" title="정상 완료">
													<fmt:formatDate value="${sub.subFinishdate}" pattern="yyyy-MM-dd" />
												</span>
											</c:if>
										</c:when>
										<c:otherwise>
											<span>-</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<span class="tudio-badge ${sub.subPriority.cssClass }">${sub.subPriority.label }</span>
								</td>

								<td>
									<div class="d-flex align-items-center gap-2">
										<div class="progress" style="height: 6px; width: 60px;">
											<div class="progress-bar bg-primary" role="progressbar"
												style="width: ${sub.subRate}%;"
												aria-valuenow="${sub.subRate}" aria-valuemin="0"
												aria-valuemax="100"></div>
										</div>
										<span class="small text-muted" style="min-width: 30px;">${sub.subRate }%</span>
									</div>
								</td>

								<td><small class="text-muted">${sub.writerName }</small></td>
							</tr>
						</c:forEach>

						<tr class="sub-add-row" data-parent-task-id="${task.taskId}" style="display: none; background: #f0f0f0;">
							<td colspan="9" class="text-center"> 
								<i class="bi bi-plus-circle me-1"></i>업무 추가
							</td>
						</tr>

					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>