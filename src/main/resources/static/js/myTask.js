/**
 * myTask.js
 * 내 업무 모아보기 전용 스크립트 (버전 1.2 - 토글 저장 및 상태 동기화)
 */

const STATUS_MAP = { 201: 'REQUEST', 202: 'PROGRESS', 203: 'DONE', 204: 'HOLD', 205: 'DELAYED' };
const PRIORITY_MAP = { 211: 'LOW', 212: 'NORMAL', 213: 'HIGH', 214: 'URGENT' };

document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    const typeParam = urlParams.get('type');
    
    document.querySelectorAll('.btn-group label').forEach(l => l.classList.remove('active'));
    document.querySelectorAll('.btn-group input').forEach(r => r.checked = false);

    let targetId = 'typeAll'; 
    if (typeParam === 'writer') targetId = 'typeWriter';
    else if (typeParam === 'manager') targetId = 'typeManager';

    const targetInput = document.getElementById(targetId);
    if (targetInput) {
        targetInput.checked = true; 
        document.querySelector('label[for="' + targetId + '"]').classList.add('active');
    }

    initMyTaskEvents();
	
	// 업무 펼치기에 대한 초기 상태 로직
	const savedState = sessionStorage.getItem('myTaskExpandedRows');
    const toggleAllBtn = document.getElementById('toggleAllCheckbox');
	if(!savedState){
		// 첫방문(저장된 상태가 없음) -> 모두 펼치기 (default)
		if(toggleAllBtn){
			toggleAllBtn.checked = true;
			// 강제로 change 이벤트 트리거
			toggleAllBtn.dispatchEvent(new Event('change'));
		}
	} else {
		// 재방문 (저장된 상태가 있음)
		if (toggleAllBtn) toggleAllBtn.checked = false;
		// 페이지 로드 시 토글 상태 복원 (약간의 지연을 주어 DOM 렌더링 확보)
		setTimeout(restoreToggleState, 50);
	}
});

