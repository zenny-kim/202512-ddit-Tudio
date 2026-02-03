document.addEventListener("DOMContentLoaded", function() {
	
	const contextPath = document.body.dataset.contextPath || "";
	const projectNo = document.body.dataset.projectNo;
	const contentArea = $('#projectTabContent'); 
	
	// 1. 탭 URL 매핑 객체 (지저분한 switch문 대체)
	const tabUrls = {
		'task': '/task/list',
		'gantt': '/gantt/view',
		'board': '/board',
		'calendar': '/schedule',
		'drive': '/drive/list',
		'member': '/member/view',
		'stats': '/stats/view',
		'meetingRoom': '/meetingRoom'
	};

	// 2. 탭 컨텐츠 로드 함수
	window.loadTab = function(tabName) {
		if(!tabName) return;

		// 매핑된 주소가 없으면 기본 이름 사용
		const endpoint = tabUrls[tabName] || `/${tabName}`;
		const url = `${contextPath}/tudio/project${endpoint}?projectNo=${projectNo}`;
		
		contentArea.load(url, function(response, status, xhr) {
			if (status === "error") {
				contentArea.html(`<div class="tudio-empty"><i class="bi bi-exclamation-circle"></i><p class="title">오류 발생</p></div>`);
				return;
			}
			$(document).trigger('tab:loaded', [tabName]);
		});
	}

	// -------------------------------------------------------------
	// 3. ⭐ 초기 로딩 (하드디스크 신호 > URL > 기본값 순서)
	// -------------------------------------------------------------
	
	// 로컬스토리지 신호 읽고 즉시 파기 (리액트가 보낸 신호)
	const signalTab = localStorage.getItem('targetTab');
	localStorage.removeItem('targetTab'); 

	// URL 파라미터 확인
	const urlParams = new URLSearchParams(window.location.search);
	const urlTab = urlParams.get("tab");

	// 최종 타겟 결정
	const finalTabName = urlTab || signalTab || "stats";

	// 결정된 탭 UI 강제 활성화 (stats가 기본이어도 여기서 뺏음)
	const targetBtn = document.querySelector(`#projectTabs .nav-link[data-tab="${finalTabName}"]`);
	if (targetBtn) {
		document.querySelectorAll("#projectTabs .nav-link").forEach(el => el.classList.remove("active"));
		targetBtn.classList.add("active");
		if (window.bootstrap) bootstrap.Tab.getOrCreateInstance(targetBtn).show();
	}

	// 탭 로드 실행
	loadTab(finalTabName);
	
	// -------------------------------------------------------------
	// 4. 이벤트 리스너 (사용자 클릭 감시)
	// -------------------------------------------------------------
	document.querySelectorAll('#projectTabs button[data-bs-toggle="tab"]').forEach(button => {
		// 다른 탭 클릭 시
		button.addEventListener('shown.bs.tab', function(event) {
			const tabName = event.target.getAttribute('data-tab');
			// 초기 로딩된 탭이 아닐 때만 로드 (중복 실행 방지)
			if (tabName !== finalTabName) loadTab(tabName);
	    });
		
		// 현재 활성화된 탭을 다시 클릭하면 새로고침
		button.addEventListener('click', function() {
			if (this.classList.contains('active')) loadTab(this.getAttribute('data-tab')); 
		});
	});
		
	// 5. 북마크 버튼 이벤트
	const btnBookmark = document.getElementById('btnBookmark');
	if(btnBookmark) {
		btnBookmark.addEventListener("click", () => toggleBookmark(contextPath, projectNo));
	}
});


/**
 * 프로젝트 북마크 설정 함수
 */
function toggleBookmark(contextPath, projectNo) {
	$.ajax({
		url: `${contextPath}/tudio/project/bookmark`,
		type: 'post',
		data: JSON.stringify({projectNo}),
		contentType: 'application/json; charset=utf-8',
		dataType: 'json',
		success: function(res) {
			if(res.status === 'SUCCESS') {
				const bookmarkText = document.getElementById('bookmarkText');
				const icon = document.querySelector('#btnBookmark i');
				const btn = document.getElementById('btnBookmark');
				
				// 설정된 북마크 상태에 따라 아이콘 변경 (Y/N)
				if(res.bookmark === 'Y') {
					icon.classList.remove('bi-star');
					icon.classList.add('bi-star-fill');
					btn.title = "북마크 해제";
					bookmarkText.textContent = "북마크 해제";
				} else {
					icon.classList.remove('bi-star-fill');
					icon.classList.add('bi-star');
					btn.title = "북마크 설정";
					bookmarkText.textContent = "북마크 설정";
				}
			} else {
				Swal.fire('오류', '북마크 설정에 실패하였습니다!', 'error');
			}
		},
		error: function(xhr) {
			console.log(xhr);
			Swal.fire('에러', '서버 통신 중 오류가 발생했습니다!', 'error');
		}
	});
}

