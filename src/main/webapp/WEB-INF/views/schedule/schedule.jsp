<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Tudio</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/project_common.css">
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
</head>

<style>
/* 1. 기본 버튼 스타일 (더 작고 연하게) */
.fc .fc-button {
	background-color: #f8fbff !important; /* 배경색을 더 하얗고 투명하게 */
	border: 1px solid #e2e8f0 !important; /* 테두리 색상을 아주 연한 회색빛으로 변경 */
	color: #64748b !important; /* 글자색을 쨍한 파랑 대신 차분한 슬레이트 블루로 */
	font-weight: 500 !important;
	border-radius: 8px !important; /* 라운딩 살짝 조절 */
	padding: 5px 12px !important; /* 안쪽 여백을 줄여 버튼 크기 축소 */
	text-transform: capitalize; /* 전체 대문자보다는 첫 글자만 대문자로 해서 차분하게 */
	font-size: 0.78rem !important; /* 글자 크기 축소 */
	transition: all 0.2s ease !important;
	box-shadow: none !important;
}

/* 2. 마우스를 올렸을 때 (Hover) */
.fc .fc-button:hover {
	background-color: #f1f5f9 !important;
	border-color: #cbd5e1 !important;
	color: var(--main-blue) !important; /* 마우스 올릴 때만 파란색 강조 */
}

/* 3. 활성화된 버튼 (현재 선택된 View) */
.fc .fc-button-active {
	background-color: #eff6ff !important; /* 활성화 시에도 너무 진하지 않은 연한 파랑 배경 */
	border-color: #bfdbfe !important; /* 테두리도 연한 파랑 */
	color: var(--main-blue) !important; /* 글자색만 파란색으로 유지하여 강조 */
	font-weight: 700 !important;
	box-shadow: none !important; /* 그림자 제거해서 더 평면적이고 깔끔하게 */
}

/* 4. 버튼 사이 간격 및 그룹 해제 */
.fc .fc-button-group>.fc-button {
	margin-right: 6px !important; /* 버튼 사이 간격을 살짝 벌림 */
	border-radius: 8px !important; /* 각 버튼의 사방을 모두 둥글게 */
	border-left: 1px solid #e2e8f0 !important; /* 그룹화 시 왼쪽 테두리 사라짐 방지 */
}

/* 5. 오늘(Today) 버튼 */
.fc .fc-today-button {
	background-color: #ffffff !important;
	border: 1px solid #e2e8f0 !important;
	color: #94a3b8 !important; /* 오늘 버튼은 더 은은하게 */
}

/* 6. 화살표 버튼 (prev, next) 크기 조절 */
.fc .fc-button .fc-icon {
	font-size: 0.9em !important; /* 화살표 아이콘 크기도 함께 축소 */
}
/* 7. 달력 날짜 숫자 스타일 (링크 느낌 제거 및 색상 통일) */
.fc .fc-daygrid-day-number {
    text-decoration: none !important;
    color: #333333; /* 평일 기본 검정색 */
    font-weight: 500;
}

/* 8. 일요일 날짜 빨간색 */
.fc .fc-day-sun .fc-daygrid-day-number {
    color: #e11d48 !important;
}

/* 9. 토요일 날짜 파란색 */
.fc .fc-day-sat .fc-daygrid-day-number {
    color: #2563eb !important;
}
/* 10. 마우스 오버 시 날짜 배경 약간 변경 (선택사항) */
.fc .fc-daygrid-day:hover {
    background-color: #f8fafc;
}

/* more 링크 관련 스타일 */
/* 1. +n more 링크 스타일 (알약 모양 배지 스타일) */
.fc .fc-daygrid-more-link {
    display: block;                /* 블록 요소로 변경하여 너비 차지 */
    text-align: center;            /* 텍스트 중앙 정렬 */
    font-size: 0.75rem !important; /* 글자 크기 */
    font-weight: 600;
    color: #64748b !important;     /* 글자색 (슬레이트) */
    background-color: #f1f5f9;     /* 배경색 (아주 연한 회색) */
    border-radius: 50rem;          /* 둥근 알약 모양 */
    padding: 2px 0;                /* 상하 패딩 */
    margin: 2px 5px 0 5px;         /* 양옆 여백 */
    text-decoration: none !important;
    transition: all 0.2s ease;
}