function initMyTaskEvents() {
    const toggleAllBtn = document.getElementById('toggleAllCheckbox');
    if(toggleAllBtn){
        toggleAllBtn.addEventListener('change', function(){
            const isChecked = this.checked;
			// 행 가시화 여부
            document.querySelectorAll('.sub-row').forEach(row => row.style.display = isChecked ? 'table-row' : 'none');
			
			// 아이콘 변경
            document.querySelectorAll('.toggle-btn i').forEach(icon => {
				if (isChecked) {
                    icon.classList.remove('bi-caret-right-fill');
                    icon.classList.add('bi-caret-down-fill');
                } else {
                    icon.classList.remove('bi-caret-down-fill');
                    icon.classList.add('bi-caret-right-fill');
                }
            });
			
			// 상태 저장 관리
	        if (isChecked) {
	            // 모두 펼쳤으므로 개별 저장 상태는 불필요 -> 삭제
	            sessionStorage.removeItem('myTaskExpandedRows');
	        } else {
	            // 모두 접었으므로 상태 초기화 (빈 배열 저장)
	            sessionStorage.setItem('myTaskExpandedRows', JSON.stringify([]));
	        }
        });
    }

    document.getElementById('btnSaveDetail').addEventListener('click', updateTask);
    document.getElementById('btnDeleteDetail').addEventListener('click', deleteTask);
    
    // 슬라이더 이벤트
    const slider = document.getElementById('detailRate');
    slider.addEventListener('input', function() {
        const val = Number(this.value);
        document.getElementById('detailRateVal').innerText = val + '%';
        updateSliderColor(this); 
        syncStatusWithRate(val);
    });

    // 상태 Select 이벤트
    const statusSelect = document.getElementById('detailStatus');
    statusSelect.addEventListener('change', function() {
        const selectedStatus = this.value;
        const slider = document.getElementById('detailRate');
        const currentRate = Number(slider.value);
        
        if (selectedStatus === 'DONE') {
            slider.value = 100;
        } else if (selectedStatus === 'REQUEST') {
            slider.value = 0;
        } else if (selectedStatus === 'PROGRESS') {
            if (currentRate === 100) slider.value = 95;
            else if (currentRate === 0) slider.value = 5;
        }
        document.getElementById('detailRateVal').innerText = slider.value + '%';
        updateSliderColor(slider);
    });
	
	// 날짜 필드 클릭 시 달력 팝업 강제 호출 (전체 클릭 효과)
    const dateInputs = document.querySelectorAll('#detailStart, #detailEnd');
    dateInputs.forEach(input => {
        input.addEventListener('click', function() {
            try {
                this.showPicker(); // 최신 브라우저 지원 메서드
            } catch (error) {
                // 구형 브라우저(Safari 등)는 기본 동작 유지
                console.log('showPicker not supported'); 
            }
        });
    });
	const endDateInput = document.getElementById('detailEnd');
	    endDateInput.addEventListener('change', function() {
	        const newEndDate = this.value;
	        const statusSelect = document.getElementById('detailStatus');
	        
	        // 이미 완료(DONE) 상태면 건드리지 않음
	        if (statusSelect.value === 'DONE') return;

	        if (isOverdue(newEndDate)) {
	            // 마감일 지남 -> '지연(DELAYED)'으로 변경
	            // 단, 사용자가 의도적으로 '보류' 등을 선택했을 수도 있으니
	            // "마감일이 지났으므로 상태를 지연으로 변경하시겠습니까?" 물어보거나 강제 변경
	            // 여기서는 규칙에 따라 '지연'으로 강제 변경하고 옵션 제어
	            statusSelect.value = 'DELAYED';
	            checkDelayedState(); // 옵션 비활성화 로직 재실행
	            
	            Swal.fire({
	                icon: 'warning',
	                title: '상태 변경',
	                text: '마감일이 경과하여 상태가 [지연]으로 변경되었습니다.',
	                timer: 2000,
	                toast: true,
	                position: 'top-end',
	                showConfirmButton: false
	            });
	        } else {
	            // 마감일 안 지남 -> 만약 현재 '지연' 상태였다면 '진행'이나 '요청'으로 복구?
	            // "마감일을 늘려주지 않는 한 상태 변경 불가" 규칙에 따라,
	            // 마감일을 늘렸으니 지연 상태를 풀어줘야 함.
	            if (statusSelect.value === 'DELAYED') {
	                const rate = Number(document.getElementById('detailRate').value);
	                statusSelect.value = (rate > 0) ? 'PROGRESS' : 'REQUEST';
	                checkDelayedState(); // 옵션 활성화
	            }
	        }
	    });
		
}

function saveToggleState(taskId, isOpen) {
    let expandedRows = [];
    try {
        expandedRows = JSON.parse(sessionStorage.getItem('myTaskExpandedRows')) || [];
    } catch(e) {
        expandedRows = [];
    }
    
    if (isOpen) {
        if (!expandedRows.includes(taskId)) expandedRows.push(taskId);
    } else {
        expandedRows = expandedRows.filter(id => id !== taskId);
    }
    sessionStorage.setItem('myTaskExpandedRows', JSON.stringify(expandedRows));
}

function restoreToggleState() {
    let expandedRows = [];
    try {
        expandedRows = JSON.parse(sessionStorage.getItem('myTaskExpandedRows')) || [];
    } catch(e) {
        return;
    }
    
    if(expandedRows.length === 0) return;

    // 모든 토글 버튼을 순회하며 상태 복원
    const allToggleBtns = document.querySelectorAll('.toggle-btn');
    
    allToggleBtns.forEach(btn => {
        // onclick 속성 파싱: onclick="toggleSubTasks('123', this)..."
        const onClickStr = btn.getAttribute('onclick');
        if (onClickStr) {
            // 숫자만 추출 (taskId)
            const match = onClickStr.match(/'(\d+)'/); 
            if (match && match[1]) {
                const taskId = match[1];
                if (expandedRows.includes(taskId)) {
                    // 펼치기
                    const subRows = document.querySelectorAll('.sub-group-' + taskId);
                    subRows.forEach(row => row.style.display = 'table-row');
                    
                    // 아이콘 변경
                    const icon = btn.querySelector('i');
                    if (icon) {
                        icon.classList.remove('bi-caret-right-fill');
                        icon.classList.add('bi-caret-down-fill');
                    }
                }
            }
        }
    });
}

