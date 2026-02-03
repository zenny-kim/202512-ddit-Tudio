/**
 *  dashboard.js
 * - GridStack.js
 */

const CONTEXT_PATH = document.body.dataset.contextPath;

// SweetAlert2 Toast 설정
const Toast = Swal.mixin({
    toast: true,
    position: 'top-end',		// 우측상단
    showConfirmButton: false,
    timer: 1000,
    timerProgressBar: true,
    didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
    }
});

// GridStack 초기화
let grid = GridStack.init({
	cellHeight: 100, 			// 높이 단위
	margin: 10,     			// 간격
	column: 12 ,   			 	// 12분할 (고정)
	disableOneColumnMode: true,
	float: false,	 			// 화면 자동채우기 설정 활성화
	acceptWidgets: true, 		// 외부 드래그 허용
	dragIn: '.sidebar-item', 	// 이 클래스를 가진 요소를 드래그해서 그리드에 추가
	dragInOptions: { revert: 'invalid', scroll: false, appendTo: 'body', helper: 'clone' },
	removable: '#widgetDrawer'	// 밖으로 드래그해서 삭제 가능 기능
});

// 초기 로드 시 : 수정 불가 상태
grid.setStatic(true);

// 드래그 & 드롭 기능
function setupDragElement(el) {
	el.classList.remove('ui-draggable', 'ui-draggable-handle');
	el.classList.add('grid-stack-item');
	// 드래그 시 그리드가 빈 공간을 찾음
	el.setAttribute('gs-auto-position', 'true');
	// el.setAttribute('draggable', 'true');
	
    GridStack.setupDragIn(el, { 
        revert: 'invalid', 	// 드롭 실패 시 원래 위치로 돌아감
        scroll: false, 
        appendTo: 'body', 
        helper: 'clone' 	// 복제본이 따라다니도록 설정
    });
}

// 페이지 로드 시: 위젯 보관함에 저장된 위젯에 드래그 기능 부여
document.addEventListener('DOMContentLoaded', function() {
    const sidebarItems = document.querySelectorAll('.sidebar-item');
    sidebarItems.forEach(item => {
        setupDragElement(item);
    });
	
	const loginMemberNo = document.body.dataset.loginNo; 
	if (loginMemberNo) {
		connectWebSocket(loginMemberNo);
	}
})


// ---------------------------------------------------------
// ** 편집 모드 및 사이드바 관련 로직 **
// ---------------------------------------------------------
function toggleEditMode(isChecked) {
	const main = document.getElementById('mainContent');
	const container = document.getElementById('dashboard-container');
	const drawer = document.getElementById('widgetDrawer');
	const saveBtn = document.getElementById('btn-save-layout');
	const switchEdit = document.getElementById('editModeSwitch');
	
	if (isChecked) {
		// [ON] 편집 모드
		main.style.marginRight = '320px';		// 메인화면 왼쪽으로 밀기
		container.classList.add('dashboard-edit-mode');
		drawer.classList.add('open');			// 위젯 보관함 open
		saveBtn.classList.remove('d-none');		// 저장 버튼 표시 
		grid.setStatic(false); 					// 그리드 수정 기능 활성화
	} else {
		// [OFF] 뷰 모드
		main.style.marginRight = '0';			// 메인화면 넓이 복구
		container.classList.remove('dashboard-edit-mode');
		drawer.classList.remove('open');		// 위젯 보관함 close
		saveBtn.classList.add('d-none');		// 저장 버튼 숨기기
		grid.setStatic(true); 					// 그리드 수정 기능 비활성화(고정)

		// 스위치 UI 동기화
		if (switchEdit) switchEdit.checked = false;
	}
}

// 저장 및 종료 (saveBtn)
function saveLayoutAndExit() {
    saveLayout(); // 레이아웃 저장 함수 호출
    
    // 위젯 레이아웃 편집모드 종료
    const switchEdit = document.getElementById('editModeSwitch');
    if(switchEdit) {
        switchEdit.checked = false;
        toggleEditMode(false);
    }
}

// 위젯 보관함 X 버튼으로 닫기
function closeDrawerManually() {
    const switchEdit = document.getElementById('editModeSwitch');
    if(switchEdit) {
        switchEdit.checked = false;
        toggleEditMode(false);
    }
}

/**
 * 위젯 사용 여부(Y/N) DB 업데이트
 * @param {string} widgetNo - 위젯 번호
 * @param {string} status - Y (사용) / N (미사용)
 */
async function updateWidgetStatus(widgetNo, status) {
    try {
        const response = await fetch(`${CONTEXT_PATH}/tudio/widget/updateStatus`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=utf-8;' },
            body: JSON.stringify({ 
                widgetNo: widgetNo, 
                widgetStatus: status
            })
        });
        
        if (!response.ok) throw new Error('Status update failed');
        // console.log(`위젯 ${widgetNo} 상태 변경 완료: ${status}`);
    } catch (error) {
        console.error('위젯 상태 변경 실패:', error);
        Toast.fire({ icon: 'error', title: '위젯 상태 저장 실패' });
    }
}

// 위젯 삭제 -> 보관함으로 이동
function removeWidget(iconEl) {
	// 클릭된 아이콘의 가장 가까운 위젯 요소
	let widgetEl = iconEl.closest('.grid-stack-item');
	
	// 위젯 정보 추출
	let widgetNo = widgetEl.getAttribute('gs-id');
	let w = widgetEl.getAttribute('gs-w'); // 위젯 현재 넓이
	let h = widgetEl.getAttribute('gs-h'); // 위젯 현재 높이
		
	let widgetTitle = "위젯";
	let titleEl = widgetEl.querySelector('h6');
	if(titleEl) widgetTitle = titleEl.innerText.trim();
	
	console.log(widgetTitle);

	// 그리드에서 제거
	grid.removeWidget(widgetEl);

	// 위젯 보관에 아이템 생성
	createSidebarItem(widgetNo, widgetTitle, w, h);
	
	// db 업데이트 -> 변경 : 레이아웃 저장 버튼 클릭시 일괄로 처리
	// updateWidgetStatus(widgetNo, 'N');
}