/* 마우스 올렸을 때 */
.fc .fc-daygrid-more-link:hover {
    background-color: #e2e8f0;     /* 배경 조금 더 진하게 */
    color: #334155 !important;     /* 글자 진하게 */
    transform: translateY(-1px);   /* 살짝 떠오르는 효과 */
}

/* 2. 더보기 팝업(Popover) 전체 박스 디자인 */
.fc-theme-standard .fc-popover {
    border: none !important;                 /* 기본 테두리 제거 */
    border-radius: 12px !important;          /* 둥근 모서리 */
    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 
                0 8px 10px -6px rgba(0, 0, 0, 0.1) !important; /* 부드러운 그림자 */
    background-color: #ffffff;
    overflow: hidden;                        /* 내부 컨텐츠 넘침 방지 */
}

/* 3. 팝업 헤더 (날짜 부분) */
.fc-theme-standard .fc-popover-header {
    background-color: #f8fbff;               /* 연한 파랑 배경 */
    padding: 12px 16px !important;
    border-bottom: 1px solid #f1f5f9;
}

.fc-theme-standard .fc-popover-title {
    font-size: 0.95rem;
    font-weight: 700;
    color: #1e293b;
    letter-spacing: -0.02em;
}

.fc-theme-standard .fc-popover-close {
    opacity: 0.5;
    font-size: 0.9em;
}
.fc-theme-standard .fc-popover-close:hover {
    opacity: 1;
}

/* 4. 팝업 바디 (일정 리스트 영역) */
.fc-theme-standard .fc-popover-body {
    padding: 12px !important;
}

/* 팝업 내부의 이벤트 항목 간격 */
.fc-popover-body .fc-daygrid-event-harness {
    margin-bottom: 6px !important;
}
.fc .fc-daygrid-day-frame {
    min-height: 150px !important;
}
.my-task-badge {
    display: inline-block;
    background-color: #FEF3C7; /* 연한 옐로우 (Amber 100) */
    color: #92400E;           /* 진한 갈색 옐로우 텍스트 (Amber 800) */
    font-size: 10px;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 20px;      /* 모서리 아주 둥글게 */
    margin-left: 8px;         /* 제목과의 간격 */
    vertical-align: middle;
    border: 1px solid #FDE68A; /* 뱃지 테두리 */
    letter-spacing: -0.5px;
}

</style>