/* =========================================================
   [To-Do List] 모달
   ========================================================= */

// 페이지 로드 시 메인 카드 영역에 할 일 개수 표시
document.addEventListener('DOMContentLoaded', function() {
    loadTodoCount();
});

function loadTodoCount() {
    fetch(`/tudio/dashboard/todo/list?projectNo=${projectNo}`)
        .then(res => res.json())
        .then(data => {
            const count = data.length;
            const done = data.filter(t => t.todoStatus === 'Y').length;
            const el = document.getElementById('todoSummaryCount');
            if(el) {
                el.innerHTML = `<span class="text-primary fw-bold">${done}</span> <span class="text-muted fs-6">/ ${count}</span>`;
            }
        })
        .catch(err => console.error("투두 카운트 로드 실패", err));
}

// 모달 열기
function openTodoModal() {
    const modal = new bootstrap.Modal(document.getElementById('todoManageModal'));
    modal.show();
    loadTodoList(); // 리스트 불러오기
    
    // 입력창 엔터키 이벤트 바인딩
    document.getElementById('newTodoInput').onkeydown = function(e) {
        if(e.key === 'Enter') addTodo();
    };
}

// 리스트 조회 및 렌더링
function loadTodoList() {
    const listBody = document.getElementById('todoListBody');
    // 로딩바
    listBody.innerHTML = '<div class="text-center py-5"><span class="spinner-border text-primary"></span></div>';

    fetch(`/tudio/dashboard/todo/list?projectNo=${projectNo}`)
        .then(res => res.json())
        .then(data => {
            renderTodoList(data);
        })
        .catch(err => {
            console.error(err);
            listBody.innerHTML = '<div class="text-center py-5 text-danger">데이터를 불러오지 못했습니다.</div>';
        });
}

function renderTodoList(todos) {
    const listBody = document.getElementById('todoListBody');
    
    if (!todos || todos.length === 0) {
        listBody.innerHTML = `
            <div class="d-flex flex-column align-items-center justify-content-center py-5 text-muted" style="min-height: 250px;">
                <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                    <i class="bi bi-clipboard-check fs-1 text-primary opacity-25"></i>
                </div>
                <p class="fw-bold mb-1">할 일이 없습니다.</p>
                <p class="small text-muted">할 일을 기록해보세요!</p>
            </div>
        `;
        return;
    }

    let html = '<div class="d-flex flex-column gap-1">'; 
    todos.forEach(todo => {
        const isDone = todo.todoStatus === 'Y';
        
        html += `
            <div class="todo-item-row p-3 d-flex align-items-center ${isDone ? 'done' : ''}" id="todo-row-${todo.todoNo}">
                
                <div class="me-3">
                    <input class="form-check-input custom-chk shadow-none" type="checkbox" 
                           ${isDone ? 'checked' : ''} 
                           onchange="toggleTodo(${todo.todoNo}, this)">
                </div>

                <div class="flex-grow-1 overflow-hidden" style="padding-top: 2px;">
                    <span class="fs-6 d-block text-truncate cursor-pointer user-select-none ${isDone ? 'text-decoration-line-through text-muted' : 'text-dark fw-medium'}"
                          id="todo-text-${todo.todoNo}"
                          title="${todo.todoContent}"
                          ondblclick="enableEditTodo(${todo.todoNo}, '${todo.todoContent.replace(/'/g, "\\'")}')">
                        ${todo.todoContent}
                    </span>
                    
                    <input type="text" class="form-control form-control-sm d-none mt-1" 
                           id="todo-edit-${todo.todoNo}" 
                           value="${todo.todoContent.replace(/"/g, '&quot;')}"
                           onblur="finishEditTodo(${todo.todoNo})"
                           onkeydown="if(event.key==='Enter') finishEditTodo(${todo.todoNo})">
                </div>
                
                <button class="btn btn-sm btn-todo-del p-2 ms-2" 
                        onclick="deleteTodo(${todo.todoNo})" title="삭제">
                    <i class="bi bi-trash3"></i>
                </button>
            </div>
        `;
    });
    html += '</div>';
    listBody.innerHTML = html;
}