function toggleSubTasks(taskId, btnElement) {
    const subRows = document.querySelectorAll('.sub-group-' + taskId);
    const icon = btnElement.querySelector('i');
    
    let isVisible = false;
    if(subRows.length > 0) isVisible = (window.getComputedStyle(subRows[0]).display !== 'none');
    
    // 상태 반전
    const newState = !isVisible;
    
    subRows.forEach(row => row.style.display = newState ? 'table-row' : 'none');
    
    if(newState) {
        icon.classList.replace('bi-caret-right-fill', 'bi-caret-down-fill');
    } else {
        icon.classList.replace('bi-caret-down-fill', 'bi-caret-right-fill');
    }
    
    saveToggleState(taskId, newState);
}

function syncStatusWithRate(rate) {
    const statusSelect = document.getElementById('detailStatus');
    const currentStatus = statusSelect.value;
    const isExceptionState = (currentStatus === 'HOLD' || currentStatus === 'DELAYED');

    if (rate == 0) {
        if (currentStatus !== 'DELAYED') statusSelect.value = 'REQUEST'; 
    } else if (rate == 100) {
        statusSelect.value = 'DONE';
    } else {
        if (!isExceptionState) statusSelect.value = 'PROGRESS';
    }
}

function updateSliderColor(input) {
    const val = input.value;
    input.style.background = `linear-gradient(to right, #3B82F6 ${val}%, #dee2e6 ${val}%)`;
}


function openDetailPanel(id, type) {
    const panel = document.getElementById('taskDetailPanel');
    const form = document.getElementById('taskEditForm');
	
	let taskPannelWidth = $("#taskDetailPanel").outerWidth();
	$(".floating-chat-container").css('right', (taskPannelWidth+30) + 'px');
	
    panel.classList.add('open');
    form.reset();
    document.getElementById('detailTitle').value = "데이터 불러오는 중...";
    document.getElementById('selectedAssigneeArea').innerHTML = ''; 
    document.getElementById('assigneeDropdownBtn').innerText = "로딩 중...";
    document.getElementById('assigneeDropdownList').innerHTML = '';

    const url = type === 'T' 
        ? `/tudio/project/task/detail/${id}` 
        : `/tudio/project/task/sub/detail/${id}`;

    fetch(url)
        .then(res => {
            if(!res.ok) throw new Error("Network Error");
            return res.json();
        })
        .then(data => {
            if(!data.projectNo) {
                console.error("ProjectNo is missing", data);
                Swal.fire('오류', '데이터 오류: 프로젝트 번호 누락', 'error');
                return;
            }
            loadProjectMembers(data.projectNo, function() {
                fillDetailForm(data, type);
            });
        })
        .catch(err => {
            console.error(err);
            Swal.fire('실패', '정보 로드 실패', 'error');
            closeTaskPanel();
        });
}