// 위젯 복구 : 보관함 -> 그리드로 드래그
grid.on('added', function(event, items) {
    items.forEach((item) => {
		// 스타일 초기화 
		item.el.classList.remove('sidebar-item', 'ui-draggable', 'ui-draggable-handle');
		item.el.removeAttribute('style');
		item.el.removeAttribute('gs-auto-position');

		let widgetNo = item.id || item.el.getAttribute('gs-id');

		let titleSpan = item.el.querySelector('span');
		let widgetTitle = titleSpan ? titleSpan.innerText.trim() : "";

        // 보관함에서 해당 아이템 DOM 제거
        const sidebarItem = document.querySelector(`.sidebar-item[gs-id="${widgetNo}"]`);
		if (sidebarItem) sidebarItem.remove();

        // 위젯 사용여부 상태 업데이트
        // updateWidgetStatus(widgetNo, 'Y');

		// 위젯 종류 판별 (기준: 위젯제목)
		let loaderFunction = null;
		
		if (widgetTitle.includes("마감 임박 업무")) loaderFunction = () => loadProjectSummary(widgetNo);
		else if (widgetTitle.includes("개인 업무")) loaderFunction = () => loadPersonalWork(widgetNo);
		else if (widgetTitle.includes("시스템 공지사항")) loaderFunction = () => loadNoticeList(widgetNo);
		else if (widgetTitle.includes("미확인 알림")) loaderFunction = () => loadAlarmList(widgetNo);
		else if (widgetTitle.includes("북마크 프로젝트")) loaderFunction = () => loadBookmarkList(widgetNo);
		else if (widgetTitle.includes("To Do List")) loaderFunction = () => loadTodoList(widgetNo);

		let targetId = getTargetIdByTitle(widgetTitle, widgetNo);	
        // 위젯 내부 HTML
        let html = `
			<div class="grid-stack-item-content">
				<i class="bi bi-x-lg btn-close-widget" onclick="removeWidget(this)"></i>
				<div class="h-100 d-flex flex-column">
					<div id="${targetId}" class="flex-grow-1 overflow-auto widget-content"></div>
				</div>
			</div>
        `;
        
        item.el.innerHTML = html;

		if (loaderFunction) {
			setTimeout(loaderFunction, 10);
		} // 0.01s delay
    });
});

function getTargetIdByTitle(title, no) {
    if (title.includes("마감 임박 업무")) return `project-summary-area-${no}`;
    if (title.includes("개인 업무")) return `pw-task-list-${no}`;
    if (title.includes("시스템 공지사항")) return `notice-list-area-${no}`;
    if (title.includes("미확인 알림")) return `alarm-list-area-${no}`;
    if (title.includes("북마크 프로젝트")) return `bookmark-list-area-${no}`;
    if (title.includes("To Do List")) return `todo-list-area-${no}`;
    return `widget-area-${no}`;
}

// 보관함에 위젯 아이탬 생성 (그리드 -> 그리드)
function createSidebarItem(id, title, width, height) {
    const sidebarContent = document.getElementById('sidebar-content');
    
    let itemDiv = document.createElement('div');
    itemDiv.className = 'sidebar-item';
	let w = width ? parseInt(width) : 4;
	let h = height ? parseInt(height) : 4;
		
    itemDiv.setAttribute('gs-id', id);
    itemDiv.setAttribute('gs-w', w);
    itemDiv.setAttribute('gs-h', h);
	itemDiv.setAttribute('gs-auto-position', 'true');
	
    itemDiv.innerHTML = `
		<div class="grid-stack-item-content">
			<span>${title}</span>
			<i class="bi bi-grip-vertical text-muted"></i>
		</div>
    `;
    
    sidebarContent.appendChild(itemDiv);

	// 동적으로 생성된 요소에 드래그 기능 부여
	setTimeout(function() {
		setupDragElement(itemDiv);
	}, 100);
}

// 위젯 설정 저장 함수 
function saveLayout() {
	let widgetData = [];

	// 그리드 위젯
	grid.engine.nodes.forEach(function(node) {
		widgetData.push({
			widgetNo: node.el.getAttribute('gs-id'),
			x: node.x,         // 현재 x 좌표
			y: node.y,         // 현재 y 좌표
			width: node.w,     // 현재 너비
			height: node.h,    // 현재 높이
			widgetStatus: 'Y'  // 사용 여부
		});
	});
	
	// 보관함 위젯
	const drawerItems = document.querySelectorAll('#sidebar-content .sidebar-item');
	drawerItems.forEach(function(el) {
		widgetData.push({
			widgetNo: el.getAttribute('gs-id'),
			x: 0,
			y: 0,
			width: el.getAttribute('gs-w') || 4,
			height: el.getAttribute('gs-h') || 4,
			widgetStatus: 'N' 		// 보관함에 있으므로 미사용
		});
	});

	$.ajax({
		url: `${CONTEXT_PATH}/tudio/widget/saveLayout`,
		type: 'POST',
		contentType: 'application/json; charset=utf-8;',
		data: JSON.stringify(widgetData),
		success: function(res) {
			if(res === "OK") {
				console.log("위젯 레이아웃 저장 성공");
				Toast.fire({ icon: 'success', title: '저장되었습니다.'});
			}
		},
		error: function(error) {
			console.error("저장 실패:", error);
			Toast.fire({ icon: 'error', title: '위젯 저장 중 오류가 발생했습니다. 다시 시도해주세요.'});
		}
	});
}