<body class="d-flex flex-column min-vh-100">

	<!-- header -->
	<jsp:include page="/WEB-INF/views/include/headerUser.jsp" />
	<div class="d-flex flex-grow-1">
		<jsp:include page="../include/sidebarUser.jsp">
			<jsp:param name="menu" value="schedule" />
		</jsp:include>

		<main class="main-content-wrap flex-grow-1">
			<div class="container-fluid px-4 pt-4">
				<div class="d-flex align-items-center justify-content-between mb-4">
					<h1 class="h3 fw-bold m-0 text-primary-dark">
						<i class="bi bi-calendar3 me-2"></i> 전체 일정
					</h1>
				</div>

				<div class="row">
					<div class="col-lg-2 col-md-3">
						<button type="button"
							class="tudio-btn tudio-btn-primary w-100 mb-4"
							id="addScheduleBtn"
							style="justify-content: center; padding: 14px; font-size: 15px; letter-spacing: -0.5px;">
							<i class="bi bi-plus-circle-fill me-2"></i> 새 일정 등록
						</button>
						
						<!-- 일정 색상 구분 div -->
						<div class="tudio-card p-3 mb-4 shadow-sm ">
							<h6 class="fw-bold mb-3 text-primary-dark border-bottom pb-2">
								<i class="bi bi-palette-fill me-2"></i> 일정 구분
							</h6>
							<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
								<div class="form-check m-0" style="min-width: 80px;">
									<label class="form-check-label small" for="typeTask"> 프로젝트</label>
								</div>
								<span class="badge rounded-pill p-2 d-inline-block" style="background-color: #e6f7ff; border: 1px solid #91d5ff; width: 50px; height: 10px;"></span>
							</div>
							<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
								<div class="form-check m-0" style="min-width: 80px;">
									<label class="form-check-label small" for="typeTask">업무</label>
								</div>
								<span class="badge rounded-pill p-2 d-inline-block" style="background-color: #ffeded; border: 1px solid #ffccc7; width: 50px; height: 10px;"></span>
							</div>
							<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
								<div class="form-check m-0" style="min-width: 80px;">
									<label class="form-check-label small" for="typeTask">단위업무</label>
								</div>
								<span class="badge rounded-pill p-2 d-inline-block" style="background-color: #fffbe6; border: 1px solid #ffe58f; width: 50px; height: 10px;"></span>
							</div>
							<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
								<div class="form-check m-0" style="min-width: 80px;">
									<label class="form-check-label small" for="typeTask">회의일정</label>
								</div>
								<span class="badge rounded-pill p-2 d-inline-block" style="background-color: #f6ffed; border: 1px solid #b7eb8f; width: 50px; height: 10px;"></span>
							</div>
						</div>
						
						<!-- 프로젝트 선택 체크박스 div -->
						<div class="tudio-card p-3 mb-4 shadow-sm">
							<div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
						        <h6 class="fw-bold m-0 text-primary-dark">
						            <i class="bi bi-collection-fill me-2"></i> 프로젝트
						        </h6>
						        <button type="button" id="btnToggleProject" class="btn btn-sm btn-light text-secondary fw-bold" 
						                style="font-size: 0.75rem; padding: 2px 8px; border-radius: 6px;">
						            <i class="bi bi-check-all me-1"></i>전체 해제
						        </button>
						    </div>
						    <div id="projectFilterList" style="max-height: 250px; overflow-y: auto;" class="custom-scrollbar"></div>
						</div>

						<!-- 일정 종류 체크박스 div -->
						<div class="tudio-card p-3 shadow-sm">
							<h6 class="fw-bold mb-3 text-primary-dark border-bottom pb-2">
								<i class="bi bi-layers-fill me-2"></i> 일정 종류
							</h6>
							<div class="type-filter-list">
								<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
								    <div class="form-check m-0">
								        <input class="form-check-input filter-check" type="checkbox" value="MEETING" id="typeMeeting" checked>
								        <label class="form-check-label small" for="typeMeeting">회의 일정</label>
								    </div>
								</div>
								<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
									<div class="form-check m-0">
										<input class="form-check-input filter-check" type="checkbox" value="TASK" id="typeTask" checked>
										<label class="form-check-label small" for="typeTask">업무</label>
									</div>
								</div>
								<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
									<div class="form-check m-0">
										<input class="form-check-input filter-check" type="checkbox" value="SUB" id="typeSub" checked>
										<label class="form-check-label small" for="typeSub">단위 업무</label>
									</div>
								</div>
								<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
									<div class="form-check m-0">
										<input class="form-check-input filter-check" type="checkbox" value="SCHEDULE" id="typeSchedule" checked>
										<label class="form-check-label small" for="typeSchedule">개인 일정</label>
									</div>
								</div>

								
							</div>
						</div>
						
					</div>

					<div class="col-lg-10 col-md-9">
						<div class="tudio-card p-4 shadow-sm bg-white">
							<div id="calendar"></div>
						</div>
					</div>
					
					
				</div>
				
				
				
			</div>
		</main>
	</div>

	<!-- 새일정등록 모달 -->
	<div class="modal fade" id="addScheduleModal" tabindex="-1"
		aria-labelledby="addScheduleModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content tudio-modal">
				<div class="modal-header tudio-modal-header">
					<h5 class="modal-title fw-bold tudio-modal-title" id="addScheduleModalLabel">
						<i class="bi bi-calendar-plus me-2"></i>새 일정 등록
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body p-4">
					<form id="scheduleForm">
						<input type="hidden" id="scheduleId" name="scheduleId">
						<div class="mb-3">
							<label class="form-label fw-bold">일정 제목</label>
							<input type="text" class="form-control" id="scheduleTitle" name="scheduleTitle" placeholder="제목을 입력하세요" required>
						</div>
						<div class="row">
							<div class="col-md-6 mb-3">
								<label class="form-label fw-bold">참여 중인 프로젝트</label>
								<select class="form-select" id="projectNo" name="projectNo" required>
									<option value="">프로젝트를 선택하세요</option>
								</select>
							</div>
							<div class="col-md-6 mb-3">
								<label class="form-label fw-bold">일정 상태</label>
								<select class="form-select" id="scheduleStatus" name="scheduleStatus">
									<option value="0">예정</option>
									<option value="1">진행</option>
									<option value="2">완료</option>
								</select>
							</div>
						</div>
						<div class="row mb-3">
						    <div class="col-12 mb-2">
						        <div class="form-check form-check-inline">
						            <input class="form-check-input" type="checkbox" id="scheduleAllday" name="scheduleAllday" value="Y">
						            <label class="form-check-label small fw-bold text-muted" for="scheduleAllday">
						                <i class="bi bi-clock-fill me-1"></i>종일 일정
						            </label>
						        </div>
						    </div>
						    
						    <div class="col-md-6">
						        <label class="form-label fw-bold small text-secondary">시작 일시</label>
						        <div class="input-group">
						            <span class="input-group-text bg-light border-end-0"><i class="bi bi-calendar-event"></i></span>
						            <input type="datetime-local" class="form-control border-start-0" id="scheduleStartdate" name="scheduleStartdate" step="3600">
						        </div>
						    </div>
						
						    <div class="col-md-6">
						        <label class="form-label fw-bold small text-secondary">종료 일시</label>
						        <div class="input-group">
						            <span class="input-group-text bg-light border-end-0"><i class="bi bi-calendar-check"></i></span>
						            <input type="datetime-local" class="form-control border-start-0" id="scheduleEnddate" name="scheduleEnddate" step="3600">
						        </div>
						    </div>
						</div>
						<div class="row">
							<div class="col-md-6 mb-3">
								<label class="form-label fw-bold">일정 색상</label>
								<input type="color" class="form-control form-control-color w-100" id="scheduleColor" name="scheduleColor" value="#1E90FF">
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">일정 내용</label>
							<textarea class="form-control" id="scheduleDescription" name="scheduleDescription" rows="3" placeholder="내용을 입력하세요"></textarea>
						</div>
					</form>
				</div>

				<div class="modal-footer tudio-modal-footer" style="border-top: 1px solid #f1f5f9;">
					<button type="button" class="tudio-btn" data-bs-dismiss="modal" style="background: #f1f5f9; color: #64748b;">취소</button>
					<button type="button" class="tudio-btn tudio-btn-primary" id="saveSchedule" style="padding: 10px 24px;">
						<i class="bi bi-check-lg me-1"></i>일정 저장
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 일정 상세확인 모달 -->
<div class="modal fade" id="detailScheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content tudio-modal" style="border-radius: 15px; overflow: hidden; border: none;">
            <div id="modalHeaderColor" style="height: 10px; width: 100%;"></div>

            <div class="modal-header border-0 pt-4 px-4 pb-2">
                <h5 class="modal-title fw-bold tudio-modal-title" style="color: #334155;">
                    <i class="bi bi-info-circle-fill me-2 text-primary"></i>일정 상세 정보
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body px-4">
                <div class="detail-item mb-4">
                    <div class="small text-muted mb-1" style="font-size: 0.85rem;">일정 제목</div>
                    <a id="detailTitleLink" href="#" class="fw-bold fs-5 text-decoration-none d-block" style="color: #1e293b;">
                        <span id="detailTitle"></span>
                    </a>
                </div>

                <div class="row mb-4">
                    <div class="col-6">
                        <div class="small text-muted mb-1" style="font-size: 0.85rem;">시작 일시</div>
                        <div id="detailStart" class="fw-semibold" style="color: #475569;"></div>
                    </div>
                    <div class="col-6 border-start"> <div class="small text-muted mb-1" style="font-size: 0.85rem;">종료 일시</div>
                        <div id="detailEnd" class="fw-semibold" style="color: #475569;"></div>
                    </div>
                </div>

                <div class="detail-item mb-4">
                    <div class="small text-muted mb-1" style="font-size: 0.85rem;">일정 구분</div>
                    <span id="detailType" class="badge rounded-pill d-inline-flex align-items-center justify-content-center px-3 py-2 fw-medium" style="font-size: 0.8rem; color: #475569;"></span>
                </div>
                
                <div class="detail-item mb-2">
                    <div class="small text-muted mb-2" style="font-size: 0.85rem;">상세 내용</div>
                    <div id="detailDescription" class="p-3 rounded-3" 
                         style="white-space: pre-wrap; color: #444; background-color: #f8fafc; border: 1px solid #f1f5f9; min-height: 80px;">
                    </div>
                </div>
            </div>
            
            <div class="modal-footer border-0 px-4 pb-4 pt-3">
                <button type="button" class="tudio-btn" id="deleteScheduleBtn" 
                        style="display: none; background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; padding: 8px 16px; border-radius: 8px;">
                    <i class="bi bi-trash3 me-1"></i> 일정 삭제
                </button>
                <button type="button" class="tudio-btn btn-secondary px-4" data-bs-dismiss="modal" 
                        style="background-color: #64748b; color: white; border: none; border-radius: 8px; padding: 8px 24px;">
                    확인
                </button>
            </div>
        </div>
    </div>