function loadProjectMembers(projectNo, callback) {
    fetch(`/tudio/project/member/list/json/${projectNo}`)
        .then(res => res.json())
        .then(members => {
            const listContainer = document.getElementById('assigneeDropdownList');
            listContainer.innerHTML = ''; 
			
			// 검색창 초기화
            const searchInput = document.getElementById('assigneeSearchInput');
            if(searchInput) {
                searchInput.value = '';
                searchInput.removeEventListener('keyup', filterMembers); // 중복 방지
                searchInput.addEventListener('keyup', filterMembers);
            }
			
            if(!members || members.length === 0) {
                listContainer.innerHTML = '<li class="p-2 text-muted small text-center">멤버가 없습니다.</li><li class="p-3 text-muted small text-center">멤버가 없습니다.</li>';
            } else {
                members.forEach(m => {
					// 이름 첫 글자로 프로필 아이콘 생성
					const initial = m.memberName ? m.memberName.charAt(0) : '?';
					
                    const li = document.createElement('li');
					// 클릭 시 체크박스 토글을 위해 전체에 이벤트 위임 예정
                    li.className = 'assignee-item';
                    li.innerHTML = `
						<div class="d-flex align-items-center w-100">
	                        <input class="form-check-input assignee-checkbox me-3" type="checkbox" 
	                               value="${m.memberNo}" 
	                               id="assignee_${m.memberNo}"
	                               data-name="${m.memberName}">
	                        
	                        <div class="profile-circle">${initial}</div>
	                        
	                        <div class="member-info">
	                            <span class="member-name">${m.memberName}</span>
	                            <span class="member-role">${m.projectRole || 'MEMBER'}</span>
	                        </div>
	                    </div>
                    `;
					// 리스트 아이템(li) 클릭 시 체크박스 토글
                    li.addEventListener('click', function(e) {
						// 체크박스를 직접 누른 게 아니라면 토글
	                    if (e.target.type !== 'checkbox') {
	                        const checkbox = this.querySelector('.assignee-checkbox');
	                        checkbox.checked = !checkbox.checked;
	                        // 강제로 클릭 이벤트 트리거하여 뱃지 업데이트 로직 실행
	                        checkbox.dispatchEvent(new Event('click')); 
	                    }
						e.stopPropagation(); // 드롭다운 닫힘 방지
					});
					// 체크박스 클릭 시 드롭다운 닫힘 방지 & 이벤트 전파
                    const checkbox = li.querySelector('.assignee-checkbox');
                    checkbox.addEventListener('click', function(e) {
                        e.stopPropagation(); // li 클릭 이벤트 버블링 막기 (무한루프 방지) X -> 드롭다운 닫힘 방지 O
                        updateSelectedBadges(); // 뱃지 업데이트
                    });

                    listContainer.appendChild(li);
                });
            }
            if(callback) callback();
        })
        .catch(err => {
            console.error("멤버 로딩 실패", err);
            document.getElementById('assigneeDropdownBtn').innerText = "멤버 로딩 실패";
        });
}

// 담당자 검색 필터링 함수
function filterMembers() {
    const filterValue = this.value.toLowerCase();
    const listItems = document.querySelectorAll('#assigneeDropdownList .assignee-item');
    
    listItems.forEach(item => {
        const name = item.querySelector('.member-name').innerText.toLowerCase();
        if (name.indexOf(filterValue) > -1) {
            item.style.display = "";
        } else {
            item.style.display = "none";
        }
    });
}


function bindCheckboxEvents() {
	// 초기 로딩(fillDetailForm) 후 뱃지를 한번 그려주는 용도로 호출
    updateSelectedBadges();
}

// 뱃지 업데이트 및 드롭다운 라벨 변경 로직
function updateSelectedBadges() {
    const area = document.getElementById('selectedAssigneeArea');
    const listContainer = document.getElementById('assigneeDropdownList');
    
    area.innerHTML = ''; 
    let count = 0;
    
    // 1. 모든 리스트 아이템을 배열로 가져오기
    const items = Array.from(listContainer.querySelectorAll('.assignee-item'));
    
    // 2. 정렬 로직: 체크된 항목을 앞으로, 나머지는 뒤로 (이름순 정렬 유지하려면 2차 정렬 필요)
    items.sort((a, b) => {
        const checkA = a.querySelector('.assignee-checkbox').checked;
        const checkB = b.querySelector('.assignee-checkbox').checked;
        
        // 체크된 것 우선 (-1: 앞으로, 1: 뒤로)
        if (checkA && !checkB) return -1;
        if (!checkA && checkB) return 1;
        
        // 둘 다 체크되거나 둘 다 안 된 경우 -> 이름순 정렬 (원래 순서 유지)
        const nameA = a.querySelector('.member-name').innerText;
        const nameB = b.querySelector('.member-name').innerText;
        return nameA.localeCompare(nameB);
    });
    
    // 3. 정렬된 순서대로 다시 append (DOM 이동 발생)
    items.forEach(item => {
        listContainer.appendChild(item);
        
        // 체크된 항목에 대해서만 뱃지 생성 및 카운트
        const checkbox = item.querySelector('.assignee-checkbox');
        if (checkbox.checked) {
            addBadge(checkbox.getAttribute('data-name'), checkbox.value);
            count++;
        }
    });
    
    updateDropdownLabel(count);
}