/**
 * -----------------------------------------------------------------
 * widget 데이터 로딩
 *  - 프로젝트 요약, 개인업무, 시스템 공지사항, 북마크 프로젝트, 미확인 알림, 투두 리스트
 * -----------------------------------------------------------------
 */
/* [위젯 1] 프로젝트 요약 */
function loadProjectSummary(widgetNo) {
	let $area = $(`#project-summary-area-${widgetNo}`);
	if ($area.length === 0) return;
	
	let $parent = $area.parent();
	
	if ($parent.find('.d-flex.justify-content-between').length === 0) { 
		$parent.find('h6').remove();
	
		let headerHtml = `
			<h6 class="font-weight-bold text-gray-800">
					<i class="bi bi-stopwatch text-danger"></i> 마감 임박 업무
			</h6>
		`;
		$parent.prepend(headerHtml);
	}
	
    $.ajax({
        url: `${CONTEXT_PATH}/tudio/widget/projectSummary`,
        type: "GET",
        dataType: "json",
        success: function(taskList) {
			// console.log(taskList);
            let $area = $("#project-summary-area-" + widgetNo);
			
			let html = '<ul class="list-group list-group-flush small">';
            if (taskList.length === 0) {
                html += '<li class="list-group-item text-center text-muted mt-3">예정된 업무가 없습니다.</li>';
            } else {
                $.each(taskList, function(i, task) {
                    // D-Day 뱃지 색상 설정
                    let badgeClass = "bg-success";
                    let badgeText = "D-" + task.taskDday;
                    
                    if (task.taskDday < 0) {
                        badgeClass = "bg-danger";
                        badgeText = "지연";
                    } else if (task.taskDday === 0) {
                        badgeClass = "bg-danger";
                        badgeText = "D-Day";
                    } else if (task.taskDday <= 3) {
                        badgeClass = "bg-warning text-dark";
                    }
					
					let gradientId = `grad-${widgetNo}-${i}`;

                    html += `
                       <li class="list-group-item px-0 py-3 border-bottom-0 d-flex align-items-center">
					   		<div class="circular-chart-container">
								<svg viewBox="0 0 36 36" class="circular-chart">
									<defs>
										<linearGradient id="${gradientId}" x1="0%" y1="0%" x2="100%" y2="0%">
											<stop offset="0%" stop-color="#4361ee" /><stop offset="100%" stop-color="#5499ff" />
										</linearGradient>
									</defs>
									<path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
					                <path class="circle" stroke="url(#${gradientId})" stroke-dasharray="${task.taskRate}, 100"
										d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
								</svg>
								<span class="percentage-label">${task.taskRate}%</span>
							</div>
					   		
							<div class="flex-grow-1 d-flex flex-column justify-content-center" style="gap: 4px;">
								<small class="text-muted text-truncate" style="width: fit-content; padding: 4px 10px;">
									<a href="${CONTEXT_PATH}/tudio/project/detail?projectNo=${task.projectNo}" 
										class="text-decoration-none text-muted">
										<i class="bi bi-folder2-open me-1"></i>${task.projectName}
									</a>
								</small>
								<div class="d-flex justify-content-between align-items-start">
									<span class="text-truncate fw-bold text-dark" style="max-width: 180px; font-size: 0.95rem;" title="${task.taskTitle}">
										${task.taskTitle}
									</span>
									<span class="badge ${badgeClass} ms-2 flex-shrink-0">${badgeText}</span>
								</div>
							</div>
						</li>
                    `;
                });
            }
            html += '</ul>';           
            $area.html(html);
        },
        error: function() {
            $("#project-summary-area-" + widgetNo).html('<p class="text-center text-danger mt-3">불러오기 실패</p>');
        }
    });
}

/* [위젯 2] 개인 업무 (주간 스케줄) */
function loadPersonalWork(widgetNo) {
	let $target = $(`#pw-task-list-${widgetNo}`);
	if ($target.length === 0) return;
	
	let $rootContent = $target.closest('.grid-stack-item-content');
	
	if ($rootContent.find(`#pw-calendar-wrapper-${widgetNo}`).length === 0) {
		let fullHtml = `
			<i class="bi bi-x-lg btn-close-widget" onclick="removeWidget(this)"></i>
		    <div class="h-100 d-flex flex-column">
				<h6 class="font-weight-bold text-gray-800">
					<i class="bi bi-calendar-week text-primary"></i> 개인 업무
				</h6>
				<div class="flex-grow-1 d-flex flex-column justify-content-between widget-content">
		        	<div class="mb-2">
						<div id="pw-date-title-${widgetNo}" class="fw-bold small mb-2 text-primary">
							<span class="spinner-border spinner-border-sm" role="status"></span> Loading...
					    </div>
					    <ul id="pw-task-list-${widgetNo}" class="list-group list-group-flush small overflow-auto" style="max-height: 130px;"></ul>
		            <div class="mt-auto">
			            <div class="d-flex align-items-end mb-3">
							<small class="text-muted schedule-title">주간 스케줄</small>
						</div>
						<div id="pw-calendar-wrapper-${widgetNo}" class="d-flex justify-content-between text-center pb-1" style="gap: 6px;">
						    <div class="w-100 py-3"><span class="spinner-border spinner-border-sm text-secondary"></span></div>
						</div>
			        </div>
				</div>
			</div>
		`;
		$rootContent.html(fullHtml);
	}

    // 날짜 형식 (YYYY-MM-DD)
    const today = new Date();
    const toYmd = (d) => {
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    };
    const sysToday = toYmd(today);

    $.ajax({
        url: `${CONTEXT_PATH}/tudio/widget/personalWork`,
        type: "GET",
        dataType: "json",
        success: function(workData) {
            // 주간 캘린더 렌더링
            renderWeeklyCalendar(widgetNo, workData, today, toYmd);          
            // 오늘 날짜 기준으로 리스트 초기화
            renderTaskList(widgetNo, workData, sysToday);
        },
        error: function() {
            $(`#pw-task-list-${widgetNo}`).html('<li class="list-group-item text-danger small">데이터 로딩 실패</li>');
        }
    });
}

