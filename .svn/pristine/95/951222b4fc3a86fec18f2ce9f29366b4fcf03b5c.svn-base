<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

/* 1. 기본 버튼 스타일 (더 작고 연하게) */
.fc .fc-button {
    background-color: #f8fbff !important;
    border: 1px solid #e2e8f0 !important;
    color: #64748b !important;
    font-weight: 500 !important;
    border-radius: 8px !important;
    padding: 5px 12px !important;
    font-size: 0.78rem !important;
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
.tudio-section .fc .fc-button-group > .fc-button {
    margin-right: 6px !important;
    border-radius: 8px !important;
    border-left: 1px solid #e2e8f0 !important;
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

    <div class="tudio-section-header mb-4 d-flex align-items-center justify-content-between">
        <h5 class="h5 fw-bold m-0 text-primary-dark">
            <i class="bi bi-calendar3 me-2"></i> 프로젝트 일정
        </h5>
        <div class="d-flex gap-2">
        	<button class="tudio-btn tudio-btn-primary" type="button" id="addScheduleBtn" >
	            <i class="bi bi-plus-lg me-1"></i> 새 일정 등록
	        </button>
        </div>
    </div>
    
    
    <div class="row g-4">
	    <div class="col-lg-2 col-md-3">
			<div class="tudio-card p-3 mb-4 shadow-sm ">
				<h6 class="fw-bold mb-3 text-primary-dark border-bottom pb-2">
					<i class="bi bi-palette-fill me-2"></i> 일정 구분
				</h6>
				<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
					<div class="form-check m-0" style="min-width: 80px;">
						<label class="form-check-label small" for="typeTask"> 프로젝트</label>
					</div>
					<span class="badge rounded-pill p-2 d-inline-block"
						style="background-color: #e6f7ff; border: 1px solid #91d5ff; width: 50px; height: 10px;"></span>
				</div>
				<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
					<div class="form-check m-0" style="min-width: 80px;">
						<label class="form-check-label small" for="typeTask">업무</label>
					</div>
					<span class="badge rounded-pill p-2 d-inline-block"
						style="background-color: #ffeded; border: 1px solid #ffccc7; width: 50px; height: 10px;"></span>
				</div>
				<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
					<div class="form-check m-0" style="min-width: 80px;">
						<label class="form-check-label small" for="typeTask">단위업무</label>
					</div>
					<span class="badge rounded-pill p-2 d-inline-block"
						style="background-color: #fffbe6; border: 1px solid #ffe58f; width: 50px; height: 10px;"></span>
				</div>
				<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
					<div class="form-check m-0" style="min-width: 80px;">
						<label class="form-check-label small" for="typeTask">회의일정</label>
					</div>
					<span class="badge rounded-pill p-2 d-inline-block"
						style="background-color: #f6ffed; border: 1px solid #b7eb8f; width: 50px; height: 10px;"></span>
				</div>
			</div>
			
			<div class="tudio-card p-3 shadow-sm">
				<h6 class="fw-bold mb-3 text-primary-dark border-bottom pb-2">
					<i class="bi bi-layers-fill me-2"></i> 일정 종류
				</h6>
				<div class="type-filter-list">
					<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
						<div class="form-check m-0">
							<input class="form-check-input filter-check" type="checkbox"
								value="MYTASK" id="typeMyTask" checked> <label
								class="form-check-label small" for="typeMyTask">내 업무</label>
						</div>
					</div>
					<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
						<div class="form-check m-0">
							<input class="form-check-input filter-check" type="checkbox"
								value="MEETING" id="typeMeeting" checked> <label
								class="form-check-label small" for="typeMeeting">회의 일정</label>
						</div>
					</div>
					<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
						<div class="form-check m-0">
							<input class="form-check-input filter-check" type="checkbox"
								value="TASK" id="typeTask" checked> <label
								class="form-check-label small" for="typeTask">업무</label>
						</div>
					</div>
					<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
						<div class="form-check m-0">
							<input class="form-check-input filter-check" type="checkbox"
								value="SUB" id="typeSub" checked> <label
								class="form-check-label small" for="typeSub">단위 업무</label>
						</div>
					</div>
					<div class="d-flex align-items-center gap-4 mb-2 task-sub-item">
						<div class="form-check m-0">
							<input class="form-check-input filter-check" type="checkbox"
								value="SCHEDULE" id="typeSchedule" checked> <label
								class="form-check-label small" for="typeSchedule">개인 일정</label>
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
    
    
    
    


<!-- 일정 등록 모달 -->
	<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-labelledby="addScheduleModalLabel" aria-hidden="true">
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
    					<input type="hidden" id="projectNo" name="projectNo">
						<div class="mb-3">
							<label class="form-label fw-bold">일정 제목</label>
							<input type="text" class="form-control" id="scheduleTitle" name="scheduleTitle" placeholder="제목을 입력하세요" required>
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
	
<!-- 상세 일정 모달 -->
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
                
				<div class="detail-item mb-4">
				    <div class="small text-muted mb-1" style="font-size: 0.85rem;">담당자</div>
				    <div class="d-flex align-items-center">
				        <span id="detailMember" class="fw-bold text-dark fs-6"></span>
				    </div>
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


<script>
$(function() {
    const currentProjectNo = "${projectNo}";
    
    let isSubmitting = false;
    $('.filter-check').prop('checked', false);
    $('#typeMyTask, #typeMeeting').prop('checked', true);
    
    const formatDate = (date) => {
        if (!date) return null;
        const d = new Date(date);
        const pad = (n) => n < 10 ? '0' + n : n;
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' +
               pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
    };

    const calendarEl = $('#calendar')[0];
    const calendar = new FullCalendar.Calendar(calendarEl, {
    	eventDidMount: function(info) {
            filterEvent(info);
        },
        buttonIcons: { prev: 'chevron-left', next: 'chevron-right' },
        initialView: 'dayGridMonth',
        locale: 'ko',
        height: 'auto',
        editable: true,             
        eventDurationEditable: true,
        eventResizableFromStart: true,
        droppable: true,
        displayEventTime: false,    
        eventDisplay: 'block',      
        eventTextColor: '#000000',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,listMonth'
        },
        dayCellContent: function(info) { return info.date.getDate(); },
        buttonText: { today: 'TODAY', month: 'MONTH', list: 'LIST' },
        
        eventDrop: function(info) { updateEventDate(info, '이동'); },
        eventContent: function(arg) {
            let title = arg.event.title;
            let myTaskVal = arg.event.extendedProps.myTask;
            let badgeHtml = myTaskVal === 1 ? '<span class="my-task-badge">담당업무</span>' : '';
            return { html: '<div class="fc-event-main-frame"><div class="fc-event-title fc-sticky">' + badgeHtml + title + '</div></div>' };
        },
        eventClick: function(info) { openDetailModal(info.event); },
        events: function(info, successCallback, failureCallback) {
            if (!currentProjectNo || currentProjectNo === "0") return;
            $.ajax({
                url: `${pageContext.request.contextPath}/tudio/project/schedule/getProjectScheduleList/` + currentProjectNo,
                type: 'GET',
                dataType: 'json',
                success: function(list) {
                    const events = (list || []).map(item => {
                        const type = item.scheduleType || item.SCHEDULETYPE;
                        let bColor = item.scheduleColor || item.SCHEDULECOLOR; 
                        if (type === 'TASK') bColor = '#ffccc7';
                        else if (type === 'SUB') bColor = '#ffe58f';
                        else if (type === 'PROJECT') bColor = '#91d5ff';
                        else if (type === 'MEETING') bColor = '#b7eb8f'; 
                        
                        let start = item.scheduleStartdate || item.SCHEDULESTARTDATE;
                        let end = item.scheduleEnddate || item.SCHEDULEENDDATE;
                        if(start) start = start.replace(/\//g, '-');
                        if(end) end = end.replace(/\//g, '-');

                        return {
                            id: item.scheduleId || item.SCHEDULEID,
                            title: item.scheduleTitle || item.SCHEDULETITLE,
                            start: start,
                            end: end,
                            backgroundColor: item.scheduleColor || item.SCHEDULECOLOR,
                            borderColor: bColor,
                            allDay: (item.scheduleAllday || item.SCHEDULEALLDAY) === 'Y',
                            editable: !(type === 'PROJECT' || type === 'MEETING'), 
                            extendedProps: {
                                type: type, 
                                description: item.scheduleDescription || item.SCHEDULEDESCRIPTION,
                                memberName: item.memberName || item.MEMBERNAME,
                                myTask: item.myTask
                            }
                        };
                    });
                    successCallback(events);
                }
            });
        }
    });
    calendar.render();

    // 체크 필터링 용
    function filterEvent(info) {
        const checkedTypes = $('.filter-check:checked').map(function() {
            return $(this).val();
        }).get();

        const eventType = info.event.extendedProps.type;
        const isMyTask = info.event.extendedProps.myTask === 1;

        let show = false;

        if (checkedTypes.includes('MYTASK') && isMyTask) {
            show = true;
        } 
        else if (checkedTypes.includes(eventType)) {
            show = true;
        }
        if (show) {
            info.el.style.display = ''; 
        } else {
            info.el.style.display = 'none';
        }
    }
    $('.filter-check').on('change', function() {
        calendar.render(); 
    });
    
    
    
    
    function updateEventDate(info) {
        const event = info.event;
        const updateData = {
            id: event.id,
            type: event.extendedProps.type,
            start: formatDate(event.start),
            end: event.end ? formatDate(event.end) : formatDate(event.start)
        };
        $.ajax({
            url: `${pageContext.request.contextPath}/tudio/project/schedule/updateDate`,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(updateData),
            success: function(res) {
                if (res === "success") {
                    Swal.fire({ toast: true, position: 'top-end', showConfirmButton: false, timer: 1500, icon: 'success', title: '변경되었습니다.' });
                } else { info.revert(); }
            }
        });
    }

    // 모달 인스턴스 관리 함수
    function getModal(id) {
        const el = document.getElementById(id);
        return bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el);
    }

    const formatKoreanDate = (dateStr) => {
    	if (!dateStr) return '-';
        const d = new Date(dateStr);
        if (isNaN(d.getTime())) return dateStr;

        const yy = String(d.getFullYear()).slice(-2);
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        const dd = String(d.getDate()).padStart(2, '0');
        const hh = d.getHours();
        const mi = d.getMinutes();

        let result = `\${yy}-\${mm}-\${dd}`;

        if (hh !== 0 || mi !== 0) {
            result += ` \${String(hh).padStart(2, '0')}시`;
            if (mi !== 0) {
                result += ` \${String(mi).padStart(2, '0')}분`;
            }
        }

        return result;
    };
    
    
    function openDetailModal(event) {
        const props = event.extendedProps;
        $('#detailTitle').text(event.title);
        $('#detailDescription').text(props.description || '내용 없음');
        $('#detailMember').text(props.memberName || '담당자 없음');
        $('#detailStart').text(event.allDay ? event.startStr : formatDate(event.start));
        $('#detailEnd').text(event.endStr || '-');
        
        const startText = event.allDay ? 
                new Date(event.start).toLocaleDateString('ko-KR', {month:'long', day:'numeric'}) + " (종일)" : 
                formatKoreanDate(event.start);
                
        const endText = event.end ? 
                (event.allDay ? new Date(event.end).toLocaleDateString('ko-KR', {month:'long', day:'numeric'}) + " (종일)" : formatKoreanDate(event.end)) : 
                '-';
                
        $('#detailStart').text(startText);
        $('#detailEnd').text(endText);
        
        const typeLabels = { 'TASK': '상위 업무', 'SUB': '하위 업무', 'PROJECT': '프로젝트', 'MEETING': '회의' };
        $('#detailType').text(typeLabels[props.type] || '개인 일정').css('background-color', event.backgroundColor);
        
        if (props.type === 'SCHEDULE') $('#deleteScheduleBtn').show().data('id', event.id);
        else $('#deleteScheduleBtn').hide();

        $('#modalHeaderColor').css('background-color', event.backgroundColor);
        getModal('detailScheduleModal').show();
    }

    $('#addScheduleBtn').on('click', function() {
        $('#scheduleForm')[0].reset();
        $('#projectNo').val(currentProjectNo);
        getModal('addScheduleModal').show();
    });

    $(document).off('click', '#saveSchedule').on('click', '#saveSchedule', function() {
        if (isSubmitting) return; // [2번 해결] 중복 방지

        const scheduleData = {
            projectNo: $('#projectNo').val(),
            scheduleTitle: $('#scheduleTitle').val().trim(),
            scheduleDescription: $('#scheduleDescription').val(),
            scheduleStartdate: $('#scheduleStartdate').val(),
            scheduleEnddate: $('#scheduleEnddate').val(),
            scheduleAllday: $('#scheduleAllday').is(':checked') ? 'Y' : 'N',
            scheduleColor: $('#scheduleColor').val(),
            memberNo: "${loginUser.memberNo}"
        };

        if(!scheduleData.scheduleTitle) {
            Swal.fire('경고', '제목을 입력하세요.', 'warning');
            return;
        }

        isSubmitting = true; 
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: `${pageContext.request.contextPath}/tudio/project/schedule/insert`,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(scheduleData),
            success: function(res) {
                if(res === "success") {
                    Swal.fire('완료', '일정이 등록되었습니다.', 'success').then(() => {
                        getModal('addScheduleModal').hide();
                        // [3번 해결] 백드롭 강제 제거
                        $('.modal-backdrop').remove();
                        $('body').removeClass('modal-open').css('overflow', '');
                        calendar.refetchEvents();
                    });
                }
            },
            complete: function() {
                isSubmitting = false; 
                $btn.prop('disabled', false);
            }
        });
    });

    $('#deleteScheduleBtn').off('click').on('click', function() {
        const id = $(this).data('id');

        Swal.fire({
            title: '일정을 삭제하시겠습니까?',
            text: "삭제된 일정은 복구할 수 없습니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e11d48', // 삭제 버튼 색상 (Red)
            cancelButtonColor: '#64748b',  // 취소 버튼 색상 (Slate)
            confirmButtonText: '삭제',
            cancelButtonText: '취소',
            reverseButtons: true // 확인/취소 버튼 위치 반전 (선택사항)
        }).then((result) => {
            if (result.isConfirmed) {
                $.post(`${pageContext.request.contextPath}/tudio/project/schedule/delete`, { scheduleId: id }, function(res) {
                    if (res === "success" || res > 0) {
                        Swal.fire('삭제 완료', '일정이 성공적으로 삭제되었습니다.', 'success');
                        getModal('detailScheduleModal').hide();
                        $('.modal-backdrop').remove();
                        calendar.refetchEvents();
                    } else {
                        Swal.fire('실패', '삭제 중 오류가 발생했습니다.', 'error');
                    }
                });
            }
        });
    });
    
    
});
</script>