// 프로젝트 메인 페이지 이동 함수 (유지보수를 위해 한 곳에서 관리)
function goToProject(projectNo) {
    if (!projectNo) return;
    // 실제 프로젝트 메인 URL 패턴에 맞게 수정해주세요.
    // 예: /tudio/project/main?projectNo=123 또는 /tudio/project/123
    location.href = `/tudio/project/detail?projectNo=${projectNo}`;
}


function fillDetailForm(data, type) {
    document.getElementById('detailId').value = (type === 'T' ? data.taskId : data.subId);
    document.getElementById('detailType').value = type;
    document.getElementById('detailProjectNo').value = data.projectNo;
	
	// 계층 구조(Breadcrumb) 생성 로직
    const breadcrumbArea = document.getElementById('taskBreadcrumbArea');
    const pName = data.projectName || '프로젝트';
	
	let breadcrumbHtml = '';
	    
    // (1) 프로젝트명 뱃지
	breadcrumbHtml += `<span class="breadcrumb-project" onclick="goToProject(${data.projectNo})">${pName}</span>`;
	    
    if (type === 'S') {
		// 하위 업무인 경우: 구분자(>) + 상위업무명(검은색)
        const parentTitle = data.parentTitle || '상위 업무';
        
		breadcrumbHtml += `<i class="bi bi-chevron-right breadcrumb-divider"></i>`;
        breadcrumbHtml += `<span class="breadcrumb-parent" title="${parentTitle}">${parentTitle}</span>`;
    }
    
    breadcrumbArea.innerHTML = breadcrumbHtml;
	
    document.getElementById('detailTitle').value = (type === 'T' ? data.taskTitle : data.subTitle);
    
    const content = (type === 'T' ? data.taskContent : data.subContent);
    document.getElementById('detailContent').value = content || '';

    // 1. 상태 값 추출
    const statusObj = (type === 'T' ? data.taskStatus : data.subStatus);
    const priorityObj = (type === 'T' ? data.taskPriority : data.subPriority);

    let statusVal = "REQUEST"; 
    if (statusObj) {
        if (typeof statusObj === 'object' && statusObj.code) statusVal = STATUS_MAP[statusObj.code] || "REQUEST";
        else statusVal = statusObj;
    }

    let priorityVal = "NORMAL";
    if (priorityObj) {
        if (typeof priorityObj === 'object' && priorityObj.code) priorityVal = PRIORITY_MAP[priorityObj.code] || "NORMAL";
        else priorityVal = priorityObj;
    }

    setSelectValue('detailStatus', statusVal);
    setSelectValue('detailPriority', priorityVal);

    // 2. [지연 상태 제약 적용]
    const statusSelect = document.getElementById('detailStatus');
    const options = statusSelect.options;

    // 초기화: 모든 옵션 활성화
    for (let i = 0; i < options.length; i++) {
        options[i].disabled = false;
        options[i].hidden = false;
    }

    if (statusVal === 'DELAYED') {
        // '지연' 상태 -> 보류, 완료, 지연만 선택 가능
        for (let i = 0; i < options.length; i++) {
            const val = options[i].value;
            if (val !== 'HOLD' && val !== 'DONE' && val !== 'DELAYED') {
                options[i].disabled = true; 
            }
        }
    } else {
        // '지연' 아님 -> 지연 선택 불가 (자동 상태이므로)
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === 'DELAYED') {
                options[i].disabled = true;
                options[i].hidden = true; 
            }
        }
    }

    // 날짜
    const start = (type === 'T' ? data.taskStartdate : data.subStartdate);
    const end = (type === 'T' ? data.taskEnddate : data.subEnddate);
    document.getElementById('detailStart').value = formatDate(start);
    document.getElementById('detailEnd').value = formatDate(end);

    // 진척도
    const rate = (type === 'T' ? data.taskRate : data.subRate) || 0;
    const rateInput = document.getElementById('detailRate');
    rateInput.value = rate;
    document.getElementById('detailRateVal').innerText = rate + '%';
    updateSliderColor(rateInput);
	
	// 상위업무(T)이고 하위업무가 존재하면 슬라이더 비활성화
	const hasSubTasks = (type === 'T' && data.subTasks && data.subTasks.length > 0);

	const form = document.getElementById('taskEditForm');
    form.dataset.hasSubTasks = hasSubTasks;
	
	if (hasSubTasks) {
        rateInput.disabled = true;
        rateInput.style.cursor = 'not-allowed';
        rateInput.title = "하위 업무의 진척도에 따라 자동 계산됩니다.";
        // 시각적으로 비활성화 느낌 주기 (투명도)
        rateInput.style.opacity = '0.5';
    } else {
        rateInput.disabled = false;
        rateInput.style.cursor = 'pointer';
        rateInput.title = "";
        rateInput.style.opacity = '1';
    }
	
    // 담당자
    const managers = (type === 'T' ? data.taskManagers : data.subManagers);
    document.querySelectorAll('.assignee-checkbox').forEach(chk => chk.checked = false);
    const selectedArea = document.getElementById('selectedAssigneeArea');
    selectedArea.innerHTML = ''; 

    if (managers && managers.length > 0) {
        managers.forEach(m => {
            const chk = document.getElementById(`assignee_${m.memberNo}`);
            if (chk) {
                chk.checked = true;
                addBadge(m.memberName);
            }
        });
        updateDropdownLabel(managers.length);
    } else {
        updateDropdownLabel(0);
    }

    bindCheckboxEvents();
	
	// 첨부파일 리스트 바인딩 로직
	const fileListArea = document.getElementById('detailFileList');
    fileListArea.innerHTML = ''; // 초기화

    if (data.fileList && data.fileList.length > 0) {
        data.fileList.forEach(f => {
            const li = document.createElement('li');
            // 디자인: 투명 배경, 아이템 간 구분선, 양쪽 정렬
            li.className = "list-group-item d-flex justify-content-between align-items-center bg-transparent py-2 px-3";
            li.style.borderBottomColor = "#f1f5f9";
            
            // 다운로드 링크 (컨텍스트 패스가 필요하면 앞에 추가, 보통 /tudio/... 로 시작하면 됨)
            // 파일명 클릭 시 다운로드
            li.innerHTML = `
                <a href="/tudio/file/download?fileNo=${f.fileNo}" class="text-decoration-none text-dark text-truncate small" style="max-width: 80%;">
                    <i class="bi bi-paperclip me-2 text-primary"></i>${f.fileOriginalName}
                </a>
                <span class="text-muted" style="font-size: 0.75rem;">${f.fileFancySize}</span>
            `;
            fileListArea.appendChild(li);
        });
    } else {
        // 파일 없을 때
        fileListArea.innerHTML = `
            <li class="list-group-item bg-transparent text-center text-muted small py-3 border-0">
                첨부된 파일이 없습니다.
            </li>
        `;
    }
}