// 주간 캘린더
function renderWeeklyCalendar(widgetNo, workData, today, toYmdFunc) {
    const $calBody = $(`#pw-calendar-wrapper-${widgetNo}`);
    const currentDay = today.getDay(); // 0(일) ~ 6(토)
    
    // 이번 주 일요일 계산
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - currentDay);
	
	const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
	let html = '';

    for (let i = 0; i < 7; i++) {
        let tempDate = new Date(startOfWeek);
        tempDate.setDate(startOfWeek.getDate() + i);
        
        let ymd = toYmdFunc(tempDate);
        let dayNum = tempDate.getDate();
		let dayName = dayNames[i];
        
        // 해당 날짜에 업무가 있는지 확인
        let hasWork = workData.some(task => task.WORK_DATE === ymd);
		
		// 요일 색상 (일:빨강, 토:파랑)
		let dayColorClass = (i === 0) ? 'text-danger' : (i === 6) ? 'text-primary' : 'text-muted';
		let dotStyle = hasWork ? "opacity: 1;" : "opacity: 0;"; // 업무 있으면 점 표시

        html += `
			<div class="zen-day-card clickable-date" 
		    	data-date="${ymd}" 
		        id="pw-cell-${widgetNo}-${ymd}">
		                
		        <span class="day-name ${dayColorClass}">${dayName}</span>
		        <span class="day-num">${dayNum}</span>
		                
		        <div class="work-dot" style="${dotStyle}"></div>
		    </div>
        `;
    }
    $calBody.html(html);

    // 날짜 클릭 시 업무 리스트 업데이트
    $calBody.find('.clickable-date').off('click').on('click', function() {
        let selectedDate = $(this).data('date');
        
        // UI 활성화
        $calBody.find('.clickable-date').removeClass('active');
        $(this).addClass('active');

        renderTaskList(widgetNo, workData, selectedDate);
    });
    
    // (오늘) 날짜 cell 활성화
    $(`#pw-cell-${widgetNo}-${toYmdFunc(today)}`).addClass('active');
}

// 선택된 날짜 업무 리스트 출력
function renderTaskList(widgetNo, workData, dateStr) {
    const $listArea = $(`#pw-task-list-${widgetNo}`);
    const $titleArea = $(`#pw-date-title-${widgetNo}`);
    
    const dateObj = new Date(dateStr);
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    let titleText = `${dateStr} ${days[dateObj.getDay()]}`;
    
    // 오늘 날짜인지 확인
    const todayStr = new Date().toISOString().split('T')[0];
    if (dateStr === todayStr) {
        titleText += " <span class='badge bg-warning text-dark ms-1'>오늘</span>";
    }
    $titleArea.html(titleText);

    // 업무 리스트 필터링 및 출력
    const dailyTasks = workData.filter(task => task.WORK_DATE === dateStr);
    let html = '';

    if (dailyTasks.length === 0) {
        html = '<li class="list-group-item text-muted small border-0 ps-0">등록된 업무가 없습니다.</li>';
    } else {
        dailyTasks.forEach(task => {
            let badgeClass = (task.WORK_TYPE === 'TASK') ? 'bg-primary' : 'bg-info';
            let typeName = (task.WORK_TYPE === 'TASK') ? '상위' : '하위';

            html += `
                <li class="list-group-item border-0 ps-0 py-1 text-truncate">
                    <span class="badge ${badgeClass} me-2" style="font-size: 0.7rem;">${typeName}</span>
                    <span title="${task.WORK_TITLE}">${task.WORK_TITLE}</span>
                </li>
            `;
        });
    }
    $listArea.html(html);
}


/* [위젯 3] 시스템 공지사항 */
function loadNoticeList(widgetNo) {
	let $area = $(`#notice-list-area-${widgetNo}`);
	if ($area.length === 0) return;

	let $parent = $area.parent();
	if ($parent.find('.d-flex.justify-content-between').length === 0) {
		let headerHtml = `
			<div class="d-flex justify-content-between align-items-center mb-2"> 
				<h6 class="font-weight-bold text-gray-800 mb-0">
					<i class="bi bi-megaphone-fill text-warning"></i> 시스템 공지사항
				</h6>
		        <a href="${CONTEXT_PATH}/tudio/notice/list" class="text-muted small text-decoration-none widget-icon"> 
                	<i class="bi bi-arrow-up-right text-primary fw-bold"></i>
		        </a>
		    </div>
		`;
		$parent.prepend(headerHtml);
	}
	
    $.ajax({
        url: `${CONTEXT_PATH}/tudio/widget/noticeList`,
        type: "GET",
        dataType: "json",
        success: function(list) {
            let html = '<ul class="list-group list-group-flush">';
            if (list.length === 0) {
                html += '<li class="list-group-item text-center text-muted py-3 small">등록된 공지사항이 없습니다.</li>';
            } else {
                $.each(list, function(i, notice) {
                    // 날짜 형식 포맷 (YYYY-MM-DD)
                    let dateObj = new Date(notice.noticeRegdate);
                    let yyyy = dateObj.getFullYear();
                    let mm = String(dateObj.getMonth() + 1).padStart(2, '0');
                    let dd = String(dateObj.getDate()).padStart(2, '0');
                    let dateStr = `${yyyy}-${mm}-${dd}`;

                    // 제목, 날짜 출력 (뱃지 X)
                    html += `
                        <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center border-bottom-0">
                            <a href="${CONTEXT_PATH}/notice/detail?noticeNo=${notice.noticeNo}" 
                               class="text-dark text-decoration-none text-truncate" 
                               style="max-width: 75%; font-size: 0.9rem;">
                                ${notice.noticeTitle}
                            </a>
                            <small class="text-muted" style="font-size: 0.8rem;">${dateStr}</small>
                        </li>
                    `;
                });
            }
            html += '</ul>';
            $area.html(html);
        },
        error: function() {
            $(`#notice-list-area-${widgetNo}`).html('<p class="text-center text-danger small mt-3">로딩 실패</p>');
        }
    });
}