</div>

	<jsp:include page="../chat/main.jsp"/>
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>


<script>
$(function() {
	const loginMemberNo = "${loginUser.memberNo}";

    const formatDate = (date) => {
        if (!date) return null;
        const d = new Date(date);
        const pad = (n) => n < 10 ? '0' + n : n;
        
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' +
               pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
    };

    // ==========================================
    // [1] 프로젝트 목록 및 필터 로드
    // ==========================================
	function loadProjectFilters() {
	    $.ajax({
	        url: '${pageContext.request.contextPath}/tudio/getMyProjects',
	        type: 'GET',
	        success: function(list) {
	        	//console.log("프로젝트 목록",list)
	            let $container = $('#projectFilterList');
	            $container.empty();
	            if (list && list.length > 0) {
	                list.forEach(p => {
	                	var html = '';
	                    html += '<div class="form-check mb-1">';
	                    html += '  <input class="form-check-input filter-project" type="checkbox" value="' + p.projectNo + '" id="pFilter' + p.projectNo + '" checked>';
	                    html += '  <label class="form-check-label small text-truncate" for="pFilter' + p.projectNo + '" style="max-width: 120px; cursor: pointer;">';
	                    html +=      p.projectName;
	                    html += '  </label>';
	                    html += '</div>';
	                    $container.append(html);
	                });
	                $('#typeTask, #typeSub, #typeMeeting').prop('checked', true);
	                syncTypeFiltersByProjectSelection();
	                updateToggleButtonState();
	                
	                if(calendar) {
	                    calendar.refetchEvents();
	                }
	            }
	        }
	    });
	}
	
    loadProjectFilters();
	
    //프로젝트 미선택 시 업무,단위업무 지움
   	function syncTypeFiltersByProjectSelection() {
        const $checked = $('.filter-project:checked');
        const hasProject = $checked.length > 0;
        const $filters = $('#typeTask, #typeSub, #typeMeeting');
        
        if (!hasProject) {
            $filters.prop('checked', false).prop('disabled', true);
            $('.task-sub-item').fadeOut(200); 
            $('#typeSchedule').prop('checked', true);
        } else {
            $filters.prop('disabled', false);
            $('.task-sub-item').fadeIn(200);
        }
    }
    
    //전체버튼 선택의 상태 업데이트
   	function updateToggleButtonState() {
        const total = $('.filter-project').length;
        const checked = $('.filter-project:checked').length;
        const $btn = $('#btnToggleProject');

        // 전부 체크되어 있다면 -> '전체 해제' 모드로
        if (total > 0 && total === checked) {
            $btn.html('<i class="bi bi-check-all me-1"></i>전체 해제');
            $btn.removeClass('text-primary').addClass('text-secondary');
            $btn.data('all-checked', true); // 상태 저장
        } 
        // 하나라도 꺼져 있다면 -> '전체 선택' 모드로
        else {
            $btn.html('<i class="bi bi-check-lg me-1"></i>전체 선택');
            $btn.removeClass('text-secondary').addClass('text-primary');
            $btn.data('all-checked', false); // 상태 저장
        }
    }
    
   	$(document).on('change', '.filter-project', function() {
        syncTypeFiltersByProjectSelection(); // 필터 활성/비활성 처리
        updateToggleButtonState();           // 버튼 글씨 업데이트
        if (calendar) calendar.refetchEvents();
    });

    $(document).on('change', '.filter-check', function() {
        if (calendar) calendar.refetchEvents();
    });
    

    $('#btnToggleProject').on('click', function() {
        const $btn = $(this);
        const isAllChecked = $btn.data('all-checked');
        const $checkboxes = $('.filter-project');
        const $filters = $('#typeTask, #typeSub, #typeMeeting');

        if (isAllChecked) {
            $checkboxes.prop('checked', false);
            $filters.prop('checked', false).prop('disabled', true);
            $('.task-sub-item').fadeOut(200);
            $('#typeSchedule').prop('checked', true);
            
        } else {
            $checkboxes.prop('checked', true);
            $filters.prop('disabled', false).prop('checked', true);
            $('.task-sub-item').fadeIn(200);
            $('#typeSchedule').prop('checked', true);
        }

        updateToggleButtonState();
	    if (calendar) calendar.refetchEvents();
	    });
	    updateToggleButtonState();
	    syncTypeFiltersByProjectSelection();

	
	//모달창 프로젝트 목록 가져오기
	function loadMyProjects() {
        $.ajax({
            url: '${pageContext.request.contextPath}/tudio/getMyProjects',
            type: 'GET',
            success: function(list) {
            	let $select = $('#projectNo');
                $select.empty().append('<option value="">프로젝트를 선택하세요</option>');

                if (list && list.length > 0) {
                    list.forEach(projectVO => {
                    	const pNo = projectVO.projectNo;
                        const pName = projectVO.projectName;
                        let option = $('<option>').val(pNo).text(pName);
                        $select.append(option);
                    });
                } else {
                    $select.html('<option value="">참여 중인 프로젝트가 없습니다</option>');
                }
            },
            error: function() {
                console.error("프로젝트 목록을 불러오는 중 오류 발생");
            }
        });
    }
	
    // ==========================================
    // [2] 달력 설정
    // ==========================================
    const calendarEl = $('#calendar')[0];
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        displayEventTime: false,
        dayMaxEvents: 5,		// 최대 5개 뜨고 나머지는 +more
        moreLinkClick: 'popover',
        eventDisplay: 'block',	
        editable: true,		//드래그 수정 기능
        eventDurationEditable: true, // 기간 늘리기 가능
        droppable: true,
        
        buttonText: { today: 'TODAY', month: 'MONTH', list: 'LIST' },
        dayCellContent: function(info) { return info.date.getDate(); },
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,listMonth'
        },
        
        // 상세 모달
        eventClick: function(info) {
            openDetailModal(info.event);
        },
        
        eventDrop: function(info) {
            updateEventDate(info, '이동');
        },
        
        eventResize: function(info) {
            updateEventDate(info, '기간 변경');
        },

        // 내업무 뱃지
        eventContent: function(arg) {
        	let title = arg.event.title;
            let myTaskVal = arg.event.extendedProps.myTask;
            let badgeHtml = '';
            if (myTaskVal === 1) {
                badgeHtml = '<span class="my-task-badge">담당업무</span>';
            }

            let html = '<div class="fc-event-main-frame">' +
                        '<div class="fc-event-title-container">' +
                            '<div class="fc-event-title fc-sticky">' + 
                                 badgeHtml + title
                            '</div>' +
                        '</div>' +
                    '</div>';
            return { html: html };
        },

        events: function(info, successCallback, failureCallback) {
            $.ajax({
                url: '${pageContext.request.contextPath}/tudio/getScheduleList', 
                type: 'GET',
                success: function(list) {
                	//console.log("달력에 뿌릴 데이터:", list);
                	
                	// 1. 클라이언트 사이드 필터링
                	const checkedTypes = $('.filter-check:checked').map((i, el) => $(el).val()).get();
                    const checkedProjects = $('.filter-project:checked').map((i, el) => $(el).val()).get();
                    
                    const filteredList = list.filter(item => {
                    	const filterType = item.scheduleType || item.SCHEDULETYPE;
                        const filterProjectNo = String(item.projectNo || item.PROJECTNO || 0);
                        const memberNo = item.memberNo || item.MEMBERNO;
                        const isTypeChecked = checkedTypes.includes(filterType);
                        
                        if (filterType === 'PROJECT') {
                            return checkedProjects.includes(filterProjectNo);
                        }
                        if (filterType === 'SCHEDULE') {
                            return isTypeChecked;
                        } 
                        else if (filterType === 'TASK' || filterType === 'SUB' || filterType === 'MEETING') { 
                            return isTypeChecked && checkedProjects.includes(filterProjectNo);
                        }
                        return false;
                    });

                    const events = filteredList.map(item => {
                    	const type = item.scheduleType || item.SCHEDULETYPE;
                    	let bColor = item.scheduleColor || item.SCHEDULECOLOR; 
                        
                        if (type === 'TASK') bColor = '#ffccc7';
                        else if (type === 'SUB') bColor = '#ffe58f';
                        else if (type === 'PROJECT') bColor = '#91d5ff';
                        else if (type === 'MEETING') bColor = '#b7eb8f';
                        
                        // 프로젝트, 회의일정은 드래그 불가
                        let isEditable = true;
                        if(type === 'PROJECT' || type === 'MEETING') {
                            isEditable = false;
                        }
                        return {
                            id: item.scheduleId || item.SCHEDULEID,
                            title: item.scheduleTitle || item.SCHEDULETITLE,
                            start: item.scheduleStartdate || item.SCHEDULESTARTDATE,
                            end: item.scheduleEnddate || item.SCHEDULEENDDATE,
                            backgroundColor: item.scheduleColor || item.SCHEDULECOLOR,
                            borderColor: bColor,
                            textColor: '#000000',
                            allDay: (item.scheduleAllday|| item.SCHEDULEALLDAY) === 'Y',
                            editable: isEditable,
                            extendedProps: {
                                type: type, 
                                description: item.scheduleDescription,
                                status: item.scheduleStatus,
                                memberNo: memberNo,
                                myTask: item.myTask
                            }
                        };
                    });
                    successCallback(events);
                },
                error: function() {
                    console.error("일정 목록 로드 실패");
                }
            });
        }
    });
    calendar.render();
    
    // 날짜 업데이트 이벤트
    function updateEventDate(info, actionName) {
        const event = info.event;
        const props = event.extendedProps;
        
        // 포맷팅 (YYYY-MM-DD HH:mm:ss)
        let startDate = formatDate(event.start);
        let endDate = event.end ? formatDate(event.end) : startDate;
        
        const updateData = {
            id: event.id,
            type: props.type, // SCHEDULE, TASK, SUB 등
            start: startDate,
            end: endDate
        };
        $.ajax({
            url: '${pageContext.request.contextPath}/tudio/updateDate',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(updateData),
            success: function(res) {
                if (res === "success") {
                    const Toast = Swal.mixin({
                        toast: true, position: 'top-end', showConfirmButton: false, timer: 1500
                    });
                    Toast.fire({ icon: 'success', title: '일정이 변경되었습니다.' });
                } else if (res === "login_required") {
                    info.revert(); 
                    Swal.fire('로그인 필요', '로그인이 필요합니다.', 'warning');
                } else {
                    info.revert();
                    Swal.fire('권한 없음', '본인이 담당자인 업무만 수정할 수 있습니다.', 'error');
                }
            },
            error: function(xhr) {
                info.revert();
                console.error("업데이트 에러:", xhr);
                Swal.fire('서버 오류', '일정 수정 중 문제가 발생했습니다.', 'error');
            }
        });
    }

    $('#scheduleStartdate, #scheduleEnddate').on('change', function() {
        let val = $(this).val();
        if (val && val.includes('T')) {
            let datePart = val.split('T')[0];
            let timePart = val.split('T')[1];
            let hour = timePart.split(':')[0];
            $(this).val(datePart + 'T' + hour + ':00');
        }
    });
    
    $(document).on('change', '.filter-check, .filter-project', function() {
        if(calendar) {
            calendar.refetchEvents();
        }
    });

    $('#addScheduleBtn').on('click', function() {
        $('#scheduleForm')[0].reset();
        loadMyProjects();
        $('#addScheduleModal').modal('show');
    });
    
    $('#scheduleAllday').on('change', function() {
        const isChecked = $(this).prop('checked');
        const $startInput = $('#scheduleStartdate');
        const $endInput = $('#scheduleEnddate');
        
        if (isChecked) {
            const offset = new Date().getTimezoneOffset() * 60000;
            const today = new Date(Date.now() - offset).toISOString().split('T')[0];
            
            if(today) {
                $startInput.val(today + "T00:00");
                $endInput.val(today + "T23:59");
                $startInput.attr('readonly', true).addClass('bg-light');
                $endInput.attr('readonly', true).addClass('bg-light');
            }
        } else {
            $startInput.attr('readonly', false).removeClass('bg-light');
            $endInput.attr('readonly', false).removeClass('bg-light');
        }
    });

    $('#saveSchedule').on('click', function() {
    	const form = $('#scheduleForm')[0];
        const formData = new FormData(form);
        const scheduleTitle = $('#scheduleTitle').val();
        
        if (!$('#scheduleId').val()) {
            formData.delete('scheduleId'); 
        }
        
        if (!scheduleTitle) {
            Swal.fire('경고', '일정 제목을 입력해주세요.', 'warning');
            return;
        }
        
        const isAllDayChecked = $('#scheduleAllday').prop('checked');
        formData.set('scheduleAllday', isAllDayChecked ? 'Y' : 'N');
        
        let startVal = $('#scheduleStartdate').val();
        let endVal = $('#scheduleEnddate').val();
        if (isAllDayChecked) {
            if (startVal) startVal = startVal.split('T')[0];
            if (endVal) endVal = endVal.split('T')[0];
            formData.set('scheduleStartdate', startVal);
            formData.set('scheduleEnddate', endVal);
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/tudio/schedule',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res) {
                if (res > 0) {
                    Swal.fire({
                        title: '저장 완료',
                        text: '일정이 성공적으로 등록되었습니다.',
                        icon: 'success'
                    }).then(() => {
                        $('#addScheduleModal').modal('hide');
                        calendar.refetchEvents();
                    });
                } else {
                    Swal.fire('실패', '저장에 실패했습니다.', 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error("에러 발생:", error);
                Swal.fire('에러', '서버 통신 중 문제가 발생했습니다.', 'error');
            }
        });
    });
    
    //삭제버튼 클릭 이벤트
    $('#deleteScheduleBtn').on('click', function() {
        const scheduleId = $(this).data('id'); 

        Swal.fire({
            title: '일정을 삭제하시겠습니까?',
            text: "삭제 후에는 복구할 수 없습니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/tudio/deleteSchedule',
                    type: 'POST',
                    data: { scheduleId: scheduleId },
                    success: function(res) {
                        if (res > 0) {
                            Swal.fire('삭제 완료', '일정이 삭제되었습니다.', 'success');
                            $('#detailScheduleModal').modal('hide');
                            calendar.refetchEvents(); 
                        } else {
                            Swal.fire('실패', '삭제 처리에 실패했습니다.', 'error');
                        }
                    },
                    error: function() {
                        Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
                    }
                });
            }
        });
    });
    
	
    //일정 상세 모달
    function openDetailModal(event) {
        const props = event.extendedProps;
        const scheduleType = props.type || props.TYPE;
        const id = event.id;

        let moveUrl = "#";
        if (scheduleType === 'PROJECT') {
            moveUrl = "${pageContext.request.contextPath}/project/main?projectNo=" + id;
        } else if (scheduleType === 'TASK') {
            moveUrl = "${pageContext.request.contextPath}/project/task/detail?taskId=" + id;
        } else if (scheduleType === 'SUB') {
            moveUrl = "${pageContext.request.contextPath}/project/task/subDetail?subId=" + id;
        } else if (scheduleType === 'MEETING') {
            moveUrl = "#"; 
        }

        $('#detailTitle').text(event.title);
        $('#detailTitleLink').attr('href', moveUrl);

        if (scheduleType === 'SCHEDULE') {
            $('#deleteScheduleBtn').show().data('id', id); 
            $('#detailTitleLink').css({'cursor': 'default', 'pointer-events': 'none', 'color': 'black'}); 
        } else {
            $('#deleteScheduleBtn').hide();
            $('#detailTitleLink').css({'cursor': 'pointer', 'pointer-events': 'auto', 'color': '#00407F'});
        }

        const formatToHour = (dateStr) => {
            if (!dateStr) return '-';
            let dateTime = dateStr.replace('T', ' '); 
            return dateTime.includes(':') ? dateTime.split(':')[0] + '시' : dateTime;
        };
        
        const isAllDay = event.allDay;
        const startStr = isAllDay ? event.startStr : formatToHour(event.startStr);
        const endStr = event.endStr ? (isAllDay ? event.endStr : formatToHour(event.endStr)) : '-';
        
        $('#detailStart').text(startStr);
        $('#detailEnd').text(endStr);
        $('#detailDescription').text(props.description || props.DESCRIPTION || '상세 내용이 없습니다.');
        
        $('#detailType').text(
            scheduleType === 'SCHEDULE' ? '개인 일정' : 
            scheduleType === 'PROJECT' ? '프로젝트 전체' : 
            scheduleType === 'TASK' ? '업무' :
            scheduleType === 'SUB' ? '단위 업무' : '회의'
        ).css('background-color', event.backgroundColor);
        
        $('#modalHeaderColor').css('background-color', event.backgroundColor);

        $('#detailScheduleModal').modal('show');
    }
});
</script>

</html>