function addBadge(name, memberNo) {
    const area = document.getElementById('selectedAssigneeArea');
    const badge = document.createElement('span');
    badge.className = "badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill d-inline-flex align-items-center";
    badge.style.fontWeight = "500";
    
    badge.innerHTML = `
        ${name}
        <i class="bi bi-x-circle-fill ms-2 text-primary" style="cursor:pointer; opacity:0.6;" onclick="removeAssignee(${memberNo})"></i>
    `;
    
    // X 버튼 호버 효과
    const icon = badge.querySelector('i');
    icon.onmouseover = () => icon.style.opacity = '1';
    icon.onmouseout = () => icon.style.opacity = '0.6';
    
    area.appendChild(badge);
}

// 뱃지에서 X 눌렀을 때 체크 해제 함수
function removeAssignee(memberNo) {
    const checkbox = document.getElementById(`assignee_${memberNo}`);
    if (checkbox) {
        checkbox.checked = false;
        updateSelectedBadges(); // 뱃지 갱신
    }
}

function updateDropdownLabel(count) {
    const btn = document.getElementById('assigneeDropdownBtn');
    btn.innerText = count > 0 ? `${count}명 선택됨` : "담당자 선택";
}


function updateTask() {
    const type = document.getElementById('detailType').value;
    const id = document.getElementById('detailId').value;
    const url = type === 'T' ? '/tudio/project/task/update' : '/tudio/project/task/sub/update';

    const formData = new FormData();
    formData.append(type === 'T' ? 'taskId' : 'subId', id);
    formData.append('projectNo', document.getElementById('detailProjectNo').value);
    
    formData.append(type === 'T' ? 'taskTitle' : 'subTitle', document.getElementById('detailTitle').value);
    formData.append(type === 'T' ? 'taskContent' : 'subContent', document.getElementById('detailContent').value);
    formData.append(type === 'T' ? 'taskStatus' : 'subStatus', document.getElementById('detailStatus').value);
    formData.append(type === 'T' ? 'taskPriority' : 'subPriority', document.getElementById('detailPriority').value);
    formData.append(type === 'T' ? 'taskRate' : 'subRate', document.getElementById('detailRate').value);
    
	formData.append(type === 'T' ? 'taskStartdate' : 'subStartdate', document.getElementById('detailStart').value);
    formData.append(type === 'T' ? 'taskEnddate' : 'subEnddate', document.getElementById('detailEnd').value);

	// 진척도 전송 제어
	const form = document.getElementById('taskEditForm');
    const hasSubTasks = (form.dataset.hasSubTasks === 'true');

    if (!hasSubTasks) {
        // 하위업무가 없거나 하위업무 자체인 경우에만 입력값 전송
        formData.append(type === 'T' ? 'taskRate' : 'subRate', document.getElementById('detailRate').value);
    } else {
        // 상위업무이고 하위업무가 있으면 전송 X -> 서버에서 기존 값 유지(또는 재계산)
        console.log("상위업무(하위포함)이므로 진척도 업데이트 제외");
    }
	
    const paramName = (type === 'T' ? 'taskManagerNos' : 'subManagerNos');
    document.querySelectorAll('.assignee-checkbox:checked').forEach(chk => {
        formData.append(paramName, chk.value); 
    });
    
    fetch(url, { method: 'POST', body: formData })
    .then(res => res.text())
    .then(result => {
        if(result === 'SUCCESS' || result === 'OK') {
            Swal.fire({
                icon: 'success',
                title: '성공',
                text: '저장되었습니다.',
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                location.reload(); // 새로고침 되어도 sessionStorage 덕분에 토글 유지됨!
            });
        } else {
            Swal.fire('실패', '저장에 실패했습니다.', 'error');
        }
    })
    .catch(err => {
        console.error(err);
        Swal.fire('오류', '서버 오류가 발생했습니다.', 'error');
    });
}