/* [위젯 4] 미확인 알림 */
function loadAlarmList(widgetNo) {
	let $area = $(`#alarm-list-area-${widgetNo}`);
	if ($area.length === 0) return;

	let $parent = $area.parent();
	if ($parent.find('h6').length === 0) {
		let headerHtml = `
			<h6 class="font-weight-bold text-gray-800">
				<i class="bi bi-bell-fill text-danger"></i> 미확인 알림
			</h6>
		`;
		$parent.prepend(headerHtml);
	}
	
    $.ajax({
        url: `${CONTEXT_PATH}/tudio/widget/alarmList`,
        type: "GET",
        dataType: "json",
        success: function(list) {
            let $area = $(`#alarm-list-area-${widgetNo}`);
			$area.parent().find('h6').html('<i class="bi bi-bell-fill text-danger"></i> 미확인 알림');
			
            let html = '<ul class="list-group list-group-flush">';
            if (list.length === 0) {
                html += '<li class="list-group-item text-center text-muted py-3 small">새로운 알림이 없습니다.</li>';
            } else {
                $.each(list, function(i, noti) {
                    let dateObj = new Date(noti.noticeRegdate); 
                    
                    let mm = String(dateObj.getMonth() + 1).padStart(2, '0');
                    let dd = String(dateObj.getDate()).padStart(2, '0');
                    let hh = String(dateObj.getHours()).padStart(2, '0');
                    let mi = String(dateObj.getMinutes()).padStart(2, '0');
                    let dateStr = `${mm}-${dd} ${hh}:${mi}`;

					let notiType = noti.notiType;
					if(notiType === "PROJECT_INVITE") {
						notiTypeStr = "새 프로젝트가 할당되었습니다.";
					}
					
                    let contentHtml = '';
                    if(noti.notiUrl) {
                        contentHtml = `<a href="${CONTEXT_PATH}${noti.notiUrl}" class="text-dark text-decoration-none text-truncate" style="max-width: 75%; font-size: 0.9rem;">${notiTypeStr}</a>`;
                    } else {
                        contentHtml = `<span class="text-dark text-truncate" style="max-width: 75%; font-size: 0.9rem;">${noti.notiType}</span>`;
                    }

                    html += `
                        <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center border-bottom-0">
                            ${contentHtml}
                            <small class="text-muted" style="font-size: 0.8rem;">${dateStr}</small>
                        </li>
                    `;
                });
            }
            html += '</ul>';
            $area.html(html);
        },
        error: function() {
            $(`#alarm-list-area-${widgetNo}`).html('<p class="text-center text-danger small mt-3">로딩 실패</p>');
        }
    });
}

/* [위젯 5] 프로젝트 북마크 */
function loadBookmarkList(widgetNo) {
	let $area = $(`#bookmark-list-area-${widgetNo}`);
	if ($area.length === 0) return;

	let $parent = $area.parent();
	if ($parent.find('h6').length === 0) {
		let headerHtml = `
			<h6 class="font-weight-bold text-gray-800">
				<i class="bi bi-bookmark-star-fill text-info"></i> 북마크 프로젝트
			</h6>
		`;
		$parent.prepend(headerHtml);
	}
	
    $.ajax({
        url: `${CONTEXT_PATH}/tudio/widget/bookmarkList`,
        type: "GET",
        dataType: "json",
        success: function(list) {
            // let $area = $(`#bookmark-list-area-${widgetNo}`);
			// $area.parent().find('h6').html('<i class="bi bi-bookmark-star-fill text-info"></i> 북마크 프로젝트');
            
			let html = '<ul class="list-group list-group-flush">';
            if (list.length === 0) {
                html += '<li class="list-group-item text-center text-muted py-3 small">북마크한 프로젝트가 없습니다.</li>';
            } else {
                $.each(list, function(i, project) {
                    // 상태값 별 뱃지 (0: 진행, 1: 완료, 2: 중단)
                    let statusBadge = '';
                    if(project.projectStatus === 0) statusBadge = '<span class="badge bg-primary">진행</span>';
                    else if(project.projectStatus === 1) statusBadge = '<span class="badge bg-success">완료</span>';
                    else if(project.projectStatus === 2) statusBadge = '<span class="badge bg-secondary">중단</span>';
                    
                    // 프로젝트 진척도
                    let progress = project.projectProgress;
                    let progressColor = (progress >= 100) ? 'bg-success' : 'bg-info';

                    html += `
						<li class="list-group-item px-0 py-2 border-bottom-0 d-flex align-items-center justify-content-between">
					    	<div class="d-flex align-items-center" style="width: 25%; min-width: 0;">
					            <i class="bi bi-star-fill text-warning me-2 flex-shrink-0"></i>
					            <a href="${CONTEXT_PATH}/tudio/project/detail?projectNo=${project.projectNo}" 
					               class="text-dark text-decoration-none fw-bold text-truncate" title="${project.projectName}"> 
					               ${project.projectName}
					            </a>
					        </div>
							<div class="d-flex align-items-center flex-grow-1 mx-2">
					            <div class="progress w-100" style="height: 6px;">
					                <div class="progress-bar ${progressColor}" role="progressbar" 
					                     style="width: ${progress}%" aria-valuenow="${progress}" aria-valuemin="0" aria-valuemax="100">
					                </div>
					            </div>
					            <small class="ms-1 text-muted" style="font-size: 0.7rem; min-width: 25px; text-align: right; margin-right: 30px">${progress}%</small>
					        </div>
							<div class="flex-shrink-0">
					            ${statusBadge}
					        </div>
					    </li>
                    `;
                });
            }
            html += '</ul>';
            $area.html(html);
        },
        error: function() {
            $(`#bookmark-list-area-${widgetNo}`).html('<p class="text-center text-danger small mt-3">로딩 실패</p>');
        }
    });
}