// 할 일 추가
function addTodo() {
    const input = document.getElementById('newTodoInput');
    const content = input.value.trim();
    if (!content) {
        Swal.fire({ icon: 'warning', title: '내용을 입력해주세요.', toast: true, position: 'top-end', timer: 1500, showConfirmButton: false });
        return;
    }

    fetch('/tudio/dashboard/todo/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ projectNo: projectNo, todoContent: content })
    })
    .then(res => res.text())
    .then(result => {
        if (result === 'OK') {
            input.value = ''; // 초기화
            loadTodoList();   // 리스트 갱신
            loadTodoCount();  // 상단 카드 갱신
            Swal.fire({ icon: 'success', title: '추가되었습니다.', toast: true, position: 'top-end', timer: 1000, showConfirmButton: false });
        } else {
            alert('추가 실패');
        }
    });
}

// 상태 변경 (체크)
function toggleTodo(todoNo, checkbox) {
    const status = checkbox.checked ? 'Y' : 'N';
    const textSpan = document.getElementById(`todo-text-${todoNo}`);

    if (status === 'Y') {
        textSpan.classList.add('text-decoration-line-through', 'text-muted');
    } else {
        textSpan.classList.remove('text-decoration-line-through', 'text-muted');
    }

    fetch('/tudio/dashboard/todo/updateStatus', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ todoNo: todoNo, todoStatus: status })
    })
    .then(res => res.text())
    .then(result => {
        if (result !== 'OK') {
            checkbox.checked = !checkbox.checked; // 실패 시 롤백
            alert('상태 변경 실패');
        } else {
            loadTodoCount(); // 상단 카드 갱신
        }
    });
}

// 삭제
function deleteTodo(todoNo) {
    if(!confirm('정말 삭제하시겠습니까?')) return;

    fetch('/tudio/dashboard/todo/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ todoNo: todoNo })
    })
    .then(res => res.text())
    .then(result => {
        if (result === 'OK') {
            loadTodoList();
            loadTodoCount();
        } else {
            alert('삭제 실패');
        }
    });
}

// 수정 모드 
function enableEditTodo(todoNo, oldContent) {
    const textSpan = document.getElementById(`todo-text-${todoNo}`);
    const editInput = document.getElementById(`todo-edit-${todoNo}`);
    
    textSpan.classList.add('d-none');
    editInput.classList.remove('d-none');
    editInput.focus();
}

// 수정
function finishEditTodo(todoNo) {
    const textSpan = document.getElementById(`todo-text-${todoNo}`);
    const editInput = document.getElementById(`todo-edit-${todoNo}`);
    const newContent = editInput.value.trim();

    if (!newContent) {
        // 내용 없으면 원상복구
        editInput.classList.add('d-none');
        textSpan.classList.remove('d-none');
        return;
    }

    fetch('/tudio/dashboard/todo/updateContent', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ todoNo: todoNo, todoContent: newContent })
    })
    .then(res => res.text())
    .then(result => {
        if (result === 'OK') {
            textSpan.innerText = newContent;
            textSpan.classList.remove('d-none');
            editInput.classList.add('d-none');
        } else {
            alert('수정 실패');
        }
    });
}

window.goToTab = function(tabName) {
    if (!tabName) return;

    // 1. 해당 data-tab을 가진 버튼 요소를 찾습니다.
    const targetTabBtn = document.querySelector(`#projectTabs button[data-tab="${tabName}"]`);
    
    if (targetTabBtn) {
        // 2. 부트스트랩 탭 인스턴스를 통해 탭 전환 (기존 코드의 shown.bs.tab 이벤트가 자동 발생함)
        const tabTrigger = bootstrap.Tab.getOrCreateInstance(targetTabBtn);
        tabTrigger.show();
        
        // 3. 탭 영역으로 부드럽게 스크롤 (사용자 경험 향상)
        const tabSection = document.getElementById('projectTabs');
        if (tabSection) {
            tabSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    } else {
        console.warn(`[이동 실패] '${tabName}' 탭이 현재 화면에 존재하지 않거나 권한이 없습니다.`);
        // 만약 탭이 없는데 클릭했다면, 사용자에게 알림을 줄 수도 있습니다.
        // Swal.fire('알림', '해당 메뉴에 대한 접근 권한이 없습니다.', 'info');
    }
};