function deleteTask() {
    Swal.fire({
        title: '정말 삭제하시겠습니까?',
        text: "이 작업은 되돌릴 수 없습니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            executeDelete();
        }
    });
}

function executeDelete() {
    const type = document.getElementById('detailType').value;
    const id = document.getElementById('detailId').value;
    const url = '/tudio/project/task/delete';

    const formData = new FormData();
    formData.append('workId', id); 
    formData.append('type', type);

    fetch(url, { method: 'POST', body: formData })
    .then(res => res.text())
    .then(res => {
        if(res === 'SUCCESS') {
            Swal.fire({
                icon: 'success',
                title: '삭제됨',
                text: '업무가 삭제되었습니다.',
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                closeTaskPanel();
                location.reload();
            });
        } else {
            Swal.fire('실패', '삭제에 실패했습니다.', 'error');
        }
    })
    .catch(() => Swal.fire('오류', '오류가 발생했습니다.', 'error'));
}

function closeTaskPanel() { 
    document.getElementById('taskDetailPanel').classList.remove('open'); 
	$(".floating-chat-container").css('right', 30+'px');
}

function formatDate(dateStr) {
    if(!dateStr) return '';
    return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
}

function setSelectValue(id, val) {
    const el = document.getElementById(id);
    if(el && val) el.value = val;
}

// 날짜 비교 함수 (YYYY-MM-DD 문자열 비교)
function isOverdue(dateStr) {
    if (!dateStr) return false;
    
    // 오늘 날짜 구하기 (시간 제외)
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    // 입력 날짜 구하기
    const targetDate = new Date(dateStr);
    targetDate.setHours(0, 0, 0, 0);
    
    // 마감일 < 오늘 이면 지연 (마감일이 어제였다면 지연)
    return targetDate < today;
}