/* [위젯 6] to do list */
async function loadTodoList(widgetNo) {
	let container = document.getElementById(`todo-list-area-${widgetNo}`);
	if(!container) return;
	
	try {
		const response = await fetch(`${CONTEXT_PATH}/tudio/widget/todo?t=${Date.now()}`);	
		if (!response.ok) throw new Error('Network error !');
		const data = await response.json();
		
		// [폴더 디자인] 위젯 최상위 컨테이너 설정
		let widgetContent = container.closest('.grid-stack-item-content');
		widgetContent.classList.add('zen-folder-widget'); // 폴더 스타일 적용
		
		// 2. [폴더 디자인] 배경 레이어가 없으면 생성 (최초 1회)
		if (!widgetContent.querySelector('.folder-shape-layer')) {
			let shapeHtml = `
				<div class="folder-shape-layer">
		        	<div class="folder-tab-todo"></div>
					<div class="folder-body-bg"></div> 
				</div>
		        <div class="folder-content-layer">
		         	<div class="widget-header-wrapper"></div>
		            <div id="todo-list-area-${widgetNo}" class="flex-grow-1 overflow-auto widget-content"></div>
		        </div>
			`;
			// 기존 닫기 버튼 보존 (필요시)
			let closeBtn = widgetContent.querySelector('.btn-close-widget');
			            
			// HTML 교체
			widgetContent.innerHTML = shapeHtml;
			            
			// 닫기 버튼 다시 추가 (콘텐츠 레이어 안으로)
			if(closeBtn) widgetContent.querySelector('.folder-content-layer').appendChild(closeBtn);
			            
			// container 변수 갱신 (DOM이 새로 그려졌으므로 다시 찾음)
			container = document.getElementById(`todo-list-area-${widgetNo}`);		
		}
		
		let headerWrapper = widgetContent.querySelector('.widget-header-wrapper');
		if (headerWrapper && !headerWrapper.querySelector('.widget-header-custom')) {
			let headerHtml = `
				<div class="d-flex justify-content-between align-items-center mb-3 widget-header-custom">
					<h6 class="font-weight-bold text-gray-800">
						<i class="bi bi-check2-square text-primary me-2"></i>To Do List
					</h6>
 					<button class="btn btn-circle-sm shadow-sm bg-white" onclick="showInputRow('${widgetNo}')" title="할 일 추가">
						<i class="bi bi-plus-lg text-primary fw-bold"></i>
					</button>
				</div>
			`;
			headerWrapper.innerHTML = headerHtml;
		}

		let html = `<ul class="list-group list-group-flush" id="todo-ul-${widgetNo}">`; 		
		if (!data || data.length === 0) {
			html += '<li class="list-group-item text-center text-muted py-3 small" id="empty-msg-' + widgetNo + '">등록된 할 일이 없습니다.</li>';
		} else {
			data.forEach(todo => {
				let isDone = (todo.todoStatus === 'Y');
				let textStyle = isDone ? 'text-decoration-line-through text-muted' : '';
				let checked = isDone ? 'checked' : '';

				html += `
					<li class="list-group-item px-0 py-2 border-bottom-0" id="todo-item-${todo.todoNo}">					
						<div class="d-flex justify-content-between align-items-center w-100" id="view-${todo.todoNo}">
							<div class="form-check text-truncate flex-grow-1" style="max-width: 80%;">
								<input class="form-check-input" type="checkbox" id="todoCheck${todo.todoNo}" 
							    	onchange="updateTodoStatus(${todo.todoNo}, '${todo.todoStatus}', '${widgetNo}')" ${checked}>
							    <label class="form-check-label ${textStyle}" for="todoCheck${todo.todoNo}" 
							    	style="cursor:pointer; font-size: 0.9rem; ${textStyle}""
									ondblclick="enableEditMode(${todo.todoNo}, '${todo.todoContent}')">
							    	${todo.todoContent}
							    </label>
							</div>
						<div class="btn-group btn-group-sm opacity-50 hover-opacity-100">
							<button type="button" class="btn btn-link text-secondary p-0 me-2" 
								onclick="enableEditMode(${todo.todoNo}, '${todo.todoContent}')">
								<i class="bi bi-pencil-square"></i>
							</button>
							<button type="button" class="btn btn-link text-danger p-0" 
								onclick="deleteTodo(${todo.todoNo}, '${widgetNo}')">
								<i class="bi bi-trash"></i>
							</button>
						</div>
					</div>
					<div class="d-flex align-items-center w-100 d-none" id="edit-${todo.todoNo}">
						<input type="text" class="form-control form-control-sm me-2" id="input-${todo.todoNo}" value="${todo.todoContent}"
							onkeydown="if(event.key==='Enter') saveEdit(${todo.todoNo}, '${widgetNo}')">
						<button class="btn btn-sm btn-success me-1" onclick="saveEdit(${todo.todoNo}, '${widgetNo}')">저장</button>
						<button class="btn btn-sm btn-secondary" onclick="cancelEdit(${todo.todoNo})">취소</button>
					</div>
				</li>
			`;
		});
	}
		html += '</ul>';
		container.innerHTML = html;
	} catch (error) {
		console.error('목록 로딩 실패:', error);
		if(document.getElementById(`todo-list-area-${widgetNo}`)) {
			document.getElementById(`todo-list-area-${widgetNo}`).innerHTML = '<p class="text-danger small text-center">로딩 실패</p>';
		}
	}
}

// [위젯 6-1] 할 일 추가
// 1. 입력 줄(Input Row) 생성
function showInputRow(widgetNo) {
	const ul = document.getElementById(`todo-ul-${widgetNo}`);
	    
	const emptyMsg = document.getElementById(`empty-msg-${widgetNo}`);
	if(emptyMsg) emptyMsg.style.display = 'none';

	if (document.getElementById(`newTodoInput-${widgetNo}`)) {
		document.getElementById(`newTodoInput-${widgetNo}`).focus();
		return;
	}

	// li 생성
    const li = document.createElement('li');
    li.className = 'list-group-item d-flex justify-content-between align-items-center bg-light'; // 입력 중 표시
	li.id = `inputRow-${widgetNo}`;

    li.innerHTML = `
        <div class="d-flex align-items-center w-100">
            <input type="text" id="newTodoInput-${widgetNo}" class="form-control" placeholder="할 일 추가" onkeydown="handleEnter(event)">
        </div>
        
        <div class="ms-2 d-flex" style="min-width: 100px;">
            <button class="btn btn-sm btn-success me-1" onclick="saveNewTodo('${widgetNo}')">추가</button>
            <button class="btn btn-sm btn-secondary" onclick="cancelInput('${widgetNo}')">취소</button>
        </div>
    `;

    ul.prepend(li); 	   		// 리스트의 맨 앞에 추가
    // ul.appendChild(li); 		// 리스트의 맨 끝에 추가
    
    // 입력창 포커스
    document.getElementById(`newTodoInput-${widgetNo}`).focus();
}

// 2. 새 할 일 저장
async function saveNewTodo(widgetNo) {
    const input = document.getElementById(`newTodoInput-${widgetNo}`);
    const content = input.value;

    if (!content.trim()) {
		Swal.fire({
			icon: 'warning',
		    title: '입력 오류',
		    text: '내용을 입력해주세요!',
		});
        return;
    }
	
	try {
		const response = await fetch(`${CONTEXT_PATH}/tudio/todo/insert`, {
			method: 'POST',
		    headers: { 'Content-Type': 'application/json' },
		    body: JSON.stringify({ todoContent: content })
		});

		const result = await response.json();
		
		if (result === 'OK') {
			Toast.fire({ icon: 'success', title: '할 일이 등록되었습니다.' });
		    await loadTodoList(widgetNo); // 성공 시 투두 리스트 전체 다시 로드
		} else {
			Swal.fire('실패', '등록에 실패했습니다.', 'error');
		}
	} catch (error) {
		console.error('등록 중 에러:', error);
	    Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
	}
}

// 3. 할 일 추가 취소 (입력 줄 제거)
function cancelInput(widgetNo) {
    const inputRow = document.getElementById(`inputRow-${widgetNo}`);
    if (inputRow) {
        inputRow.remove(); // li 삭제
    }
	
	const ul = document.getElementById(`todo-ul-${widgetNo}`);
	if(ul && ul.children.length === 0) {
		loadTodoList(widgetNo); // 다시 로드
	}
}

// 엔터키 처리
function handleEnter(e) {
    if (e.key === 'Enter') {
        saveNewTodo();
    } else if (e.key === 'Escape') {
        cancelInput();
    }
}


// [위젯 6-2] 상태 변경 (체크/해제)
async function updateTodoStatus(todoNo, currentStatus, widgetNo) {
    // 'Y'이면 'N', 'N'이면 'Y'로 변경
    const newStatus = (currentStatus === 'Y') ? 'N' : 'Y';
    const data = {
        todoNo: todoNo,
        todoStatus: newStatus
    };

	try {
		const response = await fetch(`${CONTEXT_PATH}/tudio/todo/updateStatus`, {
			method: 'POST',
		    headers: { 'Content-Type': 'application/json' },
		    body: JSON.stringify(data)
		})
		const result = await response.json();

		if (result === 'OK') {
			await loadTodoList(widgetNo); 
		} else {
			Swal.fire('오류', '상태 변경 실패', 'error');
			loadTodoList(widgetNo); // 체크박스 상태를 되돌리기 위해 재로딩
		}
	} catch (error) {
		console.error(error);
	}
}

/* [위젯 6-3] 투두 삭제 */
function deleteTodo(todoNo, widgetNo) {
	Swal.fire({
		title: '정말 삭제하시겠습니까?',
	    text: "삭제된 데이터는 복구할 수 없습니다.",
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonColor: '#d33', 	// 삭제 버튼: 빨간색
	    cancelButtonColor: '#3085d6',
	    confirmButtonText: '네, 삭제합니다',
	    cancelButtonText: '취소'
	}).then( async (result) => {
		// 사용자가 확인 버튼을 눌렀을 때만 실행
		if (result.isConfirmed) {
			try {
				const data = { todoNo: todoNo };	
							
				const response = await fetch(`${CONTEXT_PATH}/tudio/todo/delete`, {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify(data)
				})			
					
				const resData = await response.json();
				
				if(resData === 'OK') {
					Toast.fire({
						icon: 'success',
						title: '삭제되었습니다.'
					});
					loadTodoList(widgetNo); // 삭제 후 목록 갱신
				} else {
					Swal.fire('오류', '삭제 중 문제가 발생했습니다.', 'error');
				}
			} catch (error) {
				console.error('등록 중 에러:', error);
				Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
			}
	    }
	});
}

/* [위젯 6-4] 투두 내용 수정 */
async function enableEditMode(todoNo, content) {
	// 보기 모드 숨김
	document.getElementById(`view-${todoNo}`).classList.remove('d-flex');
	document.getElementById(`view-${todoNo}`).classList.add('d-none');
	
	// 수정 모드
	const editDiv = document.getElementById(`edit-${todoNo}`);
	editDiv.classList.remove('d-none');
	editDiv.classList.add('d-flex');
	    
	// 입력창 포커스
	const input = document.getElementById(`input-${todoNo}`);
	input.value = content;
	input.focus();
}

function cancelEdit(todoNo) {
    // 수정 모드 숨김
    document.getElementById(`edit-${todoNo}`).classList.remove('d-flex');
    document.getElementById(`edit-${todoNo}`).classList.add('d-none');
    
    // 보기 모드 표시
    document.getElementById(`view-${todoNo}`).classList.remove('d-none');
    document.getElementById(`view-${todoNo}`).classList.add('d-flex');
}

async function saveEdit(todoNo, widgetNo) {
	const input = document.getElementById(`input-${todoNo}`);
	const newContent = input.value;
	
	if(newContent === null) return; // 취소
	if (!newContent.trim()) {
		Swal.fire({ icon: 'warning', title: '내용을 입력해주세요.' });
		return;
	}
	
	let data = {
		todoNo: todoNo,
	    todoContent: newContent
	};
	
	try {
		const response = await fetch(`${CONTEXT_PATH}/tudio/todo/updateContent`, {
			method: "POST",
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(data)
		})
			
		const result = await response.json();
		
		if (result === 'OK') {
			Toast.fire({ icon: 'success', title: '수정 완료' });
			await loadTodoList(widgetNo); 
		} else {
				Swal.fire('실패', '수정 실패', 'error');
		}
	} catch (error) {
		console.error(error);
	}
}


/*
 * WebSocket 실시간 대시보드 동기화
 */
let stompClient = null;

// 1. 웹소켓 연결 및 채널 구독
function connectWebSocket(memberNo) {
	console.log("로그인한 회원 번호:", memberNo);
    if (!memberNo) return;

    // SockJS와 Stomp를 사용하여 연결 시도
    const socket = new SockJS(`${CONTEXT_PATH}/ws-stomp`);
    stompClient = Stomp.over(socket);
    
    // 운영 시 아래 주석 해제하여 로그 끄기
    // stompClient.debug = null; 

    stompClient.connect({}, function (frame) {
        console.log('Real-time Sync Connected: ' + frame);

        // 내 전용 대시보드 채널 구독 (/sub/dashboard/{내번호})
        stompClient.subscribe(`/sub/dashboard/${memberNo}`, function (message) {
            try {
                const body = JSON.parse(message.body);
                // body.type: (Java Enum 이름)
                handleWidgetUpdate(body.type);
            } catch (e) {
                console.error("WebSocket 메시지 파싱 오류:", e);
            }
        });
    });
}

/**
 * 2. 수신된 타입에 따라 적절한 위젯 새로고침
 */
function handleWidgetUpdate(type) {
    console.log("Update Signal Received: ", type);

    document.querySelectorAll('.grid-stack-item').forEach(item => {
        let widgetNo = item.getAttribute('gs-id');	// widgetNo(PK)
        
        // 위젯 제목을 찾아서 위젯 종류 판별
        let titleEl = item.querySelector('h6') || item.querySelector('.grid-stack-item-content span');
        let title = titleEl ? titleEl.innerText.trim() : "";
		// console.log("위젯 확인: ", title);

        // 위젯 매칭 및 갱신
        // 투두 리스트 (TODO)
        if (type === 'TODO' && title.includes("TO DO LIST")) {
            loadTodoList(widgetNo); 
        }
		
		// 개인 업무 (PERSONAL_WORK) - 주간 스케줄
		else if (type === 'PERSONAL_WORK' && title.includes("개인 업무")) {
			loadPersonalWork(widgetNo); // 캘린더 및 리스트 재로딩
			Toast.fire({ icon: 'info', title: '업무 일정이 갱신되었습니다.' }); 
		} 
        
        // 미확인 알림 (ALARM)
        else if (type === 'ALARM' && title.includes("미확인 알림")) {
            loadAlarmList(widgetNo);
            Toast.fire({ icon: 'info', title: '새로운 알림이 도착했습니다.' });
        } 
        
        // 북마크 프로젝트 (PROJECT_BOOKMARK)
        else if (type === 'PROJECT_BOOKMARK' && title.includes("북마크 프로젝트")) {
            loadBookmarkList(widgetNo);
        }
        
        // 프로젝트 요약 (PROJECT_SUMMARY)
        else if (type === 'PROJECT_SUMMARY' && title.includes("마감 임박 업무")) {
            loadProjectSummary(widgetNo);
        }
        
        // 공지사항 (NOTICE)
        else if (type === 'NOTICE' && title.includes("공지사항")) {
            loadNoticeList(widgetNo);
            Toast.fire({ icon: 'warning', title: '새로운 공지사항이 등록되었습니다.' });
        }
    });
}